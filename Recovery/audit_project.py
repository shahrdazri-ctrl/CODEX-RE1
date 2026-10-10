#!/usr/bin/env python3
"""Inventory recovered assets and detect duplicate or unresolved Unity GUIDs."""
import argparse
from collections import Counter, defaultdict
import json
from pathlib import Path
import re

GUID = re.compile(r"\bguid:\s*([0-9a-fA-F]{32})\b")
YAML_EXTENSIONS = {".asset", ".mat", ".prefab", ".unity", ".controller",
                   ".overridecontroller", ".anim", ".playable", ".physicmaterial",
                   ".physicsmaterial2d", ".mixer", ".rendertexture", ".meta"}


def audit(project: Path) -> dict:
    assets = project / "Assets"
    if not assets.is_dir():
        raise ValueError("Project has no Assets directory")
    files = sorted(p for p in assets.rglob("*") if p.is_file())
    definitions = defaultdict(list)
    for meta in (p for p in files if p.suffix == ".meta"):
        with meta.open(encoding="utf-8", errors="replace") as stream:
            for line in stream:
                if line.startswith("guid:"):
                    match = GUID.search(line)
                    if match:
                        definitions[match[1].lower()].append(str(meta.relative_to(project)))
                    break
    references = defaultdict(set)
    for path in files:
        if path.suffix.lower() not in YAML_EXTENSIONS:
            continue
        with path.open(encoding="utf-8", errors="replace") as stream:
            for line in stream:
                # Asset PPtrs have a fileID. Mixer parameter IDs and GUIDs
                # mentioned in object names are not external asset references.
                if "guid:" not in line or "fileID:" not in line:
                    continue
                for guid in GUID.findall(line):
                    guid = guid.lower()
                    # Unity's internal resources use reserved GUIDs.
                    if guid.startswith("0000000000000000"):
                        continue
                    references[guid].add(str(path.relative_to(project)))
    missing = {guid: sorted(paths) for guid, paths in references.items()
               if guid not in definitions}
    duplicate = {guid: paths for guid, paths in definitions.items() if len(paths) > 1}
    counts = Counter(p.suffix.lower() or "<no extension>" for p in files if p.suffix != ".meta")
    return {"asset_files": sum(counts.values()), "asset_bytes": sum(p.stat().st_size for p in files),
            "extensions": dict(sorted(counts.items())), "defined_guids": len(definitions),
            "referenced_guids": len(references), "duplicate_guids": duplicate,
            "unresolved_guids": missing,
            "scope": "Assets directory; Unity and package import validation is separate"}


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("project", type=Path)
    parser.add_argument("--report", type=Path, required=True)
    args = parser.parse_args()
    report = audit(args.project)
    args.report.write_text(json.dumps(report, indent=2) + "\n")
    print(f"{report['asset_files']} assets; {len(report['duplicate_guids'])} duplicate GUIDs; "
          f"{len(report['unresolved_guids'])} unresolved GUIDs")
    raise SystemExit(1 if report["duplicate_guids"] or report["unresolved_guids"] else 0)
