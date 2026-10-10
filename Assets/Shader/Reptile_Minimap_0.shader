Shader "Reptile/Minimap" {
	Properties {
		_MainTex ("MainTex", 2D) = "white" {}
		_ColorLow ("Color Low", Color) = (1,1,1,1)
		_ColorHigh ("Color High", Color) = (1,1,1,1)
		_Offset ("Height Offset", Float) = 5000
		_Scale ("Height Scale", Float) = 100
	}
	SubShader {
		Tags { "LIGHTMODE" = "FORWARDBASE" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
		Pass {
			Tags { "LIGHTMODE" = "FORWARDBASE" "QUEUE" = "Transparent" "RenderType" = "Transparent" "SHADOWSUPPORT" = "true" }
			Blend SrcAlpha OneMinusSrcAlpha, SrcAlpha OneMinusSrcAlpha

CGPROGRAM
#pragma vertex vert
#pragma fragment frag
#pragma multi_compile __ DIRECTIONAL
#pragma target 3.5
#pragma multi_compile_instancing
#pragma multi_compile __ LIGHTMAP_ON
#pragma multi_compile __ LIGHTMAP_SHADOW_MIXING
#pragma multi_compile __ LIGHTPROBE_SH
#pragma multi_compile __ SHADOWS_SCREEN
#pragma multi_compile __ SHADOWS_SHADOWMASK
#pragma multi_compile __ VERTEXLIGHT_ON
#if defined(DIRECTIONAL) && defined(LIGHTMAP_ON) && defined(LIGHTMAP_SHADOW_MIXING) && defined(LIGHTPROBE_SH) && defined(SHADOWS_SCREEN) && defined(SHADOWS_SHADOWMASK) && !defined(VERTEXLIGHT_ON)
			#include "UnityCG.cginc"
			struct v2f
			{
 UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float3 texcoord1 : TEXCOORD1;
				float3 texcoord2 : TEXCOORD2;
				float4 texcoord4 : TEXCOORD4;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _ColorLow;
			float4 _ColorHigh;
			float _Offset;
			float _Scale;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			
			// Keywords: DIRECTIONAL LIGHTPROBE_SH SHADOWS_SHADOWMASK LIGHTMAP_ON LIGHTMAP_SHADOW_MIXING SHADOWS_SCREEN
			v2f vert(appdata_full v)
			{
 UNITY_SETUP_INSTANCE_ID(v);
                v2f o;
 UNITY_TRANSFER_INSTANCE_ID(v, o);
                float4 tmp0;
                float4 tmp1;
                tmp0 = v.vertex.yyyy * float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
                tmp0 = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]) * v.vertex.xxxx + tmp0;
                tmp0 = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]) * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
                o.texcoord2.xyz = float3(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3]) * v.vertex.www + tmp0.xyz;
                tmp0 = tmp1.yyyy * float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
                tmp0 = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]) * tmp1.xxxx + tmp0;
                tmp0 = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]) * tmp1.zzzz + tmp0;
                tmp0 = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]) * tmp1.wwww + tmp0;
                o.position = tmp0;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp1.x = dot(v.normal.xyz, float3(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0]));
                tmp1.y = dot(v.normal.xyz, float3(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1]));
                tmp1.z = dot(v.normal.xyz, float3(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2]));
                tmp1.w = dot(tmp1.xyz, tmp1.xyz);
                tmp1.w = rsqrt(tmp1.w);
                o.texcoord1.xyz = tmp1.www * tmp1.xyz;
                tmp1.xyz = tmp0.xyw * float3(0.5, 0.5, 0.5);
                o.texcoord4.zw = tmp0.zw;
                tmp1.w = tmp1.y * _ProjectionParams.x;
                o.texcoord4.xy = tmp1.zz + tmp1.xw;
                return o;
			}
			// Keywords: DIRECTIONAL LIGHTPROBE_SH SHADOWS_SHADOWMASK LIGHTMAP_ON LIGHTMAP_SHADOW_MIXING SHADOWS_SCREEN
			fout frag(v2f inp)
			{
 UNITY_SETUP_INSTANCE_ID(inp);
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = inp.texcoord2.y + _Offset;
                tmp0.x = saturate(tmp0.x / _Scale);
                tmp1 = _ColorHigh - _ColorLow;
                o.sv_target = tmp0.xxxx * tmp1 + _ColorLow;
                return o;
			}
#elif defined(DIRECTIONAL) && !defined(LIGHTMAP_ON) && defined(LIGHTMAP_SHADOW_MIXING) && defined(LIGHTPROBE_SH) && defined(SHADOWS_SCREEN) && defined(SHADOWS_SHADOWMASK) && defined(VERTEXLIGHT_ON)
			#include "UnityCG.cginc"
			struct v2f
			{
 UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float3 texcoord1 : TEXCOORD1;
				float3 texcoord2 : TEXCOORD2;
				float4 texcoord4 : TEXCOORD4;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _ColorLow;
			float4 _ColorHigh;
			float _Offset;
			float _Scale;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			
			// Keywords: DIRECTIONAL LIGHTPROBE_SH SHADOWS_SHADOWMASK LIGHTMAP_SHADOW_MIXING SHADOWS_SCREEN VERTEXLIGHT_ON
			v2f vert(appdata_full v)
			{
 UNITY_SETUP_INSTANCE_ID(v);
                v2f o;
 UNITY_TRANSFER_INSTANCE_ID(v, o);
                float4 tmp0;
                float4 tmp1;
                tmp0 = v.vertex.yyyy * float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
                tmp0 = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]) * v.vertex.xxxx + tmp0;
                tmp0 = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]) * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
                o.texcoord2.xyz = float3(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3]) * v.vertex.www + tmp0.xyz;
                tmp0 = tmp1.yyyy * float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
                tmp0 = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]) * tmp1.xxxx + tmp0;
                tmp0 = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]) * tmp1.zzzz + tmp0;
                tmp0 = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]) * tmp1.wwww + tmp0;
                o.position = tmp0;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp1.x = dot(v.normal.xyz, float3(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0]));
                tmp1.y = dot(v.normal.xyz, float3(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1]));
                tmp1.z = dot(v.normal.xyz, float3(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2]));
                tmp1.w = dot(tmp1.xyz, tmp1.xyz);
                tmp1.w = rsqrt(tmp1.w);
                o.texcoord1.xyz = tmp1.www * tmp1.xyz;
                tmp1.xyz = tmp0.xyw * float3(0.5, 0.5, 0.5);
                o.texcoord4.zw = tmp0.zw;
                tmp1.w = tmp1.y * _ProjectionParams.x;
                o.texcoord4.xy = tmp1.zz + tmp1.xw;
                return o;
			}
			// Keywords: DIRECTIONAL LIGHTPROBE_SH SHADOWS_SHADOWMASK LIGHTMAP_SHADOW_MIXING SHADOWS_SCREEN
			fout frag(v2f inp)
			{
 UNITY_SETUP_INSTANCE_ID(inp);
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = inp.texcoord2.y + _Offset;
                tmp0.x = saturate(tmp0.x / _Scale);
                tmp1 = _ColorHigh - _ColorLow;
                o.sv_target = tmp0.xxxx * tmp1 + _ColorLow;
                return o;
			}
#elif defined(DIRECTIONAL) && defined(LIGHTMAP_ON) && defined(LIGHTMAP_SHADOW_MIXING) && defined(LIGHTPROBE_SH) && !defined(SHADOWS_SCREEN) && defined(SHADOWS_SHADOWMASK) && !defined(VERTEXLIGHT_ON)
			#include "UnityCG.cginc"
			struct v2f
			{
 UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float3 texcoord1 : TEXCOORD1;
				float3 texcoord2 : TEXCOORD2;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _ColorLow;
			float4 _ColorHigh;
			float _Offset;
			float _Scale;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			
			// Keywords: DIRECTIONAL LIGHTPROBE_SH SHADOWS_SHADOWMASK LIGHTMAP_ON LIGHTMAP_SHADOW_MIXING
			v2f vert(appdata_full v)
			{
 UNITY_SETUP_INSTANCE_ID(v);
                v2f o;
 UNITY_TRANSFER_INSTANCE_ID(v, o);
                float4 tmp0;
                float4 tmp1;
                tmp0 = v.vertex.yyyy * float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
                tmp0 = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]) * v.vertex.xxxx + tmp0;
                tmp0 = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]) * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
                o.texcoord2.xyz = float3(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3]) * v.vertex.www + tmp0.xyz;
                tmp0 = tmp1.yyyy * float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
                tmp0 = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]) * tmp1.xxxx + tmp0;
                tmp0 = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]) * tmp1.zzzz + tmp0;
                o.position = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]) * tmp1.wwww + tmp0;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp0.x = dot(v.normal.xyz, float3(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0]));
                tmp0.y = dot(v.normal.xyz, float3(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1]));
                tmp0.z = dot(v.normal.xyz, float3(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2]));
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord1.xyz = tmp0.www * tmp0.xyz;
                return o;
			}
			// Keywords: DIRECTIONAL LIGHTPROBE_SH SHADOWS_SHADOWMASK LIGHTMAP_ON LIGHTMAP_SHADOW_MIXING
			fout frag(v2f inp)
			{
 UNITY_SETUP_INSTANCE_ID(inp);
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = inp.texcoord2.y + _Offset;
                tmp0.x = saturate(tmp0.x / _Scale);
                tmp1 = _ColorHigh - _ColorLow;
                o.sv_target = tmp0.xxxx * tmp1 + _ColorLow;
                return o;
			}
#elif defined(DIRECTIONAL) && !defined(LIGHTMAP_ON) && defined(LIGHTMAP_SHADOW_MIXING) && defined(LIGHTPROBE_SH) && defined(SHADOWS_SCREEN) && defined(SHADOWS_SHADOWMASK) && !defined(VERTEXLIGHT_ON)
			#include "UnityCG.cginc"
			struct v2f
			{
 UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float3 texcoord1 : TEXCOORD1;
				float3 texcoord2 : TEXCOORD2;
				float4 texcoord4 : TEXCOORD4;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _ColorLow;
			float4 _ColorHigh;
			float _Offset;
			float _Scale;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			
			// Keywords: DIRECTIONAL LIGHTPROBE_SH SHADOWS_SHADOWMASK LIGHTMAP_SHADOW_MIXING SHADOWS_SCREEN
			v2f vert(appdata_full v)
			{
 UNITY_SETUP_INSTANCE_ID(v);
                v2f o;
 UNITY_TRANSFER_INSTANCE_ID(v, o);
                float4 tmp0;
                float4 tmp1;
                tmp0 = v.vertex.yyyy * float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
                tmp0 = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]) * v.vertex.xxxx + tmp0;
                tmp0 = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]) * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
                o.texcoord2.xyz = float3(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3]) * v.vertex.www + tmp0.xyz;
                tmp0 = tmp1.yyyy * float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
                tmp0 = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]) * tmp1.xxxx + tmp0;
                tmp0 = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]) * tmp1.zzzz + tmp0;
                tmp0 = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]) * tmp1.wwww + tmp0;
                o.position = tmp0;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp1.x = dot(v.normal.xyz, float3(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0]));
                tmp1.y = dot(v.normal.xyz, float3(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1]));
                tmp1.z = dot(v.normal.xyz, float3(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2]));
                tmp1.w = dot(tmp1.xyz, tmp1.xyz);
                tmp1.w = rsqrt(tmp1.w);
                o.texcoord1.xyz = tmp1.www * tmp1.xyz;
                tmp1.xyz = tmp0.xyw * float3(0.5, 0.5, 0.5);
                o.texcoord4.zw = tmp0.zw;
                tmp1.w = tmp1.y * _ProjectionParams.x;
                o.texcoord4.xy = tmp1.zz + tmp1.xw;
                return o;
			}
			// Keywords: DIRECTIONAL LIGHTPROBE_SH SHADOWS_SHADOWMASK LIGHTMAP_SHADOW_MIXING SHADOWS_SCREEN
			fout frag(v2f inp)
			{
 UNITY_SETUP_INSTANCE_ID(inp);
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = inp.texcoord2.y + _Offset;
                tmp0.x = saturate(tmp0.x / _Scale);
                tmp1 = _ColorHigh - _ColorLow;
                o.sv_target = tmp0.xxxx * tmp1 + _ColorLow;
                return o;
			}
