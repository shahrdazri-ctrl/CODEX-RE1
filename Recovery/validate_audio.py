#!/usr/bin/env python3
"""Probe every recovered audio file; report invalid or empty streams."""
import argparse
import concurrent.futures
import json
from pathlib import Path
import subprocess

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('assets', type=Path)
    parser.add_argument('--report', type=Path, required=True)
    args = parser.parse_args()
    root = args.assets.resolve()
    paths = sorted(p for p in root.rglob('*') if p.suffix in ('.ogg', '.wav'))
    def probe(path):
        run = subprocess.run(['ffprobe', '-v', 'error', '-select_streams', 'a:0',
                              '-show_entries', 'stream=codec_name,sample_rate,channels:format=duration',
                              '-of', 'json', str(path)], capture_output=True, text=True)
        data = json.loads(run.stdout or '{}')
        success = run.returncode == 0 and bool(data.get('streams')) and float(data.get('format', {}).get('duration', 0)) > 0
        return dict(path=str(path.relative_to(root)), success=success, **data, error=run.stderr)
    with concurrent.futures.ThreadPoolExecutor(max_workers=4) as pool:
        results = list(pool.map(probe, paths))
    failures = [r for r in results if not r['success']]
    args.report.write_text(json.dumps(results, indent=2) + '\n')
    print(f'{len(results)} audio files; {len(failures)} probe failures')
    for failure in failures[:10]:
        print(failure)
    raise SystemExit(bool(failures))
