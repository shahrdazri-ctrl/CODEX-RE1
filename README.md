# CODEX-RE1

Recovered Bomb Rush Cyberfunk Unity project, targeting **Unity 2021.3.27f1** and the built-in render pipeline.

Open this repository's root in Unity Hub using that Editor version. Let the initial import finish, then use **Recovery > Open Bootstrap** and press Play. The first import is large: the recovered assets occupy about 10 GB before Unity creates its Library.

The project contains 13 scenes, meshes, character and environment prefabs, textures, animation clips, music, sound effects, video, localization data, and decompiled runtime C#. Game source is under `Assets/Scripts/Assembly-CSharp`; first-pass source is under `Assets/Plugins/Assembly-CSharp-firstpass`. Vendor runtime DLLs are retained in `Assets/Plugins`.

Editor play mode loads the recovered assets through AssetDatabase and opens the recovered scenes directly. Asset edits therefore do not require rebuilding the shipped bundles. Player builds use the original bundle loading path: select a platform in Build Settings, run **Recovery > Build Bundles for Active Target**, then build the player. The supplied StreamingAssets bundles are the original Windows payloads; rebuild them before shipping edited content or another platform.

Large binary assets, bundles, and large serialized files use **Git LFS**. Install Git LFS and run `git lfs pull` after cloning a published copy. The current working tree already contains the full asset data.

Cloud checks passed for both recovered runtime assemblies, all 253 installed manifest files, all 2,364 audio probes, 3,100 reconstructed shader stage/keyword combinations, and 35 post-processing compute kernels. The asset GUID audit found no duplicate or unresolved external references. Detailed results and reconstruction provenance are in `Recovery`. Unity Editor import, actual rendering, and gameplay checks must run locally; see [the local verification checklist](Recovery/LOCAL_UNITY_CHECKS.md).

This is a reconstruction from a player build. Original comments, editor tooling, DCC authoring files, and the original source project were not supplied. Shader code was reconstructed from compiled programs or restored from compatible public package sources. Inspect visual fidelity locally before treating the project as a release baseline. New platform ports also require checking the retained vendor DLLs and replacing platform-specific integrations where necessary.

Cloud C# validation can be reproduced with:

```bash
python3 Recovery/setup_dotnet.py .tools/dotnet
export DOTNET_ROOT="$PWD/.tools/dotnet"
export DOTNET_CLI_HOME="$PWD/.tools/dotnet-home"
python3 Recovery/compile_recovered.py Assets Recovery/ReferenceAssemblies \
  --dotnet .tools/dotnet/dotnet --output .tools/compile-check
python3 Recovery/audit_project.py . --report .tools/asset-audit.json
```

These checks do not compile Editor-only code or replace Unity import and play tests. Recovery tool licenses are recorded under `Recovery/Licenses`; they do not change ownership of the recovered game content.