#elif defined(DIRECTIONAL) && defined(LIGHTMAP_ON) && defined(LIGHTMAP_SHADOW_MIXING) && defined(LIGHTPROBE_SH) && defined(SHADOWS_SCREEN) && !defined(SHADOWS_SHADOWMASK) && !defined(VERTEXLIGHT_ON)
			#include "UnityCG.cginc"
			struct v2f
			{
 UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float3 texcoord1 : TEXCOORD1;
				float3 texcoord2 : TEXCOORD2;
				float4 texcoord4 : TEXCOORD4;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _ColorLow;
			float4 _ColorHigh;
			float _Offset;
			float _Scale;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			
			// Keywords: DIRECTIONAL LIGHTPROBE_SH LIGHTMAP_ON LIGHTMAP_SHADOW_MIXING SHADOWS_SCREEN
			v2f vert(appdata_full v)
			{
 UNITY_SETUP_INSTANCE_ID(v);
                v2f o;
 UNITY_TRANSFER_INSTANCE_ID(v, o);
                float4 tmp0;
                float4 tmp1;
                tmp0 = v.vertex.yyyy * float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
                tmp0 = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]) * v.vertex.xxxx + tmp0;
                tmp0 = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]) * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
                o.texcoord2.xyz = float3(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3]) * v.vertex.www + tmp0.xyz;
                tmp0 = tmp1.yyyy * float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
                tmp0 = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]) * tmp1.xxxx + tmp0;
                tmp0 = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]) * tmp1.zzzz + tmp0;
                tmp0 = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]) * tmp1.wwww + tmp0;
                o.position = tmp0;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp1.x = dot(v.normal.xyz, float3(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0]));
                tmp1.y = dot(v.normal.xyz, float3(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1]));
                tmp1.z = dot(v.normal.xyz, float3(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2]));
                tmp1.w = dot(tmp1.xyz, tmp1.xyz);
                tmp1.w = rsqrt(tmp1.w);
                o.texcoord1.xyz = tmp1.www * tmp1.xyz;
                tmp1.xyz = tmp0.xyw * float3(0.5, 0.5, 0.5);
                o.texcoord4.zw = tmp0.zw;
                tmp1.w = tmp1.y * _ProjectionParams.x;
                o.texcoord4.xy = tmp1.zz + tmp1.xw;
                return o;
			}
			// Keywords: DIRECTIONAL LIGHTPROBE_SH LIGHTMAP_ON LIGHTMAP_SHADOW_MIXING SHADOWS_SCREEN
			fout frag(v2f inp)
			{
 UNITY_SETUP_INSTANCE_ID(inp);
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = inp.texcoord2.y + _Offset;
                tmp0.x = saturate(tmp0.x / _Scale);
                tmp1 = _ColorHigh - _ColorLow;
                o.sv_target = tmp0.xxxx * tmp1 + _ColorLow;
                return o;
			}
#elif defined(DIRECTIONAL) && defined(LIGHTMAP_ON) && !defined(LIGHTMAP_SHADOW_MIXING) && defined(LIGHTPROBE_SH) && defined(SHADOWS_SCREEN) && defined(SHADOWS_SHADOWMASK) && !defined(VERTEXLIGHT_ON)
			#include "UnityCG.cginc"
			struct v2f
			{
 UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float3 texcoord1 : TEXCOORD1;
				float3 texcoord2 : TEXCOORD2;
				float4 texcoord4 : TEXCOORD4;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _ColorLow;
			float4 _ColorHigh;
			float _Offset;
			float _Scale;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			
			// Keywords: DIRECTIONAL LIGHTPROBE_SH SHADOWS_SHADOWMASK LIGHTMAP_ON SHADOWS_SCREEN
			v2f vert(appdata_full v)
			{
 UNITY_SETUP_INSTANCE_ID(v);
                v2f o;
 UNITY_TRANSFER_INSTANCE_ID(v, o);
                float4 tmp0;
                float4 tmp1;
                tmp0 = v.vertex.yyyy * float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
                tmp0 = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]) * v.vertex.xxxx + tmp0;
                tmp0 = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]) * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
                o.texcoord2.xyz = float3(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3]) * v.vertex.www + tmp0.xyz;
                tmp0 = tmp1.yyyy * float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
                tmp0 = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]) * tmp1.xxxx + tmp0;
                tmp0 = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]) * tmp1.zzzz + tmp0;
                tmp0 = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]) * tmp1.wwww + tmp0;
                o.position = tmp0;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp1.x = dot(v.normal.xyz, float3(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0]));
                tmp1.y = dot(v.normal.xyz, float3(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1]));
                tmp1.z = dot(v.normal.xyz, float3(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2]));
                tmp1.w = dot(tmp1.xyz, tmp1.xyz);
                tmp1.w = rsqrt(tmp1.w);
                o.texcoord1.xyz = tmp1.www * tmp1.xyz;
                tmp1.xyz = tmp0.xyw * float3(0.5, 0.5, 0.5);
                o.texcoord4.zw = tmp0.zw;
                tmp1.w = tmp1.y * _ProjectionParams.x;
                o.texcoord4.xy = tmp1.zz + tmp1.xw;
                return o;
			}
			// Keywords: DIRECTIONAL LIGHTPROBE_SH SHADOWS_SHADOWMASK LIGHTMAP_ON SHADOWS_SCREEN
			fout frag(v2f inp)
			{
 UNITY_SETUP_INSTANCE_ID(inp);
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = inp.texcoord2.y + _Offset;
                tmp0.x = saturate(tmp0.x / _Scale);
                tmp1 = _ColorHigh - _ColorLow;
                o.sv_target = tmp0.xxxx * tmp1 + _ColorLow;
                return o;
			}
#elif defined(DIRECTIONAL) && defined(LIGHTMAP_ON) && defined(LIGHTMAP_SHADOW_MIXING) && !defined(LIGHTPROBE_SH) && defined(SHADOWS_SCREEN) && defined(SHADOWS_SHADOWMASK) && !defined(VERTEXLIGHT_ON)
			#include "UnityCG.cginc"
			struct v2f
			{
 UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float3 texcoord1 : TEXCOORD1;
				float3 texcoord2 : TEXCOORD2;
				float4 texcoord4 : TEXCOORD4;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _ColorLow;
			float4 _ColorHigh;
			float _Offset;
			float _Scale;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			
			// Keywords: DIRECTIONAL SHADOWS_SHADOWMASK LIGHTMAP_ON LIGHTMAP_SHADOW_MIXING SHADOWS_SCREEN
			v2f vert(appdata_full v)
			{
 UNITY_SETUP_INSTANCE_ID(v);
                v2f o;
 UNITY_TRANSFER_INSTANCE_ID(v, o);
                float4 tmp0;
                float4 tmp1;
                tmp0 = v.vertex.yyyy * float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
                tmp0 = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]) * v.vertex.xxxx + tmp0;
                tmp0 = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]) * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
                o.texcoord2.xyz = float3(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3]) * v.vertex.www + tmp0.xyz;
                tmp0 = tmp1.yyyy * float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
                tmp0 = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]) * tmp1.xxxx + tmp0;
                tmp0 = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]) * tmp1.zzzz + tmp0;
                tmp0 = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]) * tmp1.wwww + tmp0;
                o.position = tmp0;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp1.x = dot(v.normal.xyz, float3(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0]));
                tmp1.y = dot(v.normal.xyz, float3(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1]));
                tmp1.z = dot(v.normal.xyz, float3(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2]));
                tmp1.w = dot(tmp1.xyz, tmp1.xyz);
                tmp1.w = rsqrt(tmp1.w);
                o.texcoord1.xyz = tmp1.www * tmp1.xyz;
                tmp1.xyz = tmp0.xyw * float3(0.5, 0.5, 0.5);
                o.texcoord4.zw = tmp0.zw;
                tmp1.w = tmp1.y * _ProjectionParams.x;
                o.texcoord4.xy = tmp1.zz + tmp1.xw;
                return o;
			}
			// Keywords: DIRECTIONAL SHADOWS_SHADOWMASK LIGHTMAP_ON LIGHTMAP_SHADOW_MIXING SHADOWS_SCREEN
			fout frag(v2f inp)
			{
 UNITY_SETUP_INSTANCE_ID(inp);
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = inp.texcoord2.y + _Offset;
                tmp0.x = saturate(tmp0.x / _Scale);
                tmp1 = _ColorHigh - _ColorLow;
                o.sv_target = tmp0.xxxx * tmp1 + _ColorLow;
                return o;
			}
