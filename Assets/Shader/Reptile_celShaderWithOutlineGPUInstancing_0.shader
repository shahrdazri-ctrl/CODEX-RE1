Shader "Reptile/celShaderWithOutlineGPUInstancing" {
	Properties {
		_MainTex ("Texture", 2D) = "white" {}
		[NoScaleOffset] _RampTex ("Ramp", 2D) = "white" {}
		_Color ("Color", Color) = (1,1,1,1)
		_HueShift ("Shift Hue", Color) = (0,0,0,0)
		_ShadowBrightness ("Shadow Brightness", Range(0, 1)) = 0.2
		_CellShadeTendency ("CellShade Tendency", Range(-1, 1)) = 0
		_OutlineExtrusion ("Outline Extrusion", Float) = 0.01
		_OutlineColor ("Outline Color", Color) = (0,0,0,1)
	}
	SubShader {
		Pass {
			Tags { "LIGHTMODE" = "FORWARDBASE" "SHADOWSUPPORT" = "true" }
			Stencil {
				Ref 4
				Comp Always
				Pass Replace
				Fail Keep
				ZFail Keep
			}

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
#include "AutoLight.cginc"
			struct v2f
			{
 UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 position : SV_POSITION0;
				float3 normal : NORMAL0;
				float3 texcoord : TEXCOORD0;
				float4 texcoord2 : TEXCOORD2;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			// $Globals ConstantBuffers for Fragment Shader
			float _ShadowBrightness;
			float4 _Color;
			float4 _HueShift;
			float _CellShadeTendency;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _RampTex;
			sampler2D _MainTex;
			
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
                tmp0 = tmp0 + float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
                tmp1 = tmp0.yyyy * float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
                tmp1 = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]) * tmp0.xxxx + tmp1;
                tmp1 = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]) * tmp0.zzzz + tmp1;
                tmp0 = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]) * tmp0.wwww + tmp1;
                o.position = tmp0;
                tmp1.x = dot(v.normal.xyz, float3(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0]));
                tmp1.y = dot(v.normal.xyz, float3(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1]));
                tmp1.z = dot(v.normal.xyz, float3(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2]));
                tmp1.w = dot(tmp1.xyz, tmp1.xyz);
                tmp1.w = rsqrt(tmp1.w);
                o.normal.xyz = tmp1.www * tmp1.xyz;
                o.texcoord.xyz = v.texcoord.xyz;
                tmp0.y = tmp0.y * _ProjectionParams.x;
                tmp1.xzw = tmp0.xwy * float3(0.5, 0.5, 0.5);
                o.texcoord2.zw = tmp0.zw;
                o.texcoord2.xy = tmp1.zz + tmp1.xw;
                return o;
			}
			// Keywords: DIRECTIONAL LIGHTPROBE_SH SHADOWS_SHADOWMASK LIGHTMAP_ON LIGHTMAP_SHADOW_MIXING SHADOWS_SCREEN
			fout frag(v2f inp)
			{
 UNITY_SETUP_INSTANCE_ID(inp);
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = dot(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp0.xyz = tmp0.xxx * _WorldSpaceLightPos0.xyz;
                tmp0.x = dot(inp.normal.xyz, tmp0.xyz);
                tmp0.x = saturate(tmp0.x + _CellShadeTendency);
                tmp0.y = 0.5;
                tmp0 = tex2D(_RampTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord.xy);
                tmp2.xyz = tmp1.yzx - tmp1.xyz;
                tmp1.xyz = _HueShift.xxx * tmp2.xyz + tmp1.xyz;
                tmp2.xyz = tmp1.yzx - tmp1.xyz;
                tmp1.xyz = _HueShift.yyy * tmp2.xyz + tmp1.xyz;
                tmp2.xyz = tmp1.zyx - tmp1.xyz;
                tmp1.xyz = _HueShift.zzz * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = tmp0.xyz * tmp1.xyz;
                tmp0.xyz = tmp0.xyz * _Color.xyz;
                tmp1.xy = inp.texcoord2.xy / inp.texcoord2.ww;
                tmp1 = tex2D(_ShadowMapTexture, tmp1.xy);
                tmp0.w = max(tmp1.x, _ShadowBrightness);
                tmp0.w = min(tmp0.w, 1.0);
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = 1.0;
                return o;
			}
#elif defined(DIRECTIONAL) && !defined(LIGHTMAP_ON) && defined(LIGHTMAP_SHADOW_MIXING) && defined(LIGHTPROBE_SH) && defined(SHADOWS_SCREEN) && defined(SHADOWS_SHADOWMASK) && defined(VERTEXLIGHT_ON)
			#include "UnityCG.cginc"
#include "AutoLight.cginc"
			struct v2f
			{
 UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 position : SV_POSITION0;
				float3 normal : NORMAL0;
				float3 texcoord : TEXCOORD0;
				float4 texcoord2 : TEXCOORD2;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			// $Globals ConstantBuffers for Fragment Shader
			float _ShadowBrightness;
			float4 _Color;
			float4 _HueShift;
			float _CellShadeTendency;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _RampTex;
			sampler2D _MainTex;
			
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
                tmp0 = tmp0 + float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
                tmp1 = tmp0.yyyy * float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
                tmp1 = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]) * tmp0.xxxx + tmp1;
                tmp1 = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]) * tmp0.zzzz + tmp1;
                tmp0 = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]) * tmp0.wwww + tmp1;
                o.position = tmp0;
                tmp1.x = dot(v.normal.xyz, float3(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0]));
                tmp1.y = dot(v.normal.xyz, float3(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1]));
                tmp1.z = dot(v.normal.xyz, float3(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2]));
                tmp1.w = dot(tmp1.xyz, tmp1.xyz);
                tmp1.w = rsqrt(tmp1.w);
                o.normal.xyz = tmp1.www * tmp1.xyz;
                o.texcoord.xyz = v.texcoord.xyz;
                tmp0.y = tmp0.y * _ProjectionParams.x;
                tmp1.xzw = tmp0.xwy * float3(0.5, 0.5, 0.5);
                o.texcoord2.zw = tmp0.zw;
                o.texcoord2.xy = tmp1.zz + tmp1.xw;
                return o;
			}
			// Keywords: DIRECTIONAL LIGHTPROBE_SH SHADOWS_SHADOWMASK LIGHTMAP_SHADOW_MIXING SHADOWS_SCREEN
			fout frag(v2f inp)
			{
 UNITY_SETUP_INSTANCE_ID(inp);
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = dot(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp0.xyz = tmp0.xxx * _WorldSpaceLightPos0.xyz;
                tmp0.x = dot(inp.normal.xyz, tmp0.xyz);
                tmp0.x = saturate(tmp0.x + _CellShadeTendency);
                tmp0.y = 0.5;
                tmp0 = tex2D(_RampTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord.xy);
                tmp2.xyz = tmp1.yzx - tmp1.xyz;
                tmp1.xyz = _HueShift.xxx * tmp2.xyz + tmp1.xyz;
                tmp2.xyz = tmp1.yzx - tmp1.xyz;
                tmp1.xyz = _HueShift.yyy * tmp2.xyz + tmp1.xyz;
                tmp2.xyz = tmp1.zyx - tmp1.xyz;
                tmp1.xyz = _HueShift.zzz * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = tmp0.xyz * tmp1.xyz;
                tmp0.xyz = tmp0.xyz * _Color.xyz;
                tmp1.xy = inp.texcoord2.xy / inp.texcoord2.ww;
                tmp1 = tex2D(_ShadowMapTexture, tmp1.xy);
                tmp0.w = max(tmp1.x, _ShadowBrightness);
                tmp0.w = min(tmp0.w, 1.0);
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = 1.0;
                return o;
			}
#elif defined(DIRECTIONAL) && defined(LIGHTMAP_ON) && defined(LIGHTMAP_SHADOW_MIXING) && defined(LIGHTPROBE_SH) && !defined(SHADOWS_SCREEN) && defined(SHADOWS_SHADOWMASK) && !defined(VERTEXLIGHT_ON)
			#include "UnityCG.cginc"
#include "AutoLight.cginc"
			struct v2f
			{
 UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 position : SV_POSITION0;
				float3 normal : NORMAL0;
				float3 texcoord : TEXCOORD0;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			// $Globals ConstantBuffers for Fragment Shader
			float4 _Color;
			float4 _HueShift;
			float _CellShadeTendency;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _RampTex;
			sampler2D _MainTex;
			
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
                tmp0 = tmp0 + float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
                tmp1 = tmp0.yyyy * float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
                tmp1 = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]) * tmp0.xxxx + tmp1;
                tmp1 = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]) * tmp0.zzzz + tmp1;
                o.position = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]) * tmp0.wwww + tmp1;
                tmp0.x = dot(v.normal.xyz, float3(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0]));
                tmp0.y = dot(v.normal.xyz, float3(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1]));
                tmp0.z = dot(v.normal.xyz, float3(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2]));
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.normal.xyz = tmp0.www * tmp0.xyz;
                o.texcoord.xyz = v.texcoord.xyz;
                return o;
			}
			// Keywords: DIRECTIONAL LIGHTPROBE_SH SHADOWS_SHADOWMASK LIGHTMAP_ON LIGHTMAP_SHADOW_MIXING
			fout frag(v2f inp)
			{
 UNITY_SETUP_INSTANCE_ID(inp);
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = dot(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp0.xyz = tmp0.xxx * _WorldSpaceLightPos0.xyz;
                tmp0.x = dot(inp.normal.xyz, tmp0.xyz);
                tmp0.x = saturate(tmp0.x + _CellShadeTendency);
                tmp0.y = 0.5;
                tmp0 = tex2D(_RampTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord.xy);
                tmp2.xyz = tmp1.yzx - tmp1.xyz;
                tmp1.xyz = _HueShift.xxx * tmp2.xyz + tmp1.xyz;
                tmp2.xyz = tmp1.yzx - tmp1.xyz;
                tmp1.xyz = _HueShift.yyy * tmp2.xyz + tmp1.xyz;
                tmp2.xyz = tmp1.zyx - tmp1.xyz;
                tmp1.xyz = _HueShift.zzz * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = tmp0.xyz * tmp1.xyz;
                o.sv_target.xyz = tmp0.xyz * _Color.xyz;
                o.sv_target.w = 1.0;
                return o;
			}
#elif defined(DIRECTIONAL) && !defined(LIGHTMAP_ON) && defined(LIGHTMAP_SHADOW_MIXING) && defined(LIGHTPROBE_SH) && defined(SHADOWS_SCREEN) && defined(SHADOWS_SHADOWMASK) && !defined(VERTEXLIGHT_ON)
			#include "UnityCG.cginc"
#include "AutoLight.cginc"
			struct v2f
			{
 UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 position : SV_POSITION0;
				float3 normal : NORMAL0;
				float3 texcoord : TEXCOORD0;
				float4 texcoord2 : TEXCOORD2;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			// $Globals ConstantBuffers for Fragment Shader
			float _ShadowBrightness;
			float4 _Color;
			float4 _HueShift;
			float _CellShadeTendency;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _RampTex;
			sampler2D _MainTex;
			
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
                tmp0 = tmp0 + float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
                tmp1 = tmp0.yyyy * float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
                tmp1 = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]) * tmp0.xxxx + tmp1;
                tmp1 = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]) * tmp0.zzzz + tmp1;
                tmp0 = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]) * tmp0.wwww + tmp1;
                o.position = tmp0;
                tmp1.x = dot(v.normal.xyz, float3(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0]));
                tmp1.y = dot(v.normal.xyz, float3(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1]));
                tmp1.z = dot(v.normal.xyz, float3(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2]));
                tmp1.w = dot(tmp1.xyz, tmp1.xyz);
                tmp1.w = rsqrt(tmp1.w);
                o.normal.xyz = tmp1.www * tmp1.xyz;
                o.texcoord.xyz = v.texcoord.xyz;
                tmp0.y = tmp0.y * _ProjectionParams.x;
                tmp1.xzw = tmp0.xwy * float3(0.5, 0.5, 0.5);
                o.texcoord2.zw = tmp0.zw;
                o.texcoord2.xy = tmp1.zz + tmp1.xw;
                return o;
			}
			// Keywords: DIRECTIONAL LIGHTPROBE_SH SHADOWS_SHADOWMASK LIGHTMAP_SHADOW_MIXING SHADOWS_SCREEN
			fout frag(v2f inp)
			{
 UNITY_SETUP_INSTANCE_ID(inp);
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = dot(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp0.xyz = tmp0.xxx * _WorldSpaceLightPos0.xyz;
                tmp0.x = dot(inp.normal.xyz, tmp0.xyz);
                tmp0.x = saturate(tmp0.x + _CellShadeTendency);
                tmp0.y = 0.5;
                tmp0 = tex2D(_RampTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord.xy);
                tmp2.xyz = tmp1.yzx - tmp1.xyz;
                tmp1.xyz = _HueShift.xxx * tmp2.xyz + tmp1.xyz;
                tmp2.xyz = tmp1.yzx - tmp1.xyz;
                tmp1.xyz = _HueShift.yyy * tmp2.xyz + tmp1.xyz;
                tmp2.xyz = tmp1.zyx - tmp1.xyz;
                tmp1.xyz = _HueShift.zzz * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = tmp0.xyz * tmp1.xyz;
                tmp0.xyz = tmp0.xyz * _Color.xyz;
                tmp1.xy = inp.texcoord2.xy / inp.texcoord2.ww;
                tmp1 = tex2D(_ShadowMapTexture, tmp1.xy);
                tmp0.w = max(tmp1.x, _ShadowBrightness);
                tmp0.w = min(tmp0.w, 1.0);
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = 1.0;
                return o;
			}
#elif defined(DIRECTIONAL) && defined(LIGHTMAP_ON) && defined(LIGHTMAP_SHADOW_MIXING) && defined(LIGHTPROBE_SH) && defined(SHADOWS_SCREEN) && !defined(SHADOWS_SHADOWMASK) && !defined(VERTEXLIGHT_ON)
			#include "UnityCG.cginc"
#include "AutoLight.cginc"
			struct v2f
			{
 UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 position : SV_POSITION0;
				float3 normal : NORMAL0;
				float3 texcoord : TEXCOORD0;
				float4 texcoord2 : TEXCOORD2;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			// $Globals ConstantBuffers for Fragment Shader
			float _ShadowBrightness;
			float4 _Color;
			float4 _HueShift;
			float _CellShadeTendency;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _RampTex;
			sampler2D _MainTex;
			
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
                tmp0 = tmp0 + float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
                tmp1 = tmp0.yyyy * float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
                tmp1 = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]) * tmp0.xxxx + tmp1;
                tmp1 = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]) * tmp0.zzzz + tmp1;
                tmp0 = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]) * tmp0.wwww + tmp1;
                o.position = tmp0;
                tmp1.x = dot(v.normal.xyz, float3(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0]));
                tmp1.y = dot(v.normal.xyz, float3(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1]));
                tmp1.z = dot(v.normal.xyz, float3(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2]));
                tmp1.w = dot(tmp1.xyz, tmp1.xyz);
                tmp1.w = rsqrt(tmp1.w);
                o.normal.xyz = tmp1.www * tmp1.xyz;
                o.texcoord.xyz = v.texcoord.xyz;
                tmp0.y = tmp0.y * _ProjectionParams.x;
                tmp1.xzw = tmp0.xwy * float3(0.5, 0.5, 0.5);
                o.texcoord2.zw = tmp0.zw;
                o.texcoord2.xy = tmp1.zz + tmp1.xw;
                return o;
			}
			// Keywords: DIRECTIONAL LIGHTPROBE_SH LIGHTMAP_ON LIGHTMAP_SHADOW_MIXING SHADOWS_SCREEN
			fout frag(v2f inp)
			{
 UNITY_SETUP_INSTANCE_ID(inp);
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = dot(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp0.xyz = tmp0.xxx * _WorldSpaceLightPos0.xyz;
                tmp0.x = dot(inp.normal.xyz, tmp0.xyz);
                tmp0.x = saturate(tmp0.x + _CellShadeTendency);
                tmp0.y = 0.5;
                tmp0 = tex2D(_RampTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord.xy);
                tmp2.xyz = tmp1.yzx - tmp1.xyz;
                tmp1.xyz = _HueShift.xxx * tmp2.xyz + tmp1.xyz;
                tmp2.xyz = tmp1.yzx - tmp1.xyz;
                tmp1.xyz = _HueShift.yyy * tmp2.xyz + tmp1.xyz;
                tmp2.xyz = tmp1.zyx - tmp1.xyz;
                tmp1.xyz = _HueShift.zzz * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = tmp0.xyz * tmp1.xyz;
                tmp0.xyz = tmp0.xyz * _Color.xyz;
                tmp1.xy = inp.texcoord2.xy / inp.texcoord2.ww;
                tmp1 = tex2D(_ShadowMapTexture, tmp1.xy);
                tmp0.w = max(tmp1.x, _ShadowBrightness);
                tmp0.w = min(tmp0.w, 1.0);
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = 1.0;
                return o;
			}
#elif defined(DIRECTIONAL) && defined(LIGHTMAP_ON) && !defined(LIGHTMAP_SHADOW_MIXING) && defined(LIGHTPROBE_SH) && defined(SHADOWS_SCREEN) && defined(SHADOWS_SHADOWMASK) && !defined(VERTEXLIGHT_ON)
			#include "UnityCG.cginc"
#include "AutoLight.cginc"
			struct v2f
			{
 UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 position : SV_POSITION0;
				float3 normal : NORMAL0;
				float3 texcoord : TEXCOORD0;
				float4 texcoord2 : TEXCOORD2;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			// $Globals ConstantBuffers for Fragment Shader
			float _ShadowBrightness;
			float4 _Color;
			float4 _HueShift;
			float _CellShadeTendency;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _RampTex;
			sampler2D _MainTex;
			
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
                tmp0 = tmp0 + float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
                tmp1 = tmp0.yyyy * float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
                tmp1 = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]) * tmp0.xxxx + tmp1;
                tmp1 = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]) * tmp0.zzzz + tmp1;
                tmp0 = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]) * tmp0.wwww + tmp1;
                o.position = tmp0;
                tmp1.x = dot(v.normal.xyz, float3(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0]));
                tmp1.y = dot(v.normal.xyz, float3(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1]));
                tmp1.z = dot(v.normal.xyz, float3(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2]));
                tmp1.w = dot(tmp1.xyz, tmp1.xyz);
                tmp1.w = rsqrt(tmp1.w);
                o.normal.xyz = tmp1.www * tmp1.xyz;
                o.texcoord.xyz = v.texcoord.xyz;
                tmp0.y = tmp0.y * _ProjectionParams.x;
                tmp1.xzw = tmp0.xwy * float3(0.5, 0.5, 0.5);
                o.texcoord2.zw = tmp0.zw;
                o.texcoord2.xy = tmp1.zz + tmp1.xw;
                return o;
			}
			// Keywords: DIRECTIONAL LIGHTPROBE_SH SHADOWS_SHADOWMASK LIGHTMAP_ON SHADOWS_SCREEN
			fout frag(v2f inp)
			{
 UNITY_SETUP_INSTANCE_ID(inp);
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = dot(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp0.xyz = tmp0.xxx * _WorldSpaceLightPos0.xyz;
                tmp0.x = dot(inp.normal.xyz, tmp0.xyz);
                tmp0.x = saturate(tmp0.x + _CellShadeTendency);
                tmp0.y = 0.5;
                tmp0 = tex2D(_RampTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord.xy);
                tmp2.xyz = tmp1.yzx - tmp1.xyz;
                tmp1.xyz = _HueShift.xxx * tmp2.xyz + tmp1.xyz;
                tmp2.xyz = tmp1.yzx - tmp1.xyz;
                tmp1.xyz = _HueShift.yyy * tmp2.xyz + tmp1.xyz;
                tmp2.xyz = tmp1.zyx - tmp1.xyz;
                tmp1.xyz = _HueShift.zzz * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = tmp0.xyz * tmp1.xyz;
                tmp0.xyz = tmp0.xyz * _Color.xyz;
                tmp1.xy = inp.texcoord2.xy / inp.texcoord2.ww;
                tmp1 = tex2D(_ShadowMapTexture, tmp1.xy);
                tmp0.w = max(tmp1.x, _ShadowBrightness);
                tmp0.w = min(tmp0.w, 1.0);
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = 1.0;
                return o;
			}
#elif defined(DIRECTIONAL) && defined(LIGHTMAP_ON) && defined(LIGHTMAP_SHADOW_MIXING) && !defined(LIGHTPROBE_SH) && defined(SHADOWS_SCREEN) && defined(SHADOWS_SHADOWMASK) && !defined(VERTEXLIGHT_ON)
			#include "UnityCG.cginc"
#include "AutoLight.cginc"
			struct v2f
			{
 UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 position : SV_POSITION0;
				float3 normal : NORMAL0;
				float3 texcoord : TEXCOORD0;
				float4 texcoord2 : TEXCOORD2;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			// $Globals ConstantBuffers for Fragment Shader
			float _ShadowBrightness;
			float4 _Color;
			float4 _HueShift;
			float _CellShadeTendency;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _RampTex;
			sampler2D _MainTex;
			
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
                tmp0 = tmp0 + float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
                tmp1 = tmp0.yyyy * float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
                tmp1 = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]) * tmp0.xxxx + tmp1;
                tmp1 = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]) * tmp0.zzzz + tmp1;
                tmp0 = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]) * tmp0.wwww + tmp1;
                o.position = tmp0;
                tmp1.x = dot(v.normal.xyz, float3(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0]));
                tmp1.y = dot(v.normal.xyz, float3(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1]));
                tmp1.z = dot(v.normal.xyz, float3(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2]));
                tmp1.w = dot(tmp1.xyz, tmp1.xyz);
                tmp1.w = rsqrt(tmp1.w);
                o.normal.xyz = tmp1.www * tmp1.xyz;
                o.texcoord.xyz = v.texcoord.xyz;
                tmp0.y = tmp0.y * _ProjectionParams.x;
                tmp1.xzw = tmp0.xwy * float3(0.5, 0.5, 0.5);
                o.texcoord2.zw = tmp0.zw;
                o.texcoord2.xy = tmp1.zz + tmp1.xw;
                return o;
			}
			// Keywords: DIRECTIONAL SHADOWS_SHADOWMASK LIGHTMAP_ON LIGHTMAP_SHADOW_MIXING SHADOWS_SCREEN
			fout frag(v2f inp)
			{
 UNITY_SETUP_INSTANCE_ID(inp);
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = dot(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp0.xyz = tmp0.xxx * _WorldSpaceLightPos0.xyz;
                tmp0.x = dot(inp.normal.xyz, tmp0.xyz);
                tmp0.x = saturate(tmp0.x + _CellShadeTendency);
                tmp0.y = 0.5;
                tmp0 = tex2D(_RampTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord.xy);
                tmp2.xyz = tmp1.yzx - tmp1.xyz;
                tmp1.xyz = _HueShift.xxx * tmp2.xyz + tmp1.xyz;
                tmp2.xyz = tmp1.yzx - tmp1.xyz;
                tmp1.xyz = _HueShift.yyy * tmp2.xyz + tmp1.xyz;
                tmp2.xyz = tmp1.zyx - tmp1.xyz;
                tmp1.xyz = _HueShift.zzz * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = tmp0.xyz * tmp1.xyz;
                tmp0.xyz = tmp0.xyz * _Color.xyz;
                tmp1.xy = inp.texcoord2.xy / inp.texcoord2.ww;
                tmp1 = tex2D(_ShadowMapTexture, tmp1.xy);
                tmp0.w = max(tmp1.x, _ShadowBrightness);
                tmp0.w = min(tmp0.w, 1.0);
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = 1.0;
                return o;
			}
#elif defined(DIRECTIONAL) && !defined(LIGHTMAP_ON) && defined(LIGHTMAP_SHADOW_MIXING) && defined(LIGHTPROBE_SH) && defined(SHADOWS_SCREEN) && !defined(SHADOWS_SHADOWMASK) && defined(VERTEXLIGHT_ON)
			#include "UnityCG.cginc"
#include "AutoLight.cginc"
			struct v2f
			{
 UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 position : SV_POSITION0;
				float3 normal : NORMAL0;
				float3 texcoord : TEXCOORD0;
				float4 texcoord2 : TEXCOORD2;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			// $Globals ConstantBuffers for Fragment Shader
			float _ShadowBrightness;
			float4 _Color;
			float4 _HueShift;
			float _CellShadeTendency;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _RampTex;
			sampler2D _MainTex;
			
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
                tmp0 = tmp0 + float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
                tmp1 = tmp0.yyyy * float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
                tmp1 = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]) * tmp0.xxxx + tmp1;
                tmp1 = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]) * tmp0.zzzz + tmp1;
                tmp0 = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]) * tmp0.wwww + tmp1;
                o.position = tmp0;
                tmp1.x = dot(v.normal.xyz, float3(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0]));
                tmp1.y = dot(v.normal.xyz, float3(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1]));
                tmp1.z = dot(v.normal.xyz, float3(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2]));
                tmp1.w = dot(tmp1.xyz, tmp1.xyz);
                tmp1.w = rsqrt(tmp1.w);
                o.normal.xyz = tmp1.www * tmp1.xyz;
                o.texcoord.xyz = v.texcoord.xyz;
                tmp0.y = tmp0.y * _ProjectionParams.x;
                tmp1.xzw = tmp0.xwy * float3(0.5, 0.5, 0.5);
                o.texcoord2.zw = tmp0.zw;
                o.texcoord2.xy = tmp1.zz + tmp1.xw;
                return o;
			}
			// Keywords: DIRECTIONAL LIGHTPROBE_SH LIGHTMAP_SHADOW_MIXING SHADOWS_SCREEN
			fout frag(v2f inp)
			{
 UNITY_SETUP_INSTANCE_ID(inp);
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = dot(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp0.xyz = tmp0.xxx * _WorldSpaceLightPos0.xyz;
                tmp0.x = dot(inp.normal.xyz, tmp0.xyz);
                tmp0.x = saturate(tmp0.x + _CellShadeTendency);
                tmp0.y = 0.5;
                tmp0 = tex2D(_RampTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord.xy);
                tmp2.xyz = tmp1.yzx - tmp1.xyz;
                tmp1.xyz = _HueShift.xxx * tmp2.xyz + tmp1.xyz;
                tmp2.xyz = tmp1.yzx - tmp1.xyz;
                tmp1.xyz = _HueShift.yyy * tmp2.xyz + tmp1.xyz;
                tmp2.xyz = tmp1.zyx - tmp1.xyz;
                tmp1.xyz = _HueShift.zzz * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = tmp0.xyz * tmp1.xyz;
                tmp0.xyz = tmp0.xyz * _Color.xyz;
                tmp1.xy = inp.texcoord2.xy / inp.texcoord2.ww;
                tmp1 = tex2D(_ShadowMapTexture, tmp1.xy);
                tmp0.w = max(tmp1.x, _ShadowBrightness);
                tmp0.w = min(tmp0.w, 1.0);
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = 1.0;
                return o;
			}
#elif defined(DIRECTIONAL) && !defined(LIGHTMAP_ON) && !defined(LIGHTMAP_SHADOW_MIXING) && defined(LIGHTPROBE_SH) && defined(SHADOWS_SCREEN) && defined(SHADOWS_SHADOWMASK) && defined(VERTEXLIGHT_ON)
			#include "UnityCG.cginc"
#include "AutoLight.cginc"
			struct v2f
			{
 UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 position : SV_POSITION0;
				float3 normal : NORMAL0;
				float3 texcoord : TEXCOORD0;
				float4 texcoord2 : TEXCOORD2;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			// $Globals ConstantBuffers for Fragment Shader
			float _ShadowBrightness;
			float4 _Color;
			float4 _HueShift;
			float _CellShadeTendency;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _RampTex;
			sampler2D _MainTex;
			
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
                tmp0 = tmp0 + float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
                tmp1 = tmp0.yyyy * float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
                tmp1 = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]) * tmp0.xxxx + tmp1;
                tmp1 = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]) * tmp0.zzzz + tmp1;
                tmp0 = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]) * tmp0.wwww + tmp1;
                o.position = tmp0;
                tmp1.x = dot(v.normal.xyz, float3(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0]));
                tmp1.y = dot(v.normal.xyz, float3(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1]));
                tmp1.z = dot(v.normal.xyz, float3(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2]));
                tmp1.w = dot(tmp1.xyz, tmp1.xyz);
                tmp1.w = rsqrt(tmp1.w);
                o.normal.xyz = tmp1.www * tmp1.xyz;
                o.texcoord.xyz = v.texcoord.xyz;
                tmp0.y = tmp0.y * _ProjectionParams.x;
                tmp1.xzw = tmp0.xwy * float3(0.5, 0.5, 0.5);
                o.texcoord2.zw = tmp0.zw;
                o.texcoord2.xy = tmp1.zz + tmp1.xw;
                return o;
			}
			// Keywords: DIRECTIONAL LIGHTPROBE_SH SHADOWS_SHADOWMASK SHADOWS_SCREEN
			fout frag(v2f inp)
			{
 UNITY_SETUP_INSTANCE_ID(inp);
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = dot(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp0.xyz = tmp0.xxx * _WorldSpaceLightPos0.xyz;
                tmp0.x = dot(inp.normal.xyz, tmp0.xyz);
                tmp0.x = saturate(tmp0.x + _CellShadeTendency);
                tmp0.y = 0.5;
                tmp0 = tex2D(_RampTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord.xy);
                tmp2.xyz = tmp1.yzx - tmp1.xyz;
                tmp1.xyz = _HueShift.xxx * tmp2.xyz + tmp1.xyz;
                tmp2.xyz = tmp1.yzx - tmp1.xyz;
                tmp1.xyz = _HueShift.yyy * tmp2.xyz + tmp1.xyz;
                tmp2.xyz = tmp1.zyx - tmp1.xyz;
                tmp1.xyz = _HueShift.zzz * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = tmp0.xyz * tmp1.xyz;
                tmp0.xyz = tmp0.xyz * _Color.xyz;
                tmp1.xy = inp.texcoord2.xy / inp.texcoord2.ww;
                tmp1 = tex2D(_ShadowMapTexture, tmp1.xy);
                tmp0.w = max(tmp1.x, _ShadowBrightness);
                tmp0.w = min(tmp0.w, 1.0);
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = 1.0;
                return o;
			}
#elif defined(DIRECTIONAL) && !defined(LIGHTMAP_ON) && defined(LIGHTMAP_SHADOW_MIXING) && !defined(LIGHTPROBE_SH) && defined(SHADOWS_SCREEN) && defined(SHADOWS_SHADOWMASK) && defined(VERTEXLIGHT_ON)
			#include "UnityCG.cginc"
#include "AutoLight.cginc"
			struct v2f
			{
 UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 position : SV_POSITION0;
				float3 normal : NORMAL0;
				float3 texcoord : TEXCOORD0;
				float4 texcoord2 : TEXCOORD2;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			// $Globals ConstantBuffers for Fragment Shader
			float _ShadowBrightness;
			float4 _Color;
			float4 _HueShift;
			float _CellShadeTendency;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _RampTex;
			sampler2D _MainTex;
			
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
                tmp0 = tmp0 + float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
                tmp1 = tmp0.yyyy * float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
                tmp1 = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]) * tmp0.xxxx + tmp1;
                tmp1 = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]) * tmp0.zzzz + tmp1;
                tmp0 = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]) * tmp0.wwww + tmp1;
                o.position = tmp0;
                tmp1.x = dot(v.normal.xyz, float3(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0]));
                tmp1.y = dot(v.normal.xyz, float3(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1]));
                tmp1.z = dot(v.normal.xyz, float3(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2]));
                tmp1.w = dot(tmp1.xyz, tmp1.xyz);
                tmp1.w = rsqrt(tmp1.w);
                o.normal.xyz = tmp1.www * tmp1.xyz;
                o.texcoord.xyz = v.texcoord.xyz;
                tmp0.y = tmp0.y * _ProjectionParams.x;
                tmp1.xzw = tmp0.xwy * float3(0.5, 0.5, 0.5);
                o.texcoord2.zw = tmp0.zw;
                o.texcoord2.xy = tmp1.zz + tmp1.xw;
                return o;
			}
			// Keywords: DIRECTIONAL SHADOWS_SCREEN
			fout frag(v2f inp)
			{
 UNITY_SETUP_INSTANCE_ID(inp);
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = dot(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp0.xyz = tmp0.xxx * _WorldSpaceLightPos0.xyz;
                tmp0.x = dot(inp.normal.xyz, tmp0.xyz);
                tmp0.x = saturate(tmp0.x + _CellShadeTendency);
                tmp0.y = 0.5;
                tmp0 = tex2D(_RampTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord.xy);
                tmp2.xyz = tmp1.yzx - tmp1.xyz;
                tmp1.xyz = _HueShift.xxx * tmp2.xyz + tmp1.xyz;
                tmp2.xyz = tmp1.yzx - tmp1.xyz;
                tmp1.xyz = _HueShift.yyy * tmp2.xyz + tmp1.xyz;
                tmp2.xyz = tmp1.zyx - tmp1.xyz;
                tmp1.xyz = _HueShift.zzz * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = tmp0.xyz * tmp1.xyz;
                tmp0.xyz = tmp0.xyz * _Color.xyz;
                tmp1.xy = inp.texcoord2.xy / inp.texcoord2.ww;
                tmp1 = tex2D(_ShadowMapTexture, tmp1.xy);
                tmp0.w = max(tmp1.x, _ShadowBrightness);
                tmp0.w = min(tmp0.w, 1.0);
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = 1.0;
                return o;
			}
#elif defined(DIRECTIONAL) && defined(LIGHTMAP_ON) && defined(LIGHTMAP_SHADOW_MIXING) && defined(LIGHTPROBE_SH) && !defined(SHADOWS_SCREEN) && !defined(SHADOWS_SHADOWMASK) && !defined(VERTEXLIGHT_ON)
			#include "UnityCG.cginc"
#include "AutoLight.cginc"
			struct v2f
			{
 UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 position : SV_POSITION0;
				float3 normal : NORMAL0;
				float3 texcoord : TEXCOORD0;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			// $Globals ConstantBuffers for Fragment Shader
			float4 _Color;
			float4 _HueShift;
			float _CellShadeTendency;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _RampTex;
			sampler2D _MainTex;
			
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
                tmp0 = tmp0 + float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
                tmp1 = tmp0.yyyy * float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
                tmp1 = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]) * tmp0.xxxx + tmp1;
                tmp1 = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]) * tmp0.zzzz + tmp1;
                o.position = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]) * tmp0.wwww + tmp1;
                tmp0.x = dot(v.normal.xyz, float3(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0]));
                tmp0.y = dot(v.normal.xyz, float3(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1]));
                tmp0.z = dot(v.normal.xyz, float3(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2]));
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.normal.xyz = tmp0.www * tmp0.xyz;
                o.texcoord.xyz = v.texcoord.xyz;
                return o;
			}
			// Keywords: DIRECTIONAL LIGHTPROBE_SH LIGHTMAP_ON LIGHTMAP_SHADOW_MIXING
			fout frag(v2f inp)
			{
 UNITY_SETUP_INSTANCE_ID(inp);
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = dot(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp0.xyz = tmp0.xxx * _WorldSpaceLightPos0.xyz;
                tmp0.x = dot(inp.normal.xyz, tmp0.xyz);
                tmp0.x = saturate(tmp0.x + _CellShadeTendency);
                tmp0.y = 0.5;
                tmp0 = tex2D(_RampTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord.xy);
                tmp2.xyz = tmp1.yzx - tmp1.xyz;
                tmp1.xyz = _HueShift.xxx * tmp2.xyz + tmp1.xyz;
                tmp2.xyz = tmp1.yzx - tmp1.xyz;
                tmp1.xyz = _HueShift.yyy * tmp2.xyz + tmp1.xyz;
                tmp2.xyz = tmp1.zyx - tmp1.xyz;
                tmp1.xyz = _HueShift.zzz * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = tmp0.xyz * tmp1.xyz;
                o.sv_target.xyz = tmp0.xyz * _Color.xyz;
                o.sv_target.w = 1.0;
                return o;
			}
#elif defined(DIRECTIONAL) && defined(LIGHTMAP_ON) && !defined(LIGHTMAP_SHADOW_MIXING) && defined(LIGHTPROBE_SH) && !defined(SHADOWS_SCREEN) && defined(SHADOWS_SHADOWMASK) && !defined(VERTEXLIGHT_ON)
			#include "UnityCG.cginc"
#include "AutoLight.cginc"
			struct v2f
			{
 UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 position : SV_POSITION0;
				float3 normal : NORMAL0;
				float3 texcoord : TEXCOORD0;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			// $Globals ConstantBuffers for Fragment Shader
			float4 _Color;
			float4 _HueShift;
			float _CellShadeTendency;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _RampTex;
			sampler2D _MainTex;
			
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
                tmp0 = tmp0 + float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
                tmp1 = tmp0.yyyy * float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
                tmp1 = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]) * tmp0.xxxx + tmp1;
                tmp1 = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]) * tmp0.zzzz + tmp1;
                o.position = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]) * tmp0.wwww + tmp1;
                tmp0.x = dot(v.normal.xyz, float3(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0]));
                tmp0.y = dot(v.normal.xyz, float3(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1]));
                tmp0.z = dot(v.normal.xyz, float3(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2]));
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.normal.xyz = tmp0.www * tmp0.xyz;
                o.texcoord.xyz = v.texcoord.xyz;
                return o;
			}
			// Keywords: DIRECTIONAL LIGHTPROBE_SH SHADOWS_SHADOWMASK LIGHTMAP_ON
			fout frag(v2f inp)
			{
 UNITY_SETUP_INSTANCE_ID(inp);
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = dot(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp0.xyz = tmp0.xxx * _WorldSpaceLightPos0.xyz;
                tmp0.x = dot(inp.normal.xyz, tmp0.xyz);
                tmp0.x = saturate(tmp0.x + _CellShadeTendency);
                tmp0.y = 0.5;
                tmp0 = tex2D(_RampTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord.xy);
                tmp2.xyz = tmp1.yzx - tmp1.xyz;
                tmp1.xyz = _HueShift.xxx * tmp2.xyz + tmp1.xyz;
                tmp2.xyz = tmp1.yzx - tmp1.xyz;
                tmp1.xyz = _HueShift.yyy * tmp2.xyz + tmp1.xyz;
                tmp2.xyz = tmp1.zyx - tmp1.xyz;
                tmp1.xyz = _HueShift.zzz * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = tmp0.xyz * tmp1.xyz;
                o.sv_target.xyz = tmp0.xyz * _Color.xyz;
                o.sv_target.w = 1.0;
                return o;
			}
#elif defined(DIRECTIONAL) && defined(LIGHTMAP_ON) && defined(LIGHTMAP_SHADOW_MIXING) && !defined(LIGHTPROBE_SH) && !defined(SHADOWS_SCREEN) && defined(SHADOWS_SHADOWMASK) && !defined(VERTEXLIGHT_ON)
			#include "UnityCG.cginc"
#include "AutoLight.cginc"
			struct v2f
			{
 UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 position : SV_POSITION0;
				float3 normal : NORMAL0;
				float3 texcoord : TEXCOORD0;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			// $Globals ConstantBuffers for Fragment Shader
			float4 _Color;
			float4 _HueShift;
			float _CellShadeTendency;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _RampTex;
			sampler2D _MainTex;
			
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
                tmp0 = tmp0 + float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
                tmp1 = tmp0.yyyy * float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
                tmp1 = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]) * tmp0.xxxx + tmp1;
                tmp1 = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]) * tmp0.zzzz + tmp1;
                o.position = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]) * tmp0.wwww + tmp1;
                tmp0.x = dot(v.normal.xyz, float3(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0]));
                tmp0.y = dot(v.normal.xyz, float3(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1]));
                tmp0.z = dot(v.normal.xyz, float3(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2]));
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.normal.xyz = tmp0.www * tmp0.xyz;
                o.texcoord.xyz = v.texcoord.xyz;
                return o;
			}
			// Keywords: DIRECTIONAL SHADOWS_SHADOWMASK LIGHTMAP_ON LIGHTMAP_SHADOW_MIXING
			fout frag(v2f inp)
			{
 UNITY_SETUP_INSTANCE_ID(inp);
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = dot(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp0.xyz = tmp0.xxx * _WorldSpaceLightPos0.xyz;
                tmp0.x = dot(inp.normal.xyz, tmp0.xyz);
                tmp0.x = saturate(tmp0.x + _CellShadeTendency);
                tmp0.y = 0.5;
                tmp0 = tex2D(_RampTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord.xy);
                tmp2.xyz = tmp1.yzx - tmp1.xyz;
                tmp1.xyz = _HueShift.xxx * tmp2.xyz + tmp1.xyz;
                tmp2.xyz = tmp1.yzx - tmp1.xyz;
                tmp1.xyz = _HueShift.yyy * tmp2.xyz + tmp1.xyz;
                tmp2.xyz = tmp1.zyx - tmp1.xyz;
                tmp1.xyz = _HueShift.zzz * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = tmp0.xyz * tmp1.xyz;
                o.sv_target.xyz = tmp0.xyz * _Color.xyz;
                o.sv_target.w = 1.0;
                return o;
			}
#elif defined(DIRECTIONAL) && !defined(LIGHTMAP_ON) && defined(LIGHTMAP_SHADOW_MIXING) && defined(LIGHTPROBE_SH) && defined(SHADOWS_SCREEN) && !defined(SHADOWS_SHADOWMASK) && !defined(VERTEXLIGHT_ON)
			#include "UnityCG.cginc"
#include "AutoLight.cginc"
			struct v2f
			{
 UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 position : SV_POSITION0;
				float3 normal : NORMAL0;
				float3 texcoord : TEXCOORD0;
				float4 texcoord2 : TEXCOORD2;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			// $Globals ConstantBuffers for Fragment Shader
			float _ShadowBrightness;
			float4 _Color;
			float4 _HueShift;
			float _CellShadeTendency;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _RampTex;
			sampler2D _MainTex;
			
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
                tmp0 = tmp0 + float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
                tmp1 = tmp0.yyyy * float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
                tmp1 = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]) * tmp0.xxxx + tmp1;
                tmp1 = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]) * tmp0.zzzz + tmp1;
                tmp0 = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]) * tmp0.wwww + tmp1;
                o.position = tmp0;
                tmp1.x = dot(v.normal.xyz, float3(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0]));
                tmp1.y = dot(v.normal.xyz, float3(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1]));
                tmp1.z = dot(v.normal.xyz, float3(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2]));
                tmp1.w = dot(tmp1.xyz, tmp1.xyz);
                tmp1.w = rsqrt(tmp1.w);
                o.normal.xyz = tmp1.www * tmp1.xyz;
                o.texcoord.xyz = v.texcoord.xyz;
                tmp0.y = tmp0.y * _ProjectionParams.x;
                tmp1.xzw = tmp0.xwy * float3(0.5, 0.5, 0.5);
                o.texcoord2.zw = tmp0.zw;
                o.texcoord2.xy = tmp1.zz + tmp1.xw;
                return o;
			}
			// Keywords: DIRECTIONAL LIGHTPROBE_SH LIGHTMAP_SHADOW_MIXING SHADOWS_SCREEN
			fout frag(v2f inp)
			{
 UNITY_SETUP_INSTANCE_ID(inp);
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = dot(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp0.xyz = tmp0.xxx * _WorldSpaceLightPos0.xyz;
                tmp0.x = dot(inp.normal.xyz, tmp0.xyz);
                tmp0.x = saturate(tmp0.x + _CellShadeTendency);
                tmp0.y = 0.5;
                tmp0 = tex2D(_RampTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord.xy);
                tmp2.xyz = tmp1.yzx - tmp1.xyz;
                tmp1.xyz = _HueShift.xxx * tmp2.xyz + tmp1.xyz;
                tmp2.xyz = tmp1.yzx - tmp1.xyz;
                tmp1.xyz = _HueShift.yyy * tmp2.xyz + tmp1.xyz;
                tmp2.xyz = tmp1.zyx - tmp1.xyz;
                tmp1.xyz = _HueShift.zzz * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = tmp0.xyz * tmp1.xyz;
                tmp0.xyz = tmp0.xyz * _Color.xyz;
                tmp1.xy = inp.texcoord2.xy / inp.texcoord2.ww;
                tmp1 = tex2D(_ShadowMapTexture, tmp1.xy);
                tmp0.w = max(tmp1.x, _ShadowBrightness);
                tmp0.w = min(tmp0.w, 1.0);
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = 1.0;
                return o;
			}
#elif defined(DIRECTIONAL) && !defined(LIGHTMAP_ON) && !defined(LIGHTMAP_SHADOW_MIXING) && defined(LIGHTPROBE_SH) && defined(SHADOWS_SCREEN) && defined(SHADOWS_SHADOWMASK) && !defined(VERTEXLIGHT_ON)
			#include "UnityCG.cginc"
#include "AutoLight.cginc"
			struct v2f
			{
 UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 position : SV_POSITION0;
				float3 normal : NORMAL0;
				float3 texcoord : TEXCOORD0;
				float4 texcoord2 : TEXCOORD2;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			// $Globals ConstantBuffers for Fragment Shader
			float _ShadowBrightness;
			float4 _Color;
			float4 _HueShift;
			float _CellShadeTendency;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _RampTex;
			sampler2D _MainTex;
			
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
                tmp0 = tmp0 + float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
                tmp1 = tmp0.yyyy * float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
                tmp1 = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]) * tmp0.xxxx + tmp1;
                tmp1 = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]) * tmp0.zzzz + tmp1;
                tmp0 = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]) * tmp0.wwww + tmp1;
                o.position = tmp0;
                tmp1.x = dot(v.normal.xyz, float3(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0]));
                tmp1.y = dot(v.normal.xyz, float3(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1]));
                tmp1.z = dot(v.normal.xyz, float3(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2]));
                tmp1.w = dot(tmp1.xyz, tmp1.xyz);
                tmp1.w = rsqrt(tmp1.w);
                o.normal.xyz = tmp1.www * tmp1.xyz;
                o.texcoord.xyz = v.texcoord.xyz;
                tmp0.y = tmp0.y * _ProjectionParams.x;
                tmp1.xzw = tmp0.xwy * float3(0.5, 0.5, 0.5);
                o.texcoord2.zw = tmp0.zw;
                o.texcoord2.xy = tmp1.zz + tmp1.xw;
                return o;
			}
			// Keywords: DIRECTIONAL LIGHTPROBE_SH SHADOWS_SHADOWMASK SHADOWS_SCREEN
			fout frag(v2f inp)
			{
 UNITY_SETUP_INSTANCE_ID(inp);
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = dot(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp0.xyz = tmp0.xxx * _WorldSpaceLightPos0.xyz;
                tmp0.x = dot(inp.normal.xyz, tmp0.xyz);
                tmp0.x = saturate(tmp0.x + _CellShadeTendency);
                tmp0.y = 0.5;
                tmp0 = tex2D(_RampTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord.xy);
                tmp2.xyz = tmp1.yzx - tmp1.xyz;
                tmp1.xyz = _HueShift.xxx * tmp2.xyz + tmp1.xyz;
                tmp2.xyz = tmp1.yzx - tmp1.xyz;
                tmp1.xyz = _HueShift.yyy * tmp2.xyz + tmp1.xyz;
                tmp2.xyz = tmp1.zyx - tmp1.xyz;
                tmp1.xyz = _HueShift.zzz * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = tmp0.xyz * tmp1.xyz;
                tmp0.xyz = tmp0.xyz * _Color.xyz;
                tmp1.xy = inp.texcoord2.xy / inp.texcoord2.ww;
                tmp1 = tex2D(_ShadowMapTexture, tmp1.xy);
                tmp0.w = max(tmp1.x, _ShadowBrightness);
                tmp0.w = min(tmp0.w, 1.0);
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = 1.0;
                return o;
			}
#elif defined(DIRECTIONAL) && defined(LIGHTMAP_ON) && !defined(LIGHTMAP_SHADOW_MIXING) && defined(LIGHTPROBE_SH) && defined(SHADOWS_SCREEN) && !defined(SHADOWS_SHADOWMASK) && !defined(VERTEXLIGHT_ON)
			#include "UnityCG.cginc"
#include "AutoLight.cginc"
			struct v2f
			{
 UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 position : SV_POSITION0;
				float3 normal : NORMAL0;
				float3 texcoord : TEXCOORD0;
				float4 texcoord2 : TEXCOORD2;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			// $Globals ConstantBuffers for Fragment Shader
			float _ShadowBrightness;
			float4 _Color;
			float4 _HueShift;
			float _CellShadeTendency;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _RampTex;
			sampler2D _MainTex;
			
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
                tmp0 = tmp0 + float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
                tmp1 = tmp0.yyyy * float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
                tmp1 = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]) * tmp0.xxxx + tmp1;
                tmp1 = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]) * tmp0.zzzz + tmp1;
                tmp0 = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]) * tmp0.wwww + tmp1;
                o.position = tmp0;
                tmp1.x = dot(v.normal.xyz, float3(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0]));
                tmp1.y = dot(v.normal.xyz, float3(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1]));
                tmp1.z = dot(v.normal.xyz, float3(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2]));
                tmp1.w = dot(tmp1.xyz, tmp1.xyz);
                tmp1.w = rsqrt(tmp1.w);
                o.normal.xyz = tmp1.www * tmp1.xyz;
                o.texcoord.xyz = v.texcoord.xyz;
                tmp0.y = tmp0.y * _ProjectionParams.x;
                tmp1.xzw = tmp0.xwy * float3(0.5, 0.5, 0.5);
                o.texcoord2.zw = tmp0.zw;
                o.texcoord2.xy = tmp1.zz + tmp1.xw;
                return o;
			}
			// Keywords: DIRECTIONAL LIGHTPROBE_SH LIGHTMAP_ON SHADOWS_SCREEN
			fout frag(v2f inp)
			{
 UNITY_SETUP_INSTANCE_ID(inp);
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = dot(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp0.xyz = tmp0.xxx * _WorldSpaceLightPos0.xyz;
                tmp0.x = dot(inp.normal.xyz, tmp0.xyz);
                tmp0.x = saturate(tmp0.x + _CellShadeTendency);
                tmp0.y = 0.5;
                tmp0 = tex2D(_RampTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord.xy);
                tmp2.xyz = tmp1.yzx - tmp1.xyz;
                tmp1.xyz = _HueShift.xxx * tmp2.xyz + tmp1.xyz;
                tmp2.xyz = tmp1.yzx - tmp1.xyz;
                tmp1.xyz = _HueShift.yyy * tmp2.xyz + tmp1.xyz;
                tmp2.xyz = tmp1.zyx - tmp1.xyz;
                tmp1.xyz = _HueShift.zzz * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = tmp0.xyz * tmp1.xyz;
                tmp0.xyz = tmp0.xyz * _Color.xyz;
                tmp1.xy = inp.texcoord2.xy / inp.texcoord2.ww;
                tmp1 = tex2D(_ShadowMapTexture, tmp1.xy);
                tmp0.w = max(tmp1.x, _ShadowBrightness);
                tmp0.w = min(tmp0.w, 1.0);
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = 1.0;
                return o;
			}
#elif defined(DIRECTIONAL) && defined(LIGHTMAP_ON) && defined(LIGHTMAP_SHADOW_MIXING) && !defined(LIGHTPROBE_SH) && defined(SHADOWS_SCREEN) && !defined(SHADOWS_SHADOWMASK) && !defined(VERTEXLIGHT_ON)
			#include "UnityCG.cginc"
#include "AutoLight.cginc"
			struct v2f
			{
 UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 position : SV_POSITION0;
				float3 normal : NORMAL0;
				float3 texcoord : TEXCOORD0;
				float4 texcoord2 : TEXCOORD2;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			// $Globals ConstantBuffers for Fragment Shader
			float _ShadowBrightness;
			float4 _Color;
			float4 _HueShift;
			float _CellShadeTendency;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _RampTex;
			sampler2D _MainTex;
			
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
                tmp0 = tmp0 + float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
                tmp1 = tmp0.yyyy * float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
                tmp1 = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]) * tmp0.xxxx + tmp1;
                tmp1 = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]) * tmp0.zzzz + tmp1;
                tmp0 = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]) * tmp0.wwww + tmp1;
                o.position = tmp0;
                tmp1.x = dot(v.normal.xyz, float3(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0]));
                tmp1.y = dot(v.normal.xyz, float3(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1]));
                tmp1.z = dot(v.normal.xyz, float3(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2]));
                tmp1.w = dot(tmp1.xyz, tmp1.xyz);
                tmp1.w = rsqrt(tmp1.w);
                o.normal.xyz = tmp1.www * tmp1.xyz;
                o.texcoord.xyz = v.texcoord.xyz;
                tmp0.y = tmp0.y * _ProjectionParams.x;
                tmp1.xzw = tmp0.xwy * float3(0.5, 0.5, 0.5);
                o.texcoord2.zw = tmp0.zw;
                o.texcoord2.xy = tmp1.zz + tmp1.xw;
                return o;
			}
			// Keywords: DIRECTIONAL LIGHTMAP_ON LIGHTMAP_SHADOW_MIXING SHADOWS_SCREEN
			fout frag(v2f inp)
			{
 UNITY_SETUP_INSTANCE_ID(inp);
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = dot(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp0.xyz = tmp0.xxx * _WorldSpaceLightPos0.xyz;
                tmp0.x = dot(inp.normal.xyz, tmp0.xyz);
                tmp0.x = saturate(tmp0.x + _CellShadeTendency);
                tmp0.y = 0.5;
                tmp0 = tex2D(_RampTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord.xy);
                tmp2.xyz = tmp1.yzx - tmp1.xyz;
                tmp1.xyz = _HueShift.xxx * tmp2.xyz + tmp1.xyz;
                tmp2.xyz = tmp1.yzx - tmp1.xyz;
                tmp1.xyz = _HueShift.yyy * tmp2.xyz + tmp1.xyz;
                tmp2.xyz = tmp1.zyx - tmp1.xyz;
                tmp1.xyz = _HueShift.zzz * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = tmp0.xyz * tmp1.xyz;
                tmp0.xyz = tmp0.xyz * _Color.xyz;
                tmp1.xy = inp.texcoord2.xy / inp.texcoord2.ww;
                tmp1 = tex2D(_ShadowMapTexture, tmp1.xy);
                tmp0.w = max(tmp1.x, _ShadowBrightness);
                tmp0.w = min(tmp0.w, 1.0);
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = 1.0;
                return o;
			}
#elif defined(DIRECTIONAL) && defined(LIGHTMAP_ON) && !defined(LIGHTMAP_SHADOW_MIXING) && !defined(LIGHTPROBE_SH) && defined(SHADOWS_SCREEN) && defined(SHADOWS_SHADOWMASK) && !defined(VERTEXLIGHT_ON)
			#include "UnityCG.cginc"
#include "AutoLight.cginc"
			struct v2f
			{
 UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 position : SV_POSITION0;
				float3 normal : NORMAL0;
				float3 texcoord : TEXCOORD0;
				float4 texcoord2 : TEXCOORD2;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			// $Globals ConstantBuffers for Fragment Shader
			float _ShadowBrightness;
			float4 _Color;
			float4 _HueShift;
			float _CellShadeTendency;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _RampTex;
			sampler2D _MainTex;
			
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
                tmp0 = tmp0 + float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
                tmp1 = tmp0.yyyy * float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
                tmp1 = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]) * tmp0.xxxx + tmp1;
                tmp1 = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]) * tmp0.zzzz + tmp1;
                tmp0 = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]) * tmp0.wwww + tmp1;
                o.position = tmp0;
                tmp1.x = dot(v.normal.xyz, float3(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0]));
                tmp1.y = dot(v.normal.xyz, float3(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1]));
                tmp1.z = dot(v.normal.xyz, float3(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2]));
                tmp1.w = dot(tmp1.xyz, tmp1.xyz);
                tmp1.w = rsqrt(tmp1.w);
                o.normal.xyz = tmp1.www * tmp1.xyz;
                o.texcoord.xyz = v.texcoord.xyz;
                tmp0.y = tmp0.y * _ProjectionParams.x;
                tmp1.xzw = tmp0.xwy * float3(0.5, 0.5, 0.5);
                o.texcoord2.zw = tmp0.zw;
                o.texcoord2.xy = tmp1.zz + tmp1.xw;
                return o;
			}
			// Keywords: DIRECTIONAL SHADOWS_SHADOWMASK LIGHTMAP_ON SHADOWS_SCREEN
			fout frag(v2f inp)
			{
 UNITY_SETUP_INSTANCE_ID(inp);
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = dot(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp0.xyz = tmp0.xxx * _WorldSpaceLightPos0.xyz;
                tmp0.x = dot(inp.normal.xyz, tmp0.xyz);
                tmp0.x = saturate(tmp0.x + _CellShadeTendency);
                tmp0.y = 0.5;
                tmp0 = tex2D(_RampTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord.xy);
                tmp2.xyz = tmp1.yzx - tmp1.xyz;
                tmp1.xyz = _HueShift.xxx * tmp2.xyz + tmp1.xyz;
                tmp2.xyz = tmp1.yzx - tmp1.xyz;
                tmp1.xyz = _HueShift.yyy * tmp2.xyz + tmp1.xyz;
                tmp2.xyz = tmp1.zyx - tmp1.xyz;
                tmp1.xyz = _HueShift.zzz * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = tmp0.xyz * tmp1.xyz;
                tmp0.xyz = tmp0.xyz * _Color.xyz;
                tmp1.xy = inp.texcoord2.xy / inp.texcoord2.ww;
                tmp1 = tex2D(_ShadowMapTexture, tmp1.xy);
                tmp0.w = max(tmp1.x, _ShadowBrightness);
                tmp0.w = min(tmp0.w, 1.0);
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = 1.0;
                return o;
			}
#elif defined(DIRECTIONAL) && !defined(LIGHTMAP_ON) && !defined(LIGHTMAP_SHADOW_MIXING) && defined(LIGHTPROBE_SH) && defined(SHADOWS_SCREEN) && !defined(SHADOWS_SHADOWMASK) && defined(VERTEXLIGHT_ON)
			#include "UnityCG.cginc"
#include "AutoLight.cginc"
			struct v2f
			{
 UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 position : SV_POSITION0;
				float3 normal : NORMAL0;
				float3 texcoord : TEXCOORD0;
				float4 texcoord2 : TEXCOORD2;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			// $Globals ConstantBuffers for Fragment Shader
			float _ShadowBrightness;
			float4 _Color;
			float4 _HueShift;
			float _CellShadeTendency;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _RampTex;
			sampler2D _MainTex;
			
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
                tmp0 = tmp0 + float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
                tmp1 = tmp0.yyyy * float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
                tmp1 = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]) * tmp0.xxxx + tmp1;
                tmp1 = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]) * tmp0.zzzz + tmp1;
                tmp0 = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]) * tmp0.wwww + tmp1;
                o.position = tmp0;
                tmp1.x = dot(v.normal.xyz, float3(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0]));
                tmp1.y = dot(v.normal.xyz, float3(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1]));
                tmp1.z = dot(v.normal.xyz, float3(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2]));
                tmp1.w = dot(tmp1.xyz, tmp1.xyz);
                tmp1.w = rsqrt(tmp1.w);
                o.normal.xyz = tmp1.www * tmp1.xyz;
                o.texcoord.xyz = v.texcoord.xyz;
                tmp0.y = tmp0.y * _ProjectionParams.x;
                tmp1.xzw = tmp0.xwy * float3(0.5, 0.5, 0.5);
                o.texcoord2.zw = tmp0.zw;
                o.texcoord2.xy = tmp1.zz + tmp1.xw;
                return o;
			}
			// Keywords: DIRECTIONAL LIGHTPROBE_SH SHADOWS_SCREEN
			fout frag(v2f inp)
			{
 UNITY_SETUP_INSTANCE_ID(inp);
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = dot(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp0.xyz = tmp0.xxx * _WorldSpaceLightPos0.xyz;
                tmp0.x = dot(inp.normal.xyz, tmp0.xyz);
                tmp0.x = saturate(tmp0.x + _CellShadeTendency);
                tmp0.y = 0.5;
                tmp0 = tex2D(_RampTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord.xy);
                tmp2.xyz = tmp1.yzx - tmp1.xyz;
                tmp1.xyz = _HueShift.xxx * tmp2.xyz + tmp1.xyz;
                tmp2.xyz = tmp1.yzx - tmp1.xyz;
                tmp1.xyz = _HueShift.yyy * tmp2.xyz + tmp1.xyz;
                tmp2.xyz = tmp1.zyx - tmp1.xyz;
                tmp1.xyz = _HueShift.zzz * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = tmp0.xyz * tmp1.xyz;
                tmp0.xyz = tmp0.xyz * _Color.xyz;
                tmp1.xy = inp.texcoord2.xy / inp.texcoord2.ww;
                tmp1 = tex2D(_ShadowMapTexture, tmp1.xy);
                tmp0.w = max(tmp1.x, _ShadowBrightness);
                tmp0.w = min(tmp0.w, 1.0);
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = 1.0;
                return o;
			}
#elif defined(DIRECTIONAL) && !defined(LIGHTMAP_ON) && defined(LIGHTMAP_SHADOW_MIXING) && !defined(LIGHTPROBE_SH) && defined(SHADOWS_SCREEN) && !defined(SHADOWS_SHADOWMASK) && defined(VERTEXLIGHT_ON)
			#include "UnityCG.cginc"
#include "AutoLight.cginc"
			struct v2f
			{
 UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 position : SV_POSITION0;
				float3 normal : NORMAL0;
				float3 texcoord : TEXCOORD0;
				float4 texcoord2 : TEXCOORD2;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			// $Globals ConstantBuffers for Fragment Shader
			float _ShadowBrightness;
			float4 _Color;
			float4 _HueShift;
			float _CellShadeTendency;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _RampTex;
			sampler2D _MainTex;
			
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
                tmp0 = tmp0 + float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
                tmp1 = tmp0.yyyy * float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
                tmp1 = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]) * tmp0.xxxx + tmp1;
                tmp1 = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]) * tmp0.zzzz + tmp1;
                tmp0 = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]) * tmp0.wwww + tmp1;
                o.position = tmp0;
                tmp1.x = dot(v.normal.xyz, float3(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0]));
                tmp1.y = dot(v.normal.xyz, float3(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1]));
                tmp1.z = dot(v.normal.xyz, float3(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2]));
                tmp1.w = dot(tmp1.xyz, tmp1.xyz);
                tmp1.w = rsqrt(tmp1.w);
                o.normal.xyz = tmp1.www * tmp1.xyz;
                o.texcoord.xyz = v.texcoord.xyz;
                tmp0.y = tmp0.y * _ProjectionParams.x;
                tmp1.xzw = tmp0.xwy * float3(0.5, 0.5, 0.5);
                o.texcoord2.zw = tmp0.zw;
                o.texcoord2.xy = tmp1.zz + tmp1.xw;
                return o;
			}
			// Keywords: DIRECTIONAL SHADOWS_SCREEN
			fout frag(v2f inp)
			{
 UNITY_SETUP_INSTANCE_ID(inp);
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = dot(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp0.xyz = tmp0.xxx * _WorldSpaceLightPos0.xyz;
                tmp0.x = dot(inp.normal.xyz, tmp0.xyz);
                tmp0.x = saturate(tmp0.x + _CellShadeTendency);
                tmp0.y = 0.5;
                tmp0 = tex2D(_RampTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord.xy);
                tmp2.xyz = tmp1.yzx - tmp1.xyz;
                tmp1.xyz = _HueShift.xxx * tmp2.xyz + tmp1.xyz;
                tmp2.xyz = tmp1.yzx - tmp1.xyz;
                tmp1.xyz = _HueShift.yyy * tmp2.xyz + tmp1.xyz;
                tmp2.xyz = tmp1.zyx - tmp1.xyz;
                tmp1.xyz = _HueShift.zzz * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = tmp0.xyz * tmp1.xyz;
                tmp0.xyz = tmp0.xyz * _Color.xyz;
                tmp1.xy = inp.texcoord2.xy / inp.texcoord2.ww;
                tmp1 = tex2D(_ShadowMapTexture, tmp1.xy);
                tmp0.w = max(tmp1.x, _ShadowBrightness);
                tmp0.w = min(tmp0.w, 1.0);
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = 1.0;
                return o;
			}
#elif defined(DIRECTIONAL) && !defined(LIGHTMAP_ON) && !defined(LIGHTMAP_SHADOW_MIXING) && !defined(LIGHTPROBE_SH) && defined(SHADOWS_SCREEN) && defined(SHADOWS_SHADOWMASK) && defined(VERTEXLIGHT_ON)
			#include "UnityCG.cginc"
#include "AutoLight.cginc"
			struct v2f
			{
 UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 position : SV_POSITION0;
				float3 normal : NORMAL0;
				float3 texcoord : TEXCOORD0;
				float4 texcoord2 : TEXCOORD2;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			// $Globals ConstantBuffers for Fragment Shader
			float _ShadowBrightness;
			float4 _Color;
			float4 _HueShift;
			float _CellShadeTendency;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _RampTex;
			sampler2D _MainTex;
			
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
                tmp0 = tmp0 + float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
                tmp1 = tmp0.yyyy * float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
                tmp1 = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]) * tmp0.xxxx + tmp1;
                tmp1 = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]) * tmp0.zzzz + tmp1;
                tmp0 = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]) * tmp0.wwww + tmp1;
                o.position = tmp0;
                tmp1.x = dot(v.normal.xyz, float3(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0]));
                tmp1.y = dot(v.normal.xyz, float3(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1]));
                tmp1.z = dot(v.normal.xyz, float3(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2]));
                tmp1.w = dot(tmp1.xyz, tmp1.xyz);
                tmp1.w = rsqrt(tmp1.w);
                o.normal.xyz = tmp1.www * tmp1.xyz;
                o.texcoord.xyz = v.texcoord.xyz;
                tmp0.y = tmp0.y * _ProjectionParams.x;
                tmp1.xzw = tmp0.xwy * float3(0.5, 0.5, 0.5);
                o.texcoord2.zw = tmp0.zw;
                o.texcoord2.xy = tmp1.zz + tmp1.xw;
                return o;
			}
			// Keywords: DIRECTIONAL SHADOWS_SCREEN
			fout frag(v2f inp)
			{
 UNITY_SETUP_INSTANCE_ID(inp);
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = dot(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp0.xyz = tmp0.xxx * _WorldSpaceLightPos0.xyz;
                tmp0.x = dot(inp.normal.xyz, tmp0.xyz);
                tmp0.x = saturate(tmp0.x + _CellShadeTendency);
                tmp0.y = 0.5;
                tmp0 = tex2D(_RampTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord.xy);
                tmp2.xyz = tmp1.yzx - tmp1.xyz;
                tmp1.xyz = _HueShift.xxx * tmp2.xyz + tmp1.xyz;
                tmp2.xyz = tmp1.yzx - tmp1.xyz;
                tmp1.xyz = _HueShift.yyy * tmp2.xyz + tmp1.xyz;
                tmp2.xyz = tmp1.zyx - tmp1.xyz;
                tmp1.xyz = _HueShift.zzz * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = tmp0.xyz * tmp1.xyz;
                tmp0.xyz = tmp0.xyz * _Color.xyz;
                tmp1.xy = inp.texcoord2.xy / inp.texcoord2.ww;
                tmp1 = tex2D(_ShadowMapTexture, tmp1.xy);
                tmp0.w = max(tmp1.x, _ShadowBrightness);
                tmp0.w = min(tmp0.w, 1.0);
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = 1.0;
                return o;
			}
#elif defined(DIRECTIONAL) && !defined(LIGHTMAP_ON) && !defined(LIGHTMAP_SHADOW_MIXING) && defined(LIGHTPROBE_SH) && !defined(SHADOWS_SCREEN) && defined(SHADOWS_SHADOWMASK) && !defined(VERTEXLIGHT_ON)
			#include "UnityCG.cginc"
#include "AutoLight.cginc"
			struct v2f
			{
 UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 position : SV_POSITION0;
				float3 normal : NORMAL0;
				float3 texcoord : TEXCOORD0;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			// $Globals ConstantBuffers for Fragment Shader
			float4 _Color;
			float4 _HueShift;
			float _CellShadeTendency;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _RampTex;
			sampler2D _MainTex;
			
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
                tmp0 = tmp0 + float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
                tmp1 = tmp0.yyyy * float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
                tmp1 = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]) * tmp0.xxxx + tmp1;
                tmp1 = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]) * tmp0.zzzz + tmp1;
                o.position = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]) * tmp0.wwww + tmp1;
                tmp0.x = dot(v.normal.xyz, float3(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0]));
                tmp0.y = dot(v.normal.xyz, float3(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1]));
                tmp0.z = dot(v.normal.xyz, float3(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2]));
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.normal.xyz = tmp0.www * tmp0.xyz;
                o.texcoord.xyz = v.texcoord.xyz;
                return o;
			}
			// Keywords: DIRECTIONAL LIGHTPROBE_SH SHADOWS_SHADOWMASK
			fout frag(v2f inp)
			{
 UNITY_SETUP_INSTANCE_ID(inp);
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = dot(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp0.xyz = tmp0.xxx * _WorldSpaceLightPos0.xyz;
                tmp0.x = dot(inp.normal.xyz, tmp0.xyz);
                tmp0.x = saturate(tmp0.x + _CellShadeTendency);
                tmp0.y = 0.5;
                tmp0 = tex2D(_RampTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord.xy);
                tmp2.xyz = tmp1.yzx - tmp1.xyz;
                tmp1.xyz = _HueShift.xxx * tmp2.xyz + tmp1.xyz;
                tmp2.xyz = tmp1.yzx - tmp1.xyz;
                tmp1.xyz = _HueShift.yyy * tmp2.xyz + tmp1.xyz;
                tmp2.xyz = tmp1.zyx - tmp1.xyz;
                tmp1.xyz = _HueShift.zzz * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = tmp0.xyz * tmp1.xyz;
                o.sv_target.xyz = tmp0.xyz * _Color.xyz;
                o.sv_target.w = 1.0;
                return o;
			}
#elif defined(DIRECTIONAL) && defined(LIGHTMAP_ON) && !defined(LIGHTMAP_SHADOW_MIXING) && defined(LIGHTPROBE_SH) && !defined(SHADOWS_SCREEN) && !defined(SHADOWS_SHADOWMASK) && !defined(VERTEXLIGHT_ON)
			#include "UnityCG.cginc"
#include "AutoLight.cginc"
			struct v2f
			{
 UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 position : SV_POSITION0;
				float3 normal : NORMAL0;
				float3 texcoord : TEXCOORD0;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			// $Globals ConstantBuffers for Fragment Shader
			float4 _Color;
			float4 _HueShift;
			float _CellShadeTendency;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _RampTex;
			sampler2D _MainTex;
			
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
                tmp0 = tmp0 + float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
                tmp1 = tmp0.yyyy * float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
                tmp1 = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]) * tmp0.xxxx + tmp1;
                tmp1 = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]) * tmp0.zzzz + tmp1;
                o.position = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]) * tmp0.wwww + tmp1;
                tmp0.x = dot(v.normal.xyz, float3(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0]));
                tmp0.y = dot(v.normal.xyz, float3(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1]));
                tmp0.z = dot(v.normal.xyz, float3(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2]));
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.normal.xyz = tmp0.www * tmp0.xyz;
                o.texcoord.xyz = v.texcoord.xyz;
                return o;
			}
			// Keywords: DIRECTIONAL LIGHTPROBE_SH LIGHTMAP_ON
			fout frag(v2f inp)
			{
 UNITY_SETUP_INSTANCE_ID(inp);
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = dot(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp0.xyz = tmp0.xxx * _WorldSpaceLightPos0.xyz;
                tmp0.x = dot(inp.normal.xyz, tmp0.xyz);
                tmp0.x = saturate(tmp0.x + _CellShadeTendency);
                tmp0.y = 0.5;
                tmp0 = tex2D(_RampTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord.xy);
                tmp2.xyz = tmp1.yzx - tmp1.xyz;
                tmp1.xyz = _HueShift.xxx * tmp2.xyz + tmp1.xyz;
                tmp2.xyz = tmp1.yzx - tmp1.xyz;
                tmp1.xyz = _HueShift.yyy * tmp2.xyz + tmp1.xyz;
                tmp2.xyz = tmp1.zyx - tmp1.xyz;
                tmp1.xyz = _HueShift.zzz * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = tmp0.xyz * tmp1.xyz;
                o.sv_target.xyz = tmp0.xyz * _Color.xyz;
                o.sv_target.w = 1.0;
                return o;
			}
#elif defined(DIRECTIONAL) && defined(LIGHTMAP_ON) && defined(LIGHTMAP_SHADOW_MIXING) && !defined(LIGHTPROBE_SH) && !defined(SHADOWS_SCREEN) && !defined(SHADOWS_SHADOWMASK) && !defined(VERTEXLIGHT_ON)
			#include "UnityCG.cginc"
#include "AutoLight.cginc"
			struct v2f
			{
 UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 position : SV_POSITION0;
				float3 normal : NORMAL0;
				float3 texcoord : TEXCOORD0;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			// $Globals ConstantBuffers for Fragment Shader
			float4 _Color;
			float4 _HueShift;
			float _CellShadeTendency;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _RampTex;
			sampler2D _MainTex;
			
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
                tmp0 = tmp0 + float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
                tmp1 = tmp0.yyyy * float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
                tmp1 = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]) * tmp0.xxxx + tmp1;
                tmp1 = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]) * tmp0.zzzz + tmp1;
                o.position = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]) * tmp0.wwww + tmp1;
                tmp0.x = dot(v.normal.xyz, float3(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0]));
                tmp0.y = dot(v.normal.xyz, float3(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1]));
                tmp0.z = dot(v.normal.xyz, float3(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2]));
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.normal.xyz = tmp0.www * tmp0.xyz;
                o.texcoord.xyz = v.texcoord.xyz;
                return o;
			}
			// Keywords: DIRECTIONAL LIGHTMAP_ON LIGHTMAP_SHADOW_MIXING
			fout frag(v2f inp)
			{
 UNITY_SETUP_INSTANCE_ID(inp);
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = dot(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp0.xyz = tmp0.xxx * _WorldSpaceLightPos0.xyz;
                tmp0.x = dot(inp.normal.xyz, tmp0.xyz);
                tmp0.x = saturate(tmp0.x + _CellShadeTendency);
                tmp0.y = 0.5;
                tmp0 = tex2D(_RampTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord.xy);
                tmp2.xyz = tmp1.yzx - tmp1.xyz;
                tmp1.xyz = _HueShift.xxx * tmp2.xyz + tmp1.xyz;
                tmp2.xyz = tmp1.yzx - tmp1.xyz;
                tmp1.xyz = _HueShift.yyy * tmp2.xyz + tmp1.xyz;
                tmp2.xyz = tmp1.zyx - tmp1.xyz;
                tmp1.xyz = _HueShift.zzz * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = tmp0.xyz * tmp1.xyz;
                o.sv_target.xyz = tmp0.xyz * _Color.xyz;
                o.sv_target.w = 1.0;
                return o;
			}
#elif defined(DIRECTIONAL) && defined(LIGHTMAP_ON) && !defined(LIGHTMAP_SHADOW_MIXING) && !defined(LIGHTPROBE_SH) && !defined(SHADOWS_SCREEN) && defined(SHADOWS_SHADOWMASK) && !defined(VERTEXLIGHT_ON)
			#include "UnityCG.cginc"
#include "AutoLight.cginc"
			struct v2f
			{
 UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 position : SV_POSITION0;
				float3 normal : NORMAL0;
				float3 texcoord : TEXCOORD0;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			// $Globals ConstantBuffers for Fragment Shader
			float4 _Color;
			float4 _HueShift;
			float _CellShadeTendency;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _RampTex;
			sampler2D _MainTex;
			
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
                tmp0 = tmp0 + float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
                tmp1 = tmp0.yyyy * float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
                tmp1 = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]) * tmp0.xxxx + tmp1;
                tmp1 = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]) * tmp0.zzzz + tmp1;
                o.position = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]) * tmp0.wwww + tmp1;
                tmp0.x = dot(v.normal.xyz, float3(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0]));
                tmp0.y = dot(v.normal.xyz, float3(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1]));
                tmp0.z = dot(v.normal.xyz, float3(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2]));
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.normal.xyz = tmp0.www * tmp0.xyz;
                o.texcoord.xyz = v.texcoord.xyz;
                return o;
			}
			// Keywords: DIRECTIONAL SHADOWS_SHADOWMASK LIGHTMAP_ON
			fout frag(v2f inp)
			{
 UNITY_SETUP_INSTANCE_ID(inp);
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = dot(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp0.xyz = tmp0.xxx * _WorldSpaceLightPos0.xyz;
                tmp0.x = dot(inp.normal.xyz, tmp0.xyz);
                tmp0.x = saturate(tmp0.x + _CellShadeTendency);
                tmp0.y = 0.5;
                tmp0 = tex2D(_RampTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord.xy);
                tmp2.xyz = tmp1.yzx - tmp1.xyz;
                tmp1.xyz = _HueShift.xxx * tmp2.xyz + tmp1.xyz;
                tmp2.xyz = tmp1.yzx - tmp1.xyz;
                tmp1.xyz = _HueShift.yyy * tmp2.xyz + tmp1.xyz;
                tmp2.xyz = tmp1.zyx - tmp1.xyz;
                tmp1.xyz = _HueShift.zzz * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = tmp0.xyz * tmp1.xyz;
                o.sv_target.xyz = tmp0.xyz * _Color.xyz;
                o.sv_target.w = 1.0;
                return o;
			}
#elif defined(DIRECTIONAL) && !defined(LIGHTMAP_ON) && !defined(LIGHTMAP_SHADOW_MIXING) && defined(LIGHTPROBE_SH) && defined(SHADOWS_SCREEN) && !defined(SHADOWS_SHADOWMASK) && !defined(VERTEXLIGHT_ON)
			#include "UnityCG.cginc"
#include "AutoLight.cginc"
			struct v2f
			{
 UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 position : SV_POSITION0;
				float3 normal : NORMAL0;
				float3 texcoord : TEXCOORD0;
				float4 texcoord2 : TEXCOORD2;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			// $Globals ConstantBuffers for Fragment Shader
			float _ShadowBrightness;
			float4 _Color;
			float4 _HueShift;
			float _CellShadeTendency;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _RampTex;
			sampler2D _MainTex;
			
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
                tmp0 = tmp0 + float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
                tmp1 = tmp0.yyyy * float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
                tmp1 = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]) * tmp0.xxxx + tmp1;
                tmp1 = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]) * tmp0.zzzz + tmp1;
                tmp0 = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]) * tmp0.wwww + tmp1;
                o.position = tmp0;
                tmp1.x = dot(v.normal.xyz, float3(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0]));
                tmp1.y = dot(v.normal.xyz, float3(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1]));
                tmp1.z = dot(v.normal.xyz, float3(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2]));
                tmp1.w = dot(tmp1.xyz, tmp1.xyz);
                tmp1.w = rsqrt(tmp1.w);
                o.normal.xyz = tmp1.www * tmp1.xyz;
                o.texcoord.xyz = v.texcoord.xyz;
                tmp0.y = tmp0.y * _ProjectionParams.x;
                tmp1.xzw = tmp0.xwy * float3(0.5, 0.5, 0.5);
                o.texcoord2.zw = tmp0.zw;
                o.texcoord2.xy = tmp1.zz + tmp1.xw;
                return o;
			}
			// Keywords: DIRECTIONAL LIGHTPROBE_SH SHADOWS_SCREEN
			fout frag(v2f inp)
			{
 UNITY_SETUP_INSTANCE_ID(inp);
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = dot(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp0.xyz = tmp0.xxx * _WorldSpaceLightPos0.xyz;
                tmp0.x = dot(inp.normal.xyz, tmp0.xyz);
                tmp0.x = saturate(tmp0.x + _CellShadeTendency);
                tmp0.y = 0.5;
                tmp0 = tex2D(_RampTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord.xy);
                tmp2.xyz = tmp1.yzx - tmp1.xyz;
                tmp1.xyz = _HueShift.xxx * tmp2.xyz + tmp1.xyz;
                tmp2.xyz = tmp1.yzx - tmp1.xyz;
                tmp1.xyz = _HueShift.yyy * tmp2.xyz + tmp1.xyz;
                tmp2.xyz = tmp1.zyx - tmp1.xyz;
                tmp1.xyz = _HueShift.zzz * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = tmp0.xyz * tmp1.xyz;
                tmp0.xyz = tmp0.xyz * _Color.xyz;
                tmp1.xy = inp.texcoord2.xy / inp.texcoord2.ww;
                tmp1 = tex2D(_ShadowMapTexture, tmp1.xy);
                tmp0.w = max(tmp1.x, _ShadowBrightness);
                tmp0.w = min(tmp0.w, 1.0);
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = 1.0;
                return o;
			}
#elif defined(DIRECTIONAL) && defined(LIGHTMAP_ON) && !defined(LIGHTMAP_SHADOW_MIXING) && !defined(LIGHTPROBE_SH) && defined(SHADOWS_SCREEN) && !defined(SHADOWS_SHADOWMASK) && !defined(VERTEXLIGHT_ON)
			#include "UnityCG.cginc"
#include "AutoLight.cginc"
			struct v2f
			{
 UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 position : SV_POSITION0;
				float3 normal : NORMAL0;
				float3 texcoord : TEXCOORD0;
				float4 texcoord2 : TEXCOORD2;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			// $Globals ConstantBuffers for Fragment Shader
			float _ShadowBrightness;
			float4 _Color;
			float4 _HueShift;
			float _CellShadeTendency;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _RampTex;
			sampler2D _MainTex;
			
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
                tmp0 = tmp0 + float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
                tmp1 = tmp0.yyyy * float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
                tmp1 = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]) * tmp0.xxxx + tmp1;
                tmp1 = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]) * tmp0.zzzz + tmp1;
                tmp0 = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]) * tmp0.wwww + tmp1;
                o.position = tmp0;
                tmp1.x = dot(v.normal.xyz, float3(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0]));
                tmp1.y = dot(v.normal.xyz, float3(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1]));
                tmp1.z = dot(v.normal.xyz, float3(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2]));
                tmp1.w = dot(tmp1.xyz, tmp1.xyz);
                tmp1.w = rsqrt(tmp1.w);
                o.normal.xyz = tmp1.www * tmp1.xyz;
                o.texcoord.xyz = v.texcoord.xyz;
                tmp0.y = tmp0.y * _ProjectionParams.x;
                tmp1.xzw = tmp0.xwy * float3(0.5, 0.5, 0.5);
                o.texcoord2.zw = tmp0.zw;
                o.texcoord2.xy = tmp1.zz + tmp1.xw;
                return o;
			}
			// Keywords: DIRECTIONAL LIGHTMAP_ON SHADOWS_SCREEN
			fout frag(v2f inp)
			{
 UNITY_SETUP_INSTANCE_ID(inp);
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = dot(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp0.xyz = tmp0.xxx * _WorldSpaceLightPos0.xyz;
                tmp0.x = dot(inp.normal.xyz, tmp0.xyz);
                tmp0.x = saturate(tmp0.x + _CellShadeTendency);
                tmp0.y = 0.5;
                tmp0 = tex2D(_RampTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord.xy);
                tmp2.xyz = tmp1.yzx - tmp1.xyz;
                tmp1.xyz = _HueShift.xxx * tmp2.xyz + tmp1.xyz;
                tmp2.xyz = tmp1.yzx - tmp1.xyz;
                tmp1.xyz = _HueShift.yyy * tmp2.xyz + tmp1.xyz;
                tmp2.xyz = tmp1.zyx - tmp1.xyz;
                tmp1.xyz = _HueShift.zzz * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = tmp0.xyz * tmp1.xyz;
                tmp0.xyz = tmp0.xyz * _Color.xyz;
                tmp1.xy = inp.texcoord2.xy / inp.texcoord2.ww;
                tmp1 = tex2D(_ShadowMapTexture, tmp1.xy);
                tmp0.w = max(tmp1.x, _ShadowBrightness);
                tmp0.w = min(tmp0.w, 1.0);
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = 1.0;
                return o;
			}
#elif defined(DIRECTIONAL) && !defined(LIGHTMAP_ON) && !defined(LIGHTMAP_SHADOW_MIXING) && defined(LIGHTPROBE_SH) && !defined(SHADOWS_SCREEN) && !defined(SHADOWS_SHADOWMASK) && defined(VERTEXLIGHT_ON)
			#include "UnityCG.cginc"
#include "AutoLight.cginc"
			struct v2f
			{
 UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 position : SV_POSITION0;
				float3 normal : NORMAL0;
				float3 texcoord : TEXCOORD0;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			// $Globals ConstantBuffers for Fragment Shader
			float4 _Color;
			float4 _HueShift;
			float _CellShadeTendency;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _RampTex;
			sampler2D _MainTex;
			
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
                tmp0 = tmp0 + float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
                tmp1 = tmp0.yyyy * float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
                tmp1 = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]) * tmp0.xxxx + tmp1;
                tmp1 = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]) * tmp0.zzzz + tmp1;
                o.position = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]) * tmp0.wwww + tmp1;
                tmp0.x = dot(v.normal.xyz, float3(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0]));
                tmp0.y = dot(v.normal.xyz, float3(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1]));
                tmp0.z = dot(v.normal.xyz, float3(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2]));
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.normal.xyz = tmp0.www * tmp0.xyz;
                o.texcoord.xyz = v.texcoord.xyz;
                return o;
			}
			// Keywords: DIRECTIONAL LIGHTPROBE_SH
			fout frag(v2f inp)
			{
 UNITY_SETUP_INSTANCE_ID(inp);
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = dot(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp0.xyz = tmp0.xxx * _WorldSpaceLightPos0.xyz;
                tmp0.x = dot(inp.normal.xyz, tmp0.xyz);
                tmp0.x = saturate(tmp0.x + _CellShadeTendency);
                tmp0.y = 0.5;
                tmp0 = tex2D(_RampTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord.xy);
                tmp2.xyz = tmp1.yzx - tmp1.xyz;
                tmp1.xyz = _HueShift.xxx * tmp2.xyz + tmp1.xyz;
                tmp2.xyz = tmp1.yzx - tmp1.xyz;
                tmp1.xyz = _HueShift.yyy * tmp2.xyz + tmp1.xyz;
                tmp2.xyz = tmp1.zyx - tmp1.xyz;
                tmp1.xyz = _HueShift.zzz * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = tmp0.xyz * tmp1.xyz;
                o.sv_target.xyz = tmp0.xyz * _Color.xyz;
                o.sv_target.w = 1.0;
                return o;
			}
#elif defined(DIRECTIONAL) && !defined(LIGHTMAP_ON) && !defined(LIGHTMAP_SHADOW_MIXING) && !defined(LIGHTPROBE_SH) && defined(SHADOWS_SCREEN) && !defined(SHADOWS_SHADOWMASK) && defined(VERTEXLIGHT_ON)
			#include "UnityCG.cginc"
#include "AutoLight.cginc"
			struct v2f
			{
 UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 position : SV_POSITION0;
				float3 normal : NORMAL0;
				float3 texcoord : TEXCOORD0;
				float4 texcoord2 : TEXCOORD2;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			// $Globals ConstantBuffers for Fragment Shader
			float _ShadowBrightness;
			float4 _Color;
			float4 _HueShift;
			float _CellShadeTendency;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _RampTex;
			sampler2D _MainTex;
			
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
                tmp0 = tmp0 + float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
                tmp1 = tmp0.yyyy * float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
                tmp1 = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]) * tmp0.xxxx + tmp1;
                tmp1 = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]) * tmp0.zzzz + tmp1;
                tmp0 = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]) * tmp0.wwww + tmp1;
                o.position = tmp0;
                tmp1.x = dot(v.normal.xyz, float3(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0]));
                tmp1.y = dot(v.normal.xyz, float3(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1]));
                tmp1.z = dot(v.normal.xyz, float3(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2]));
                tmp1.w = dot(tmp1.xyz, tmp1.xyz);
                tmp1.w = rsqrt(tmp1.w);
                o.normal.xyz = tmp1.www * tmp1.xyz;
                o.texcoord.xyz = v.texcoord.xyz;
                tmp0.y = tmp0.y * _ProjectionParams.x;
                tmp1.xzw = tmp0.xwy * float3(0.5, 0.5, 0.5);
                o.texcoord2.zw = tmp0.zw;
                o.texcoord2.xy = tmp1.zz + tmp1.xw;
                return o;
			}
			// Keywords: DIRECTIONAL SHADOWS_SCREEN
			fout frag(v2f inp)
			{
 UNITY_SETUP_INSTANCE_ID(inp);
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = dot(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp0.xyz = tmp0.xxx * _WorldSpaceLightPos0.xyz;
                tmp0.x = dot(inp.normal.xyz, tmp0.xyz);
                tmp0.x = saturate(tmp0.x + _CellShadeTendency);
                tmp0.y = 0.5;
                tmp0 = tex2D(_RampTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord.xy);
                tmp2.xyz = tmp1.yzx - tmp1.xyz;
                tmp1.xyz = _HueShift.xxx * tmp2.xyz + tmp1.xyz;
                tmp2.xyz = tmp1.yzx - tmp1.xyz;
                tmp1.xyz = _HueShift.yyy * tmp2.xyz + tmp1.xyz;
                tmp2.xyz = tmp1.zyx - tmp1.xyz;
                tmp1.xyz = _HueShift.zzz * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = tmp0.xyz * tmp1.xyz;
                tmp0.xyz = tmp0.xyz * _Color.xyz;
                tmp1.xy = inp.texcoord2.xy / inp.texcoord2.ww;
                tmp1 = tex2D(_ShadowMapTexture, tmp1.xy);
                tmp0.w = max(tmp1.x, _ShadowBrightness);
                tmp0.w = min(tmp0.w, 1.0);
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = 1.0;
                return o;
			}
#elif defined(DIRECTIONAL) && !defined(LIGHTMAP_ON) && !defined(LIGHTMAP_SHADOW_MIXING) && defined(LIGHTPROBE_SH) && !defined(SHADOWS_SCREEN) && !defined(SHADOWS_SHADOWMASK) && !defined(VERTEXLIGHT_ON)
			#include "UnityCG.cginc"
#include "AutoLight.cginc"
			struct v2f
			{
 UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 position : SV_POSITION0;
				float3 normal : NORMAL0;
				float3 texcoord : TEXCOORD0;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			// $Globals ConstantBuffers for Fragment Shader
			float4 _Color;
			float4 _HueShift;
			float _CellShadeTendency;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _RampTex;
			sampler2D _MainTex;
			
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
                tmp0 = tmp0 + float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
                tmp1 = tmp0.yyyy * float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
                tmp1 = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]) * tmp0.xxxx + tmp1;
                tmp1 = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]) * tmp0.zzzz + tmp1;
                o.position = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]) * tmp0.wwww + tmp1;
                tmp0.x = dot(v.normal.xyz, float3(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0]));
                tmp0.y = dot(v.normal.xyz, float3(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1]));
                tmp0.z = dot(v.normal.xyz, float3(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2]));
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.normal.xyz = tmp0.www * tmp0.xyz;
                o.texcoord.xyz = v.texcoord.xyz;
                return o;
			}
			// Keywords: DIRECTIONAL LIGHTPROBE_SH
			fout frag(v2f inp)
			{
 UNITY_SETUP_INSTANCE_ID(inp);
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = dot(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp0.xyz = tmp0.xxx * _WorldSpaceLightPos0.xyz;
                tmp0.x = dot(inp.normal.xyz, tmp0.xyz);
                tmp0.x = saturate(tmp0.x + _CellShadeTendency);
                tmp0.y = 0.5;
                tmp0 = tex2D(_RampTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord.xy);
                tmp2.xyz = tmp1.yzx - tmp1.xyz;
                tmp1.xyz = _HueShift.xxx * tmp2.xyz + tmp1.xyz;
                tmp2.xyz = tmp1.yzx - tmp1.xyz;
                tmp1.xyz = _HueShift.yyy * tmp2.xyz + tmp1.xyz;
                tmp2.xyz = tmp1.zyx - tmp1.xyz;
                tmp1.xyz = _HueShift.zzz * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = tmp0.xyz * tmp1.xyz;
                o.sv_target.xyz = tmp0.xyz * _Color.xyz;
                o.sv_target.w = 1.0;
                return o;
			}
#elif defined(DIRECTIONAL) && defined(LIGHTMAP_ON) && !defined(LIGHTMAP_SHADOW_MIXING) && !defined(LIGHTPROBE_SH) && !defined(SHADOWS_SCREEN) && !defined(SHADOWS_SHADOWMASK) && !defined(VERTEXLIGHT_ON)
			#include "UnityCG.cginc"
#include "AutoLight.cginc"
			struct v2f
			{
 UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 position : SV_POSITION0;
				float3 normal : NORMAL0;
				float3 texcoord : TEXCOORD0;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			// $Globals ConstantBuffers for Fragment Shader
			float4 _Color;
			float4 _HueShift;
			float _CellShadeTendency;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _RampTex;
			sampler2D _MainTex;
			
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
                tmp0 = tmp0 + float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
                tmp1 = tmp0.yyyy * float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
                tmp1 = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]) * tmp0.xxxx + tmp1;
                tmp1 = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]) * tmp0.zzzz + tmp1;
                o.position = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]) * tmp0.wwww + tmp1;
                tmp0.x = dot(v.normal.xyz, float3(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0]));
                tmp0.y = dot(v.normal.xyz, float3(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1]));
                tmp0.z = dot(v.normal.xyz, float3(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2]));
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.normal.xyz = tmp0.www * tmp0.xyz;
                o.texcoord.xyz = v.texcoord.xyz;
                return o;
			}
			// Keywords: DIRECTIONAL LIGHTMAP_ON
			fout frag(v2f inp)
			{
 UNITY_SETUP_INSTANCE_ID(inp);
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = dot(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp0.xyz = tmp0.xxx * _WorldSpaceLightPos0.xyz;
                tmp0.x = dot(inp.normal.xyz, tmp0.xyz);
                tmp0.x = saturate(tmp0.x + _CellShadeTendency);
                tmp0.y = 0.5;
                tmp0 = tex2D(_RampTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord.xy);
                tmp2.xyz = tmp1.yzx - tmp1.xyz;
                tmp1.xyz = _HueShift.xxx * tmp2.xyz + tmp1.xyz;
                tmp2.xyz = tmp1.yzx - tmp1.xyz;
                tmp1.xyz = _HueShift.yyy * tmp2.xyz + tmp1.xyz;
                tmp2.xyz = tmp1.zyx - tmp1.xyz;
                tmp1.xyz = _HueShift.zzz * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = tmp0.xyz * tmp1.xyz;
                o.sv_target.xyz = tmp0.xyz * _Color.xyz;
                o.sv_target.w = 1.0;
                return o;
			}
#elif defined(DIRECTIONAL) && !defined(LIGHTMAP_ON) && !defined(LIGHTMAP_SHADOW_MIXING) && !defined(LIGHTPROBE_SH) && defined(SHADOWS_SCREEN) && !defined(SHADOWS_SHADOWMASK) && !defined(VERTEXLIGHT_ON)
			#include "UnityCG.cginc"
#include "AutoLight.cginc"
			struct v2f
			{
 UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 position : SV_POSITION0;
				float3 normal : NORMAL0;
				float3 texcoord : TEXCOORD0;
				float4 texcoord2 : TEXCOORD2;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			// $Globals ConstantBuffers for Fragment Shader
			float _ShadowBrightness;
			float4 _Color;
			float4 _HueShift;
			float _CellShadeTendency;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _RampTex;
			sampler2D _MainTex;
			
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
                tmp0 = tmp0 + float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
                tmp1 = tmp0.yyyy * float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
                tmp1 = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]) * tmp0.xxxx + tmp1;
                tmp1 = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]) * tmp0.zzzz + tmp1;
                tmp0 = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]) * tmp0.wwww + tmp1;
                o.position = tmp0;
                tmp1.x = dot(v.normal.xyz, float3(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0]));
                tmp1.y = dot(v.normal.xyz, float3(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1]));
                tmp1.z = dot(v.normal.xyz, float3(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2]));
                tmp1.w = dot(tmp1.xyz, tmp1.xyz);
                tmp1.w = rsqrt(tmp1.w);
                o.normal.xyz = tmp1.www * tmp1.xyz;
                o.texcoord.xyz = v.texcoord.xyz;
                tmp0.y = tmp0.y * _ProjectionParams.x;
                tmp1.xzw = tmp0.xwy * float3(0.5, 0.5, 0.5);
                o.texcoord2.zw = tmp0.zw;
                o.texcoord2.xy = tmp1.zz + tmp1.xw;
                return o;
			}
			// Keywords: DIRECTIONAL SHADOWS_SCREEN
			fout frag(v2f inp)
			{
 UNITY_SETUP_INSTANCE_ID(inp);
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = dot(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp0.xyz = tmp0.xxx * _WorldSpaceLightPos0.xyz;
                tmp0.x = dot(inp.normal.xyz, tmp0.xyz);
                tmp0.x = saturate(tmp0.x + _CellShadeTendency);
                tmp0.y = 0.5;
                tmp0 = tex2D(_RampTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord.xy);
                tmp2.xyz = tmp1.yzx - tmp1.xyz;
                tmp1.xyz = _HueShift.xxx * tmp2.xyz + tmp1.xyz;
                tmp2.xyz = tmp1.yzx - tmp1.xyz;
                tmp1.xyz = _HueShift.yyy * tmp2.xyz + tmp1.xyz;
                tmp2.xyz = tmp1.zyx - tmp1.xyz;
                tmp1.xyz = _HueShift.zzz * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = tmp0.xyz * tmp1.xyz;
                tmp0.xyz = tmp0.xyz * _Color.xyz;
                tmp1.xy = inp.texcoord2.xy / inp.texcoord2.ww;
                tmp1 = tex2D(_ShadowMapTexture, tmp1.xy);
                tmp0.w = max(tmp1.x, _ShadowBrightness);
                tmp0.w = min(tmp0.w, 1.0);
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = 1.0;
                return o;
			}
#elif defined(DIRECTIONAL) && !defined(LIGHTMAP_ON) && !defined(LIGHTMAP_SHADOW_MIXING) && !defined(LIGHTPROBE_SH) && !defined(SHADOWS_SCREEN) && !defined(SHADOWS_SHADOWMASK) && defined(VERTEXLIGHT_ON)
			#include "UnityCG.cginc"
#include "AutoLight.cginc"
			struct v2f
			{
 UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 position : SV_POSITION0;
				float3 normal : NORMAL0;
				float3 texcoord : TEXCOORD0;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			// $Globals ConstantBuffers for Fragment Shader
			float4 _Color;
			float4 _HueShift;
			float _CellShadeTendency;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _RampTex;
			sampler2D _MainTex;
			
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
                tmp0 = tmp0 + float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
                tmp1 = tmp0.yyyy * float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
                tmp1 = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]) * tmp0.xxxx + tmp1;
                tmp1 = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]) * tmp0.zzzz + tmp1;
                o.position = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]) * tmp0.wwww + tmp1;
                tmp0.x = dot(v.normal.xyz, float3(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0]));
                tmp0.y = dot(v.normal.xyz, float3(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1]));
                tmp0.z = dot(v.normal.xyz, float3(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2]));
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.normal.xyz = tmp0.www * tmp0.xyz;
                o.texcoord.xyz = v.texcoord.xyz;
                return o;
			}
			// Keywords: DIRECTIONAL
			fout frag(v2f inp)
			{
 UNITY_SETUP_INSTANCE_ID(inp);
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = dot(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp0.xyz = tmp0.xxx * _WorldSpaceLightPos0.xyz;
                tmp0.x = dot(inp.normal.xyz, tmp0.xyz);
                tmp0.x = saturate(tmp0.x + _CellShadeTendency);
                tmp0.y = 0.5;
                tmp0 = tex2D(_RampTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord.xy);
                tmp2.xyz = tmp1.yzx - tmp1.xyz;
                tmp1.xyz = _HueShift.xxx * tmp2.xyz + tmp1.xyz;
                tmp2.xyz = tmp1.yzx - tmp1.xyz;
                tmp1.xyz = _HueShift.yyy * tmp2.xyz + tmp1.xyz;
                tmp2.xyz = tmp1.zyx - tmp1.xyz;
                tmp1.xyz = _HueShift.zzz * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = tmp0.xyz * tmp1.xyz;
                o.sv_target.xyz = tmp0.xyz * _Color.xyz;
                o.sv_target.w = 1.0;
                return o;
			}
#else
#if !defined(DIRECTIONAL) && !defined(POINT) && !defined(SPOT) && !defined(POINT_COOKIE) && !defined(DIRECTIONAL_COOKIE)
#define DIRECTIONAL 1
#endif
			#include "UnityCG.cginc"
#include "AutoLight.cginc"
			struct v2f
			{
 UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 position : SV_POSITION0;
				float3 normal : NORMAL0;
				float3 texcoord : TEXCOORD0;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			// $Globals ConstantBuffers for Fragment Shader
			float4 _Color;
			float4 _HueShift;
			float _CellShadeTendency;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _RampTex;
			sampler2D _MainTex;
			
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
                tmp0 = tmp0 + float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
                tmp1 = tmp0.yyyy * float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
                tmp1 = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]) * tmp0.xxxx + tmp1;
                tmp1 = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]) * tmp0.zzzz + tmp1;
                o.position = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]) * tmp0.wwww + tmp1;
                tmp0.x = dot(v.normal.xyz, float3(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0]));
                tmp0.y = dot(v.normal.xyz, float3(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1]));
                tmp0.z = dot(v.normal.xyz, float3(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2]));
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.normal.xyz = tmp0.www * tmp0.xyz;
                o.texcoord.xyz = v.texcoord.xyz;
                return o;
			}
			// Keywords: DIRECTIONAL
			fout frag(v2f inp)
			{
 UNITY_SETUP_INSTANCE_ID(inp);
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = dot(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp0.xyz = tmp0.xxx * _WorldSpaceLightPos0.xyz;
                tmp0.x = dot(inp.normal.xyz, tmp0.xyz);
                tmp0.x = saturate(tmp0.x + _CellShadeTendency);
                tmp0.y = 0.5;
                tmp0 = tex2D(_RampTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord.xy);
                tmp2.xyz = tmp1.yzx - tmp1.xyz;
                tmp1.xyz = _HueShift.xxx * tmp2.xyz + tmp1.xyz;
                tmp2.xyz = tmp1.yzx - tmp1.xyz;
                tmp1.xyz = _HueShift.yyy * tmp2.xyz + tmp1.xyz;
                tmp2.xyz = tmp1.zyx - tmp1.xyz;
                tmp1.xyz = _HueShift.zzz * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = tmp0.xyz * tmp1.xyz;
                o.sv_target.xyz = tmp0.xyz * _Color.xyz;
                o.sv_target.w = 1.0;
                return o;
			}
#endif
			ENDCG
		}
		Pass {
			Tags { "LIGHTMODE" = "SHADOWCASTER" "SHADOWSUPPORT" = "true" }

CGPROGRAM
#pragma vertex vert
#pragma fragment frag
#pragma target 3.5
#pragma multi_compile_instancing
#pragma multi_compile __ SHADOWS_CUBE
#pragma multi_compile __ SHADOWS_DEPTH
#if !defined(SHADOWS_CUBE) && defined(SHADOWS_DEPTH)
			#include "UnityCG.cginc"
#include "AutoLight.cginc"
			struct v2f
			{
 UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 position : SV_POSITION0;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			// $Globals ConstantBuffers for Fragment Shader
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			
			// Keywords: SHADOWS_DEPTH
			v2f vert(appdata_full v)
			{
 UNITY_SETUP_INSTANCE_ID(v);
                v2f o;
 UNITY_TRANSFER_INSTANCE_ID(v, o);
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = dot(v.normal.xyz, float3(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0]));
                tmp0.y = dot(v.normal.xyz, float3(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1]));
                tmp0.z = dot(v.normal.xyz, float3(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2]));
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1 = v.vertex.yyyy * float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
                tmp1 = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]) * v.vertex.xxxx + tmp1;
                tmp1 = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]) * v.vertex.zzzz + tmp1;
                tmp1 = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]) * v.vertex.wwww + tmp1;
                tmp2.xyz = -tmp1.xyz * _WorldSpaceLightPos0.www + _WorldSpaceLightPos0.xyz;
                tmp0.w = dot(tmp2.xyz, tmp2.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp2.xyz = tmp0.www * tmp2.xyz;
                tmp0.w = dot(tmp0.xyz, tmp2.xyz);
                tmp0.w = -tmp0.w * tmp0.w + 1.0;
                tmp0.w = sqrt(tmp0.w);
                tmp0.w = tmp0.w * unity_LightShadowBias.z;
                tmp0.xyz = -tmp0.xyz * tmp0.www + tmp1.xyz;
                tmp0.w = unity_LightShadowBias.z != 0.0;
                tmp0.xyz = tmp0.www ? tmp0.xyz : tmp1.xyz;
                tmp2 = tmp0.yyyy * float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
                tmp2 = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]) * tmp0.xxxx + tmp2;
                tmp0 = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]) * tmp0.zzzz + tmp2;
                tmp0 = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]) * tmp1.wwww + tmp0;
                tmp1.x = unity_LightShadowBias.x / tmp0.w;
                tmp1.x = min(tmp1.x, 0.0);
                tmp1.x = max(tmp1.x, -1.0);
                tmp0.z = tmp0.z + tmp1.x;
                tmp1.x = min(tmp0.w, tmp0.z);
                o.position.xyw = tmp0.xyw;
                tmp0.x = tmp1.x - tmp0.z;
                o.position.z = unity_LightShadowBias.y * tmp0.x + tmp0.z;
                return o;
			}
			// Keywords: SHADOWS_DEPTH
			fout frag(v2f inp)
			{
 UNITY_SETUP_INSTANCE_ID(inp);
                fout o;
                o.sv_target = float4(0.0, 0.0, 0.0, 0.0);
                return o;
			}
