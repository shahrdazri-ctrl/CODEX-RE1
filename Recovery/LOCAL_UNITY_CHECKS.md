# Local Unity verification

Use Unity **2021.3.27f1**, with Windows build support for the first player comparison. Keep the built-in render pipeline. Import the repository root, not the Assets subdirectory.

1. Wait for import to finish. Check the Console for C#, ShaderLab, compute shader, plugin, and serialized asset errors. The cloud C# check covers player code against the original DLLs; it cannot validate Editor APIs or Unity's asset import.
2. Run **Recovery > Open Bootstrap** and enter Play mode. Confirm the introduction and main menu load, then start a game. Confirm character selection, movement, controller input, phone UI, graffiti, save/load, music, and sound effects.
3. Visit Prelude, hideout, osaka, Mall, pyramid, square, tower, and downhill. Compare materials, outlines, shadows, lightmaps, water, skyboxes, effects, and post-processing with the supplied game. Check crowd instance transforms and animation particularly closely: reconstructed shaders use Unity's standard instancing macros.
4. Edit a character material and an environment asset, then re-enter Play mode. Confirm the changes appear through the Editor asset loader. Leave domain reload enabled during initial testing.
5. Select Windows in Build Settings. Run **Recovery > Build Bundles for Active Target**. Resolve any duplicate address or dependency messages before building the player. Build Bootstrap as the only startup scene; the remaining scenes are loaded from rebuilt scene bundles.
6. Run the built player and repeat a representative stage, audio, and save/load check. Compare it with the unmodified input game before making larger changes.
7. For another platform, install its Unity build module, rebuild all bundles for that target, and review Rewired, console/Windows save services, video codecs, filesystem access, and other retained vendor dependencies. Asset recovery alone does not establish that a platform port works.

Keep Console errors and screenshots of visual differences with the scene and asset names when reporting problems. Do not upgrade the Unity version or replace vendor packages before the initial baseline comparison; those changes introduce additional variables.