#elif defined(DIRECTIONAL) && !defined(LIGHTMAP_ON) && defined(LIGHTMAP_SHADOW_MIXING) && defined(LIGHTPROBE_SH) && defined(SHADOWS_SCREEN) && !defined(SHADOWS_SHADOWMASK) && defined(VERTEXLIGHT_ON)
			#include "UnityCG.cginc"
			struct v2f
			{
 UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float3 texcoord1 : TEXCOORD1;
				float3 texcoord2 : TEXCOORD2;
				float4 texcoord4 : TEXCOORD4;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _ColorLow;
			float4 _ColorHigh;
			float _Offset;
			float _Scale;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			
			// Keywords: DIRECTIONAL LIGHTPROBE_SH LIGHTMAP_SHADOW_MIXING SHADOWS_SCREEN VERTEXLIGHT_ON
			v2f vert(appdata_full v)
			{
 UNITY_SETUP_INSTANCE_ID(v);
                v2f o;
 UNITY_TRANSFER_INSTANCE_ID(v, o);
                float4 tmp0;
                float4 tmp1;
                tmp0 = v.vertex.yyyy * float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
                tmp0 = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]) * v.vertex.xxxx + tmp0;
                tmp0 = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]) * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
                o.texcoord2.xyz = float3(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3]) * v.vertex.www + tmp0.xyz;
                tmp0 = tmp1.yyyy * float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
                tmp0 = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]) * tmp1.xxxx + tmp0;
                tmp0 = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]) * tmp1.zzzz + tmp0;
                tmp0 = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]) * tmp1.wwww + tmp0;
                o.position = tmp0;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp1.x = dot(v.normal.xyz, float3(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0]));
                tmp1.y = dot(v.normal.xyz, float3(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1]));
                tmp1.z = dot(v.normal.xyz, float3(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2]));
                tmp1.w = dot(tmp1.xyz, tmp1.xyz);
                tmp1.w = rsqrt(tmp1.w);
                o.texcoord1.xyz = tmp1.www * tmp1.xyz;
                tmp1.xyz = tmp0.xyw * float3(0.5, 0.5, 0.5);
                o.texcoord4.zw = tmp0.zw;
                tmp1.w = tmp1.y * _ProjectionParams.x;
                o.texcoord4.xy = tmp1.zz + tmp1.xw;
                return o;
			}
			// Keywords: DIRECTIONAL LIGHTPROBE_SH LIGHTMAP_SHADOW_MIXING SHADOWS_SCREEN
			fout frag(v2f inp)
			{
 UNITY_SETUP_INSTANCE_ID(inp);
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = inp.texcoord2.y + _Offset;
                tmp0.x = saturate(tmp0.x / _Scale);
                tmp1 = _ColorHigh - _ColorLow;
                o.sv_target = tmp0.xxxx * tmp1 + _ColorLow;
                return o;
			}
#elif defined(DIRECTIONAL) && !defined(LIGHTMAP_ON) && !defined(LIGHTMAP_SHADOW_MIXING) && defined(LIGHTPROBE_SH) && defined(SHADOWS_SCREEN) && defined(SHADOWS_SHADOWMASK) && defined(VERTEXLIGHT_ON)
			#include "UnityCG.cginc"
			struct v2f
			{
 UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float3 texcoord1 : TEXCOORD1;
				float3 texcoord2 : TEXCOORD2;
				float4 texcoord4 : TEXCOORD4;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _ColorLow;
			float4 _ColorHigh;
			float _Offset;
			float _Scale;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			
			// Keywords: DIRECTIONAL LIGHTPROBE_SH SHADOWS_SHADOWMASK SHADOWS_SCREEN VERTEXLIGHT_ON
			v2f vert(appdata_full v)
			{
 UNITY_SETUP_INSTANCE_ID(v);
                v2f o;
 UNITY_TRANSFER_INSTANCE_ID(v, o);
                float4 tmp0;
                float4 tmp1;
                tmp0 = v.vertex.yyyy * float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
                tmp0 = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]) * v.vertex.xxxx + tmp0;
                tmp0 = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]) * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
                o.texcoord2.xyz = float3(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3]) * v.vertex.www + tmp0.xyz;
                tmp0 = tmp1.yyyy * float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
                tmp0 = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]) * tmp1.xxxx + tmp0;
                tmp0 = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]) * tmp1.zzzz + tmp0;
                tmp0 = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]) * tmp1.wwww + tmp0;
                o.position = tmp0;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp1.x = dot(v.normal.xyz, float3(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0]));
                tmp1.y = dot(v.normal.xyz, float3(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1]));
                tmp1.z = dot(v.normal.xyz, float3(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2]));
                tmp1.w = dot(tmp1.xyz, tmp1.xyz);
                tmp1.w = rsqrt(tmp1.w);
                o.texcoord1.xyz = tmp1.www * tmp1.xyz;
                tmp1.xyz = tmp0.xyw * float3(0.5, 0.5, 0.5);
                o.texcoord4.zw = tmp0.zw;
                tmp1.w = tmp1.y * _ProjectionParams.x;
                o.texcoord4.xy = tmp1.zz + tmp1.xw;
                return o;
			}
			// Keywords: DIRECTIONAL LIGHTPROBE_SH SHADOWS_SHADOWMASK SHADOWS_SCREEN
			fout frag(v2f inp)
			{
 UNITY_SETUP_INSTANCE_ID(inp);
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = inp.texcoord2.y + _Offset;
                tmp0.x = saturate(tmp0.x / _Scale);
                tmp1 = _ColorHigh - _ColorLow;
                o.sv_target = tmp0.xxxx * tmp1 + _ColorLow;
                return o;
			}
#elif defined(DIRECTIONAL) && !defined(LIGHTMAP_ON) && defined(LIGHTMAP_SHADOW_MIXING) && !defined(LIGHTPROBE_SH) && defined(SHADOWS_SCREEN) && defined(SHADOWS_SHADOWMASK) && defined(VERTEXLIGHT_ON)
			#include "UnityCG.cginc"
			struct v2f
			{
 UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float3 texcoord1 : TEXCOORD1;
				float3 texcoord2 : TEXCOORD2;
				float4 texcoord4 : TEXCOORD4;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _ColorLow;
			float4 _ColorHigh;
			float _Offset;
			float _Scale;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			
			// Keywords: DIRECTIONAL SHADOWS_SHADOWMASK LIGHTMAP_SHADOW_MIXING SHADOWS_SCREEN VERTEXLIGHT_ON
			v2f vert(appdata_full v)
			{
 UNITY_SETUP_INSTANCE_ID(v);
                v2f o;
 UNITY_TRANSFER_INSTANCE_ID(v, o);
                float4 tmp0;
                float4 tmp1;
                tmp0 = v.vertex.yyyy * float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
                tmp0 = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]) * v.vertex.xxxx + tmp0;
                tmp0 = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]) * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
                o.texcoord2.xyz = float3(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3]) * v.vertex.www + tmp0.xyz;
                tmp0 = tmp1.yyyy * float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
                tmp0 = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]) * tmp1.xxxx + tmp0;
                tmp0 = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]) * tmp1.zzzz + tmp0;
                tmp0 = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]) * tmp1.wwww + tmp0;
                o.position = tmp0;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp1.x = dot(v.normal.xyz, float3(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0]));
                tmp1.y = dot(v.normal.xyz, float3(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1]));
                tmp1.z = dot(v.normal.xyz, float3(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2]));
                tmp1.w = dot(tmp1.xyz, tmp1.xyz);
                tmp1.w = rsqrt(tmp1.w);
                o.texcoord1.xyz = tmp1.www * tmp1.xyz;
                tmp1.xyz = tmp0.xyw * float3(0.5, 0.5, 0.5);
                o.texcoord4.zw = tmp0.zw;
                tmp1.w = tmp1.y * _ProjectionParams.x;
                o.texcoord4.xy = tmp1.zz + tmp1.xw;
                return o;
			}
			// Keywords: DIRECTIONAL SHADOWS_SCREEN
			fout frag(v2f inp)
			{
 UNITY_SETUP_INSTANCE_ID(inp);
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = inp.texcoord2.y + _Offset;
                tmp0.x = saturate(tmp0.x / _Scale);
                tmp1 = _ColorHigh - _ColorLow;
                o.sv_target = tmp0.xxxx * tmp1 + _ColorLow;
                return o;
			}
#elif defined(DIRECTIONAL) && defined(LIGHTMAP_ON) && defined(LIGHTMAP_SHADOW_MIXING) && defined(LIGHTPROBE_SH) && !defined(SHADOWS_SCREEN) && !defined(SHADOWS_SHADOWMASK) && !defined(VERTEXLIGHT_ON)
			#include "UnityCG.cginc"
			struct v2f
			{
 UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float3 texcoord1 : TEXCOORD1;
				float3 texcoord2 : TEXCOORD2;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _ColorLow;
			float4 _ColorHigh;
			float _Offset;
			float _Scale;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			
			// Keywords: DIRECTIONAL LIGHTPROBE_SH LIGHTMAP_ON LIGHTMAP_SHADOW_MIXING
			v2f vert(appdata_full v)
			{
 UNITY_SETUP_INSTANCE_ID(v);
                v2f o;
 UNITY_TRANSFER_INSTANCE_ID(v, o);
                float4 tmp0;
                float4 tmp1;
                tmp0 = v.vertex.yyyy * float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
                tmp0 = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]) * v.vertex.xxxx + tmp0;
                tmp0 = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]) * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
                o.texcoord2.xyz = float3(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3]) * v.vertex.www + tmp0.xyz;
                tmp0 = tmp1.yyyy * float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
                tmp0 = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]) * tmp1.xxxx + tmp0;
                tmp0 = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]) * tmp1.zzzz + tmp0;
                o.position = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]) * tmp1.wwww + tmp0;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp0.x = dot(v.normal.xyz, float3(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0]));
                tmp0.y = dot(v.normal.xyz, float3(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1]));
                tmp0.z = dot(v.normal.xyz, float3(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2]));
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord1.xyz = tmp0.www * tmp0.xyz;
                return o;
			}
			// Keywords: DIRECTIONAL LIGHTPROBE_SH LIGHTMAP_ON LIGHTMAP_SHADOW_MIXING
			fout frag(v2f inp)
			{
 UNITY_SETUP_INSTANCE_ID(inp);
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = inp.texcoord2.y + _Offset;
                tmp0.x = saturate(tmp0.x / _Scale);
                tmp1 = _ColorHigh - _ColorLow;
                o.sv_target = tmp0.xxxx * tmp1 + _ColorLow;
                return o;
			}
#elif defined(DIRECTIONAL) && defined(LIGHTMAP_ON) && !defined(LIGHTMAP_SHADOW_MIXING) && defined(LIGHTPROBE_SH) && !defined(SHADOWS_SCREEN) && defined(SHADOWS_SHADOWMASK) && !defined(VERTEXLIGHT_ON)
			#include "UnityCG.cginc"
			struct v2f
			{
 UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float3 texcoord1 : TEXCOORD1;
				float3 texcoord2 : TEXCOORD2;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _ColorLow;
			float4 _ColorHigh;
			float _Offset;
			float _Scale;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			
			// Keywords: DIRECTIONAL LIGHTPROBE_SH SHADOWS_SHADOWMASK LIGHTMAP_ON
			v2f vert(appdata_full v)
			{
 UNITY_SETUP_INSTANCE_ID(v);
                v2f o;
 UNITY_TRANSFER_INSTANCE_ID(v, o);
                float4 tmp0;
                float4 tmp1;
                tmp0 = v.vertex.yyyy * float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
                tmp0 = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]) * v.vertex.xxxx + tmp0;
                tmp0 = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]) * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
                o.texcoord2.xyz = float3(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3]) * v.vertex.www + tmp0.xyz;
                tmp0 = tmp1.yyyy * float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
                tmp0 = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]) * tmp1.xxxx + tmp0;
                tmp0 = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]) * tmp1.zzzz + tmp0;
                o.position = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]) * tmp1.wwww + tmp0;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp0.x = dot(v.normal.xyz, float3(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0]));
                tmp0.y = dot(v.normal.xyz, float3(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1]));
                tmp0.z = dot(v.normal.xyz, float3(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2]));
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord1.xyz = tmp0.www * tmp0.xyz;
                return o;
			}
			// Keywords: DIRECTIONAL LIGHTPROBE_SH SHADOWS_SHADOWMASK LIGHTMAP_ON
			fout frag(v2f inp)
			{
 UNITY_SETUP_INSTANCE_ID(inp);
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = inp.texcoord2.y + _Offset;
                tmp0.x = saturate(tmp0.x / _Scale);
                tmp1 = _ColorHigh - _ColorLow;
                o.sv_target = tmp0.xxxx * tmp1 + _ColorLow;
                return o;
			}