#else
			#include "UnityCG.cginc"
#include "AutoLight.cginc"
			struct v2f
			{
 UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 position : SV_POSITION0;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			// $Globals ConstantBuffers for Fragment Shader
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			
			// Keywords: SHADOWS_CUBE
			v2f vert(appdata_full v)
			{
 UNITY_SETUP_INSTANCE_ID(v);
                v2f o;
 UNITY_TRANSFER_INSTANCE_ID(v, o);
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = dot(v.normal.xyz, float3(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0]));
                tmp0.y = dot(v.normal.xyz, float3(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1]));
                tmp0.z = dot(v.normal.xyz, float3(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2]));
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1 = v.vertex.yyyy * float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
                tmp1 = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]) * v.vertex.xxxx + tmp1;
                tmp1 = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]) * v.vertex.zzzz + tmp1;
                tmp1 = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]) * v.vertex.wwww + tmp1;
                tmp2.xyz = -tmp1.xyz * _WorldSpaceLightPos0.www + _WorldSpaceLightPos0.xyz;
                tmp0.w = dot(tmp2.xyz, tmp2.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp2.xyz = tmp0.www * tmp2.xyz;
                tmp0.w = dot(tmp0.xyz, tmp2.xyz);
                tmp0.w = -tmp0.w * tmp0.w + 1.0;
                tmp0.w = sqrt(tmp0.w);
                tmp0.w = tmp0.w * unity_LightShadowBias.z;
                tmp0.xyz = -tmp0.xyz * tmp0.www + tmp1.xyz;
                tmp0.w = unity_LightShadowBias.z != 0.0;
                tmp0.xyz = tmp0.www ? tmp0.xyz : tmp1.xyz;
                tmp2 = tmp0.yyyy * float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
                tmp2 = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]) * tmp0.xxxx + tmp2;
                tmp0 = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]) * tmp0.zzzz + tmp2;
                tmp0 = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]) * tmp1.wwww + tmp0;
                tmp1.x = min(tmp0.w, tmp0.z);
                tmp1.x = tmp1.x - tmp0.z;
                o.position.z = unity_LightShadowBias.y * tmp1.x + tmp0.z;
                o.position.xyw = tmp0.xyw;
                return o;
			}
			// Keywords: SHADOWS_CUBE
			fout frag(v2f inp)
			{
 UNITY_SETUP_INSTANCE_ID(inp);
                fout o;
                o.sv_target = float4(0.0, 0.0, 0.0, 0.0);
                return o;
			}
