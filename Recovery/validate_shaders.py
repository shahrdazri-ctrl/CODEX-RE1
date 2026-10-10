#!/usr/bin/env python3
"""Compile every recovered HLSL branch with glslang and Unity's matching includes.

This checks HLSL compilation; it does not replace Unity ShaderLab import or
visual play tests. Public package shaders are validated by Unity locally.
"""
import argparse
import concurrent.futures
import hashlib
import json
from pathlib import Path
import re
import subprocess

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('project', type=Path)
    parser.add_argument('--compiler', type=Path, required=True)
    parser.add_argument('--includes', type=Path, required=True)
    parser.add_argument('--output', type=Path, required=True)
    parser.add_argument('--report', type=Path, required=True)
    args = parser.parse_args()
    args.output.mkdir(parents=True, exist_ok=True)
    report = json.loads((args.project / 'Recovery/shader-recovery.json').read_text())
    unique = {}
    for item in report:
        if item.get('method') == 'DXBC reconstruction':
            unique.setdefault(item['name'], args.project / item['path'])
    tasks = []
    for name, p in unique.items():
        for pass_index, body in enumerate(re.findall(r'CGPROGRAM(.*?)ENDCG', p.read_text(), re.S)):
            # Each branch retains the exact keyword combination that generated it.
            choices = [()] + [tuple(re.findall(r'(?<!!)defined\((\w+)\)', line))
                             for line in body.splitlines() if line.startswith(('#if ', '#elif '))]
            # The fallback branch is tested with no keywords. The instancing
            # bridge is also compiled once per pass.
            choices += [('INSTANCING_ON',)]
            for keywords in sorted(set(choices)):
                for stage in ('vert', 'frag'):
                    tasks.append((name, str(p.relative_to(args.project)), pass_index, body, keywords, stage))
    def compile(task):
        name, path, pass_index, body, keywords, stage = task
        key = hashlib.sha256((name + str(pass_index) + ','.join(keywords) + stage).encode()).hexdigest()[:24]
        source = args.output / (key + '.hlsl')
        # glslang consumes the code independently from Unity's pragma processor.
        body = re.sub(r'^\s*#pragma.*$', '', body, flags=re.M)
        source.write_text('#include "HLSLSupport.cginc"\n' + body)
        command = [str(args.compiler.resolve()), '-D', '-V', '--hlsl-dx9-compatible',
                   '--auto-map-bindings', '--auto-map-locations', '-DSHADER_API_D3D11=1',
                   '-DUNITY_VERSION=202130', '-DSHADER_TARGET=35', '-I' + str(args.includes.resolve())]
        command += ['-D' + k + '=1' for k in keywords]
        command += ['-S', stage, '-e', 'vert' if stage == 'vert' else 'frag', '-o', str(source.with_suffix('.spv')), str(source)]
        run = subprocess.run(command, capture_output=True, text=True)
        return dict(name=name, path=path, passIndex=pass_index, keywords=keywords,
                    stage=stage, success=run.returncode == 0, exitCode=run.returncode, log=run.stdout + run.stderr)
    with concurrent.futures.ThreadPoolExecutor(max_workers=6) as pool:
        results = list(pool.map(compile, tasks))
    args.report.write_text(json.dumps(results, indent=2) + '\n')
    failures = [r for r in results if not r['success']]
    print(f'{len(unique)} unique reconstructed shaders; {len(results)} stage/keyword checks; {len(failures)} failures')
    seen = set()
    for r in failures:
        error = '\n'.join(l for l in r['log'].splitlines() if l.startswith('ERROR:'))[:800]
        key = (r['name'], error)
        if key not in seen:
            print(r['name'], r['passIndex'], r['keywords'], r['stage'], r['exitCode'], error)
            seen.add(key)
    raise SystemExit(bool(failures))
