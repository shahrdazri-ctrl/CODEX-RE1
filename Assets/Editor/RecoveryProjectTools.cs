using System;
using System.IO;
using System.Linq;
using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;

public static class RecoveryProjectTools
{
    [MenuItem("Recovery/Open Bootstrap")]
    public static void OpenBootstrap()
    {
        if (EditorSceneManager.SaveCurrentModifiedScenesIfUserWantsTo())
            EditorSceneManager.OpenScene("Assets/GameManagement/Scenes/Bootstrap.unity");
    }

    [MenuItem("Recovery/Build Bundles for Active Target")]
    public static void BuildBundles()
    {
        if (EditorApplication.isPlaying)
            throw new InvalidOperationException("Stop play mode before rebuilding bundles.");
        string output = Path.GetFullPath("Build/Bundles/" + EditorUserBuildSettings.activeBuildTarget);
        Directory.CreateDirectory(output);
        var builds = AssetDatabase.GetAllAssetBundleNames().Select(name =>
        {
            var paths = AssetDatabase.GetAssetPathsFromAssetBundle(name);
            // Keep full paths as the general addresses. Add short addresses for
            // the bundles queried by the original runtime's LoadAsset calls.
            bool shortAddresses = name == "characters" || name == "graffiti" || name == "in_game_assets";
            var addresses = paths.Select(p =>
            {
                var type = AssetDatabase.GetMainAssetTypeAtPath(p);
                bool queriedType = type == typeof(GameObject) || type == typeof(Material) ||
                    typeof(Texture).IsAssignableFrom(type) || type == typeof(TextAsset) ||
                    name == "graffiti" && typeof(ScriptableObject).IsAssignableFrom(type);
                return shortAddresses && queriedType ? Path.GetFileNameWithoutExtension(p).ToLowerInvariant()
                    : p.ToLowerInvariant();
            }).ToArray();
            if (addresses.Distinct(StringComparer.OrdinalIgnoreCase).Count() != addresses.Length)
                throw new InvalidOperationException("Duplicate asset addresses in bundle " + name);
            return new AssetBundleBuild { assetBundleName = name, assetNames = paths, addressableNames = addresses };
        }).ToArray();
        var manifest = BuildPipeline.BuildAssetBundles(output, builds,
            BuildAssetBundleOptions.ChunkBasedCompression, EditorUserBuildSettings.activeBuildTarget);
        if (manifest == null) throw new InvalidOperationException("Bundle build failed; see the Console.");
        // Install only successfully built payloads; leave languages and other
        // StreamingAssets intact. Stale bundle files are retained for comparison.
        string destination = "Assets/StreamingAssets/Assets";
        Directory.CreateDirectory(destination);
        foreach (string bundle in manifest.GetAllAssetBundles())
        {
            string target = Path.Combine(destination, bundle);
            Directory.CreateDirectory(Path.GetDirectoryName(target));
            File.Copy(Path.Combine(output, bundle), target, true);
        }
        AssetDatabase.Refresh();
        Debug.Log("Built and installed bundles for " + EditorUserBuildSettings.activeBuildTarget + ". Build the player using File > Build Settings.");
    }
}