#endif
			ENDCG
		}
		Pass {
			Cull Front

CGPROGRAM
#pragma vertex vert
#pragma fragment frag
#pragma target 3.5
#pragma multi_compile_instancing
#pragma multi_compile __ _MENU_RENDER
#if defined(_MENU_RENDER)
			#include "UnityCG.cginc"
#include "AutoLight.cginc"
			struct v2f
			{
 UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 position : SV_POSITION0;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float _OutlineExtrusion;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _OutlineColor;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			
			// Keywords: _MENU_RENDER
			v2f vert(appdata_full v)
			{
 UNITY_SETUP_INSTANCE_ID(v);
                v2f o;
 UNITY_TRANSFER_INSTANCE_ID(v, o);
                float4 tmp0;
                float4 tmp1;
                tmp0.xyz = _WorldSpaceCameraPos * float3(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1]);
                tmp0.xyz = float3(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0]) * _WorldSpaceCameraPos + tmp0.xyz;
                tmp0.xyz = float3(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2]) * _WorldSpaceCameraPos + tmp0.xyz;
                tmp0.xyz = tmp0.xyz + float3(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3]);
                tmp0.xyz = tmp0.xyz - v.vertex.xyz;
                tmp0.x = dot(tmp0.xyz, tmp0.xyz);
                tmp0.x = sqrt(tmp0.x);
                tmp0.x = tmp0.x < 1.65;
                tmp0.y = _OutlineExtrusion * 0.3;
                tmp0.x = tmp0.x ? tmp0.y : _OutlineExtrusion;
                tmp0.y = dot(v.normal.xyz, v.normal.xyz);
                tmp0.y = rsqrt(tmp0.y);
                tmp0.yzw = tmp0.yyy * v.normal.xyz;
                tmp0.xyz = tmp0.xxx * tmp0.yzw;
                tmp0.xyz = tmp0.xyz * v.color.xxx + v.vertex.xyz;
                tmp1 = tmp0.yyyy * float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
                tmp1 = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]) * tmp0.xxxx + tmp1;
                tmp0 = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]) * tmp0.zzzz + tmp1;
                tmp0 = tmp0 + float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
                tmp1 = tmp0.yyyy * float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
                tmp1 = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]) * tmp0.xxxx + tmp1;
                tmp1 = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]) * tmp0.zzzz + tmp1;
                o.position = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]) * tmp0.wwww + tmp1;
                return o;
			}
			// Keywords: _MENU_RENDER
			fout frag(v2f inp)
			{
 UNITY_SETUP_INSTANCE_ID(inp);
                fout o;
                o.sv_target = _OutlineColor;
                return o;
			}
