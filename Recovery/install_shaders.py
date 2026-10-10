#!/usr/bin/env python3
"""Install reconstructed shaders and compatible public package shader sources.

Workdir contains shader-export-variants, optional shader-export-array-fix,
postprocessing-source, tmp-shaders, probuilder-source and the pinned built-in
shader source mirror. Existing exported shader GUIDs are retained.
"""
import argparse
import hashlib
import json
from pathlib import Path
import re
import shutil


def shader_name(text):
    m = re.search(r'\bShader\s+"([^"]+)"', text)
    return m[1] if m else None


def reconstruct(text):
    light_keywords = ('DIRECTIONAL', 'POINT', 'SPOT', 'POINT_COOKIE', 'DIRECTIONAL_COOKIE')
    def fallback(body_match):
        body = body_match[1]
        # Forward-add passes have a point/spot fallback. Give that compiled
        # fallback its light type when Unity compiles the no-keyword variant.
        marker = body.rfind('\n#else\n')
        if marker >= 0:
            tail = body[marker + len('\n#else\n'):]
            keywords = set(re.findall(r'// Keywords: (.*)', tail)[0].split())
            chosen = next((k for k in light_keywords if k in keywords), None)
            if chosen:
                guard = ' && '.join('!defined(' + k + ')' for k in light_keywords)
                body = body[:marker + len('\n#else\n')] + '#if ' + guard + '\n#define ' + chosen + ' 1\n#endif\n' + tail
        found = re.findall(r'^#pragma multi_compile __ (' + '|'.join(light_keywords) + r')$', body, re.M)
        if found:
            body = re.sub(r'^#pragma multi_compile __ (' + '|'.join(light_keywords) + r')\n', '', body, flags=re.M)
            body = body.replace('#pragma target 3.0', '#pragma multi_compile __ ' + ' '.join(found) + '\n#pragma target 3.0')
        return 'CGPROGRAM' + body + 'ENDCG'
    text = re.sub(r'CGPROGRAM(.*?)ENDCG', fallback, text, flags=re.S)
    # The metadata converter names the first matrix of this built-in array.
    text = re.sub(r'\bunity_WorldToShadow(?=\._m)', 'unity_WorldToShadow[0]', text)
    # Matrix swizzles are valid D3D HLSL but fail in several cross compilers.
    text = re.sub(r'(\w+(?:\[\d+\])?)\.(_m\d\d(?:_m\d\d)+)', lambda m: 'float' + str(len(re.findall(r'_m(\d)(\d)', m[2]))) + '(' + ', '.join(m[1] + '[' + a + '][' + b + ']' for a, b in re.findall(r'_m(\d)(\d)', m[2])) + ')', text)
    text = text.replace('#pragma target 3.0', '#pragma target 3.5')
    text = re.sub(r'^\s*GpuProgramID \d+\s*$', '', text, flags=re.M)
    # Recreate standard Unity instance transforms around non-instanced DXBC.
    text = re.sub(r'(struct v2f\s*\{)', r'\1\n UNITY_VERTEX_INPUT_INSTANCE_ID', text)
    text = re.sub(r'(v2f vert\(appdata_full v\)\s*\{)', r'\1\n UNITY_SETUP_INSTANCE_ID(v);', text)
    text = text.replace('v2f o;', 'v2f o;\n UNITY_TRANSFER_INSTANCE_ID(v, o);')
    text = re.sub(r'(fout frag\(v2f inp[^)]*\)\s*\{)', r'\1\n UNITY_SETUP_INSTANCE_ID(inp);', text)
    text = re.sub(r'\btex2D\((unity_Lightmap|unity_LightmapInd|unity_ShadowMask)\s*,', r'UNITY_SAMPLE_TEX2D(\1,', text)
    text = re.sub(r'\btex3D\(unity_ProbeVolumeSH\s*,', r'UNITY_SAMPLE_TEX3D(unity_ProbeVolumeSH,', text)
    if '_ShadowMapTexture' in text or '_LightTexture' in text or 'unity_WorldToLight' in text:
        text = text.replace('#include "UnityCG.cginc"', '#include "UnityCG.cginc"\n#include "AutoLight.cginc"')
        # AutoLight declares these with the type required for the current light.
        text = re.sub(r'^\s*(?:float4x4|sampler2D|samplerCUBE)\s+(?:unity_WorldToLight|_LightTexture0|_LightTextureB0);\s*$', '', text, flags=re.M)
        text = re.sub(r'UNITY_SAMPLE_TEX2D_SAMPLER\((_ShadowMapTexture|_LightTexture0|_LightTextureB0),\s*\1,', r'tex2D(\1,', text)
        text = re.sub(r'UNITY_SAMPLE_TEXCUBE_SAMPLER\((_ShadowMapTexture|_LightTexture0),\s*\1,', r'texCUBE(\1,', text)
    if 'unity_ProbeVolumeParams' in text:
        # Built-in variants normally request this through Unity's tier keyword.
        # Preserve the variables even when the selected platform lacks LPPV.
        prelude = '''
#if !UNITY_LIGHT_PROBE_PROXY_VOLUME
UNITY_DECLARE_TEX3D_FLOAT(unity_ProbeVolumeSH);
float4 unity_ProbeVolumeParams;
float4x4 unity_ProbeVolumeWorldToObject;
float3 unity_ProbeVolumeSizeInv;
float3 unity_ProbeVolumeMin;
#endif
'''
        text = text.replace('#include "UnityCG.cginc"', '#include "UnityCG.cginc"' + prelude)
    return text


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('project', type=Path)
    parser.add_argument('workdir', type=Path)
    args = parser.parse_args()
    sources = {}
    for folder in ('shader-export-variants', 'shader-export-array-fix', 'shader-export-final'):
        directory = args.workdir / folder
        if not (directory / 'shader-index.json').exists():
            continue
        choices = {}
        for item in json.loads((directory / 'shader-index.json').read_text()):
            if not item['success']:
                continue
            p = directory / (item['file'] + '.shader')
            text = p.read_text()
            if item['name'] not in choices or len(text) > len(choices[item['name']][0]):
                choices[item['name']] = (text, dict(method='DXBC reconstruction', input=str(p.relative_to(args.workdir)), sourceBundle=item['source'], pathID=item['PathID']))
        for name, (text, provenance) in choices.items():
            sources[name] = (reconstruct(text), provenance)
    packages = [
        ('PostProcessing', args.workdir / 'postprocessing-source/PostProcessing/Shaders'),
        ('TextMeshPro', args.workdir / 'tmp-shaders'),
        ('ProBuilder', args.workdir / 'probuilder-source/Content/Shader'),
    ]
    for label, directory in packages:
        destination = args.project / 'Assets/RecoveryShaders' / label
        for p in directory.rglob('*'):
            if p.suffix not in ('.shader', '.cginc', '.hlsl'):
                continue
            text = p.read_text()
            text = text.replace('Packages/com.unity.postprocessing/PostProcessing/Shaders/', 'Assets/RecoveryShaders/PostProcessing/')
            # Resolve relative includes from shaders installed into original paths.
            def include(m):
                value = m[1]
                candidate = (p.parent / value).resolve()
                if candidate.is_relative_to(directory.resolve()) and candidate.is_file():
                    return '#include "Assets/RecoveryShaders/' + label + '/' + str(candidate.relative_to(directory.resolve())) + '"'
                return m[0]
            text = re.sub(r'#include\s+"([^"]+)"', include, text)
            if p.suffix == '.shader':
                sources[shader_name(text)] = (text, dict(method='Compatible public shader source', package=label, input=str(p.relative_to(args.workdir))))
            else:
                target = destination / p.relative_to(directory)
                target.parent.mkdir(parents=True, exist_ok=True)
                target.write_text(text)
    builtins = args.workdir / 'unity-builtin-shaders-2021.3.27f1/Shaders'
    for p in builtins.rglob('*.shader'):
        text = p.read_text()
        name = shader_name(text)
        if name:
            sources[name] = (text, dict(method='Unity 2021.3.27f1 built-in source', input=str(p.relative_to(args.workdir))))
    report = []
    # Snapshot list before creating include assets. All original GUIDs survive.
    for p in sorted((args.project / 'Assets').rglob('*.shader')):
        name = shader_name(p.read_text())
        if name not in sources:
            report.append(dict(path=str(p.relative_to(args.project)), name=name, success=False))
            continue
        text, origin = sources[name]
        # Editor GUI classes are not in a player build; use the generic inspector.
        text = re.sub(r'^\s*CustomEditor\s+"[^"]+"\s*$', '', text, flags=re.M)
        p.write_text(text)
        report.append(dict(path=str(p.relative_to(args.project)), name=name, success=True, sha256=hashlib.sha256(text.encode()).hexdigest(), **origin))
    (args.project / 'Recovery/shader-recovery.json').write_text(json.dumps(report, indent=2) + '\n')
    failures = [r for r in report if not r['success']]
    print(f'{len(report)} shader assets; {len(failures)} missing shader sources')
    for r in failures:
        print(r['name'], r['path'])
    raise SystemExit(bool(failures))
