Shader "Reptile/Skybox/XboxSeriesPanoramic" {
	Properties {
		_Tint ("Tint Color", Color) = (0.5,0.5,0.5,0.5)
		[Gamma] _Exposure ("Exposure", Range(0, 8)) = 1
		_Rotation ("Rotation", Range(0, 360)) = 0
		[NoScaleOffset] _MainTex ("Spherical  (HDR)", 2D) = "grey" {}
		[KeywordEnum(6 Frames Layout, Latitude Longitude Layout)] _Mapping ("Mapping", Float) = 1
		[Enum(360 Degrees, 0, 180 Degrees, 1)] _ImageType ("Image Type", Float) = 0
		[Toggle] _MirrorOnBack ("Mirror on Back", Float) = 0
		[Enum(None, 0, Side by Side, 1, Over Under, 2)] _Layout ("3D Layout", Float) = 0
	}
	SubShader {
		Tags { "PreviewType" = "Skybox" "QUEUE" = "Background" "RenderType" = "Background" }
		Pass {
			Tags { "PreviewType" = "Skybox" "QUEUE" = "Background" "RenderType" = "Background" }
			ZWrite Off
			Cull Off

CGPROGRAM
#pragma vertex vert
#pragma fragment frag
#pragma target 3.5
#pragma multi_compile_instancing
#pragma multi_compile __ _MAPPING_6_FRAMES_LAYOUT
#if defined(_MAPPING_6_FRAMES_LAYOUT)
			#include "UnityCG.cginc"
			struct v2f
			{
 UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 position : SV_POSITION0;
				float3 texcoord : TEXCOORD0;
				float3 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
				float4 texcoord3 : TEXCOORD3;
				float4 texcoord4 : TEXCOORD4;
				float4 texcoord5 : TEXCOORD5;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_TexelSize;
			float _Rotation;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _MainTex_HDR;
			float4 _Tint;
			float _Exposure;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			
			// Keywords: _MAPPING_6_FRAMES_LAYOUT
			v2f vert(appdata_full v)
			{
 UNITY_SETUP_INSTANCE_ID(v);
                v2f o;
 UNITY_TRANSFER_INSTANCE_ID(v, o);
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = _Rotation * 0.0174533;
                tmp0.x = sin(tmp0.x);
                tmp1.x = cos(tmp0.x);
                tmp2.x = -tmp0.x;
                tmp2.y = tmp1.x;
                tmp2.z = tmp0.x;
                tmp0.x = dot(tmp2.xy, v.vertex.xy);
                tmp0.y = dot(tmp2.xy, v.vertex.xy);
                tmp1 = v.vertex.yyyy * float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
                tmp1 = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]) * tmp0.yyyy + tmp1;
                tmp0 = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]) * tmp0.xxxx + tmp1;
                tmp0 = tmp0 + float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
                tmp1 = tmp0.yyyy * float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
                tmp1 = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]) * tmp0.xxxx + tmp1;
                tmp1 = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]) * tmp0.zzzz + tmp1;
                o.position = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]) * tmp0.wwww + tmp1;
                o.texcoord.xyz = v.vertex.xyz;
                tmp0.x = _MainTex_TexelSize.z / _MainTex_TexelSize.w;
                tmp0.xyz = tmp0.xxx > float3(1.0, 0.4583333, 3.666667);
                tmp1.xyz = tmp0.zzz ? float3(-1.0, 0.1666667, 1.0) : float3(-1.0, 0.25, 0.3333333);
                tmp2.xyz = tmp0.yyy ? float3(1.0, 0.3333333, 0.25) : float3(-1.0, 1.0, 0.1666667);
                tmp1.xyz = tmp0.xxx ? tmp1.xyz : tmp2.xyz;
                o.texcoord1.xyz = tmp1.xyz;
                tmp1.xw = _MainTex_TexelSize.xy * float2(0.5, 0.5);
                tmp1.xy = tmp1.xw / tmp1.yz;
                tmp1.xy = tmp1.xy - float2(0.5, 0.5);
                o.texcoord2.zw = -tmp1.xy;
                o.texcoord2.xy = tmp1.xy;
                tmp1 = tmp0.zzzz ? float4(0.5, 0.5, 1.5, 0.5) : float4(2.5, 1.5, 0.5, 1.5);
                tmp2 = tmp0.yyyy ? float4(2.5, 2.5, 0.5, 2.5) : float4(0.5, 5.5, 0.5, 4.5);
                o.texcoord3 = tmp0.xxxx ? tmp1 : tmp2;
                tmp1 = tmp0.zzzz ? float4(2.5, 0.5, 3.5, 0.5) : float4(1.5, 2.5, 1.5, 0.5);
                tmp2 = tmp0.yyyy ? float4(1.5, 3.5, 1.5, 1.5) : float4(0.5, 3.5, 0.5, 2.5);
                o.texcoord4 = tmp0.xxxx ? tmp1 : tmp2;
                tmp1 = tmp0.zzzz ? float4(4.5, 0.5, 5.5, 0.5) : float4(1.5, 1.5, 3.5, 1.5);
                tmp2 = tmp0.yyyy ? float4(1.5, 2.5, 1.5, 0.5) : float4(0.5, 1.5, 0.5, 0.5);
                o.texcoord5 = tmp0.xxxx ? tmp1 : tmp2;
                return o;
			}
			// Keywords: _MAPPING_6_FRAMES_LAYOUT
			fout frag(v2f inp)
			{
 UNITY_SETUP_INSTANCE_ID(inp);
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.xyz = inp.texcoord.zxx * float3(1.0, 1.0, -1.0);
                tmp1.xyz = max(abs(inp.texcoord.zzy), abs(inp.texcoord.yxx));
                tmp1.xyz = tmp1.xyz < abs(inp.texcoord.xyz);
                tmp1.xyz = tmp1.xyz ? 1.0 : 0.0;
                tmp0.x = dot(tmp1.xyz, tmp0.xyz);
                tmp2.xyz = inp.texcoord.yzy * float3(1.0, 1.0, -1.0);
                tmp0.y = dot(tmp1.xyz, tmp2.xyz);
                tmp2.x = dot(tmp1.xyz, inp.texcoord.xyz);
                tmp0.xy = tmp0.xy / tmp2.xx;
                tmp1.w = 0.0;
                tmp2.y = inp.texcoord1.x;
                tmp0.zw = tmp2.xy > float2(0.0, 0.0);
                tmp2.xy = tmp0.ww ? tmp1.zw : tmp1.wz;
                tmp2.xy = tmp0.zz ? tmp1.yx : tmp2.xy;
                tmp2.xy = tmp2.xy - float2(0.5, 0.5);
                tmp0.xy = tmp0.xy * tmp2.xy;
                tmp0.xy = max(tmp0.xy, inp.texcoord2.xy);
                tmp0.xy = min(tmp0.xy, inp.texcoord2.zw);
                tmp2 = tmp1.yyyy * inp.texcoord4;
                tmp2 = tmp1.xxxx * inp.texcoord3 + tmp2;
                tmp1 = tmp1.zzzz * inp.texcoord5 + tmp2;
                tmp0.zw = tmp0.zz ? tmp1.xy : tmp1.zw;
                tmp0.xy = tmp0.zw + tmp0.xy;
                tmp0.xy = tmp0.xy * inp.texcoord1.yz;
                tmp0 = tex2Dlod(_MainTex, float4(tmp0.xy, 0, 0.0));
                tmp0.w = tmp0.w - 1.0;
                tmp0.w = _MainTex_HDR.w * tmp0.w + 1.0;
                tmp0.w = log(tmp0.w);
                tmp0.w = tmp0.w * _MainTex_HDR.y;
                tmp0.w = exp(tmp0.w);
                tmp0.w = tmp0.w * _MainTex_HDR.x;
                tmp0.xyz = tmp0.xyz * tmp0.www;
                tmp0.xyz = tmp0.xyz * _Tint.xyz;
                tmp0.xyz = tmp0.xyz * _Exposure.xxx;
                o.sv_target.xyz = tmp0.xyz * float3(4.594794, 4.594794, 4.594794);
                o.sv_target.w = 1.0;
                return o;
			}
