#if UNITY_EDITOR
using System;
using System.Collections.Generic;
using System.IO;
using UnityEditor;
using UnityEngine;
using Object = UnityEngine.Object;

namespace Reptile.Recovery
{
    // Editor play mode reads the recovered assets directly. Player builds keep
    // the original AssetBundle loading API and require rebuilt target bundles.
    public sealed class EditorAssetRequest : CustomYieldInstruction
    {
        public Object asset { get; private set; }
        public bool isDone { get { return true; } }
        public float progress { get { return 1f; } }
        public override bool keepWaiting { get { return false; } }
        public EditorAssetRequest(Object value) { asset = value; }
    }

    public static class EditorAssetGateway
    {
        private static readonly Dictionary<string, Object> cache = new Dictionary<string, Object>();

        public static string[] BundleNames() { return AssetDatabase.GetAllAssetBundleNames(); }

        public static T Load<T>(string bundle, string address) where T : Object
        {
            string key = bundle + ":" + address + ":" + typeof(T).FullName;
            Object cached;
            if (cache.TryGetValue(key, out cached) && cached != null) return (T)cached;
            var paths = AssetDatabase.GetAssetPathsFromAssetBundle(bundle);
            var matches = new List<T>();
            string shortName = Path.GetFileNameWithoutExtension(address);
            foreach (string path in paths)
            {
                if (!String.Equals(Path.GetFileNameWithoutExtension(path), shortName, StringComparison.OrdinalIgnoreCase) &&
                    !String.Equals(path, address, StringComparison.OrdinalIgnoreCase)) continue;
                T value = AssetDatabase.LoadAssetAtPath<T>(path);
                if (value != null) matches.Add(value);
            }
            // FBX and audio have been reconstructed as prefabs and OGG/WAV.
            // Their original object names survive even when the extension changes.
            if (matches.Count == 0)
            {
                foreach (string path in paths)
                {
                    T value = AssetDatabase.LoadAssetAtPath<T>(path);
                    if (value != null && String.Equals(value.name, address, StringComparison.OrdinalIgnoreCase))
                        matches.Add(value);
                }
            }
            if (matches.Count != 1)
                throw new InvalidOperationException("Recovered asset lookup for " + bundle + "/" + address +
                    " (" + typeof(T).Name + ") found " + matches.Count + " matches.");
            cache[key] = matches[0];
            return matches[0];
        }

        public static string ScenePath(string name)
        {
            var matches = new List<string>();
            foreach (string guid in AssetDatabase.FindAssets("t:SceneAsset"))
            {
                string path = AssetDatabase.GUIDToAssetPath(guid);
                if (String.Equals(Path.GetFileNameWithoutExtension(path), Path.GetFileNameWithoutExtension(name),
                    StringComparison.OrdinalIgnoreCase)) matches.Add(path);
            }
            if (matches.Count != 1)
                throw new InvalidOperationException("Recovered scene lookup for " + name + " found " + matches.Count + " matches.");
            return matches[0];
        }
    }
}
#endif