#elif defined(DIRECTIONAL) && defined(LIGHTMAP_ON) && defined(LIGHTMAP_SHADOW_MIXING) && !defined(LIGHTPROBE_SH) && !defined(SHADOWS_SCREEN) && defined(SHADOWS_SHADOWMASK) && !defined(VERTEXLIGHT_ON)
			#include "UnityCG.cginc"
			struct v2f
			{
 UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float3 texcoord1 : TEXCOORD1;
				float3 texcoord2 : TEXCOORD2;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _ColorLow;
			float4 _ColorHigh;
			float _Offset;
			float _Scale;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			
			// Keywords: DIRECTIONAL SHADOWS_SHADOWMASK LIGHTMAP_ON LIGHTMAP_SHADOW_MIXING
			v2f vert(appdata_full v)
			{
 UNITY_SETUP_INSTANCE_ID(v);
                v2f o;
 UNITY_TRANSFER_INSTANCE_ID(v, o);
                float4 tmp0;
                float4 tmp1;
                tmp0 = v.vertex.yyyy * float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
                tmp0 = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]) * v.vertex.xxxx + tmp0;
                tmp0 = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]) * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
                o.texcoord2.xyz = float3(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3]) * v.vertex.www + tmp0.xyz;
                tmp0 = tmp1.yyyy * float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
                tmp0 = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]) * tmp1.xxxx + tmp0;
                tmp0 = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]) * tmp1.zzzz + tmp0;
                o.position = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]) * tmp1.wwww + tmp0;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp0.x = dot(v.normal.xyz, float3(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0]));
                tmp0.y = dot(v.normal.xyz, float3(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1]));
                tmp0.z = dot(v.normal.xyz, float3(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2]));
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord1.xyz = tmp0.www * tmp0.xyz;
                return o;
			}
			// Keywords: DIRECTIONAL SHADOWS_SHADOWMASK LIGHTMAP_ON LIGHTMAP_SHADOW_MIXING
			fout frag(v2f inp)
			{
 UNITY_SETUP_INSTANCE_ID(inp);
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = inp.texcoord2.y + _Offset;
                tmp0.x = saturate(tmp0.x / _Scale);
                tmp1 = _ColorHigh - _ColorLow;
                o.sv_target = tmp0.xxxx * tmp1 + _ColorLow;
                return o;
			}
#elif defined(DIRECTIONAL) && !defined(LIGHTMAP_ON) && defined(LIGHTMAP_SHADOW_MIXING) && defined(LIGHTPROBE_SH) && defined(SHADOWS_SCREEN) && !defined(SHADOWS_SHADOWMASK) && !defined(VERTEXLIGHT_ON)
			#include "UnityCG.cginc"
			struct v2f
			{
 UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float3 texcoord1 : TEXCOORD1;
				float3 texcoord2 : TEXCOORD2;
				float4 texcoord4 : TEXCOORD4;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _ColorLow;
			float4 _ColorHigh;
			float _Offset;
			float _Scale;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			
			// Keywords: DIRECTIONAL LIGHTPROBE_SH LIGHTMAP_SHADOW_MIXING SHADOWS_SCREEN
			v2f vert(appdata_full v)
			{
 UNITY_SETUP_INSTANCE_ID(v);
                v2f o;
 UNITY_TRANSFER_INSTANCE_ID(v, o);
                float4 tmp0;
                float4 tmp1;
                tmp0 = v.vertex.yyyy * float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
                tmp0 = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]) * v.vertex.xxxx + tmp0;
                tmp0 = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]) * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
                o.texcoord2.xyz = float3(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3]) * v.vertex.www + tmp0.xyz;
                tmp0 = tmp1.yyyy * float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
                tmp0 = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]) * tmp1.xxxx + tmp0;
                tmp0 = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]) * tmp1.zzzz + tmp0;
                tmp0 = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]) * tmp1.wwww + tmp0;
                o.position = tmp0;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp1.x = dot(v.normal.xyz, float3(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0]));
                tmp1.y = dot(v.normal.xyz, float3(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1]));
                tmp1.z = dot(v.normal.xyz, float3(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2]));
                tmp1.w = dot(tmp1.xyz, tmp1.xyz);
                tmp1.w = rsqrt(tmp1.w);
                o.texcoord1.xyz = tmp1.www * tmp1.xyz;
                tmp1.xyz = tmp0.xyw * float3(0.5, 0.5, 0.5);
                o.texcoord4.zw = tmp0.zw;
                tmp1.w = tmp1.y * _ProjectionParams.x;
                o.texcoord4.xy = tmp1.zz + tmp1.xw;
                return o;
			}
			// Keywords: DIRECTIONAL LIGHTPROBE_SH LIGHTMAP_SHADOW_MIXING SHADOWS_SCREEN
			fout frag(v2f inp)
			{
 UNITY_SETUP_INSTANCE_ID(inp);
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = inp.texcoord2.y + _Offset;
                tmp0.x = saturate(tmp0.x / _Scale);
                tmp1 = _ColorHigh - _ColorLow;
                o.sv_target = tmp0.xxxx * tmp1 + _ColorLow;
                return o;
			}
#elif defined(DIRECTIONAL) && !defined(LIGHTMAP_ON) && !defined(LIGHTMAP_SHADOW_MIXING) && defined(LIGHTPROBE_SH) && defined(SHADOWS_SCREEN) && defined(SHADOWS_SHADOWMASK) && !defined(VERTEXLIGHT_ON)
			#include "UnityCG.cginc"
			struct v2f
			{
 UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float3 texcoord1 : TEXCOORD1;
				float3 texcoord2 : TEXCOORD2;
				float4 texcoord4 : TEXCOORD4;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _ColorLow;
			float4 _ColorHigh;
			float _Offset;
			float _Scale;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			
			// Keywords: DIRECTIONAL LIGHTPROBE_SH SHADOWS_SHADOWMASK SHADOWS_SCREEN
			v2f vert(appdata_full v)
			{
 UNITY_SETUP_INSTANCE_ID(v);
                v2f o;
 UNITY_TRANSFER_INSTANCE_ID(v, o);
                float4 tmp0;
                float4 tmp1;
                tmp0 = v.vertex.yyyy * float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
                tmp0 = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]) * v.vertex.xxxx + tmp0;
                tmp0 = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]) * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
                o.texcoord2.xyz = float3(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3]) * v.vertex.www + tmp0.xyz;
                tmp0 = tmp1.yyyy * float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
                tmp0 = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]) * tmp1.xxxx + tmp0;
                tmp0 = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]) * tmp1.zzzz + tmp0;
                tmp0 = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]) * tmp1.wwww + tmp0;
                o.position = tmp0;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp1.x = dot(v.normal.xyz, float3(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0]));
                tmp1.y = dot(v.normal.xyz, float3(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1]));
                tmp1.z = dot(v.normal.xyz, float3(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2]));
                tmp1.w = dot(tmp1.xyz, tmp1.xyz);
                tmp1.w = rsqrt(tmp1.w);
                o.texcoord1.xyz = tmp1.www * tmp1.xyz;
                tmp1.xyz = tmp0.xyw * float3(0.5, 0.5, 0.5);
                o.texcoord4.zw = tmp0.zw;
                tmp1.w = tmp1.y * _ProjectionParams.x;
                o.texcoord4.xy = tmp1.zz + tmp1.xw;
                return o;
			}
			// Keywords: DIRECTIONAL LIGHTPROBE_SH SHADOWS_SHADOWMASK SHADOWS_SCREEN
			fout frag(v2f inp)
			{
 UNITY_SETUP_INSTANCE_ID(inp);
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = inp.texcoord2.y + _Offset;
                tmp0.x = saturate(tmp0.x / _Scale);
                tmp1 = _ColorHigh - _ColorLow;
                o.sv_target = tmp0.xxxx * tmp1 + _ColorLow;
                return o;
			}
#elif defined(DIRECTIONAL) && defined(LIGHTMAP_ON) && !defined(LIGHTMAP_SHADOW_MIXING) && defined(LIGHTPROBE_SH) && defined(SHADOWS_SCREEN) && !defined(SHADOWS_SHADOWMASK) && !defined(VERTEXLIGHT_ON)
			#include "UnityCG.cginc"
			struct v2f
			{
 UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float3 texcoord1 : TEXCOORD1;
				float3 texcoord2 : TEXCOORD2;
				float4 texcoord4 : TEXCOORD4;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _ColorLow;
			float4 _ColorHigh;
			float _Offset;
			float _Scale;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			
			// Keywords: DIRECTIONAL LIGHTPROBE_SH LIGHTMAP_ON SHADOWS_SCREEN
			v2f vert(appdata_full v)
			{
 UNITY_SETUP_INSTANCE_ID(v);
                v2f o;
 UNITY_TRANSFER_INSTANCE_ID(v, o);
                float4 tmp0;
                float4 tmp1;
                tmp0 = v.vertex.yyyy * float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
                tmp0 = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]) * v.vertex.xxxx + tmp0;
                tmp0 = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]) * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
                o.texcoord2.xyz = float3(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3]) * v.vertex.www + tmp0.xyz;
                tmp0 = tmp1.yyyy * float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
                tmp0 = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]) * tmp1.xxxx + tmp0;
                tmp0 = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]) * tmp1.zzzz + tmp0;
                tmp0 = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]) * tmp1.wwww + tmp0;
                o.position = tmp0;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp1.x = dot(v.normal.xyz, float3(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0]));
                tmp1.y = dot(v.normal.xyz, float3(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1]));
                tmp1.z = dot(v.normal.xyz, float3(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2]));
                tmp1.w = dot(tmp1.xyz, tmp1.xyz);
                tmp1.w = rsqrt(tmp1.w);
                o.texcoord1.xyz = tmp1.www * tmp1.xyz;
                tmp1.xyz = tmp0.xyw * float3(0.5, 0.5, 0.5);
                o.texcoord4.zw = tmp0.zw;
                tmp1.w = tmp1.y * _ProjectionParams.x;
                o.texcoord4.xy = tmp1.zz + tmp1.xw;
                return o;
			}
			// Keywords: DIRECTIONAL LIGHTPROBE_SH LIGHTMAP_ON SHADOWS_SCREEN
			fout frag(v2f inp)
			{
 UNITY_SETUP_INSTANCE_ID(inp);
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = inp.texcoord2.y + _Offset;
                tmp0.x = saturate(tmp0.x / _Scale);
                tmp1 = _ColorHigh - _ColorLow;
                o.sv_target = tmp0.xxxx * tmp1 + _ColorLow;
                return o;
			}
