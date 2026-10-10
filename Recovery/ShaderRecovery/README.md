# Shader reconstruction helper

The project shaders are already installed. This helper documents how the custom HLSL was recovered; it is not needed to open Unity.

Use the AssetRipper 1.3.0 source at commit `9af4bbf5b05ab7dd6492d65ce4a16a46ebb3e8cf`, .NET SDK 9.0.318, and the patch in this directory. Place that upstream source in `../assetripper-source-1.3.0` relative to the helper, then apply the patch from the upstream root. The helper's project references the upstream exporter.

The patch resolves shared Unity 2021 shader parameter metadata, preserves keyword branches, fixes constant-buffer array indexing, and preserves shadow comparison operands. Original instanced programs are replaced with standard Unity instancing macros by `install_shaders.py`. The Mono-only recovery tool rejects IL2CPP method fixups; this restriction concerns the recovery helper, not Unity's player build backend.

Run the helper with the installed game directory and an empty output directory. It writes decompiled shaders, compiled-program disassembly, and a per-shader index. Shader source installation and standalone HLSL validation are implemented by `Recovery/install_shaders.py` and `Recovery/validate_shaders.py`. Input/public-source folder names are documented in those scripts. Public package source versions and commit hashes are recorded in `Recovery/shader-source-provenance.json`.

The AssetRipper patch and derivative helper are GPL-3.0; see `../Licenses/AssetRipper-GPL-3.0.md`. Public Unity shader source license notices are preserved separately.
