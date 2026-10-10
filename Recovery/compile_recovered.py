#!/usr/bin/env python3
"""Check recovered runtime C# against the original game's managed references.

This checks C# compilation only. Unity import, rendering, and play testing still
require the matching licensed Unity Editor.
"""
import argparse
from pathlib import Path
import re
import subprocess

ASSEMBLIES = ("Assembly-CSharp-firstpass", "Assembly-CSharp")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("source_root", type=Path,
                        help="Unity Assets directory, or directory with one folder per assembly")
    parser.add_argument("managed", type=Path, help="Original game's Managed directory")
    parser.add_argument("--dotnet", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--language-version", default="8.0")
    args = parser.parse_args()
    dotnet = args.dotnet.resolve()
    sdks = sorted((dotnet.parent / "sdk").glob("*/Roslyn/bincore/csc.dll"))
    if not sdks:
        parser.error("--dotnet must point to a locally installed SDK executable")
    args.output.mkdir(parents=True, exist_ok=True)
    references = sorted(p.resolve() for p in args.managed.glob("*.dll")
                        if p.stem not in ASSEMBLIES)
    # Prefer the actual project's vendor dependencies over a separate reference
    # copy, including ILSpy's additional Unsafe helper when it is present.
    plugin_root = args.source_root / "Plugins"
    if plugin_root.is_dir():
        plugins = {p.name: p.resolve() for p in plugin_root.glob("*.dll")}
        references = [plugins.pop(p.name, p) for p in references]
        references += list(plugins.values())
    failed = False
    for assembly in ASSEMBLIES:
        folder = args.source_root / assembly
        if not folder.is_dir():
            folder = args.source_root / ("Plugins" if assembly.endswith("firstpass") else "Scripts") / assembly
        sources = sorted(folder.rglob("*.cs"))
        if not sources:
            parser.error(f"No source files found for {assembly}")
        destination = (args.output / (assembly + ".dll")).resolve()
        # An old successful output must never mask a failed new compilation.
        destination.unlink(missing_ok=True)
        options = ["/nostdlib+", "/target:library", "/unsafe+",
                   "/deterministic+", "/langversion:" + args.language_version,
                   f'/out:"{destination}"']
        options += [f'/reference:"{p}"' for p in references]
        options += [f'"{p.resolve()}"' for p in sources]
        response = args.output / (assembly + ".rsp")
        response.write_text("\n".join(options) + "\n")
        result = subprocess.run([str(dotnet), str(sdks[-1]), "/noconfig", "@" + str(response.resolve())],
                                stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True)
        (args.output / (assembly + ".log")).write_text(result.stdout)
        errors = [line for line in result.stdout.splitlines() if re.search(r"error CS\d+", line)]
        print(f"{assembly}: {len(sources)} source files; {len(errors)} compiler errors")
        for line in errors[:20]:
            print(line)
        if result.returncode:
            failed = True
            break
        references.append(destination)
    raise SystemExit(1 if failed else 0)