#elif defined(DIRECTIONAL) && defined(LIGHTMAP_ON) && defined(LIGHTMAP_SHADOW_MIXING) && !defined(LIGHTPROBE_SH) && defined(SHADOWS_SCREEN) && !defined(SHADOWS_SHADOWMASK) && !defined(VERTEXLIGHT_ON)
			#include "UnityCG.cginc"
			struct v2f
			{
 UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float3 texcoord1 : TEXCOORD1;
				float3 texcoord2 : TEXCOORD2;
				float4 texcoord4 : TEXCOORD4;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _ColorLow;
			float4 _ColorHigh;
			float _Offset;
			float _Scale;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			
			// Keywords: DIRECTIONAL LIGHTMAP_ON LIGHTMAP_SHADOW_MIXING SHADOWS_SCREEN
			v2f vert(appdata_full v)
			{
 UNITY_SETUP_INSTANCE_ID(v);
                v2f o;
 UNITY_TRANSFER_INSTANCE_ID(v, o);
                float4 tmp0;
                float4 tmp1;
                tmp0 = v.vertex.yyyy * float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
                tmp0 = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]) * v.vertex.xxxx + tmp0;
                tmp0 = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]) * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
                o.texcoord2.xyz = float3(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3]) * v.vertex.www + tmp0.xyz;
                tmp0 = tmp1.yyyy * float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
                tmp0 = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]) * tmp1.xxxx + tmp0;
                tmp0 = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]) * tmp1.zzzz + tmp0;
                tmp0 = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]) * tmp1.wwww + tmp0;
                o.position = tmp0;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp1.x = dot(v.normal.xyz, float3(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0]));
                tmp1.y = dot(v.normal.xyz, float3(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1]));
                tmp1.z = dot(v.normal.xyz, float3(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2]));
                tmp1.w = dot(tmp1.xyz, tmp1.xyz);
                tmp1.w = rsqrt(tmp1.w);
                o.texcoord1.xyz = tmp1.www * tmp1.xyz;
                tmp1.xyz = tmp0.xyw * float3(0.5, 0.5, 0.5);
                o.texcoord4.zw = tmp0.zw;
                tmp1.w = tmp1.y * _ProjectionParams.x;
                o.texcoord4.xy = tmp1.zz + tmp1.xw;
                return o;
			}
			// Keywords: DIRECTIONAL LIGHTMAP_ON LIGHTMAP_SHADOW_MIXING SHADOWS_SCREEN
			fout frag(v2f inp)
			{
 UNITY_SETUP_INSTANCE_ID(inp);
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = inp.texcoord2.y + _Offset;
                tmp0.x = saturate(tmp0.x / _Scale);
                tmp1 = _ColorHigh - _ColorLow;
                o.sv_target = tmp0.xxxx * tmp1 + _ColorLow;
                return o;
			}
#elif defined(DIRECTIONAL) && defined(LIGHTMAP_ON) && !defined(LIGHTMAP_SHADOW_MIXING) && !defined(LIGHTPROBE_SH) && defined(SHADOWS_SCREEN) && defined(SHADOWS_SHADOWMASK) && !defined(VERTEXLIGHT_ON)
			#include "UnityCG.cginc"
			struct v2f
			{
 UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float3 texcoord1 : TEXCOORD1;
				float3 texcoord2 : TEXCOORD2;
				float4 texcoord4 : TEXCOORD4;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _ColorLow;
			float4 _ColorHigh;
			float _Offset;
			float _Scale;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			
			// Keywords: DIRECTIONAL SHADOWS_SHADOWMASK LIGHTMAP_ON SHADOWS_SCREEN
			v2f vert(appdata_full v)
			{
 UNITY_SETUP_INSTANCE_ID(v);
                v2f o;
 UNITY_TRANSFER_INSTANCE_ID(v, o);
                float4 tmp0;
                float4 tmp1;
                tmp0 = v.vertex.yyyy * float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
                tmp0 = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]) * v.vertex.xxxx + tmp0;
                tmp0 = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]) * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
                o.texcoord2.xyz = float3(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3]) * v.vertex.www + tmp0.xyz;
                tmp0 = tmp1.yyyy * float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
                tmp0 = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]) * tmp1.xxxx + tmp0;
                tmp0 = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]) * tmp1.zzzz + tmp0;
                tmp0 = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]) * tmp1.wwww + tmp0;
                o.position = tmp0;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp1.x = dot(v.normal.xyz, float3(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0]));
                tmp1.y = dot(v.normal.xyz, float3(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1]));
                tmp1.z = dot(v.normal.xyz, float3(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2]));
                tmp1.w = dot(tmp1.xyz, tmp1.xyz);
                tmp1.w = rsqrt(tmp1.w);
                o.texcoord1.xyz = tmp1.www * tmp1.xyz;
                tmp1.xyz = tmp0.xyw * float3(0.5, 0.5, 0.5);
                o.texcoord4.zw = tmp0.zw;
                tmp1.w = tmp1.y * _ProjectionParams.x;
                o.texcoord4.xy = tmp1.zz + tmp1.xw;
                return o;
			}
			// Keywords: DIRECTIONAL SHADOWS_SHADOWMASK LIGHTMAP_ON SHADOWS_SCREEN
			fout frag(v2f inp)
			{
 UNITY_SETUP_INSTANCE_ID(inp);
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = inp.texcoord2.y + _Offset;
                tmp0.x = saturate(tmp0.x / _Scale);
                tmp1 = _ColorHigh - _ColorLow;
                o.sv_target = tmp0.xxxx * tmp1 + _ColorLow;
                return o;
			}
#elif defined(DIRECTIONAL) && !defined(LIGHTMAP_ON) && !defined(LIGHTMAP_SHADOW_MIXING) && defined(LIGHTPROBE_SH) && defined(SHADOWS_SCREEN) && !defined(SHADOWS_SHADOWMASK) && defined(VERTEXLIGHT_ON)
			#include "UnityCG.cginc"
			struct v2f
			{
 UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float3 texcoord1 : TEXCOORD1;
				float3 texcoord2 : TEXCOORD2;
				float4 texcoord4 : TEXCOORD4;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _ColorLow;
			float4 _ColorHigh;
			float _Offset;
			float _Scale;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			
			// Keywords: DIRECTIONAL LIGHTPROBE_SH SHADOWS_SCREEN VERTEXLIGHT_ON
			v2f vert(appdata_full v)
			{
 UNITY_SETUP_INSTANCE_ID(v);
                v2f o;
 UNITY_TRANSFER_INSTANCE_ID(v, o);
                float4 tmp0;
                float4 tmp1;
                tmp0 = v.vertex.yyyy * float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
                tmp0 = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]) * v.vertex.xxxx + tmp0;
                tmp0 = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]) * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
                o.texcoord2.xyz = float3(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3]) * v.vertex.www + tmp0.xyz;
                tmp0 = tmp1.yyyy * float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
                tmp0 = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]) * tmp1.xxxx + tmp0;
                tmp0 = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]) * tmp1.zzzz + tmp0;
                tmp0 = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]) * tmp1.wwww + tmp0;
                o.position = tmp0;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp1.x = dot(v.normal.xyz, float3(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0]));
                tmp1.y = dot(v.normal.xyz, float3(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1]));
                tmp1.z = dot(v.normal.xyz, float3(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2]));
                tmp1.w = dot(tmp1.xyz, tmp1.xyz);
                tmp1.w = rsqrt(tmp1.w);
                o.texcoord1.xyz = tmp1.www * tmp1.xyz;
                tmp1.xyz = tmp0.xyw * float3(0.5, 0.5, 0.5);
                o.texcoord4.zw = tmp0.zw;
                tmp1.w = tmp1.y * _ProjectionParams.x;
                o.texcoord4.xy = tmp1.zz + tmp1.xw;
                return o;
			}
			// Keywords: DIRECTIONAL LIGHTPROBE_SH SHADOWS_SCREEN
			fout frag(v2f inp)
			{
 UNITY_SETUP_INSTANCE_ID(inp);
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = inp.texcoord2.y + _Offset;
                tmp0.x = saturate(tmp0.x / _Scale);
                tmp1 = _ColorHigh - _ColorLow;
                o.sv_target = tmp0.xxxx * tmp1 + _ColorLow;
                return o;
			}
#elif defined(DIRECTIONAL) && !defined(LIGHTMAP_ON) && defined(LIGHTMAP_SHADOW_MIXING) && !defined(LIGHTPROBE_SH) && defined(SHADOWS_SCREEN) && !defined(SHADOWS_SHADOWMASK) && defined(VERTEXLIGHT_ON)
			#include "UnityCG.cginc"
			struct v2f
			{
 UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float3 texcoord1 : TEXCOORD1;
				float3 texcoord2 : TEXCOORD2;
				float4 texcoord4 : TEXCOORD4;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _ColorLow;
			float4 _ColorHigh;
			float _Offset;
			float _Scale;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			
			// Keywords: DIRECTIONAL LIGHTMAP_SHADOW_MIXING SHADOWS_SCREEN VERTEXLIGHT_ON
			v2f vert(appdata_full v)
			{
 UNITY_SETUP_INSTANCE_ID(v);
                v2f o;
 UNITY_TRANSFER_INSTANCE_ID(v, o);
                float4 tmp0;
                float4 tmp1;
                tmp0 = v.vertex.yyyy * float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
                tmp0 = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]) * v.vertex.xxxx + tmp0;
                tmp0 = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]) * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
                o.texcoord2.xyz = float3(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3]) * v.vertex.www + tmp0.xyz;
                tmp0 = tmp1.yyyy * float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
                tmp0 = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]) * tmp1.xxxx + tmp0;
                tmp0 = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]) * tmp1.zzzz + tmp0;
                tmp0 = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]) * tmp1.wwww + tmp0;
                o.position = tmp0;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp1.x = dot(v.normal.xyz, float3(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0]));
                tmp1.y = dot(v.normal.xyz, float3(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1]));
                tmp1.z = dot(v.normal.xyz, float3(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2]));
                tmp1.w = dot(tmp1.xyz, tmp1.xyz);
                tmp1.w = rsqrt(tmp1.w);
                o.texcoord1.xyz = tmp1.www * tmp1.xyz;
                tmp1.xyz = tmp0.xyw * float3(0.5, 0.5, 0.5);
                o.texcoord4.zw = tmp0.zw;
                tmp1.w = tmp1.y * _ProjectionParams.x;
                o.texcoord4.xy = tmp1.zz + tmp1.xw;
                return o;
			}
			// Keywords: DIRECTIONAL SHADOWS_SCREEN
			fout frag(v2f inp)
			{
 UNITY_SETUP_INSTANCE_ID(inp);
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = inp.texcoord2.y + _Offset;
                tmp0.x = saturate(tmp0.x / _Scale);
                tmp1 = _ColorHigh - _ColorLow;
                o.sv_target = tmp0.xxxx * tmp1 + _ColorLow;
                return o;
			}