#else
			#include "UnityCG.cginc"
			struct v2f
			{
 UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 position : SV_POSITION0;
				float3 texcoord : TEXCOORD0;
				float2 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			int _Layout;
			bool _MirrorOnBack;
			int _ImageType;
			float _Rotation;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _MainTex_HDR;
			float4 _Tint;
			float _Exposure;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			
			// Keywords: 
			v2f vert(appdata_full v)
			{
 UNITY_SETUP_INSTANCE_ID(v);
                v2f o;
 UNITY_TRANSFER_INSTANCE_ID(v, o);
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = _Rotation * 0.0174533;
                tmp0.x = sin(tmp0.x);
                tmp1.x = cos(tmp0.x);
                tmp2.x = -tmp0.x;
                tmp2.y = tmp1.x;
                tmp2.z = tmp0.x;
                tmp0.x = dot(tmp2.xy, v.vertex.xy);
                tmp0.y = dot(tmp2.xy, v.vertex.xy);
                tmp1 = v.vertex.yyyy * float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
                tmp1 = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]) * tmp0.yyyy + tmp1;
                tmp0 = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]) * tmp0.xxxx + tmp1;
                tmp0 = tmp0 + float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
                tmp1 = tmp0.yyyy * float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
                tmp1 = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]) * tmp0.xxxx + tmp1;
                tmp1 = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]) * tmp0.zzzz + tmp1;
                o.position = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]) * tmp0.wwww + tmp1;
                o.texcoord.xyz = v.vertex.xyz;
                tmp0.y = _MirrorOnBack ? 1.0 : 0.5;
                tmp0.x = 2.0;
                o.texcoord1.xy = _ImageType.xx ? tmp0.xy : float2(1.0, 1.0);
                tmp0.x = 1 - unity_StereoEyeIndex;
                tmp0.y = floor(tmp0.x);
                tmp1.x = _Layout == 1;
                tmp2.x = floor(unity_StereoEyeIndex);
                tmp2.yzw = float3(0.0, 0.5, 1.0);
                tmp0.xzw = float3(0.0, 1.0, 0.5);
                tmp0 = tmp1.xxxx ? tmp2 : tmp0;
                o.texcoord2 = _Layout.xxxx ? tmp0 : float4(0.0, 0.0, 1.0, 1.0);
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
 UNITY_SETUP_INSTANCE_ID(inp);
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = dot(inp.texcoord.xyz, inp.texcoord.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp0.xyz = tmp0.xxx * inp.texcoord.yzx;
                tmp0.w = 1.0 - abs(tmp0.x);
                tmp0.w = sqrt(tmp0.w);
                tmp1.x = abs(tmp0.x) * -0.0187293 + 0.074261;
                tmp1.x = tmp1.x * abs(tmp0.x) + -0.2121144;
                tmp1.x = tmp1.x * abs(tmp0.x) + 1.570729;
                tmp1.y = tmp0.w * tmp1.x;
                tmp1.y = tmp1.y * -2.0 + 3.141593;
                tmp1.zw = tmp0.xz < -tmp0.xz;
                tmp0.x = tmp1.z ? tmp1.y : 0.0;
                tmp1.z = tmp1.x * tmp0.w + tmp0.x;
                tmp0.x = min(abs(tmp0.z), abs(tmp0.y));
                tmp0.w = max(abs(tmp0.z), abs(tmp0.y));
                tmp0.w = 1.0 / tmp0.w;
                tmp0.x = tmp0.w * tmp0.x;
                tmp0.w = tmp0.x * tmp0.x;
                tmp1.x = tmp0.w * 0.0208351 + -0.085133;
                tmp1.x = tmp0.w * tmp1.x + 0.180141;
                tmp1.x = tmp0.w * tmp1.x + -0.3302995;
                tmp0.w = tmp0.w * tmp1.x + 0.999866;
                tmp1.x = tmp0.w * tmp0.x;
                tmp2.x = abs(tmp0.z) < abs(tmp0.y);
                tmp1.x = tmp1.x * -2.0 + 1.570796;
                tmp1.x = tmp2.x ? tmp1.x : 0.0;
                tmp0.x = tmp0.x * tmp0.w + tmp1.x;
                tmp0.w = tmp1.w ? -3.141593 : 0.0;
                tmp0.x = tmp0.w + tmp0.x;
                tmp0.w = min(tmp0.z, tmp0.y);
                tmp0.y = max(tmp0.z, tmp0.y);
                tmp0.z = tmp0.w < -tmp0.w;
                tmp0.y = tmp0.y >= -tmp0.y;
                tmp0.y = tmp0.y ? tmp0.z : 0.0;
                tmp1.y = tmp0.y ? -tmp0.x : tmp0.x;
                tmp0.yz = -tmp1.yz * float2(0.1591549, 0.3183099) + float2(0.5, 1.0);
                tmp0.w = inp.texcoord1.y < tmp0.y;
                if (tmp0.w) {
                    o.sv_target = float4(0.0, 0.0, 0.0, 1.0);
                    return o;
                }
                tmp0.y = tmp0.y * inp.texcoord1.x;
                tmp0.w = tmp0.y >= -tmp0.y;
                tmp0.y = frac(abs(tmp0.y));
                tmp0.x = tmp0.w ? tmp0.y : -tmp0.y;
                tmp0.xy = tmp0.xz + inp.texcoord2.xy;
                tmp0.xy = tmp0.xy * inp.texcoord2.zw;
                tmp0 = tex2Dlod(_MainTex, float4(tmp0.xy, 0, 0.0));
                tmp0.w = tmp0.w - 1.0;
                tmp0.w = _MainTex_HDR.w * tmp0.w + 1.0;
                tmp0.w = log(tmp0.w);
                tmp0.w = tmp0.w * _MainTex_HDR.y;
                tmp0.w = exp(tmp0.w);
                tmp0.w = tmp0.w * _MainTex_HDR.x;
                tmp0.xyz = tmp0.xyz * tmp0.www;
                tmp0.xyz = tmp0.xyz * _Tint.xyz;
                tmp0.xyz = tmp0.xyz * _Exposure.xxx;
                o.sv_target.xyz = tmp0.xyz * float3(4.594794, 4.594794, 4.594794);
                o.sv_target.w = 1.0;
                return o;
			}
#endif
			ENDCG
		}
	}

}