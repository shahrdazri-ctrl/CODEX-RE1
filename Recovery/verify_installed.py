#!/usr/bin/env python3
"""Verify recovered installer files against its bundled MD5 manifest."""
import argparse
import hashlib
import json
from pathlib import Path


def verify(root: Path, manifest: Path) -> dict:
    entries = []
    for line in manifest.read_text(encoding="utf-8-sig").splitlines():
        if not line.strip():
            continue
        expected, name = line.split(maxsplit=1)
        name = name.lstrip("*").replace("\\", "/")
        # The installer manifest lives in _Redist and uses ../game paths.
        relative = name.removeprefix("../")
        path = (root / relative).resolve()
        if not path.is_relative_to(root.resolve()):
            raise ValueError(f"Manifest path escapes installation: {name}")
        entry = {"path": relative, "expected_md5": expected.lower()}
        if not path.is_file():
            entry["status"] = "missing"
        else:
            with path.open("rb") as stream:
                actual = hashlib.file_digest(stream, "md5").hexdigest()
            entry.update(size=path.stat().st_size, actual_md5=actual,
                         status="ok" if actual == expected.lower() else "mismatch")
        entries.append(entry)
    return {"manifest": manifest.name, "expected_files": len(entries),
            "verified_files": sum(e["status"] == "ok" for e in entries),
            "files": entries}


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("installation", type=Path)
    parser.add_argument("--manifest", type=Path)
    parser.add_argument("--report", type=Path)
    args = parser.parse_args()
    report = verify(args.installation,
                    args.manifest or args.installation / "_Redist/fitgirl.md5")
    if args.report:
        args.report.write_text(json.dumps(report, indent=2) + "\n")
    print(f"Verified {report['verified_files']}/{report['expected_files']} files")
    for entry in report["files"]:
        if entry["status"] != "ok":
            print(f"{entry['status']}: {entry['path']}")
    raise SystemExit(0 if report["verified_files"] == report["expected_files"] else 1)