#elif defined(DIRECTIONAL) && !defined(LIGHTMAP_ON) && !defined(LIGHTMAP_SHADOW_MIXING) && !defined(LIGHTPROBE_SH) && defined(SHADOWS_SCREEN) && defined(SHADOWS_SHADOWMASK) && defined(VERTEXLIGHT_ON)
			#include "UnityCG.cginc"
			struct v2f
			{
 UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float3 texcoord1 : TEXCOORD1;
				float3 texcoord2 : TEXCOORD2;
				float4 texcoord4 : TEXCOORD4;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _ColorLow;
			float4 _ColorHigh;
			float _Offset;
			float _Scale;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			
			// Keywords: DIRECTIONAL SHADOWS_SHADOWMASK SHADOWS_SCREEN VERTEXLIGHT_ON
			v2f vert(appdata_full v)
			{
 UNITY_SETUP_INSTANCE_ID(v);
                v2f o;
 UNITY_TRANSFER_INSTANCE_ID(v, o);
                float4 tmp0;
                float4 tmp1;
                tmp0 = v.vertex.yyyy * float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
                tmp0 = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]) * v.vertex.xxxx + tmp0;
                tmp0 = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]) * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
                o.texcoord2.xyz = float3(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3]) * v.vertex.www + tmp0.xyz;
                tmp0 = tmp1.yyyy * float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
                tmp0 = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]) * tmp1.xxxx + tmp0;
                tmp0 = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]) * tmp1.zzzz + tmp0;
                tmp0 = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]) * tmp1.wwww + tmp0;
                o.position = tmp0;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp1.x = dot(v.normal.xyz, float3(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0]));
                tmp1.y = dot(v.normal.xyz, float3(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1]));
                tmp1.z = dot(v.normal.xyz, float3(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2]));
                tmp1.w = dot(tmp1.xyz, tmp1.xyz);
                tmp1.w = rsqrt(tmp1.w);
                o.texcoord1.xyz = tmp1.www * tmp1.xyz;
                tmp1.xyz = tmp0.xyw * float3(0.5, 0.5, 0.5);
                o.texcoord4.zw = tmp0.zw;
                tmp1.w = tmp1.y * _ProjectionParams.x;
                o.texcoord4.xy = tmp1.zz + tmp1.xw;
                return o;
			}
			// Keywords: DIRECTIONAL SHADOWS_SCREEN
			fout frag(v2f inp)
			{
 UNITY_SETUP_INSTANCE_ID(inp);
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = inp.texcoord2.y + _Offset;
                tmp0.x = saturate(tmp0.x / _Scale);
                tmp1 = _ColorHigh - _ColorLow;
                o.sv_target = tmp0.xxxx * tmp1 + _ColorLow;
                return o;
			}
#elif defined(DIRECTIONAL) && !defined(LIGHTMAP_ON) && !defined(LIGHTMAP_SHADOW_MIXING) && defined(LIGHTPROBE_SH) && !defined(SHADOWS_SCREEN) && defined(SHADOWS_SHADOWMASK) && !defined(VERTEXLIGHT_ON)
			#include "UnityCG.cginc"
			struct v2f
			{
 UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float3 texcoord1 : TEXCOORD1;
				float3 texcoord2 : TEXCOORD2;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _ColorLow;
			float4 _ColorHigh;
			float _Offset;
			float _Scale;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			
			// Keywords: DIRECTIONAL LIGHTPROBE_SH SHADOWS_SHADOWMASK
			v2f vert(appdata_full v)
			{
 UNITY_SETUP_INSTANCE_ID(v);
                v2f o;
 UNITY_TRANSFER_INSTANCE_ID(v, o);
                float4 tmp0;
                float4 tmp1;
                tmp0 = v.vertex.yyyy * float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
                tmp0 = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]) * v.vertex.xxxx + tmp0;
                tmp0 = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]) * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
                o.texcoord2.xyz = float3(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3]) * v.vertex.www + tmp0.xyz;
                tmp0 = tmp1.yyyy * float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
                tmp0 = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]) * tmp1.xxxx + tmp0;
                tmp0 = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]) * tmp1.zzzz + tmp0;
                o.position = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]) * tmp1.wwww + tmp0;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp0.x = dot(v.normal.xyz, float3(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0]));
                tmp0.y = dot(v.normal.xyz, float3(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1]));
                tmp0.z = dot(v.normal.xyz, float3(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2]));
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord1.xyz = tmp0.www * tmp0.xyz;
                return o;
			}
			// Keywords: DIRECTIONAL LIGHTPROBE_SH SHADOWS_SHADOWMASK
			fout frag(v2f inp)
			{
 UNITY_SETUP_INSTANCE_ID(inp);
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = inp.texcoord2.y + _Offset;
                tmp0.x = saturate(tmp0.x / _Scale);
                tmp1 = _ColorHigh - _ColorLow;
                o.sv_target = tmp0.xxxx * tmp1 + _ColorLow;
                return o;
			}
#elif defined(DIRECTIONAL) && defined(LIGHTMAP_ON) && !defined(LIGHTMAP_SHADOW_MIXING) && defined(LIGHTPROBE_SH) && !defined(SHADOWS_SCREEN) && !defined(SHADOWS_SHADOWMASK) && !defined(VERTEXLIGHT_ON)
			#include "UnityCG.cginc"
			struct v2f
			{
 UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float3 texcoord1 : TEXCOORD1;
				float3 texcoord2 : TEXCOORD2;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _ColorLow;
			float4 _ColorHigh;
			float _Offset;
			float _Scale;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			
			// Keywords: DIRECTIONAL LIGHTPROBE_SH LIGHTMAP_ON
			v2f vert(appdata_full v)
			{
 UNITY_SETUP_INSTANCE_ID(v);
                v2f o;
 UNITY_TRANSFER_INSTANCE_ID(v, o);
                float4 tmp0;
                float4 tmp1;
                tmp0 = v.vertex.yyyy * float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
                tmp0 = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]) * v.vertex.xxxx + tmp0;
                tmp0 = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]) * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
                o.texcoord2.xyz = float3(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3]) * v.vertex.www + tmp0.xyz;
                tmp0 = tmp1.yyyy * float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
                tmp0 = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]) * tmp1.xxxx + tmp0;
                tmp0 = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]) * tmp1.zzzz + tmp0;
                o.position = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]) * tmp1.wwww + tmp0;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp0.x = dot(v.normal.xyz, float3(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0]));
                tmp0.y = dot(v.normal.xyz, float3(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1]));
                tmp0.z = dot(v.normal.xyz, float3(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2]));
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord1.xyz = tmp0.www * tmp0.xyz;
                return o;
			}
			// Keywords: DIRECTIONAL LIGHTPROBE_SH LIGHTMAP_ON
			fout frag(v2f inp)
			{
 UNITY_SETUP_INSTANCE_ID(inp);
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = inp.texcoord2.y + _Offset;
                tmp0.x = saturate(tmp0.x / _Scale);
                tmp1 = _ColorHigh - _ColorLow;
                o.sv_target = tmp0.xxxx * tmp1 + _ColorLow;
                return o;
			}
#elif defined(DIRECTIONAL) && defined(LIGHTMAP_ON) && defined(LIGHTMAP_SHADOW_MIXING) && !defined(LIGHTPROBE_SH) && !defined(SHADOWS_SCREEN) && !defined(SHADOWS_SHADOWMASK) && !defined(VERTEXLIGHT_ON)
			#include "UnityCG.cginc"
			struct v2f
			{
 UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float3 texcoord1 : TEXCOORD1;
				float3 texcoord2 : TEXCOORD2;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _ColorLow;
			float4 _ColorHigh;
			float _Offset;
			float _Scale;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			
			// Keywords: DIRECTIONAL LIGHTMAP_ON LIGHTMAP_SHADOW_MIXING
			v2f vert(appdata_full v)
			{
 UNITY_SETUP_INSTANCE_ID(v);
                v2f o;
 UNITY_TRANSFER_INSTANCE_ID(v, o);
                float4 tmp0;
                float4 tmp1;
                tmp0 = v.vertex.yyyy * float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
                tmp0 = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]) * v.vertex.xxxx + tmp0;
                tmp0 = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]) * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
                o.texcoord2.xyz = float3(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3]) * v.vertex.www + tmp0.xyz;
                tmp0 = tmp1.yyyy * float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
                tmp0 = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]) * tmp1.xxxx + tmp0;
                tmp0 = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]) * tmp1.zzzz + tmp0;
                o.position = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]) * tmp1.wwww + tmp0;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp0.x = dot(v.normal.xyz, float3(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0]));
                tmp0.y = dot(v.normal.xyz, float3(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1]));
                tmp0.z = dot(v.normal.xyz, float3(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2]));
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord1.xyz = tmp0.www * tmp0.xyz;
                return o;
			}
			// Keywords: DIRECTIONAL LIGHTMAP_ON LIGHTMAP_SHADOW_MIXING
			fout frag(v2f inp)
			{
 UNITY_SETUP_INSTANCE_ID(inp);
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = inp.texcoord2.y + _Offset;
                tmp0.x = saturate(tmp0.x / _Scale);
                tmp1 = _ColorHigh - _ColorLow;
                o.sv_target = tmp0.xxxx * tmp1 + _ColorLow;
                return o;
			}
#elif defined(DIRECTIONAL) && defined(LIGHTMAP_ON) && !defined(LIGHTMAP_SHADOW_MIXING) && !defined(LIGHTPROBE_SH) && !defined(SHADOWS_SCREEN) && defined(SHADOWS_SHADOWMASK) && !defined(VERTEXLIGHT_ON)
			#include "UnityCG.cginc"
			struct v2f
			{
 UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float3 texcoord1 : TEXCOORD1;
				float3 texcoord2 : TEXCOORD2;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _ColorLow;
			float4 _ColorHigh;
			float _Offset;
			float _Scale;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			
			// Keywords: DIRECTIONAL SHADOWS_SHADOWMASK LIGHTMAP_ON
			v2f vert(appdata_full v)
			{
 UNITY_SETUP_INSTANCE_ID(v);
                v2f o;
 UNITY_TRANSFER_INSTANCE_ID(v, o);
                float4 tmp0;
                float4 tmp1;
                tmp0 = v.vertex.yyyy * float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
                tmp0 = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]) * v.vertex.xxxx + tmp0;
                tmp0 = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]) * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
                o.texcoord2.xyz = float3(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3]) * v.vertex.www + tmp0.xyz;
                tmp0 = tmp1.yyyy * float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
                tmp0 = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]) * tmp1.xxxx + tmp0;
                tmp0 = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]) * tmp1.zzzz + tmp0;
                o.position = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]) * tmp1.wwww + tmp0;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp0.x = dot(v.normal.xyz, float3(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0]));
                tmp0.y = dot(v.normal.xyz, float3(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1]));
                tmp0.z = dot(v.normal.xyz, float3(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2]));
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord1.xyz = tmp0.www * tmp0.xyz;
                return o;
			}
			// Keywords: DIRECTIONAL SHADOWS_SHADOWMASK LIGHTMAP_ON
			fout frag(v2f inp)
			{
 UNITY_SETUP_INSTANCE_ID(inp);
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = inp.texcoord2.y + _Offset;
                tmp0.x = saturate(tmp0.x / _Scale);
                tmp1 = _ColorHigh - _ColorLow;
                o.sv_target = tmp0.xxxx * tmp1 + _ColorLow;
                return o;
			}