#else
			#include "UnityCG.cginc"
#include "AutoLight.cginc"
			struct v2f
			{
 UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 position : SV_POSITION0;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float _OutlineExtrusion;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _OutlineColor;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			
			// Keywords: 
			v2f vert(appdata_full v)
			{
 UNITY_SETUP_INSTANCE_ID(v);
                v2f o;
 UNITY_TRANSFER_INSTANCE_ID(v, o);
                float4 tmp0;
                float4 tmp1;
                tmp0.xyz = _WorldSpaceCameraPos * float3(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1]);
                tmp0.xyz = float3(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0]) * _WorldSpaceCameraPos + tmp0.xyz;
                tmp0.xyz = float3(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2]) * _WorldSpaceCameraPos + tmp0.xyz;
                tmp0.xyz = tmp0.xyz + float3(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3]);
                tmp0.xyz = tmp0.xyz - v.vertex.xyz;
                tmp0.x = dot(tmp0.xyz, tmp0.xyz);
                tmp0.x = sqrt(tmp0.x);
                tmp0.x = tmp0.x < 1.65;
                tmp0.y = _OutlineExtrusion * 0.3;
                tmp0.x = tmp0.x ? tmp0.y : _OutlineExtrusion;
                tmp0.y = dot(v.normal.xyz, v.normal.xyz);
                tmp0.y = rsqrt(tmp0.y);
                tmp0.yzw = tmp0.yyy * v.normal.xyz;
                tmp0.xyz = tmp0.xxx * tmp0.yzw;
                tmp0.xyz = tmp0.xyz * v.color.xxx + v.vertex.xyz;
                tmp1 = tmp0.yyyy * float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
                tmp1 = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]) * tmp0.xxxx + tmp1;
                tmp0 = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]) * tmp0.zzzz + tmp1;
                tmp0 = tmp0 + float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
                tmp1 = tmp0.yyyy * float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
                tmp1 = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]) * tmp0.xxxx + tmp1;
                tmp1 = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]) * tmp0.zzzz + tmp1;
                o.position = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]) * tmp0.wwww + tmp1;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
 UNITY_SETUP_INSTANCE_ID(inp);
                fout o;
                o.sv_target = _OutlineColor;
                return o;
			}
#endif
			ENDCG
		}
	}
}