#elif defined(DIRECTIONAL) && !defined(LIGHTMAP_ON) && !defined(LIGHTMAP_SHADOW_MIXING) && defined(LIGHTPROBE_SH) && defined(SHADOWS_SCREEN) && !defined(SHADOWS_SHADOWMASK) && !defined(VERTEXLIGHT_ON)
			#include "UnityCG.cginc"
			struct v2f
			{
 UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float3 texcoord1 : TEXCOORD1;
				float3 texcoord2 : TEXCOORD2;
				float4 texcoord4 : TEXCOORD4;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _ColorLow;
			float4 _ColorHigh;
			float _Offset;
			float _Scale;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			
			// Keywords: DIRECTIONAL LIGHTPROBE_SH SHADOWS_SCREEN
			v2f vert(appdata_full v)
			{
 UNITY_SETUP_INSTANCE_ID(v);
                v2f o;
 UNITY_TRANSFER_INSTANCE_ID(v, o);
                float4 tmp0;
                float4 tmp1;
                tmp0 = v.vertex.yyyy * float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
                tmp0 = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]) * v.vertex.xxxx + tmp0;
                tmp0 = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]) * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
                o.texcoord2.xyz = float3(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3]) * v.vertex.www + tmp0.xyz;
                tmp0 = tmp1.yyyy * float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
                tmp0 = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]) * tmp1.xxxx + tmp0;
                tmp0 = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]) * tmp1.zzzz + tmp0;
                tmp0 = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]) * tmp1.wwww + tmp0;
                o.position = tmp0;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp1.x = dot(v.normal.xyz, float3(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0]));
                tmp1.y = dot(v.normal.xyz, float3(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1]));
                tmp1.z = dot(v.normal.xyz, float3(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2]));
                tmp1.w = dot(tmp1.xyz, tmp1.xyz);
                tmp1.w = rsqrt(tmp1.w);
                o.texcoord1.xyz = tmp1.www * tmp1.xyz;
                tmp1.xyz = tmp0.xyw * float3(0.5, 0.5, 0.5);
                o.texcoord4.zw = tmp0.zw;
                tmp1.w = tmp1.y * _ProjectionParams.x;
                o.texcoord4.xy = tmp1.zz + tmp1.xw;
                return o;
			}
			// Keywords: DIRECTIONAL LIGHTPROBE_SH SHADOWS_SCREEN
			fout frag(v2f inp)
			{
 UNITY_SETUP_INSTANCE_ID(inp);
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = inp.texcoord2.y + _Offset;
                tmp0.x = saturate(tmp0.x / _Scale);
                tmp1 = _ColorHigh - _ColorLow;
                o.sv_target = tmp0.xxxx * tmp1 + _ColorLow;
                return o;
			}
#elif defined(DIRECTIONAL) && defined(LIGHTMAP_ON) && !defined(LIGHTMAP_SHADOW_MIXING) && !defined(LIGHTPROBE_SH) && defined(SHADOWS_SCREEN) && !defined(SHADOWS_SHADOWMASK) && !defined(VERTEXLIGHT_ON)
			#include "UnityCG.cginc"
			struct v2f
			{
 UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float3 texcoord1 : TEXCOORD1;
				float3 texcoord2 : TEXCOORD2;
				float4 texcoord4 : TEXCOORD4;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _ColorLow;
			float4 _ColorHigh;
			float _Offset;
			float _Scale;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			
			// Keywords: DIRECTIONAL LIGHTMAP_ON SHADOWS_SCREEN
			v2f vert(appdata_full v)
			{
 UNITY_SETUP_INSTANCE_ID(v);
                v2f o;
 UNITY_TRANSFER_INSTANCE_ID(v, o);
                float4 tmp0;
                float4 tmp1;
                tmp0 = v.vertex.yyyy * float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
                tmp0 = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]) * v.vertex.xxxx + tmp0;
                tmp0 = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]) * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
                o.texcoord2.xyz = float3(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3]) * v.vertex.www + tmp0.xyz;
                tmp0 = tmp1.yyyy * float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
                tmp0 = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]) * tmp1.xxxx + tmp0;
                tmp0 = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]) * tmp1.zzzz + tmp0;
                tmp0 = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]) * tmp1.wwww + tmp0;
                o.position = tmp0;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp1.x = dot(v.normal.xyz, float3(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0]));
                tmp1.y = dot(v.normal.xyz, float3(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1]));
                tmp1.z = dot(v.normal.xyz, float3(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2]));
                tmp1.w = dot(tmp1.xyz, tmp1.xyz);
                tmp1.w = rsqrt(tmp1.w);
                o.texcoord1.xyz = tmp1.www * tmp1.xyz;
                tmp1.xyz = tmp0.xyw * float3(0.5, 0.5, 0.5);
                o.texcoord4.zw = tmp0.zw;
                tmp1.w = tmp1.y * _ProjectionParams.x;
                o.texcoord4.xy = tmp1.zz + tmp1.xw;
                return o;
			}
			// Keywords: DIRECTIONAL LIGHTMAP_ON SHADOWS_SCREEN
			fout frag(v2f inp)
			{
 UNITY_SETUP_INSTANCE_ID(inp);
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = inp.texcoord2.y + _Offset;
                tmp0.x = saturate(tmp0.x / _Scale);
                tmp1 = _ColorHigh - _ColorLow;
                o.sv_target = tmp0.xxxx * tmp1 + _ColorLow;
                return o;
			}
#elif defined(DIRECTIONAL) && !defined(LIGHTMAP_ON) && !defined(LIGHTMAP_SHADOW_MIXING) && defined(LIGHTPROBE_SH) && !defined(SHADOWS_SCREEN) && !defined(SHADOWS_SHADOWMASK) && defined(VERTEXLIGHT_ON)
			#include "UnityCG.cginc"
			struct v2f
			{
 UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float3 texcoord1 : TEXCOORD1;
				float3 texcoord2 : TEXCOORD2;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _ColorLow;
			float4 _ColorHigh;
			float _Offset;
			float _Scale;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			
			// Keywords: DIRECTIONAL LIGHTPROBE_SH VERTEXLIGHT_ON
			v2f vert(appdata_full v)
			{
 UNITY_SETUP_INSTANCE_ID(v);
                v2f o;
 UNITY_TRANSFER_INSTANCE_ID(v, o);
                float4 tmp0;
                float4 tmp1;
                tmp0 = v.vertex.yyyy * float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
                tmp0 = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]) * v.vertex.xxxx + tmp0;
                tmp0 = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]) * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
                o.texcoord2.xyz = float3(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3]) * v.vertex.www + tmp0.xyz;
                tmp0 = tmp1.yyyy * float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
                tmp0 = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]) * tmp1.xxxx + tmp0;
                tmp0 = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]) * tmp1.zzzz + tmp0;
                o.position = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]) * tmp1.wwww + tmp0;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp0.x = dot(v.normal.xyz, float3(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0]));
                tmp0.y = dot(v.normal.xyz, float3(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1]));
                tmp0.z = dot(v.normal.xyz, float3(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2]));
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord1.xyz = tmp0.www * tmp0.xyz;
                return o;
			}
			// Keywords: DIRECTIONAL LIGHTPROBE_SH
			fout frag(v2f inp)
			{
 UNITY_SETUP_INSTANCE_ID(inp);
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = inp.texcoord2.y + _Offset;
                tmp0.x = saturate(tmp0.x / _Scale);
                tmp1 = _ColorHigh - _ColorLow;
                o.sv_target = tmp0.xxxx * tmp1 + _ColorLow;
                return o;
			}
#elif defined(DIRECTIONAL) && !defined(LIGHTMAP_ON) && !defined(LIGHTMAP_SHADOW_MIXING) && !defined(LIGHTPROBE_SH) && defined(SHADOWS_SCREEN) && !defined(SHADOWS_SHADOWMASK) && defined(VERTEXLIGHT_ON)
			#include "UnityCG.cginc"
			struct v2f
			{
 UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float3 texcoord1 : TEXCOORD1;
				float3 texcoord2 : TEXCOORD2;
				float4 texcoord4 : TEXCOORD4;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _ColorLow;
			float4 _ColorHigh;
			float _Offset;
			float _Scale;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			
			// Keywords: DIRECTIONAL SHADOWS_SCREEN VERTEXLIGHT_ON
			v2f vert(appdata_full v)
			{
 UNITY_SETUP_INSTANCE_ID(v);
                v2f o;
 UNITY_TRANSFER_INSTANCE_ID(v, o);
                float4 tmp0;
                float4 tmp1;
                tmp0 = v.vertex.yyyy * float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
                tmp0 = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]) * v.vertex.xxxx + tmp0;
                tmp0 = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]) * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
                o.texcoord2.xyz = float3(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3]) * v.vertex.www + tmp0.xyz;
                tmp0 = tmp1.yyyy * float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
                tmp0 = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]) * tmp1.xxxx + tmp0;
                tmp0 = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]) * tmp1.zzzz + tmp0;
                tmp0 = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]) * tmp1.wwww + tmp0;
                o.position = tmp0;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp1.x = dot(v.normal.xyz, float3(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0]));
                tmp1.y = dot(v.normal.xyz, float3(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1]));
                tmp1.z = dot(v.normal.xyz, float3(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2]));
                tmp1.w = dot(tmp1.xyz, tmp1.xyz);
                tmp1.w = rsqrt(tmp1.w);
                o.texcoord1.xyz = tmp1.www * tmp1.xyz;
                tmp1.xyz = tmp0.xyw * float3(0.5, 0.5, 0.5);
                o.texcoord4.zw = tmp0.zw;
                tmp1.w = tmp1.y * _ProjectionParams.x;
                o.texcoord4.xy = tmp1.zz + tmp1.xw;
                return o;
			}
			// Keywords: DIRECTIONAL SHADOWS_SCREEN
			fout frag(v2f inp)
			{
 UNITY_SETUP_INSTANCE_ID(inp);
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = inp.texcoord2.y + _Offset;
                tmp0.x = saturate(tmp0.x / _Scale);
                tmp1 = _ColorHigh - _ColorLow;
                o.sv_target = tmp0.xxxx * tmp1 + _ColorLow;
                return o;
			}
#elif defined(DIRECTIONAL) && !defined(LIGHTMAP_ON) && !defined(LIGHTMAP_SHADOW_MIXING) && defined(LIGHTPROBE_SH) && !defined(SHADOWS_SCREEN) && !defined(SHADOWS_SHADOWMASK) && !defined(VERTEXLIGHT_ON)
			#include "UnityCG.cginc"
			struct v2f
			{
 UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float3 texcoord1 : TEXCOORD1;
				float3 texcoord2 : TEXCOORD2;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _ColorLow;
			float4 _ColorHigh;
			float _Offset;
			float _Scale;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			
			// Keywords: DIRECTIONAL LIGHTPROBE_SH
			v2f vert(appdata_full v)
			{
 UNITY_SETUP_INSTANCE_ID(v);
                v2f o;
 UNITY_TRANSFER_INSTANCE_ID(v, o);
                float4 tmp0;
                float4 tmp1;
                tmp0 = v.vertex.yyyy * float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
                tmp0 = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]) * v.vertex.xxxx + tmp0;
                tmp0 = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]) * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
                o.texcoord2.xyz = float3(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3]) * v.vertex.www + tmp0.xyz;
                tmp0 = tmp1.yyyy * float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
                tmp0 = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]) * tmp1.xxxx + tmp0;
                tmp0 = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]) * tmp1.zzzz + tmp0;
                o.position = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]) * tmp1.wwww + tmp0;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp0.x = dot(v.normal.xyz, float3(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0]));
                tmp0.y = dot(v.normal.xyz, float3(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1]));
                tmp0.z = dot(v.normal.xyz, float3(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2]));
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord1.xyz = tmp0.www * tmp0.xyz;
                return o;
			}
			// Keywords: DIRECTIONAL LIGHTPROBE_SH
			fout frag(v2f inp)
			{
 UNITY_SETUP_INSTANCE_ID(inp);
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = inp.texcoord2.y + _Offset;
                tmp0.x = saturate(tmp0.x / _Scale);
                tmp1 = _ColorHigh - _ColorLow;
                o.sv_target = tmp0.xxxx * tmp1 + _ColorLow;
                return o;
			}
#elif defined(DIRECTIONAL) && defined(LIGHTMAP_ON) && !defined(LIGHTMAP_SHADOW_MIXING) && !defined(LIGHTPROBE_SH) && !defined(SHADOWS_SCREEN) && !defined(SHADOWS_SHADOWMASK) && !defined(VERTEXLIGHT_ON)
			#include "UnityCG.cginc"
			struct v2f
			{
 UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float3 texcoord1 : TEXCOORD1;
				float3 texcoord2 : TEXCOORD2;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _ColorLow;
			float4 _ColorHigh;
			float _Offset;
			float _Scale;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			
			// Keywords: DIRECTIONAL LIGHTMAP_ON
			v2f vert(appdata_full v)
			{
 UNITY_SETUP_INSTANCE_ID(v);
                v2f o;
 UNITY_TRANSFER_INSTANCE_ID(v, o);
                float4 tmp0;
                float4 tmp1;
                tmp0 = v.vertex.yyyy * float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
                tmp0 = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]) * v.vertex.xxxx + tmp0;
                tmp0 = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]) * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
                o.texcoord2.xyz = float3(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3]) * v.vertex.www + tmp0.xyz;
                tmp0 = tmp1.yyyy * float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
                tmp0 = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]) * tmp1.xxxx + tmp0;
                tmp0 = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]) * tmp1.zzzz + tmp0;
                o.position = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]) * tmp1.wwww + tmp0;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp0.x = dot(v.normal.xyz, float3(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0]));
                tmp0.y = dot(v.normal.xyz, float3(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1]));
                tmp0.z = dot(v.normal.xyz, float3(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2]));
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord1.xyz = tmp0.www * tmp0.xyz;
                return o;
			}
			// Keywords: DIRECTIONAL LIGHTMAP_ON
			fout frag(v2f inp)
			{
 UNITY_SETUP_INSTANCE_ID(inp);
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = inp.texcoord2.y + _Offset;
                tmp0.x = saturate(tmp0.x / _Scale);
                tmp1 = _ColorHigh - _ColorLow;
                o.sv_target = tmp0.xxxx * tmp1 + _ColorLow;
                return o;
			}
#elif defined(DIRECTIONAL) && !defined(LIGHTMAP_ON) && !defined(LIGHTMAP_SHADOW_MIXING) && !defined(LIGHTPROBE_SH) && defined(SHADOWS_SCREEN) && !defined(SHADOWS_SHADOWMASK) && !defined(VERTEXLIGHT_ON)
			#include "UnityCG.cginc"
			struct v2f
			{
 UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float3 texcoord1 : TEXCOORD1;
				float3 texcoord2 : TEXCOORD2;
				float4 texcoord4 : TEXCOORD4;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _ColorLow;
			float4 _ColorHigh;
			float _Offset;
			float _Scale;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			
			// Keywords: DIRECTIONAL SHADOWS_SCREEN
			v2f vert(appdata_full v)
			{
 UNITY_SETUP_INSTANCE_ID(v);
                v2f o;
 UNITY_TRANSFER_INSTANCE_ID(v, o);
                float4 tmp0;
                float4 tmp1;
                tmp0 = v.vertex.yyyy * float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
                tmp0 = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]) * v.vertex.xxxx + tmp0;
                tmp0 = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]) * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
                o.texcoord2.xyz = float3(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3]) * v.vertex.www + tmp0.xyz;
                tmp0 = tmp1.yyyy * float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
                tmp0 = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]) * tmp1.xxxx + tmp0;
                tmp0 = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]) * tmp1.zzzz + tmp0;
                tmp0 = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]) * tmp1.wwww + tmp0;
                o.position = tmp0;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp1.x = dot(v.normal.xyz, float3(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0]));
                tmp1.y = dot(v.normal.xyz, float3(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1]));
                tmp1.z = dot(v.normal.xyz, float3(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2]));
                tmp1.w = dot(tmp1.xyz, tmp1.xyz);
                tmp1.w = rsqrt(tmp1.w);
                o.texcoord1.xyz = tmp1.www * tmp1.xyz;
                tmp1.xyz = tmp0.xyw * float3(0.5, 0.5, 0.5);
                o.texcoord4.zw = tmp0.zw;
                tmp1.w = tmp1.y * _ProjectionParams.x;
                o.texcoord4.xy = tmp1.zz + tmp1.xw;
                return o;
			}
			// Keywords: DIRECTIONAL SHADOWS_SCREEN
			fout frag(v2f inp)
			{
 UNITY_SETUP_INSTANCE_ID(inp);
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = inp.texcoord2.y + _Offset;
                tmp0.x = saturate(tmp0.x / _Scale);
                tmp1 = _ColorHigh - _ColorLow;
                o.sv_target = tmp0.xxxx * tmp1 + _ColorLow;
                return o;
			}
#elif defined(DIRECTIONAL) && !defined(LIGHTMAP_ON) && !defined(LIGHTMAP_SHADOW_MIXING) && !defined(LIGHTPROBE_SH) && !defined(SHADOWS_SCREEN) && !defined(SHADOWS_SHADOWMASK) && defined(VERTEXLIGHT_ON)
			#include "UnityCG.cginc"
			struct v2f
			{
 UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float3 texcoord1 : TEXCOORD1;
				float3 texcoord2 : TEXCOORD2;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _ColorLow;
			float4 _ColorHigh;
			float _Offset;
			float _Scale;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			
			// Keywords: DIRECTIONAL VERTEXLIGHT_ON
			v2f vert(appdata_full v)
			{
 UNITY_SETUP_INSTANCE_ID(v);
                v2f o;
 UNITY_TRANSFER_INSTANCE_ID(v, o);
                float4 tmp0;
                float4 tmp1;
                tmp0 = v.vertex.yyyy * float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
                tmp0 = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]) * v.vertex.xxxx + tmp0;
                tmp0 = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]) * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
                o.texcoord2.xyz = float3(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3]) * v.vertex.www + tmp0.xyz;
                tmp0 = tmp1.yyyy * float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
                tmp0 = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]) * tmp1.xxxx + tmp0;
                tmp0 = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]) * tmp1.zzzz + tmp0;
                o.position = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]) * tmp1.wwww + tmp0;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp0.x = dot(v.normal.xyz, float3(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0]));
                tmp0.y = dot(v.normal.xyz, float3(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1]));
                tmp0.z = dot(v.normal.xyz, float3(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2]));
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord1.xyz = tmp0.www * tmp0.xyz;
                return o;
			}
			// Keywords: DIRECTIONAL
			fout frag(v2f inp)
			{
 UNITY_SETUP_INSTANCE_ID(inp);
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = inp.texcoord2.y + _Offset;
                tmp0.x = saturate(tmp0.x / _Scale);
                tmp1 = _ColorHigh - _ColorLow;
                o.sv_target = tmp0.xxxx * tmp1 + _ColorLow;
                return o;
			}
#else
#if !defined(DIRECTIONAL) && !defined(POINT) && !defined(SPOT) && !defined(POINT_COOKIE) && !defined(DIRECTIONAL_COOKIE)
#define DIRECTIONAL 1
#endif
			#include "UnityCG.cginc"
			struct v2f
			{
 UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float3 texcoord1 : TEXCOORD1;
				float3 texcoord2 : TEXCOORD2;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _ColorLow;
			float4 _ColorHigh;
			float _Offset;
			float _Scale;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			
			// Keywords: DIRECTIONAL
			v2f vert(appdata_full v)
			{
 UNITY_SETUP_INSTANCE_ID(v);
                v2f o;
 UNITY_TRANSFER_INSTANCE_ID(v, o);
                float4 tmp0;
                float4 tmp1;
                tmp0 = v.vertex.yyyy * float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
                tmp0 = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]) * v.vertex.xxxx + tmp0;
                tmp0 = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]) * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
                o.texcoord2.xyz = float3(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3]) * v.vertex.www + tmp0.xyz;
                tmp0 = tmp1.yyyy * float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
                tmp0 = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]) * tmp1.xxxx + tmp0;
                tmp0 = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]) * tmp1.zzzz + tmp0;
                o.position = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]) * tmp1.wwww + tmp0;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp0.x = dot(v.normal.xyz, float3(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0]));
                tmp0.y = dot(v.normal.xyz, float3(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1]));
                tmp0.z = dot(v.normal.xyz, float3(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2]));
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord1.xyz = tmp0.www * tmp0.xyz;
                return o;
			}
			// Keywords: DIRECTIONAL
			fout frag(v2f inp)
			{
 UNITY_SETUP_INSTANCE_ID(inp);
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = inp.texcoord2.y + _Offset;
                tmp0.x = saturate(tmp0.x / _Scale);
                tmp1 = _ColorHigh - _ColorLow;
                o.sv_target = tmp0.xxxx * tmp1 + _ColorLow;
                return o;
			}
#endif
			ENDCG
		}
	}
	Fallback "Diffuse"
}