Shader "Reptile/Ambient Environment Glass" {
	Properties {
		_MainTex ("MainTex", 2D) = "white" {}
		_Color ("Color", Color) = (1,1,1,1)
		[NoScaleOffset] _Emission ("Emission", 2D) = "black" {}
		[HideInInspector] _Opacity ("Projected Shadow", Range(0, 1)) = 1
		[HideInInspector] _SelfShadowOpacity ("Self Shadow", Range(0, 1)) = 1
		[HideInInspector] _Tendency ("Tendency", Range(-1, 1)) = -0.2
	}
	SubShader {
		Tags { "LIGHTMODE" = "FORWARDBASE" "QUEUE" = "Transparent+1" "RenderType" = "Transparent" }
		Pass {
			Tags { "LIGHTMODE" = "FORWARDBASE" "QUEUE" = "Transparent+1" "RenderType" = "Transparent" "SHADOWSUPPORT" = "true" }
			Blend SrcAlpha OneMinusSrcAlpha, SrcAlpha OneMinusSrcAlpha
			ZWrite Off

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
				float2 texcoord : TEXCOORD0;
				float2 texcoord1 : TEXCOORD1;
				float3 texcoord2 : TEXCOORD2;
				float3 texcoord3 : TEXCOORD3;
				float3 texcoord4 : TEXCOORD4;
				float4 texcoord6 : TEXCOORD6;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 _Color;
			float4 ShadowColor;
			float4 LightColor;
			float _Opacity;
			float _Tendency;
			float _SelfShadowOpacity;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			sampler2D _Emission;
			
			// Keywords: DIRECTIONAL LIGHTPROBE_SH SHADOWS_SHADOWMASK LIGHTMAP_ON LIGHTMAP_SHADOW_MIXING SHADOWS_SCREEN
			v2f vert(appdata_full v)
			{
 UNITY_SETUP_INSTANCE_ID(v);
                v2f o;
 UNITY_TRANSFER_INSTANCE_ID(v, o);
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0 = v.vertex.yyyy * float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
                tmp0 = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]) * v.vertex.xxxx + tmp0;
                tmp0 = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]) * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
                tmp0.xyz = float3(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3]) * v.vertex.www + tmp0.xyz;
                tmp2 = tmp1.yyyy * float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
                tmp2 = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]) * tmp1.xxxx + tmp2;
                tmp2 = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]) * tmp1.zzzz + tmp2;
                tmp1 = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]) * tmp1.wwww + tmp2;
                o.position = tmp1;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord1.xy = v.texcoord1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
                tmp2.x = dot(v.normal.xyz, float3(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0]));
                tmp2.y = dot(v.normal.xyz, float3(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1]));
                tmp2.z = dot(v.normal.xyz, float3(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2]));
                tmp0.w = dot(tmp2.xyz, tmp2.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord2.xyz = tmp0.www * tmp2.xyz;
                o.texcoord3.xyz = tmp0.xyz;
                tmp0.xyz = _WorldSpaceCameraPos - tmp0.xyz;
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord4.xyz = tmp0.www * tmp0.xyz;
                tmp0.xyz = tmp1.xyw * float3(0.5, 0.5, 0.5);
                o.texcoord6.zw = tmp1.zw;
                tmp0.w = tmp0.y * _ProjectionParams.x;
                o.texcoord6.xy = tmp0.zz + tmp0.xw;
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
                float4 tmp3;
                tmp0.xyz = inp.texcoord3.xyz - unity_ShadowFadeCenterAndType.xyz;
                tmp0.x = dot(tmp0.xyz, tmp0.xyz);
                tmp0.x = sqrt(tmp0.x);
                tmp0.yzw = _WorldSpaceCameraPos - inp.texcoord3.xyz;
                tmp1.x = unity_MatrixV._m20;
                tmp1.y = unity_MatrixV._m21;
                tmp1.z = unity_MatrixV._m22;
                tmp0.y = dot(tmp0.xyz, tmp1.xyz);
                tmp0.x = tmp0.x - tmp0.y;
                tmp0.x = unity_ShadowFadeCenterAndType.w * tmp0.x + tmp0.y;
                tmp0.x = saturate(tmp0.x * _LightShadowData.z + _LightShadowData.w);
                tmp0.y = tmp0.x < 1.0;
                tmp0.z = tmp0.x >= 1.0;
                tmp0.yz = tmp0.yz ? 1.0 : 0.0;
                tmp1.xy = inp.texcoord6.xy / inp.texcoord6.ww;
                tmp1 = tex2D(_ShadowMapTexture, tmp1.xy);
                tmp0.y = tmp0.y * tmp1.x + tmp0.z;
                tmp0.y = tmp0.y > 0.5;
                tmp0.z = tmp0.y ? -1.0 : -0.0;
                tmp1 = UNITY_SAMPLE_TEX2D_SAMPLER(unity_ShadowMask, unity_ShadowMask, inp.texcoord1.xy);
                tmp0.w = saturate(dot(tmp1, unity_OcclusionMaskSelector));
                tmp0.w = tmp0.w > 0.5;
                tmp0.yw = tmp0.yw ? 1.0 : 0.0;
                tmp0.z = tmp0.z + tmp0.w;
                tmp0.x = tmp0.x * tmp0.z + tmp0.y;
                tmp0.y = dot(_WorldSpaceLightPos0.xyz, inp.texcoord2.xyz);
                tmp0.y = tmp0.y - _Tendency;
                tmp0.y = saturate(tmp0.y * 100.0);
                tmp0.z = tmp0.y * -2.0 + 3.0;
                tmp0.y = tmp0.y * tmp0.y;
                tmp0.y = tmp0.y * tmp0.z;
                tmp0.xy = tmp0.xy * float2(_Opacity.x, _SelfShadowOpacity.x);
                tmp0.x = tmp0.x * tmp0.y;
                tmp0.yzw = LightColor.xyz - ShadowColor.xyz;
                tmp0.xyz = tmp0.xxx * tmp0.yzw + ShadowColor.xyz;
                tmp0.w = dot(inp.texcoord4.xyz, inp.texcoord2.xyz);
                tmp1.x = inp.texcoord3.x - inp.texcoord3.y;
                tmp0.w = tmp0.w * 5.0 + tmp1.x;
                tmp0.w = sin(tmp0.w);
                tmp1.xy = tmp0.ww + float2(0.4, 0.1);
                tmp1.xy = floor(tmp1.xy);
                tmp1.xy = max(tmp1.xy, float2(0.0, 0.0));
                tmp2 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0.w = -tmp2.w * _Color.w + 1.0;
                tmp1.yzw = tmp1.yyy * _LightColor0.xyz;
                tmp1 = tmp0.wwww * tmp1;
                tmp3 = tmp2 * _Color;
                tmp3.xyz = tmp1.xxx * tmp3.xyz;
                o.sv_target.w = tmp3.w;
                tmp0.w = sin(inp.texcoord.y);
                tmp0.w = max(tmp0.w, 0.5);
                tmp0.w = tmp0.w * 0.5;
                tmp2.xyz = tmp3.xyz * tmp0.www + tmp2.xyz;
                tmp1.xyz = tmp1.yzw * tmp0.www + tmp2.xyz;
                tmp1.xyz = tmp1.xyz * _LightColor0.xyz;
                tmp2 = tex2D(_Emission, inp.texcoord.xy);
                o.sv_target.xyz = tmp1.xyz * tmp0.xyz + tmp2.xyz;
                return o;
			}
#elif defined(DIRECTIONAL) && !defined(LIGHTMAP_ON) && defined(LIGHTMAP_SHADOW_MIXING) && defined(LIGHTPROBE_SH) && defined(SHADOWS_SCREEN) && defined(SHADOWS_SHADOWMASK) && defined(VERTEXLIGHT_ON)
			#include "UnityCG.cginc"
#include "AutoLight.cginc"
			struct v2f
			{
 UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float3 texcoord2 : TEXCOORD2;
				float3 texcoord3 : TEXCOORD3;
				float3 texcoord4 : TEXCOORD4;
				float4 texcoord6 : TEXCOORD6;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 _Color;
			float4 ShadowColor;
			float4 LightColor;
			float _Opacity;
			float _Tendency;
			float _SelfShadowOpacity;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			sampler2D _Emission;
			
			// Keywords: DIRECTIONAL LIGHTPROBE_SH SHADOWS_SHADOWMASK LIGHTMAP_SHADOW_MIXING SHADOWS_SCREEN VERTEXLIGHT_ON
			v2f vert(appdata_full v)
			{
 UNITY_SETUP_INSTANCE_ID(v);
                v2f o;
 UNITY_TRANSFER_INSTANCE_ID(v, o);
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0 = v.vertex.yyyy * float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
                tmp0 = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]) * v.vertex.xxxx + tmp0;
                tmp0 = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]) * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
                tmp0.xyz = float3(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3]) * v.vertex.www + tmp0.xyz;
                tmp2 = tmp1.yyyy * float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
                tmp2 = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]) * tmp1.xxxx + tmp2;
                tmp2 = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]) * tmp1.zzzz + tmp2;
                tmp1 = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]) * tmp1.wwww + tmp2;
                o.position = tmp1;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp2.x = dot(v.normal.xyz, float3(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0]));
                tmp2.y = dot(v.normal.xyz, float3(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1]));
                tmp2.z = dot(v.normal.xyz, float3(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2]));
                tmp0.w = dot(tmp2.xyz, tmp2.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord2.xyz = tmp0.www * tmp2.xyz;
                o.texcoord3.xyz = tmp0.xyz;
                tmp0.xyz = _WorldSpaceCameraPos - tmp0.xyz;
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord4.xyz = tmp0.www * tmp0.xyz;
                tmp0.xyz = tmp1.xyw * float3(0.5, 0.5, 0.5);
                o.texcoord6.zw = tmp1.zw;
                tmp0.w = tmp0.y * _ProjectionParams.x;
                o.texcoord6.xy = tmp0.zz + tmp0.xw;
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
                float4 tmp3;
                tmp0.xyz = inp.texcoord3.xyz - unity_ShadowFadeCenterAndType.xyz;
                tmp0.x = dot(tmp0.xyz, tmp0.xyz);
                tmp0.x = sqrt(tmp0.x);
                tmp0.yzw = _WorldSpaceCameraPos - inp.texcoord3.xyz;
                tmp1.x = unity_MatrixV._m20;
                tmp1.y = unity_MatrixV._m21;
                tmp1.z = unity_MatrixV._m22;
                tmp0.y = dot(tmp0.xyz, tmp1.xyz);
                tmp0.x = tmp0.x - tmp0.y;
                tmp0.x = unity_ShadowFadeCenterAndType.w * tmp0.x + tmp0.y;
                tmp0.x = saturate(tmp0.x * _LightShadowData.z + _LightShadowData.w);
                tmp0.y = tmp0.x < 1.0;
                tmp0.z = tmp0.x >= 1.0;
                tmp0.yz = tmp0.yz ? 1.0 : 0.0;
                tmp1.xy = inp.texcoord6.xy / inp.texcoord6.ww;
                tmp1 = tex2D(_ShadowMapTexture, tmp1.xy);
                tmp0.y = tmp0.y * tmp1.x + tmp0.z;
                tmp0.y = tmp0.y > 0.5;
                tmp0.x = tmp0.y ? 0.0 : tmp0.x;
                tmp0.y = tmp0.y ? 1.0 : 0.0;
                tmp0.x = tmp0.x + tmp0.y;
                tmp0.y = dot(_WorldSpaceLightPos0.xyz, inp.texcoord2.xyz);
                tmp0.y = tmp0.y - _Tendency;
                tmp0.y = saturate(tmp0.y * 100.0);
                tmp0.z = tmp0.y * -2.0 + 3.0;
                tmp0.y = tmp0.y * tmp0.y;
                tmp0.y = tmp0.y * tmp0.z;
                tmp0.xy = tmp0.xy * float2(_Opacity.x, _SelfShadowOpacity.x);
                tmp0.x = tmp0.x * tmp0.y;
                tmp0.yzw = LightColor.xyz - ShadowColor.xyz;
                tmp0.xyz = tmp0.xxx * tmp0.yzw + ShadowColor.xyz;
                tmp0.w = dot(inp.texcoord4.xyz, inp.texcoord2.xyz);
                tmp1.x = inp.texcoord3.x - inp.texcoord3.y;
                tmp0.w = tmp0.w * 5.0 + tmp1.x;
                tmp0.w = sin(tmp0.w);
                tmp1.xy = tmp0.ww + float2(0.4, 0.1);
                tmp1.xy = floor(tmp1.xy);
                tmp1.xy = max(tmp1.xy, float2(0.0, 0.0));
                tmp2 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0.w = -tmp2.w * _Color.w + 1.0;
                tmp1.yzw = tmp1.yyy * _LightColor0.xyz;
                tmp1 = tmp0.wwww * tmp1;
                tmp3 = tmp2 * _Color;
                tmp3.xyz = tmp1.xxx * tmp3.xyz;
                o.sv_target.w = tmp3.w;
                tmp0.w = sin(inp.texcoord.y);
                tmp0.w = max(tmp0.w, 0.5);
                tmp0.w = tmp0.w * 0.5;
                tmp2.xyz = tmp3.xyz * tmp0.www + tmp2.xyz;
                tmp1.xyz = tmp1.yzw * tmp0.www + tmp2.xyz;
                tmp1.xyz = tmp1.xyz * _LightColor0.xyz;
                tmp2 = tex2D(_Emission, inp.texcoord.xy);
                o.sv_target.xyz = tmp1.xyz * tmp0.xyz + tmp2.xyz;
                return o;
			}
#elif defined(DIRECTIONAL) && defined(LIGHTMAP_ON) && defined(LIGHTMAP_SHADOW_MIXING) && defined(LIGHTPROBE_SH) && !defined(SHADOWS_SCREEN) && defined(SHADOWS_SHADOWMASK) && !defined(VERTEXLIGHT_ON)
			#include "UnityCG.cginc"
#include "AutoLight.cginc"
			struct v2f
			{
 UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord1 : TEXCOORD1;
				float3 texcoord2 : TEXCOORD2;
				float3 texcoord3 : TEXCOORD3;
				float3 texcoord4 : TEXCOORD4;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 _Color;
			float4 ShadowColor;
			float4 LightColor;
			float _Opacity;
			float _Tendency;
			float _SelfShadowOpacity;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			sampler2D _Emission;
			
			// Keywords: DIRECTIONAL LIGHTPROBE_SH SHADOWS_SHADOWMASK LIGHTMAP_ON LIGHTMAP_SHADOW_MIXING
			v2f vert(appdata_full v)
			{
 UNITY_SETUP_INSTANCE_ID(v);
                v2f o;
 UNITY_TRANSFER_INSTANCE_ID(v, o);
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0 = v.vertex.yyyy * float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
                tmp0 = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]) * v.vertex.xxxx + tmp0;
                tmp0 = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]) * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
                tmp0.xyz = float3(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3]) * v.vertex.www + tmp0.xyz;
                tmp2 = tmp1.yyyy * float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
                tmp2 = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]) * tmp1.xxxx + tmp2;
                tmp2 = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]) * tmp1.zzzz + tmp2;
                o.position = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]) * tmp1.wwww + tmp2;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord1.xy = v.texcoord1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
                tmp1.x = dot(v.normal.xyz, float3(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0]));
                tmp1.y = dot(v.normal.xyz, float3(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1]));
                tmp1.z = dot(v.normal.xyz, float3(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2]));
                tmp0.w = dot(tmp1.xyz, tmp1.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord2.xyz = tmp0.www * tmp1.xyz;
                o.texcoord3.xyz = tmp0.xyz;
                tmp0.xyz = _WorldSpaceCameraPos - tmp0.xyz;
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord4.xyz = tmp0.www * tmp0.xyz;
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
                float4 tmp3;
                tmp0.xyz = inp.texcoord3.xyz - unity_ShadowFadeCenterAndType.xyz;
                tmp0.x = dot(tmp0.xyz, tmp0.xyz);
                tmp0.x = sqrt(tmp0.x);
                tmp0.yzw = _WorldSpaceCameraPos - inp.texcoord3.xyz;
                tmp1.x = unity_MatrixV._m20;
                tmp1.y = unity_MatrixV._m21;
                tmp1.z = unity_MatrixV._m22;
                tmp0.y = dot(tmp0.xyz, tmp1.xyz);
                tmp0.x = tmp0.x - tmp0.y;
                tmp0.x = unity_ShadowFadeCenterAndType.w * tmp0.x + tmp0.y;
                tmp0.x = saturate(tmp0.x * _LightShadowData.z + _LightShadowData.w);
                tmp0.y = tmp0.x < 1.0;
                tmp0.z = tmp0.x >= 1.0;
                tmp0.yz = tmp0.yz ? 1.0 : 0.0;
                tmp0.y = tmp0.z + tmp0.y;
                tmp0.y = tmp0.y > 0.5;
                tmp0.z = tmp0.y ? -1.0 : -0.0;
                tmp1 = UNITY_SAMPLE_TEX2D_SAMPLER(unity_ShadowMask, unity_ShadowMask, inp.texcoord1.xy);
                tmp0.w = saturate(dot(tmp1, unity_OcclusionMaskSelector));
                tmp0.w = tmp0.w > 0.5;
                tmp0.yw = tmp0.yw ? 1.0 : 0.0;
                tmp0.z = tmp0.z + tmp0.w;
                tmp0.x = tmp0.x * tmp0.z + tmp0.y;
                tmp0.y = dot(_WorldSpaceLightPos0.xyz, inp.texcoord2.xyz);
                tmp0.y = tmp0.y - _Tendency;
                tmp0.y = saturate(tmp0.y * 100.0);
                tmp0.z = tmp0.y * -2.0 + 3.0;
                tmp0.y = tmp0.y * tmp0.y;
                tmp0.y = tmp0.y * tmp0.z;
                tmp0.xy = tmp0.xy * float2(_Opacity.x, _SelfShadowOpacity.x);
                tmp0.x = tmp0.x * tmp0.y;
                tmp0.yzw = LightColor.xyz - ShadowColor.xyz;
                tmp0.xyz = tmp0.xxx * tmp0.yzw + ShadowColor.xyz;
                tmp0.w = dot(inp.texcoord4.xyz, inp.texcoord2.xyz);
                tmp1.x = inp.texcoord3.x - inp.texcoord3.y;
                tmp0.w = tmp0.w * 5.0 + tmp1.x;
                tmp0.w = sin(tmp0.w);
                tmp1.xy = tmp0.ww + float2(0.4, 0.1);
                tmp1.xy = floor(tmp1.xy);
                tmp1.xy = max(tmp1.xy, float2(0.0, 0.0));
                tmp2 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0.w = -tmp2.w * _Color.w + 1.0;
                tmp1.yzw = tmp1.yyy * _LightColor0.xyz;
                tmp1 = tmp0.wwww * tmp1;
                tmp3 = tmp2 * _Color;
                tmp3.xyz = tmp1.xxx * tmp3.xyz;
                o.sv_target.w = tmp3.w;
                tmp0.w = sin(inp.texcoord.y);
                tmp0.w = max(tmp0.w, 0.5);
                tmp0.w = tmp0.w * 0.5;
                tmp2.xyz = tmp3.xyz * tmp0.www + tmp2.xyz;
                tmp1.xyz = tmp1.yzw * tmp0.www + tmp2.xyz;
                tmp1.xyz = tmp1.xyz * _LightColor0.xyz;
                tmp2 = tex2D(_Emission, inp.texcoord.xy);
                o.sv_target.xyz = tmp1.xyz * tmp0.xyz + tmp2.xyz;
                return o;
			}
#elif defined(DIRECTIONAL) && !defined(LIGHTMAP_ON) && defined(LIGHTMAP_SHADOW_MIXING) && defined(LIGHTPROBE_SH) && defined(SHADOWS_SCREEN) && defined(SHADOWS_SHADOWMASK) && !defined(VERTEXLIGHT_ON)
			#include "UnityCG.cginc"
#include "AutoLight.cginc"
			struct v2f
			{
 UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float3 texcoord2 : TEXCOORD2;
				float3 texcoord3 : TEXCOORD3;
				float3 texcoord4 : TEXCOORD4;
				float4 texcoord6 : TEXCOORD6;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 _Color;
			float4 ShadowColor;
			float4 LightColor;
			float _Opacity;
			float _Tendency;
			float _SelfShadowOpacity;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			sampler2D _Emission;
			
			// Keywords: DIRECTIONAL LIGHTPROBE_SH SHADOWS_SHADOWMASK LIGHTMAP_SHADOW_MIXING SHADOWS_SCREEN
			v2f vert(appdata_full v)
			{
 UNITY_SETUP_INSTANCE_ID(v);
                v2f o;
 UNITY_TRANSFER_INSTANCE_ID(v, o);
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0 = v.vertex.yyyy * float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
                tmp0 = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]) * v.vertex.xxxx + tmp0;
                tmp0 = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]) * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
                tmp0.xyz = float3(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3]) * v.vertex.www + tmp0.xyz;
                tmp2 = tmp1.yyyy * float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
                tmp2 = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]) * tmp1.xxxx + tmp2;
                tmp2 = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]) * tmp1.zzzz + tmp2;
                tmp1 = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]) * tmp1.wwww + tmp2;
                o.position = tmp1;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp2.x = dot(v.normal.xyz, float3(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0]));
                tmp2.y = dot(v.normal.xyz, float3(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1]));
                tmp2.z = dot(v.normal.xyz, float3(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2]));
                tmp0.w = dot(tmp2.xyz, tmp2.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord2.xyz = tmp0.www * tmp2.xyz;
                o.texcoord3.xyz = tmp0.xyz;
                tmp0.xyz = _WorldSpaceCameraPos - tmp0.xyz;
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord4.xyz = tmp0.www * tmp0.xyz;
                tmp0.xyz = tmp1.xyw * float3(0.5, 0.5, 0.5);
                o.texcoord6.zw = tmp1.zw;
                tmp0.w = tmp0.y * _ProjectionParams.x;
                o.texcoord6.xy = tmp0.zz + tmp0.xw;
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
                float4 tmp3;
                tmp0.xyz = inp.texcoord3.xyz - unity_ShadowFadeCenterAndType.xyz;
                tmp0.x = dot(tmp0.xyz, tmp0.xyz);
                tmp0.x = sqrt(tmp0.x);
                tmp0.yzw = _WorldSpaceCameraPos - inp.texcoord3.xyz;
                tmp1.x = unity_MatrixV._m20;
                tmp1.y = unity_MatrixV._m21;
                tmp1.z = unity_MatrixV._m22;
                tmp0.y = dot(tmp0.xyz, tmp1.xyz);
                tmp0.x = tmp0.x - tmp0.y;
                tmp0.x = unity_ShadowFadeCenterAndType.w * tmp0.x + tmp0.y;
                tmp0.x = saturate(tmp0.x * _LightShadowData.z + _LightShadowData.w);
                tmp0.y = tmp0.x < 1.0;
                tmp0.z = tmp0.x >= 1.0;
                tmp0.yz = tmp0.yz ? 1.0 : 0.0;
                tmp1.xy = inp.texcoord6.xy / inp.texcoord6.ww;
                tmp1 = tex2D(_ShadowMapTexture, tmp1.xy);
                tmp0.y = tmp0.y * tmp1.x + tmp0.z;
                tmp0.y = tmp0.y > 0.5;
                tmp0.x = tmp0.y ? 0.0 : tmp0.x;
                tmp0.y = tmp0.y ? 1.0 : 0.0;
                tmp0.x = tmp0.x + tmp0.y;
                tmp0.y = dot(_WorldSpaceLightPos0.xyz, inp.texcoord2.xyz);
                tmp0.y = tmp0.y - _Tendency;
                tmp0.y = saturate(tmp0.y * 100.0);
                tmp0.z = tmp0.y * -2.0 + 3.0;
                tmp0.y = tmp0.y * tmp0.y;
                tmp0.y = tmp0.y * tmp0.z;
                tmp0.xy = tmp0.xy * float2(_Opacity.x, _SelfShadowOpacity.x);
                tmp0.x = tmp0.x * tmp0.y;
                tmp0.yzw = LightColor.xyz - ShadowColor.xyz;
                tmp0.xyz = tmp0.xxx * tmp0.yzw + ShadowColor.xyz;
                tmp0.w = dot(inp.texcoord4.xyz, inp.texcoord2.xyz);
                tmp1.x = inp.texcoord3.x - inp.texcoord3.y;
                tmp0.w = tmp0.w * 5.0 + tmp1.x;
                tmp0.w = sin(tmp0.w);
                tmp1.xy = tmp0.ww + float2(0.4, 0.1);
                tmp1.xy = floor(tmp1.xy);
                tmp1.xy = max(tmp1.xy, float2(0.0, 0.0));
                tmp2 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0.w = -tmp2.w * _Color.w + 1.0;
                tmp1.yzw = tmp1.yyy * _LightColor0.xyz;
                tmp1 = tmp0.wwww * tmp1;
                tmp3 = tmp2 * _Color;
                tmp3.xyz = tmp1.xxx * tmp3.xyz;
                o.sv_target.w = tmp3.w;
                tmp0.w = sin(inp.texcoord.y);
                tmp0.w = max(tmp0.w, 0.5);
                tmp0.w = tmp0.w * 0.5;
                tmp2.xyz = tmp3.xyz * tmp0.www + tmp2.xyz;
                tmp1.xyz = tmp1.yzw * tmp0.www + tmp2.xyz;
                tmp1.xyz = tmp1.xyz * _LightColor0.xyz;
                tmp2 = tex2D(_Emission, inp.texcoord.xy);
                o.sv_target.xyz = tmp1.xyz * tmp0.xyz + tmp2.xyz;
                return o;
			}
#elif defined(DIRECTIONAL) && defined(LIGHTMAP_ON) && defined(LIGHTMAP_SHADOW_MIXING) && defined(LIGHTPROBE_SH) && defined(SHADOWS_SCREEN) && !defined(SHADOWS_SHADOWMASK) && !defined(VERTEXLIGHT_ON)
			#include "UnityCG.cginc"
#include "AutoLight.cginc"
			struct v2f
			{
 UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord1 : TEXCOORD1;
				float3 texcoord2 : TEXCOORD2;
				float3 texcoord3 : TEXCOORD3;
				float3 texcoord4 : TEXCOORD4;
				float4 texcoord6 : TEXCOORD6;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 _Color;
			float4 ShadowColor;
			float4 LightColor;
			float _Opacity;
			float _Tendency;
			float _SelfShadowOpacity;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			sampler2D _Emission;
			
			// Keywords: DIRECTIONAL LIGHTPROBE_SH LIGHTMAP_ON LIGHTMAP_SHADOW_MIXING SHADOWS_SCREEN
			v2f vert(appdata_full v)
			{
 UNITY_SETUP_INSTANCE_ID(v);
                v2f o;
 UNITY_TRANSFER_INSTANCE_ID(v, o);
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0 = v.vertex.yyyy * float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
                tmp0 = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]) * v.vertex.xxxx + tmp0;
                tmp0 = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]) * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
                tmp0.xyz = float3(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3]) * v.vertex.www + tmp0.xyz;
                tmp2 = tmp1.yyyy * float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
                tmp2 = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]) * tmp1.xxxx + tmp2;
                tmp2 = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]) * tmp1.zzzz + tmp2;
                tmp1 = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]) * tmp1.wwww + tmp2;
                o.position = tmp1;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord1.xy = v.texcoord1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
                tmp2.x = dot(v.normal.xyz, float3(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0]));
                tmp2.y = dot(v.normal.xyz, float3(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1]));
                tmp2.z = dot(v.normal.xyz, float3(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2]));
                tmp0.w = dot(tmp2.xyz, tmp2.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord2.xyz = tmp0.www * tmp2.xyz;
                o.texcoord3.xyz = tmp0.xyz;
                tmp0.xyz = _WorldSpaceCameraPos - tmp0.xyz;
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord4.xyz = tmp0.www * tmp0.xyz;
                tmp0.xyz = tmp1.xyw * float3(0.5, 0.5, 0.5);
                o.texcoord6.zw = tmp1.zw;
                tmp0.w = tmp0.y * _ProjectionParams.x;
                o.texcoord6.xy = tmp0.zz + tmp0.xw;
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
                float4 tmp3;
                tmp0.xyz = inp.texcoord3.xyz - unity_ShadowFadeCenterAndType.xyz;
                tmp0.x = dot(tmp0.xyz, tmp0.xyz);
                tmp0.x = sqrt(tmp0.x);
                tmp0.yzw = _WorldSpaceCameraPos - inp.texcoord3.xyz;
                tmp1.x = unity_MatrixV._m20;
                tmp1.y = unity_MatrixV._m21;
                tmp1.z = unity_MatrixV._m22;
                tmp0.y = dot(tmp0.xyz, tmp1.xyz);
                tmp0.x = tmp0.x - tmp0.y;
                tmp0.x = unity_ShadowFadeCenterAndType.w * tmp0.x + tmp0.y;
                tmp0.x = saturate(tmp0.x * _LightShadowData.z + _LightShadowData.w);
                tmp0.y = tmp0.x < 1.0;
                tmp0.z = tmp0.x >= 1.0;
                tmp0.yz = tmp0.yz ? 1.0 : 0.0;
                tmp1.xy = inp.texcoord6.xy / inp.texcoord6.ww;
                tmp1 = tex2D(_ShadowMapTexture, tmp1.xy);
                tmp0.y = tmp0.y * tmp1.x + tmp0.z;
                tmp0.y = tmp0.y > 0.5;
                tmp0.x = tmp0.y ? 0.0 : tmp0.x;
                tmp0.y = tmp0.y ? 1.0 : 0.0;
                tmp0.x = tmp0.x + tmp0.y;
                tmp0.y = dot(_WorldSpaceLightPos0.xyz, inp.texcoord2.xyz);
                tmp0.y = tmp0.y - _Tendency;
                tmp0.y = saturate(tmp0.y * 100.0);
                tmp0.z = tmp0.y * -2.0 + 3.0;
                tmp0.y = tmp0.y * tmp0.y;
                tmp0.y = tmp0.y * tmp0.z;
                tmp0.xy = tmp0.xy * float2(_Opacity.x, _SelfShadowOpacity.x);
                tmp0.x = tmp0.x * tmp0.y;
                tmp0.yzw = LightColor.xyz - ShadowColor.xyz;
                tmp0.xyz = tmp0.xxx * tmp0.yzw + ShadowColor.xyz;
                tmp0.w = dot(inp.texcoord4.xyz, inp.texcoord2.xyz);
                tmp1.x = inp.texcoord3.x - inp.texcoord3.y;
                tmp0.w = tmp0.w * 5.0 + tmp1.x;
                tmp0.w = sin(tmp0.w);
                tmp1.xy = tmp0.ww + float2(0.4, 0.1);
                tmp1.xy = floor(tmp1.xy);
                tmp1.xy = max(tmp1.xy, float2(0.0, 0.0));
                tmp2 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0.w = -tmp2.w * _Color.w + 1.0;
                tmp1.yzw = tmp1.yyy * _LightColor0.xyz;
                tmp1 = tmp0.wwww * tmp1;
                tmp3 = tmp2 * _Color;
                tmp3.xyz = tmp1.xxx * tmp3.xyz;
                o.sv_target.w = tmp3.w;
                tmp0.w = sin(inp.texcoord.y);
                tmp0.w = max(tmp0.w, 0.5);
                tmp0.w = tmp0.w * 0.5;
                tmp2.xyz = tmp3.xyz * tmp0.www + tmp2.xyz;
                tmp1.xyz = tmp1.yzw * tmp0.www + tmp2.xyz;
                tmp1.xyz = tmp1.xyz * _LightColor0.xyz;
                tmp2 = tex2D(_Emission, inp.texcoord.xy);
                o.sv_target.xyz = tmp1.xyz * tmp0.xyz + tmp2.xyz;
                return o;
			}
#elif defined(DIRECTIONAL) && defined(LIGHTMAP_ON) && !defined(LIGHTMAP_SHADOW_MIXING) && defined(LIGHTPROBE_SH) && defined(SHADOWS_SCREEN) && defined(SHADOWS_SHADOWMASK) && !defined(VERTEXLIGHT_ON)
			#include "UnityCG.cginc"
#include "AutoLight.cginc"
			struct v2f
			{
 UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord1 : TEXCOORD1;
				float3 texcoord2 : TEXCOORD2;
				float3 texcoord3 : TEXCOORD3;
				float3 texcoord4 : TEXCOORD4;
				float4 texcoord6 : TEXCOORD6;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 _Color;
			float4 ShadowColor;
			float4 LightColor;
			float _Opacity;
			float _Tendency;
			float _SelfShadowOpacity;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			sampler2D _Emission;
			
			// Keywords: DIRECTIONAL LIGHTPROBE_SH SHADOWS_SHADOWMASK LIGHTMAP_ON SHADOWS_SCREEN
			v2f vert(appdata_full v)
			{
 UNITY_SETUP_INSTANCE_ID(v);
                v2f o;
 UNITY_TRANSFER_INSTANCE_ID(v, o);
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0 = v.vertex.yyyy * float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
                tmp0 = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]) * v.vertex.xxxx + tmp0;
                tmp0 = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]) * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
                tmp0.xyz = float3(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3]) * v.vertex.www + tmp0.xyz;
                tmp2 = tmp1.yyyy * float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
                tmp2 = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]) * tmp1.xxxx + tmp2;
                tmp2 = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]) * tmp1.zzzz + tmp2;
                tmp1 = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]) * tmp1.wwww + tmp2;
                o.position = tmp1;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord1.xy = v.texcoord1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
                tmp2.x = dot(v.normal.xyz, float3(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0]));
                tmp2.y = dot(v.normal.xyz, float3(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1]));
                tmp2.z = dot(v.normal.xyz, float3(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2]));
                tmp0.w = dot(tmp2.xyz, tmp2.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord2.xyz = tmp0.www * tmp2.xyz;
                o.texcoord3.xyz = tmp0.xyz;
                tmp0.xyz = _WorldSpaceCameraPos - tmp0.xyz;
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord4.xyz = tmp0.www * tmp0.xyz;
                tmp0.xyz = tmp1.xyw * float3(0.5, 0.5, 0.5);
                o.texcoord6.zw = tmp1.zw;
                tmp0.w = tmp0.y * _ProjectionParams.x;
                o.texcoord6.xy = tmp0.zz + tmp0.xw;
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
                float4 tmp3;
                tmp0.xyz = inp.texcoord3.xyz - unity_ShadowFadeCenterAndType.xyz;
                tmp0.x = dot(tmp0.xyz, tmp0.xyz);
                tmp0.x = sqrt(tmp0.x);
                tmp0.yzw = _WorldSpaceCameraPos - inp.texcoord3.xyz;
                tmp1.x = unity_MatrixV._m20;
                tmp1.y = unity_MatrixV._m21;
                tmp1.z = unity_MatrixV._m22;
                tmp0.y = dot(tmp0.xyz, tmp1.xyz);
                tmp0.x = tmp0.x - tmp0.y;
                tmp0.x = unity_ShadowFadeCenterAndType.w * tmp0.x + tmp0.y;
                tmp0.x = saturate(tmp0.x * _LightShadowData.z + _LightShadowData.w);
                tmp0.y = tmp0.x < 1.0;
                tmp0.z = tmp0.x >= 1.0;
                tmp0.yz = tmp0.yz ? 1.0 : 0.0;
                tmp1.xy = inp.texcoord6.xy / inp.texcoord6.ww;
                tmp1 = tex2D(_ShadowMapTexture, tmp1.xy);
                tmp0.y = tmp0.y * tmp1.x + tmp0.z;
                tmp0.y = tmp0.y > 0.5;
                tmp0.z = tmp0.y ? -1.0 : -0.0;
                tmp1 = UNITY_SAMPLE_TEX2D_SAMPLER(unity_ShadowMask, unity_ShadowMask, inp.texcoord1.xy);
                tmp0.w = saturate(dot(tmp1, unity_OcclusionMaskSelector));
                tmp0.w = tmp0.w > 0.5;
                tmp0.yw = tmp0.yw ? 1.0 : 0.0;
                tmp0.z = tmp0.z + tmp0.w;
                tmp0.x = tmp0.x * tmp0.z + tmp0.y;
                tmp0.y = dot(_WorldSpaceLightPos0.xyz, inp.texcoord2.xyz);
                tmp0.y = tmp0.y - _Tendency;
                tmp0.y = saturate(tmp0.y * 100.0);
                tmp0.z = tmp0.y * -2.0 + 3.0;
                tmp0.y = tmp0.y * tmp0.y;
                tmp0.y = tmp0.y * tmp0.z;
                tmp0.xy = tmp0.xy * float2(_Opacity.x, _SelfShadowOpacity.x);
                tmp0.x = tmp0.x * tmp0.y;
                tmp0.yzw = LightColor.xyz - ShadowColor.xyz;
                tmp0.xyz = tmp0.xxx * tmp0.yzw + ShadowColor.xyz;
                tmp0.w = dot(inp.texcoord4.xyz, inp.texcoord2.xyz);
                tmp1.x = inp.texcoord3.x - inp.texcoord3.y;
                tmp0.w = tmp0.w * 5.0 + tmp1.x;
                tmp0.w = sin(tmp0.w);
                tmp1.xy = tmp0.ww + float2(0.4, 0.1);
                tmp1.xy = floor(tmp1.xy);
                tmp1.xy = max(tmp1.xy, float2(0.0, 0.0));
                tmp2 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0.w = -tmp2.w * _Color.w + 1.0;
                tmp1.yzw = tmp1.yyy * _LightColor0.xyz;
                tmp1 = tmp0.wwww * tmp1;
                tmp3 = tmp2 * _Color;
                tmp3.xyz = tmp1.xxx * tmp3.xyz;
                o.sv_target.w = tmp3.w;
                tmp0.w = sin(inp.texcoord.y);
                tmp0.w = max(tmp0.w, 0.5);
                tmp0.w = tmp0.w * 0.5;
                tmp2.xyz = tmp3.xyz * tmp0.www + tmp2.xyz;
                tmp1.xyz = tmp1.yzw * tmp0.www + tmp2.xyz;
                tmp1.xyz = tmp1.xyz * _LightColor0.xyz;
                tmp2 = tex2D(_Emission, inp.texcoord.xy);
                o.sv_target.xyz = tmp1.xyz * tmp0.xyz + tmp2.xyz;
                return o;
			}
#elif defined(DIRECTIONAL) && defined(LIGHTMAP_ON) && defined(LIGHTMAP_SHADOW_MIXING) && !defined(LIGHTPROBE_SH) && defined(SHADOWS_SCREEN) && defined(SHADOWS_SHADOWMASK) && !defined(VERTEXLIGHT_ON)
			#include "UnityCG.cginc"
#include "AutoLight.cginc"
			struct v2f
			{
 UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord1 : TEXCOORD1;
				float3 texcoord2 : TEXCOORD2;
				float3 texcoord3 : TEXCOORD3;
				float3 texcoord4 : TEXCOORD4;
				float4 texcoord6 : TEXCOORD6;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 _Color;
			float4 ShadowColor;
			float4 LightColor;
			float _Opacity;
			float _Tendency;
			float _SelfShadowOpacity;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			sampler2D _Emission;
			
			// Keywords: DIRECTIONAL SHADOWS_SHADOWMASK LIGHTMAP_ON LIGHTMAP_SHADOW_MIXING SHADOWS_SCREEN
			v2f vert(appdata_full v)
			{
 UNITY_SETUP_INSTANCE_ID(v);
                v2f o;
 UNITY_TRANSFER_INSTANCE_ID(v, o);
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0 = v.vertex.yyyy * float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
                tmp0 = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]) * v.vertex.xxxx + tmp0;
                tmp0 = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]) * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
                tmp0.xyz = float3(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3]) * v.vertex.www + tmp0.xyz;
                tmp2 = tmp1.yyyy * float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
                tmp2 = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]) * tmp1.xxxx + tmp2;
                tmp2 = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]) * tmp1.zzzz + tmp2;
                tmp1 = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]) * tmp1.wwww + tmp2;
                o.position = tmp1;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord1.xy = v.texcoord1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
                tmp2.x = dot(v.normal.xyz, float3(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0]));
                tmp2.y = dot(v.normal.xyz, float3(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1]));
                tmp2.z = dot(v.normal.xyz, float3(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2]));
                tmp0.w = dot(tmp2.xyz, tmp2.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord2.xyz = tmp0.www * tmp2.xyz;
                o.texcoord3.xyz = tmp0.xyz;
                tmp0.xyz = _WorldSpaceCameraPos - tmp0.xyz;
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord4.xyz = tmp0.www * tmp0.xyz;
                tmp0.xyz = tmp1.xyw * float3(0.5, 0.5, 0.5);
                o.texcoord6.zw = tmp1.zw;
                tmp0.w = tmp0.y * _ProjectionParams.x;
                o.texcoord6.xy = tmp0.zz + tmp0.xw;
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
                float4 tmp3;
                tmp0.xyz = inp.texcoord3.xyz - unity_ShadowFadeCenterAndType.xyz;
                tmp0.x = dot(tmp0.xyz, tmp0.xyz);
                tmp0.x = sqrt(tmp0.x);
                tmp0.yzw = _WorldSpaceCameraPos - inp.texcoord3.xyz;
                tmp1.x = unity_MatrixV._m20;
                tmp1.y = unity_MatrixV._m21;
                tmp1.z = unity_MatrixV._m22;
                tmp0.y = dot(tmp0.xyz, tmp1.xyz);
                tmp0.x = tmp0.x - tmp0.y;
                tmp0.x = unity_ShadowFadeCenterAndType.w * tmp0.x + tmp0.y;
                tmp0.x = saturate(tmp0.x * _LightShadowData.z + _LightShadowData.w);
                tmp0.y = tmp0.x < 1.0;
                tmp0.z = tmp0.x >= 1.0;
                tmp0.yz = tmp0.yz ? 1.0 : 0.0;
                tmp1.xy = inp.texcoord6.xy / inp.texcoord6.ww;
                tmp1 = tex2D(_ShadowMapTexture, tmp1.xy);
                tmp0.y = tmp0.y * tmp1.x + tmp0.z;
                tmp0.y = tmp0.y > 0.5;
                tmp0.z = tmp0.y ? -1.0 : -0.0;
                tmp1 = UNITY_SAMPLE_TEX2D_SAMPLER(unity_ShadowMask, unity_ShadowMask, inp.texcoord1.xy);
                tmp0.w = saturate(dot(tmp1, unity_OcclusionMaskSelector));
                tmp0.w = tmp0.w > 0.5;
                tmp0.yw = tmp0.yw ? 1.0 : 0.0;
                tmp0.z = tmp0.z + tmp0.w;
                tmp0.x = tmp0.x * tmp0.z + tmp0.y;
                tmp0.y = dot(_WorldSpaceLightPos0.xyz, inp.texcoord2.xyz);
                tmp0.y = tmp0.y - _Tendency;
                tmp0.y = saturate(tmp0.y * 100.0);
                tmp0.z = tmp0.y * -2.0 + 3.0;
                tmp0.y = tmp0.y * tmp0.y;
                tmp0.y = tmp0.y * tmp0.z;
                tmp0.xy = tmp0.xy * float2(_Opacity.x, _SelfShadowOpacity.x);
                tmp0.x = tmp0.x * tmp0.y;
                tmp0.yzw = LightColor.xyz - ShadowColor.xyz;
                tmp0.xyz = tmp0.xxx * tmp0.yzw + ShadowColor.xyz;
                tmp0.w = dot(inp.texcoord4.xyz, inp.texcoord2.xyz);
                tmp1.x = inp.texcoord3.x - inp.texcoord3.y;
                tmp0.w = tmp0.w * 5.0 + tmp1.x;
                tmp0.w = sin(tmp0.w);
                tmp1.xy = tmp0.ww + float2(0.4, 0.1);
                tmp1.xy = floor(tmp1.xy);
                tmp1.xy = max(tmp1.xy, float2(0.0, 0.0));
                tmp2 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0.w = -tmp2.w * _Color.w + 1.0;
                tmp1.yzw = tmp1.yyy * _LightColor0.xyz;
                tmp1 = tmp0.wwww * tmp1;
                tmp3 = tmp2 * _Color;
                tmp3.xyz = tmp1.xxx * tmp3.xyz;
                o.sv_target.w = tmp3.w;
                tmp0.w = sin(inp.texcoord.y);
                tmp0.w = max(tmp0.w, 0.5);
                tmp0.w = tmp0.w * 0.5;
                tmp2.xyz = tmp3.xyz * tmp0.www + tmp2.xyz;
                tmp1.xyz = tmp1.yzw * tmp0.www + tmp2.xyz;
                tmp1.xyz = tmp1.xyz * _LightColor0.xyz;
                tmp2 = tex2D(_Emission, inp.texcoord.xy);
                o.sv_target.xyz = tmp1.xyz * tmp0.xyz + tmp2.xyz;
                return o;
			}
#elif defined(DIRECTIONAL) && !defined(LIGHTMAP_ON) && defined(LIGHTMAP_SHADOW_MIXING) && defined(LIGHTPROBE_SH) && defined(SHADOWS_SCREEN) && !defined(SHADOWS_SHADOWMASK) && defined(VERTEXLIGHT_ON)
			#include "UnityCG.cginc"
#include "AutoLight.cginc"
			struct v2f
			{
 UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float3 texcoord2 : TEXCOORD2;
				float3 texcoord3 : TEXCOORD3;
				float3 texcoord4 : TEXCOORD4;
				float4 texcoord6 : TEXCOORD6;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 _Color;
			float4 ShadowColor;
			float4 LightColor;
			float _Opacity;
			float _Tendency;
			float _SelfShadowOpacity;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			sampler2D _Emission;
			
			// Keywords: DIRECTIONAL LIGHTPROBE_SH LIGHTMAP_SHADOW_MIXING SHADOWS_SCREEN VERTEXLIGHT_ON
			v2f vert(appdata_full v)
			{
 UNITY_SETUP_INSTANCE_ID(v);
                v2f o;
 UNITY_TRANSFER_INSTANCE_ID(v, o);
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0 = v.vertex.yyyy * float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
                tmp0 = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]) * v.vertex.xxxx + tmp0;
                tmp0 = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]) * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
                tmp0.xyz = float3(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3]) * v.vertex.www + tmp0.xyz;
                tmp2 = tmp1.yyyy * float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
                tmp2 = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]) * tmp1.xxxx + tmp2;
                tmp2 = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]) * tmp1.zzzz + tmp2;
                tmp1 = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]) * tmp1.wwww + tmp2;
                o.position = tmp1;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp2.x = dot(v.normal.xyz, float3(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0]));
                tmp2.y = dot(v.normal.xyz, float3(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1]));
                tmp2.z = dot(v.normal.xyz, float3(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2]));
                tmp0.w = dot(tmp2.xyz, tmp2.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord2.xyz = tmp0.www * tmp2.xyz;
                o.texcoord3.xyz = tmp0.xyz;
                tmp0.xyz = _WorldSpaceCameraPos - tmp0.xyz;
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord4.xyz = tmp0.www * tmp0.xyz;
                tmp0.xyz = tmp1.xyw * float3(0.5, 0.5, 0.5);
                o.texcoord6.zw = tmp1.zw;
                tmp0.w = tmp0.y * _ProjectionParams.x;
                o.texcoord6.xy = tmp0.zz + tmp0.xw;
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
                float4 tmp3;
                tmp0.xyz = inp.texcoord3.xyz - unity_ShadowFadeCenterAndType.xyz;
                tmp0.x = dot(tmp0.xyz, tmp0.xyz);
                tmp0.x = sqrt(tmp0.x);
                tmp0.yzw = _WorldSpaceCameraPos - inp.texcoord3.xyz;
                tmp1.x = unity_MatrixV._m20;
                tmp1.y = unity_MatrixV._m21;
                tmp1.z = unity_MatrixV._m22;
                tmp0.y = dot(tmp0.xyz, tmp1.xyz);
                tmp0.x = tmp0.x - tmp0.y;
                tmp0.x = unity_ShadowFadeCenterAndType.w * tmp0.x + tmp0.y;
                tmp0.x = saturate(tmp0.x * _LightShadowData.z + _LightShadowData.w);
                tmp0.y = tmp0.x < 1.0;
                tmp0.z = tmp0.x >= 1.0;
                tmp0.yz = tmp0.yz ? 1.0 : 0.0;
                tmp1.xy = inp.texcoord6.xy / inp.texcoord6.ww;
                tmp1 = tex2D(_ShadowMapTexture, tmp1.xy);
                tmp0.y = tmp0.y * tmp1.x + tmp0.z;
                tmp0.y = tmp0.y > 0.5;
                tmp0.x = tmp0.y ? 0.0 : tmp0.x;
                tmp0.y = tmp0.y ? 1.0 : 0.0;
                tmp0.x = tmp0.x + tmp0.y;
                tmp0.y = dot(_WorldSpaceLightPos0.xyz, inp.texcoord2.xyz);
                tmp0.y = tmp0.y - _Tendency;
                tmp0.y = saturate(tmp0.y * 100.0);
                tmp0.z = tmp0.y * -2.0 + 3.0;
                tmp0.y = tmp0.y * tmp0.y;
                tmp0.y = tmp0.y * tmp0.z;
                tmp0.xy = tmp0.xy * float2(_Opacity.x, _SelfShadowOpacity.x);
                tmp0.x = tmp0.x * tmp0.y;
                tmp0.yzw = LightColor.xyz - ShadowColor.xyz;
                tmp0.xyz = tmp0.xxx * tmp0.yzw + ShadowColor.xyz;
                tmp0.w = dot(inp.texcoord4.xyz, inp.texcoord2.xyz);
                tmp1.x = inp.texcoord3.x - inp.texcoord3.y;
                tmp0.w = tmp0.w * 5.0 + tmp1.x;
                tmp0.w = sin(tmp0.w);
                tmp1.xy = tmp0.ww + float2(0.4, 0.1);
                tmp1.xy = floor(tmp1.xy);
                tmp1.xy = max(tmp1.xy, float2(0.0, 0.0));
                tmp2 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0.w = -tmp2.w * _Color.w + 1.0;
                tmp1.yzw = tmp1.yyy * _LightColor0.xyz;
                tmp1 = tmp0.wwww * tmp1;
                tmp3 = tmp2 * _Color;
                tmp3.xyz = tmp1.xxx * tmp3.xyz;
                o.sv_target.w = tmp3.w;
                tmp0.w = sin(inp.texcoord.y);
                tmp0.w = max(tmp0.w, 0.5);
                tmp0.w = tmp0.w * 0.5;
                tmp2.xyz = tmp3.xyz * tmp0.www + tmp2.xyz;
                tmp1.xyz = tmp1.yzw * tmp0.www + tmp2.xyz;
                tmp1.xyz = tmp1.xyz * _LightColor0.xyz;
                tmp2 = tex2D(_Emission, inp.texcoord.xy);
                o.sv_target.xyz = tmp1.xyz * tmp0.xyz + tmp2.xyz;
                return o;
			}
#elif defined(DIRECTIONAL) && !defined(LIGHTMAP_ON) && !defined(LIGHTMAP_SHADOW_MIXING) && defined(LIGHTPROBE_SH) && defined(SHADOWS_SCREEN) && defined(SHADOWS_SHADOWMASK) && defined(VERTEXLIGHT_ON)
			#include "UnityCG.cginc"
#include "AutoLight.cginc"
			struct v2f
			{
 UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float3 texcoord2 : TEXCOORD2;
				float3 texcoord3 : TEXCOORD3;
				float3 texcoord4 : TEXCOORD4;
				float4 texcoord6 : TEXCOORD6;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 _Color;
			float4 ShadowColor;
			float4 LightColor;
			float _Opacity;
			float _Tendency;
			float _SelfShadowOpacity;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			sampler2D _Emission;
			
			// Keywords: DIRECTIONAL LIGHTPROBE_SH SHADOWS_SHADOWMASK SHADOWS_SCREEN VERTEXLIGHT_ON
			v2f vert(appdata_full v)
			{
 UNITY_SETUP_INSTANCE_ID(v);
                v2f o;
 UNITY_TRANSFER_INSTANCE_ID(v, o);
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0 = v.vertex.yyyy * float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
                tmp0 = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]) * v.vertex.xxxx + tmp0;
                tmp0 = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]) * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
                tmp0.xyz = float3(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3]) * v.vertex.www + tmp0.xyz;
                tmp2 = tmp1.yyyy * float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
                tmp2 = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]) * tmp1.xxxx + tmp2;
                tmp2 = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]) * tmp1.zzzz + tmp2;
                tmp1 = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]) * tmp1.wwww + tmp2;
                o.position = tmp1;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp2.x = dot(v.normal.xyz, float3(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0]));
                tmp2.y = dot(v.normal.xyz, float3(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1]));
                tmp2.z = dot(v.normal.xyz, float3(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2]));
                tmp0.w = dot(tmp2.xyz, tmp2.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord2.xyz = tmp0.www * tmp2.xyz;
                o.texcoord3.xyz = tmp0.xyz;
                tmp0.xyz = _WorldSpaceCameraPos - tmp0.xyz;
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord4.xyz = tmp0.www * tmp0.xyz;
                tmp0.xyz = tmp1.xyw * float3(0.5, 0.5, 0.5);
                o.texcoord6.zw = tmp1.zw;
                tmp0.w = tmp0.y * _ProjectionParams.x;
                o.texcoord6.xy = tmp0.zz + tmp0.xw;
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
                float4 tmp3;
                tmp0.xyz = inp.texcoord3.xyz - unity_ShadowFadeCenterAndType.xyz;
                tmp0.x = dot(tmp0.xyz, tmp0.xyz);
                tmp0.x = sqrt(tmp0.x);
                tmp0.yzw = _WorldSpaceCameraPos - inp.texcoord3.xyz;
                tmp1.x = unity_MatrixV._m20;
                tmp1.y = unity_MatrixV._m21;
                tmp1.z = unity_MatrixV._m22;
                tmp0.y = dot(tmp0.xyz, tmp1.xyz);
                tmp0.x = tmp0.x - tmp0.y;
                tmp0.x = unity_ShadowFadeCenterAndType.w * tmp0.x + tmp0.y;
                tmp0.x = saturate(tmp0.x * _LightShadowData.z + _LightShadowData.w);
                tmp0.y = tmp0.x < 1.0;
                tmp0.z = tmp0.x >= 1.0;
                tmp0.yz = tmp0.yz ? 1.0 : 0.0;
                tmp1.xy = inp.texcoord6.xy / inp.texcoord6.ww;
                tmp1 = tex2D(_ShadowMapTexture, tmp1.xy);
                tmp0.y = tmp0.y * tmp1.x + tmp0.z;
                tmp0.y = tmp0.y > 0.5;
                tmp0.x = tmp0.y ? 0.0 : tmp0.x;
                tmp0.y = tmp0.y ? 1.0 : 0.0;
                tmp0.x = tmp0.x + tmp0.y;
                tmp0.y = dot(_WorldSpaceLightPos0.xyz, inp.texcoord2.xyz);
                tmp0.y = tmp0.y - _Tendency;
                tmp0.y = saturate(tmp0.y * 100.0);
                tmp0.z = tmp0.y * -2.0 + 3.0;
                tmp0.y = tmp0.y * tmp0.y;
                tmp0.y = tmp0.y * tmp0.z;
                tmp0.xy = tmp0.xy * float2(_Opacity.x, _SelfShadowOpacity.x);
                tmp0.x = tmp0.x * tmp0.y;
                tmp0.yzw = LightColor.xyz - ShadowColor.xyz;
                tmp0.xyz = tmp0.xxx * tmp0.yzw + ShadowColor.xyz;
                tmp0.w = dot(inp.texcoord4.xyz, inp.texcoord2.xyz);
                tmp1.x = inp.texcoord3.x - inp.texcoord3.y;
                tmp0.w = tmp0.w * 5.0 + tmp1.x;
                tmp0.w = sin(tmp0.w);
                tmp1.xy = tmp0.ww + float2(0.4, 0.1);
                tmp1.xy = floor(tmp1.xy);
                tmp1.xy = max(tmp1.xy, float2(0.0, 0.0));
                tmp2 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0.w = -tmp2.w * _Color.w + 1.0;
                tmp1.yzw = tmp1.yyy * _LightColor0.xyz;
                tmp1 = tmp0.wwww * tmp1;
                tmp3 = tmp2 * _Color;
                tmp3.xyz = tmp1.xxx * tmp3.xyz;
                o.sv_target.w = tmp3.w;
                tmp0.w = sin(inp.texcoord.y);
                tmp0.w = max(tmp0.w, 0.5);
                tmp0.w = tmp0.w * 0.5;
                tmp2.xyz = tmp3.xyz * tmp0.www + tmp2.xyz;
                tmp1.xyz = tmp1.yzw * tmp0.www + tmp2.xyz;
                tmp1.xyz = tmp1.xyz * _LightColor0.xyz;
                tmp2 = tex2D(_Emission, inp.texcoord.xy);
                o.sv_target.xyz = tmp1.xyz * tmp0.xyz + tmp2.xyz;
                return o;
			}
#elif defined(DIRECTIONAL) && !defined(LIGHTMAP_ON) && defined(LIGHTMAP_SHADOW_MIXING) && !defined(LIGHTPROBE_SH) && defined(SHADOWS_SCREEN) && defined(SHADOWS_SHADOWMASK) && defined(VERTEXLIGHT_ON)
			#include "UnityCG.cginc"
#include "AutoLight.cginc"
			struct v2f
			{
 UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float3 texcoord2 : TEXCOORD2;
				float3 texcoord3 : TEXCOORD3;
				float3 texcoord4 : TEXCOORD4;
				float4 texcoord6 : TEXCOORD6;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 _Color;
			float4 ShadowColor;
			float4 LightColor;
			float _Opacity;
			float _Tendency;
			float _SelfShadowOpacity;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			sampler2D _Emission;
			
			// Keywords: DIRECTIONAL SHADOWS_SHADOWMASK LIGHTMAP_SHADOW_MIXING SHADOWS_SCREEN VERTEXLIGHT_ON
			v2f vert(appdata_full v)
			{
 UNITY_SETUP_INSTANCE_ID(v);
                v2f o;
 UNITY_TRANSFER_INSTANCE_ID(v, o);
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0 = v.vertex.yyyy * float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
                tmp0 = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]) * v.vertex.xxxx + tmp0;
                tmp0 = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]) * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
                tmp0.xyz = float3(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3]) * v.vertex.www + tmp0.xyz;
                tmp2 = tmp1.yyyy * float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
                tmp2 = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]) * tmp1.xxxx + tmp2;
                tmp2 = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]) * tmp1.zzzz + tmp2;
                tmp1 = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]) * tmp1.wwww + tmp2;
                o.position = tmp1;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp2.x = dot(v.normal.xyz, float3(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0]));
                tmp2.y = dot(v.normal.xyz, float3(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1]));
                tmp2.z = dot(v.normal.xyz, float3(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2]));
                tmp0.w = dot(tmp2.xyz, tmp2.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord2.xyz = tmp0.www * tmp2.xyz;
                o.texcoord3.xyz = tmp0.xyz;
                tmp0.xyz = _WorldSpaceCameraPos - tmp0.xyz;
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord4.xyz = tmp0.www * tmp0.xyz;
                tmp0.xyz = tmp1.xyw * float3(0.5, 0.5, 0.5);
                o.texcoord6.zw = tmp1.zw;
                tmp0.w = tmp0.y * _ProjectionParams.x;
                o.texcoord6.xy = tmp0.zz + tmp0.xw;
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
                float4 tmp3;
                tmp0.xyz = inp.texcoord3.xyz - unity_ShadowFadeCenterAndType.xyz;
                tmp0.x = dot(tmp0.xyz, tmp0.xyz);
                tmp0.x = sqrt(tmp0.x);
                tmp0.yzw = _WorldSpaceCameraPos - inp.texcoord3.xyz;
                tmp1.x = unity_MatrixV._m20;
                tmp1.y = unity_MatrixV._m21;
                tmp1.z = unity_MatrixV._m22;
                tmp0.y = dot(tmp0.xyz, tmp1.xyz);
                tmp0.x = tmp0.x - tmp0.y;
                tmp0.x = unity_ShadowFadeCenterAndType.w * tmp0.x + tmp0.y;
                tmp0.x = saturate(tmp0.x * _LightShadowData.z + _LightShadowData.w);
                tmp0.y = tmp0.x < 1.0;
                tmp0.z = tmp0.x >= 1.0;
                tmp0.yz = tmp0.yz ? 1.0 : 0.0;
                tmp1.xy = inp.texcoord6.xy / inp.texcoord6.ww;
                tmp1 = tex2D(_ShadowMapTexture, tmp1.xy);
                tmp0.y = tmp0.y * tmp1.x + tmp0.z;
                tmp0.y = tmp0.y > 0.5;
                tmp0.x = tmp0.y ? 0.0 : tmp0.x;
                tmp0.y = tmp0.y ? 1.0 : 0.0;
                tmp0.x = tmp0.x + tmp0.y;
                tmp0.y = dot(_WorldSpaceLightPos0.xyz, inp.texcoord2.xyz);
                tmp0.y = tmp0.y - _Tendency;
                tmp0.y = saturate(tmp0.y * 100.0);
                tmp0.z = tmp0.y * -2.0 + 3.0;
                tmp0.y = tmp0.y * tmp0.y;
                tmp0.y = tmp0.y * tmp0.z;
                tmp0.xy = tmp0.xy * float2(_Opacity.x, _SelfShadowOpacity.x);
                tmp0.x = tmp0.x * tmp0.y;
                tmp0.yzw = LightColor.xyz - ShadowColor.xyz;
                tmp0.xyz = tmp0.xxx * tmp0.yzw + ShadowColor.xyz;
                tmp0.w = dot(inp.texcoord4.xyz, inp.texcoord2.xyz);
                tmp1.x = inp.texcoord3.x - inp.texcoord3.y;
                tmp0.w = tmp0.w * 5.0 + tmp1.x;
                tmp0.w = sin(tmp0.w);
                tmp1.xy = tmp0.ww + float2(0.4, 0.1);
                tmp1.xy = floor(tmp1.xy);
                tmp1.xy = max(tmp1.xy, float2(0.0, 0.0));
                tmp2 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0.w = -tmp2.w * _Color.w + 1.0;
                tmp1.yzw = tmp1.yyy * _LightColor0.xyz;
                tmp1 = tmp0.wwww * tmp1;
                tmp3 = tmp2 * _Color;
                tmp3.xyz = tmp1.xxx * tmp3.xyz;
                o.sv_target.w = tmp3.w;
                tmp0.w = sin(inp.texcoord.y);
                tmp0.w = max(tmp0.w, 0.5);
                tmp0.w = tmp0.w * 0.5;
                tmp2.xyz = tmp3.xyz * tmp0.www + tmp2.xyz;
                tmp1.xyz = tmp1.yzw * tmp0.www + tmp2.xyz;
                tmp1.xyz = tmp1.xyz * _LightColor0.xyz;
                tmp2 = tex2D(_Emission, inp.texcoord.xy);
                o.sv_target.xyz = tmp1.xyz * tmp0.xyz + tmp2.xyz;
                return o;
			}
#elif defined(DIRECTIONAL) && defined(LIGHTMAP_ON) && defined(LIGHTMAP_SHADOW_MIXING) && defined(LIGHTPROBE_SH) && !defined(SHADOWS_SCREEN) && !defined(SHADOWS_SHADOWMASK) && !defined(VERTEXLIGHT_ON)
			#include "UnityCG.cginc"
#include "AutoLight.cginc"
			struct v2f
			{
 UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord1 : TEXCOORD1;
				float3 texcoord2 : TEXCOORD2;
				float3 texcoord3 : TEXCOORD3;
				float3 texcoord4 : TEXCOORD4;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 _Color;
			float4 ShadowColor;
			float4 LightColor;
			float _Opacity;
			float _Tendency;
			float _SelfShadowOpacity;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			sampler2D _Emission;
			
			// Keywords: DIRECTIONAL LIGHTPROBE_SH LIGHTMAP_ON LIGHTMAP_SHADOW_MIXING
			v2f vert(appdata_full v)
			{
 UNITY_SETUP_INSTANCE_ID(v);
                v2f o;
 UNITY_TRANSFER_INSTANCE_ID(v, o);
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0 = v.vertex.yyyy * float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
                tmp0 = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]) * v.vertex.xxxx + tmp0;
                tmp0 = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]) * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
                tmp0.xyz = float3(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3]) * v.vertex.www + tmp0.xyz;
                tmp2 = tmp1.yyyy * float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
                tmp2 = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]) * tmp1.xxxx + tmp2;
                tmp2 = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]) * tmp1.zzzz + tmp2;
                o.position = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]) * tmp1.wwww + tmp2;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord1.xy = v.texcoord1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
                tmp1.x = dot(v.normal.xyz, float3(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0]));
                tmp1.y = dot(v.normal.xyz, float3(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1]));
                tmp1.z = dot(v.normal.xyz, float3(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2]));
                tmp0.w = dot(tmp1.xyz, tmp1.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord2.xyz = tmp0.www * tmp1.xyz;
                o.texcoord3.xyz = tmp0.xyz;
                tmp0.xyz = _WorldSpaceCameraPos - tmp0.xyz;
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord4.xyz = tmp0.www * tmp0.xyz;
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
                float4 tmp3;
                tmp0.xyz = inp.texcoord3.xyz - unity_ShadowFadeCenterAndType.xyz;
                tmp0.x = dot(tmp0.xyz, tmp0.xyz);
                tmp0.x = sqrt(tmp0.x);
                tmp0.yzw = _WorldSpaceCameraPos - inp.texcoord3.xyz;
                tmp1.x = unity_MatrixV._m20;
                tmp1.y = unity_MatrixV._m21;
                tmp1.z = unity_MatrixV._m22;
                tmp0.y = dot(tmp0.xyz, tmp1.xyz);
                tmp0.x = tmp0.x - tmp0.y;
                tmp0.x = unity_ShadowFadeCenterAndType.w * tmp0.x + tmp0.y;
                tmp0.x = saturate(tmp0.x * _LightShadowData.z + _LightShadowData.w);
                tmp0.y = tmp0.x < 1.0;
                tmp0.z = tmp0.x >= 1.0;
                tmp0.yz = tmp0.yz ? 1.0 : 0.0;
                tmp0.y = tmp0.z + tmp0.y;
                tmp0.y = tmp0.y > 0.5;
                tmp0.x = tmp0.y ? 0.0 : tmp0.x;
                tmp0.y = tmp0.y ? 1.0 : 0.0;
                tmp0.x = tmp0.x + tmp0.y;
                tmp0.y = dot(_WorldSpaceLightPos0.xyz, inp.texcoord2.xyz);
                tmp0.y = tmp0.y - _Tendency;
                tmp0.y = saturate(tmp0.y * 100.0);
                tmp0.z = tmp0.y * -2.0 + 3.0;
                tmp0.y = tmp0.y * tmp0.y;
                tmp0.y = tmp0.y * tmp0.z;
                tmp0.xy = tmp0.xy * float2(_Opacity.x, _SelfShadowOpacity.x);
                tmp0.x = tmp0.x * tmp0.y;
                tmp0.yzw = LightColor.xyz - ShadowColor.xyz;
                tmp0.xyz = tmp0.xxx * tmp0.yzw + ShadowColor.xyz;
                tmp0.w = dot(inp.texcoord4.xyz, inp.texcoord2.xyz);
                tmp1.x = inp.texcoord3.x - inp.texcoord3.y;
                tmp0.w = tmp0.w * 5.0 + tmp1.x;
                tmp0.w = sin(tmp0.w);
                tmp1.xy = tmp0.ww + float2(0.4, 0.1);
                tmp1.xy = floor(tmp1.xy);
                tmp1.xy = max(tmp1.xy, float2(0.0, 0.0));
                tmp2 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0.w = -tmp2.w * _Color.w + 1.0;
                tmp1.yzw = tmp1.yyy * _LightColor0.xyz;
                tmp1 = tmp0.wwww * tmp1;
                tmp3 = tmp2 * _Color;
                tmp3.xyz = tmp1.xxx * tmp3.xyz;
                o.sv_target.w = tmp3.w;
                tmp0.w = sin(inp.texcoord.y);
                tmp0.w = max(tmp0.w, 0.5);
                tmp0.w = tmp0.w * 0.5;
                tmp2.xyz = tmp3.xyz * tmp0.www + tmp2.xyz;
                tmp1.xyz = tmp1.yzw * tmp0.www + tmp2.xyz;
                tmp1.xyz = tmp1.xyz * _LightColor0.xyz;
                tmp2 = tex2D(_Emission, inp.texcoord.xy);
                o.sv_target.xyz = tmp1.xyz * tmp0.xyz + tmp2.xyz;
                return o;
			}
#elif defined(DIRECTIONAL) && defined(LIGHTMAP_ON) && !defined(LIGHTMAP_SHADOW_MIXING) && defined(LIGHTPROBE_SH) && !defined(SHADOWS_SCREEN) && defined(SHADOWS_SHADOWMASK) && !defined(VERTEXLIGHT_ON)
			#include "UnityCG.cginc"
#include "AutoLight.cginc"
			struct v2f
			{
 UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord1 : TEXCOORD1;
				float3 texcoord2 : TEXCOORD2;
				float3 texcoord3 : TEXCOORD3;
				float3 texcoord4 : TEXCOORD4;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 _Color;
			float4 ShadowColor;
			float4 LightColor;
			float _Opacity;
			float _Tendency;
			float _SelfShadowOpacity;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			sampler2D _Emission;
			
			// Keywords: DIRECTIONAL LIGHTPROBE_SH SHADOWS_SHADOWMASK LIGHTMAP_ON
			v2f vert(appdata_full v)
			{
 UNITY_SETUP_INSTANCE_ID(v);
                v2f o;
 UNITY_TRANSFER_INSTANCE_ID(v, o);
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0 = v.vertex.yyyy * float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
                tmp0 = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]) * v.vertex.xxxx + tmp0;
                tmp0 = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]) * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
                tmp0.xyz = float3(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3]) * v.vertex.www + tmp0.xyz;
                tmp2 = tmp1.yyyy * float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
                tmp2 = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]) * tmp1.xxxx + tmp2;
                tmp2 = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]) * tmp1.zzzz + tmp2;
                o.position = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]) * tmp1.wwww + tmp2;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord1.xy = v.texcoord1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
                tmp1.x = dot(v.normal.xyz, float3(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0]));
                tmp1.y = dot(v.normal.xyz, float3(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1]));
                tmp1.z = dot(v.normal.xyz, float3(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2]));
                tmp0.w = dot(tmp1.xyz, tmp1.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord2.xyz = tmp0.www * tmp1.xyz;
                o.texcoord3.xyz = tmp0.xyz;
                tmp0.xyz = _WorldSpaceCameraPos - tmp0.xyz;
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord4.xyz = tmp0.www * tmp0.xyz;
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
                float4 tmp3;
                tmp0.xyz = inp.texcoord3.xyz - unity_ShadowFadeCenterAndType.xyz;
                tmp0.x = dot(tmp0.xyz, tmp0.xyz);
                tmp0.x = sqrt(tmp0.x);
                tmp0.yzw = _WorldSpaceCameraPos - inp.texcoord3.xyz;
                tmp1.x = unity_MatrixV._m20;
                tmp1.y = unity_MatrixV._m21;
                tmp1.z = unity_MatrixV._m22;
                tmp0.y = dot(tmp0.xyz, tmp1.xyz);
                tmp0.x = tmp0.x - tmp0.y;
                tmp0.x = unity_ShadowFadeCenterAndType.w * tmp0.x + tmp0.y;
                tmp0.x = saturate(tmp0.x * _LightShadowData.z + _LightShadowData.w);
                tmp0.y = tmp0.x < 1.0;
                tmp0.z = tmp0.x >= 1.0;
                tmp0.yz = tmp0.yz ? 1.0 : 0.0;
                tmp0.y = tmp0.z + tmp0.y;
                tmp0.y = tmp0.y > 0.5;
                tmp0.z = tmp0.y ? -1.0 : -0.0;
                tmp1 = UNITY_SAMPLE_TEX2D_SAMPLER(unity_ShadowMask, unity_ShadowMask, inp.texcoord1.xy);
                tmp0.w = saturate(dot(tmp1, unity_OcclusionMaskSelector));
                tmp0.w = tmp0.w > 0.5;
                tmp0.yw = tmp0.yw ? 1.0 : 0.0;
                tmp0.z = tmp0.z + tmp0.w;
                tmp0.x = tmp0.x * tmp0.z + tmp0.y;
                tmp0.y = dot(_WorldSpaceLightPos0.xyz, inp.texcoord2.xyz);
                tmp0.y = tmp0.y - _Tendency;
                tmp0.y = saturate(tmp0.y * 100.0);
                tmp0.z = tmp0.y * -2.0 + 3.0;
                tmp0.y = tmp0.y * tmp0.y;
                tmp0.y = tmp0.y * tmp0.z;
                tmp0.xy = tmp0.xy * float2(_Opacity.x, _SelfShadowOpacity.x);
                tmp0.x = tmp0.x * tmp0.y;
                tmp0.yzw = LightColor.xyz - ShadowColor.xyz;
                tmp0.xyz = tmp0.xxx * tmp0.yzw + ShadowColor.xyz;
                tmp0.w = dot(inp.texcoord4.xyz, inp.texcoord2.xyz);
                tmp1.x = inp.texcoord3.x - inp.texcoord3.y;
                tmp0.w = tmp0.w * 5.0 + tmp1.x;
                tmp0.w = sin(tmp0.w);
                tmp1.xy = tmp0.ww + float2(0.4, 0.1);
                tmp1.xy = floor(tmp1.xy);
                tmp1.xy = max(tmp1.xy, float2(0.0, 0.0));
                tmp2 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0.w = -tmp2.w * _Color.w + 1.0;
                tmp1.yzw = tmp1.yyy * _LightColor0.xyz;
                tmp1 = tmp0.wwww * tmp1;
                tmp3 = tmp2 * _Color;
                tmp3.xyz = tmp1.xxx * tmp3.xyz;
                o.sv_target.w = tmp3.w;
                tmp0.w = sin(inp.texcoord.y);
                tmp0.w = max(tmp0.w, 0.5);
                tmp0.w = tmp0.w * 0.5;
                tmp2.xyz = tmp3.xyz * tmp0.www + tmp2.xyz;
                tmp1.xyz = tmp1.yzw * tmp0.www + tmp2.xyz;
                tmp1.xyz = tmp1.xyz * _LightColor0.xyz;
                tmp2 = tex2D(_Emission, inp.texcoord.xy);
                o.sv_target.xyz = tmp1.xyz * tmp0.xyz + tmp2.xyz;
                return o;
			}
#elif defined(DIRECTIONAL) && defined(LIGHTMAP_ON) && defined(LIGHTMAP_SHADOW_MIXING) && !defined(LIGHTPROBE_SH) && !defined(SHADOWS_SCREEN) && defined(SHADOWS_SHADOWMASK) && !defined(VERTEXLIGHT_ON)
			#include "UnityCG.cginc"
#include "AutoLight.cginc"
			struct v2f
			{
 UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord1 : TEXCOORD1;
				float3 texcoord2 : TEXCOORD2;
				float3 texcoord3 : TEXCOORD3;
				float3 texcoord4 : TEXCOORD4;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 _Color;
			float4 ShadowColor;
			float4 LightColor;
			float _Opacity;
			float _Tendency;
			float _SelfShadowOpacity;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			sampler2D _Emission;
			
			// Keywords: DIRECTIONAL SHADOWS_SHADOWMASK LIGHTMAP_ON LIGHTMAP_SHADOW_MIXING
			v2f vert(appdata_full v)
			{
 UNITY_SETUP_INSTANCE_ID(v);
                v2f o;
 UNITY_TRANSFER_INSTANCE_ID(v, o);
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0 = v.vertex.yyyy * float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
                tmp0 = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]) * v.vertex.xxxx + tmp0;
                tmp0 = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]) * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
                tmp0.xyz = float3(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3]) * v.vertex.www + tmp0.xyz;
                tmp2 = tmp1.yyyy * float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
                tmp2 = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]) * tmp1.xxxx + tmp2;
                tmp2 = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]) * tmp1.zzzz + tmp2;
                o.position = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]) * tmp1.wwww + tmp2;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord1.xy = v.texcoord1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
                tmp1.x = dot(v.normal.xyz, float3(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0]));
                tmp1.y = dot(v.normal.xyz, float3(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1]));
                tmp1.z = dot(v.normal.xyz, float3(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2]));
                tmp0.w = dot(tmp1.xyz, tmp1.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord2.xyz = tmp0.www * tmp1.xyz;
                o.texcoord3.xyz = tmp0.xyz;
                tmp0.xyz = _WorldSpaceCameraPos - tmp0.xyz;
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord4.xyz = tmp0.www * tmp0.xyz;
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
                float4 tmp3;
                tmp0.xyz = inp.texcoord3.xyz - unity_ShadowFadeCenterAndType.xyz;
                tmp0.x = dot(tmp0.xyz, tmp0.xyz);
                tmp0.x = sqrt(tmp0.x);
                tmp0.yzw = _WorldSpaceCameraPos - inp.texcoord3.xyz;
                tmp1.x = unity_MatrixV._m20;
                tmp1.y = unity_MatrixV._m21;
                tmp1.z = unity_MatrixV._m22;
                tmp0.y = dot(tmp0.xyz, tmp1.xyz);
                tmp0.x = tmp0.x - tmp0.y;
                tmp0.x = unity_ShadowFadeCenterAndType.w * tmp0.x + tmp0.y;
                tmp0.x = saturate(tmp0.x * _LightShadowData.z + _LightShadowData.w);
                tmp0.y = tmp0.x < 1.0;
                tmp0.z = tmp0.x >= 1.0;
                tmp0.yz = tmp0.yz ? 1.0 : 0.0;
                tmp0.y = tmp0.z + tmp0.y;
                tmp0.y = tmp0.y > 0.5;
                tmp0.z = tmp0.y ? -1.0 : -0.0;
                tmp1 = UNITY_SAMPLE_TEX2D_SAMPLER(unity_ShadowMask, unity_ShadowMask, inp.texcoord1.xy);
                tmp0.w = saturate(dot(tmp1, unity_OcclusionMaskSelector));
                tmp0.w = tmp0.w > 0.5;
                tmp0.yw = tmp0.yw ? 1.0 : 0.0;
                tmp0.z = tmp0.z + tmp0.w;
                tmp0.x = tmp0.x * tmp0.z + tmp0.y;
                tmp0.y = dot(_WorldSpaceLightPos0.xyz, inp.texcoord2.xyz);
                tmp0.y = tmp0.y - _Tendency;
                tmp0.y = saturate(tmp0.y * 100.0);
                tmp0.z = tmp0.y * -2.0 + 3.0;
                tmp0.y = tmp0.y * tmp0.y;
                tmp0.y = tmp0.y * tmp0.z;
                tmp0.xy = tmp0.xy * float2(_Opacity.x, _SelfShadowOpacity.x);
                tmp0.x = tmp0.x * tmp0.y;
                tmp0.yzw = LightColor.xyz - ShadowColor.xyz;
                tmp0.xyz = tmp0.xxx * tmp0.yzw + ShadowColor.xyz;
                tmp0.w = dot(inp.texcoord4.xyz, inp.texcoord2.xyz);
                tmp1.x = inp.texcoord3.x - inp.texcoord3.y;
                tmp0.w = tmp0.w * 5.0 + tmp1.x;
                tmp0.w = sin(tmp0.w);
                tmp1.xy = tmp0.ww + float2(0.4, 0.1);
                tmp1.xy = floor(tmp1.xy);
                tmp1.xy = max(tmp1.xy, float2(0.0, 0.0));
                tmp2 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0.w = -tmp2.w * _Color.w + 1.0;
                tmp1.yzw = tmp1.yyy * _LightColor0.xyz;
                tmp1 = tmp0.wwww * tmp1;
                tmp3 = tmp2 * _Color;
                tmp3.xyz = tmp1.xxx * tmp3.xyz;
                o.sv_target.w = tmp3.w;
                tmp0.w = sin(inp.texcoord.y);
                tmp0.w = max(tmp0.w, 0.5);
                tmp0.w = tmp0.w * 0.5;
                tmp2.xyz = tmp3.xyz * tmp0.www + tmp2.xyz;
                tmp1.xyz = tmp1.yzw * tmp0.www + tmp2.xyz;
                tmp1.xyz = tmp1.xyz * _LightColor0.xyz;
                tmp2 = tex2D(_Emission, inp.texcoord.xy);
                o.sv_target.xyz = tmp1.xyz * tmp0.xyz + tmp2.xyz;
                return o;
			}
#elif defined(DIRECTIONAL) && !defined(LIGHTMAP_ON) && defined(LIGHTMAP_SHADOW_MIXING) && defined(LIGHTPROBE_SH) && defined(SHADOWS_SCREEN) && !defined(SHADOWS_SHADOWMASK) && !defined(VERTEXLIGHT_ON)
			#include "UnityCG.cginc"
#include "AutoLight.cginc"
			struct v2f
			{
 UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float3 texcoord2 : TEXCOORD2;
				float3 texcoord3 : TEXCOORD3;
				float3 texcoord4 : TEXCOORD4;
				float4 texcoord6 : TEXCOORD6;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 _Color;
			float4 ShadowColor;
			float4 LightColor;
			float _Opacity;
			float _Tendency;
			float _SelfShadowOpacity;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			sampler2D _Emission;
			
			// Keywords: DIRECTIONAL LIGHTPROBE_SH LIGHTMAP_SHADOW_MIXING SHADOWS_SCREEN
			v2f vert(appdata_full v)
			{
 UNITY_SETUP_INSTANCE_ID(v);
                v2f o;
 UNITY_TRANSFER_INSTANCE_ID(v, o);
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0 = v.vertex.yyyy * float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
                tmp0 = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]) * v.vertex.xxxx + tmp0;
                tmp0 = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]) * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
                tmp0.xyz = float3(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3]) * v.vertex.www + tmp0.xyz;
                tmp2 = tmp1.yyyy * float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
                tmp2 = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]) * tmp1.xxxx + tmp2;
                tmp2 = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]) * tmp1.zzzz + tmp2;
                tmp1 = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]) * tmp1.wwww + tmp2;
                o.position = tmp1;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp2.x = dot(v.normal.xyz, float3(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0]));
                tmp2.y = dot(v.normal.xyz, float3(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1]));
                tmp2.z = dot(v.normal.xyz, float3(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2]));
                tmp0.w = dot(tmp2.xyz, tmp2.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord2.xyz = tmp0.www * tmp2.xyz;
                o.texcoord3.xyz = tmp0.xyz;
                tmp0.xyz = _WorldSpaceCameraPos - tmp0.xyz;
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord4.xyz = tmp0.www * tmp0.xyz;
                tmp0.xyz = tmp1.xyw * float3(0.5, 0.5, 0.5);
                o.texcoord6.zw = tmp1.zw;
                tmp0.w = tmp0.y * _ProjectionParams.x;
                o.texcoord6.xy = tmp0.zz + tmp0.xw;
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
                float4 tmp3;
                tmp0.xyz = inp.texcoord3.xyz - unity_ShadowFadeCenterAndType.xyz;
                tmp0.x = dot(tmp0.xyz, tmp0.xyz);
                tmp0.x = sqrt(tmp0.x);
                tmp0.yzw = _WorldSpaceCameraPos - inp.texcoord3.xyz;
                tmp1.x = unity_MatrixV._m20;
                tmp1.y = unity_MatrixV._m21;
                tmp1.z = unity_MatrixV._m22;
                tmp0.y = dot(tmp0.xyz, tmp1.xyz);
                tmp0.x = tmp0.x - tmp0.y;
                tmp0.x = unity_ShadowFadeCenterAndType.w * tmp0.x + tmp0.y;
                tmp0.x = saturate(tmp0.x * _LightShadowData.z + _LightShadowData.w);
                tmp0.y = tmp0.x < 1.0;
                tmp0.z = tmp0.x >= 1.0;
                tmp0.yz = tmp0.yz ? 1.0 : 0.0;
                tmp1.xy = inp.texcoord6.xy / inp.texcoord6.ww;
                tmp1 = tex2D(_ShadowMapTexture, tmp1.xy);
                tmp0.y = tmp0.y * tmp1.x + tmp0.z;
                tmp0.y = tmp0.y > 0.5;
                tmp0.x = tmp0.y ? 0.0 : tmp0.x;
                tmp0.y = tmp0.y ? 1.0 : 0.0;
                tmp0.x = tmp0.x + tmp0.y;
                tmp0.y = dot(_WorldSpaceLightPos0.xyz, inp.texcoord2.xyz);
                tmp0.y = tmp0.y - _Tendency;
                tmp0.y = saturate(tmp0.y * 100.0);
                tmp0.z = tmp0.y * -2.0 + 3.0;
                tmp0.y = tmp0.y * tmp0.y;
                tmp0.y = tmp0.y * tmp0.z;
                tmp0.xy = tmp0.xy * float2(_Opacity.x, _SelfShadowOpacity.x);
                tmp0.x = tmp0.x * tmp0.y;
                tmp0.yzw = LightColor.xyz - ShadowColor.xyz;
                tmp0.xyz = tmp0.xxx * tmp0.yzw + ShadowColor.xyz;
                tmp0.w = dot(inp.texcoord4.xyz, inp.texcoord2.xyz);
                tmp1.x = inp.texcoord3.x - inp.texcoord3.y;
                tmp0.w = tmp0.w * 5.0 + tmp1.x;
                tmp0.w = sin(tmp0.w);
                tmp1.xy = tmp0.ww + float2(0.4, 0.1);
                tmp1.xy = floor(tmp1.xy);
                tmp1.xy = max(tmp1.xy, float2(0.0, 0.0));
                tmp2 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0.w = -tmp2.w * _Color.w + 1.0;
                tmp1.yzw = tmp1.yyy * _LightColor0.xyz;
                tmp1 = tmp0.wwww * tmp1;
                tmp3 = tmp2 * _Color;
                tmp3.xyz = tmp1.xxx * tmp3.xyz;
                o.sv_target.w = tmp3.w;
                tmp0.w = sin(inp.texcoord.y);
                tmp0.w = max(tmp0.w, 0.5);
                tmp0.w = tmp0.w * 0.5;
                tmp2.xyz = tmp3.xyz * tmp0.www + tmp2.xyz;
                tmp1.xyz = tmp1.yzw * tmp0.www + tmp2.xyz;
                tmp1.xyz = tmp1.xyz * _LightColor0.xyz;
                tmp2 = tex2D(_Emission, inp.texcoord.xy);
                o.sv_target.xyz = tmp1.xyz * tmp0.xyz + tmp2.xyz;
                return o;
			}
#elif defined(DIRECTIONAL) && !defined(LIGHTMAP_ON) && !defined(LIGHTMAP_SHADOW_MIXING) && defined(LIGHTPROBE_SH) && defined(SHADOWS_SCREEN) && defined(SHADOWS_SHADOWMASK) && !defined(VERTEXLIGHT_ON)
			#include "UnityCG.cginc"
#include "AutoLight.cginc"
			struct v2f
			{
 UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float3 texcoord2 : TEXCOORD2;
				float3 texcoord3 : TEXCOORD3;
				float3 texcoord4 : TEXCOORD4;
				float4 texcoord6 : TEXCOORD6;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 _Color;
			float4 ShadowColor;
			float4 LightColor;
			float _Opacity;
			float _Tendency;
			float _SelfShadowOpacity;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			sampler2D _Emission;
			
			// Keywords: DIRECTIONAL LIGHTPROBE_SH SHADOWS_SHADOWMASK SHADOWS_SCREEN
			v2f vert(appdata_full v)
			{
 UNITY_SETUP_INSTANCE_ID(v);
                v2f o;
 UNITY_TRANSFER_INSTANCE_ID(v, o);
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0 = v.vertex.yyyy * float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
                tmp0 = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]) * v.vertex.xxxx + tmp0;
                tmp0 = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]) * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
                tmp0.xyz = float3(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3]) * v.vertex.www + tmp0.xyz;
                tmp2 = tmp1.yyyy * float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
                tmp2 = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]) * tmp1.xxxx + tmp2;
                tmp2 = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]) * tmp1.zzzz + tmp2;
                tmp1 = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]) * tmp1.wwww + tmp2;
                o.position = tmp1;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp2.x = dot(v.normal.xyz, float3(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0]));
                tmp2.y = dot(v.normal.xyz, float3(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1]));
                tmp2.z = dot(v.normal.xyz, float3(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2]));
                tmp0.w = dot(tmp2.xyz, tmp2.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord2.xyz = tmp0.www * tmp2.xyz;
                o.texcoord3.xyz = tmp0.xyz;
                tmp0.xyz = _WorldSpaceCameraPos - tmp0.xyz;
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord4.xyz = tmp0.www * tmp0.xyz;
                tmp0.xyz = tmp1.xyw * float3(0.5, 0.5, 0.5);
                o.texcoord6.zw = tmp1.zw;
                tmp0.w = tmp0.y * _ProjectionParams.x;
                o.texcoord6.xy = tmp0.zz + tmp0.xw;
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
                float4 tmp3;
                tmp0.xyz = inp.texcoord3.xyz - unity_ShadowFadeCenterAndType.xyz;
                tmp0.x = dot(tmp0.xyz, tmp0.xyz);
                tmp0.x = sqrt(tmp0.x);
                tmp0.yzw = _WorldSpaceCameraPos - inp.texcoord3.xyz;
                tmp1.x = unity_MatrixV._m20;
                tmp1.y = unity_MatrixV._m21;
                tmp1.z = unity_MatrixV._m22;
                tmp0.y = dot(tmp0.xyz, tmp1.xyz);
                tmp0.x = tmp0.x - tmp0.y;
                tmp0.x = unity_ShadowFadeCenterAndType.w * tmp0.x + tmp0.y;
                tmp0.x = saturate(tmp0.x * _LightShadowData.z + _LightShadowData.w);
                tmp0.y = tmp0.x < 1.0;
                tmp0.z = tmp0.x >= 1.0;
                tmp0.yz = tmp0.yz ? 1.0 : 0.0;
                tmp1.xy = inp.texcoord6.xy / inp.texcoord6.ww;
                tmp1 = tex2D(_ShadowMapTexture, tmp1.xy);
                tmp0.y = tmp0.y * tmp1.x + tmp0.z;
                tmp0.y = tmp0.y > 0.5;
                tmp0.x = tmp0.y ? 0.0 : tmp0.x;
                tmp0.y = tmp0.y ? 1.0 : 0.0;
                tmp0.x = tmp0.x + tmp0.y;
                tmp0.y = dot(_WorldSpaceLightPos0.xyz, inp.texcoord2.xyz);
                tmp0.y = tmp0.y - _Tendency;
                tmp0.y = saturate(tmp0.y * 100.0);
                tmp0.z = tmp0.y * -2.0 + 3.0;
                tmp0.y = tmp0.y * tmp0.y;
                tmp0.y = tmp0.y * tmp0.z;
                tmp0.xy = tmp0.xy * float2(_Opacity.x, _SelfShadowOpacity.x);
                tmp0.x = tmp0.x * tmp0.y;
                tmp0.yzw = LightColor.xyz - ShadowColor.xyz;
                tmp0.xyz = tmp0.xxx * tmp0.yzw + ShadowColor.xyz;
                tmp0.w = dot(inp.texcoord4.xyz, inp.texcoord2.xyz);
                tmp1.x = inp.texcoord3.x - inp.texcoord3.y;
                tmp0.w = tmp0.w * 5.0 + tmp1.x;
                tmp0.w = sin(tmp0.w);
                tmp1.xy = tmp0.ww + float2(0.4, 0.1);
                tmp1.xy = floor(tmp1.xy);
                tmp1.xy = max(tmp1.xy, float2(0.0, 0.0));
                tmp2 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0.w = -tmp2.w * _Color.w + 1.0;
                tmp1.yzw = tmp1.yyy * _LightColor0.xyz;
                tmp1 = tmp0.wwww * tmp1;
                tmp3 = tmp2 * _Color;
                tmp3.xyz = tmp1.xxx * tmp3.xyz;
                o.sv_target.w = tmp3.w;
                tmp0.w = sin(inp.texcoord.y);
                tmp0.w = max(tmp0.w, 0.5);
                tmp0.w = tmp0.w * 0.5;
                tmp2.xyz = tmp3.xyz * tmp0.www + tmp2.xyz;
                tmp1.xyz = tmp1.yzw * tmp0.www + tmp2.xyz;
                tmp1.xyz = tmp1.xyz * _LightColor0.xyz;
                tmp2 = tex2D(_Emission, inp.texcoord.xy);
                o.sv_target.xyz = tmp1.xyz * tmp0.xyz + tmp2.xyz;
                return o;
			}
#elif defined(DIRECTIONAL) && defined(LIGHTMAP_ON) && !defined(LIGHTMAP_SHADOW_MIXING) && defined(LIGHTPROBE_SH) && defined(SHADOWS_SCREEN) && !defined(SHADOWS_SHADOWMASK) && !defined(VERTEXLIGHT_ON)
			#include "UnityCG.cginc"
#include "AutoLight.cginc"
			struct v2f
			{
 UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord1 : TEXCOORD1;
				float3 texcoord2 : TEXCOORD2;
				float3 texcoord3 : TEXCOORD3;
				float3 texcoord4 : TEXCOORD4;
				float4 texcoord6 : TEXCOORD6;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 _Color;
			float4 ShadowColor;
			float4 LightColor;
			float _Opacity;
			float _Tendency;
			float _SelfShadowOpacity;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			sampler2D _Emission;
			
			// Keywords: DIRECTIONAL LIGHTPROBE_SH LIGHTMAP_ON SHADOWS_SCREEN
			v2f vert(appdata_full v)
			{
 UNITY_SETUP_INSTANCE_ID(v);
                v2f o;
 UNITY_TRANSFER_INSTANCE_ID(v, o);
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0 = v.vertex.yyyy * float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
                tmp0 = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]) * v.vertex.xxxx + tmp0;
                tmp0 = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]) * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
                tmp0.xyz = float3(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3]) * v.vertex.www + tmp0.xyz;
                tmp2 = tmp1.yyyy * float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
                tmp2 = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]) * tmp1.xxxx + tmp2;
                tmp2 = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]) * tmp1.zzzz + tmp2;
                tmp1 = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]) * tmp1.wwww + tmp2;
                o.position = tmp1;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord1.xy = v.texcoord1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
                tmp2.x = dot(v.normal.xyz, float3(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0]));
                tmp2.y = dot(v.normal.xyz, float3(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1]));
                tmp2.z = dot(v.normal.xyz, float3(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2]));
                tmp0.w = dot(tmp2.xyz, tmp2.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord2.xyz = tmp0.www * tmp2.xyz;
                o.texcoord3.xyz = tmp0.xyz;
                tmp0.xyz = _WorldSpaceCameraPos - tmp0.xyz;
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord4.xyz = tmp0.www * tmp0.xyz;
                tmp0.xyz = tmp1.xyw * float3(0.5, 0.5, 0.5);
                o.texcoord6.zw = tmp1.zw;
                tmp0.w = tmp0.y * _ProjectionParams.x;
                o.texcoord6.xy = tmp0.zz + tmp0.xw;
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
                float4 tmp3;
                tmp0.xyz = inp.texcoord3.xyz - unity_ShadowFadeCenterAndType.xyz;
                tmp0.x = dot(tmp0.xyz, tmp0.xyz);
                tmp0.x = sqrt(tmp0.x);
                tmp0.yzw = _WorldSpaceCameraPos - inp.texcoord3.xyz;
                tmp1.x = unity_MatrixV._m20;
                tmp1.y = unity_MatrixV._m21;
                tmp1.z = unity_MatrixV._m22;
                tmp0.y = dot(tmp0.xyz, tmp1.xyz);
                tmp0.x = tmp0.x - tmp0.y;
                tmp0.x = unity_ShadowFadeCenterAndType.w * tmp0.x + tmp0.y;
                tmp0.x = saturate(tmp0.x * _LightShadowData.z + _LightShadowData.w);
                tmp0.y = tmp0.x < 1.0;
                tmp0.z = tmp0.x >= 1.0;
                tmp0.yz = tmp0.yz ? 1.0 : 0.0;
                tmp1.xy = inp.texcoord6.xy / inp.texcoord6.ww;
                tmp1 = tex2D(_ShadowMapTexture, tmp1.xy);
                tmp0.y = tmp0.y * tmp1.x + tmp0.z;
                tmp0.y = tmp0.y > 0.5;
                tmp0.x = tmp0.y ? 0.0 : tmp0.x;
                tmp0.y = tmp0.y ? 1.0 : 0.0;
                tmp0.x = tmp0.x + tmp0.y;
                tmp0.y = dot(_WorldSpaceLightPos0.xyz, inp.texcoord2.xyz);
                tmp0.y = tmp0.y - _Tendency;
                tmp0.y = saturate(tmp0.y * 100.0);
                tmp0.z = tmp0.y * -2.0 + 3.0;
                tmp0.y = tmp0.y * tmp0.y;
                tmp0.y = tmp0.y * tmp0.z;
                tmp0.xy = tmp0.xy * float2(_Opacity.x, _SelfShadowOpacity.x);
                tmp0.x = tmp0.x * tmp0.y;
                tmp0.yzw = LightColor.xyz - ShadowColor.xyz;
                tmp0.xyz = tmp0.xxx * tmp0.yzw + ShadowColor.xyz;
                tmp0.w = dot(inp.texcoord4.xyz, inp.texcoord2.xyz);
                tmp1.x = inp.texcoord3.x - inp.texcoord3.y;
                tmp0.w = tmp0.w * 5.0 + tmp1.x;
                tmp0.w = sin(tmp0.w);
                tmp1.xy = tmp0.ww + float2(0.4, 0.1);
                tmp1.xy = floor(tmp1.xy);
                tmp1.xy = max(tmp1.xy, float2(0.0, 0.0));
                tmp2 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0.w = -tmp2.w * _Color.w + 1.0;
                tmp1.yzw = tmp1.yyy * _LightColor0.xyz;
                tmp1 = tmp0.wwww * tmp1;
                tmp3 = tmp2 * _Color;
                tmp3.xyz = tmp1.xxx * tmp3.xyz;
                o.sv_target.w = tmp3.w;
                tmp0.w = sin(inp.texcoord.y);
                tmp0.w = max(tmp0.w, 0.5);
                tmp0.w = tmp0.w * 0.5;
                tmp2.xyz = tmp3.xyz * tmp0.www + tmp2.xyz;
                tmp1.xyz = tmp1.yzw * tmp0.www + tmp2.xyz;
                tmp1.xyz = tmp1.xyz * _LightColor0.xyz;
                tmp2 = tex2D(_Emission, inp.texcoord.xy);
                o.sv_target.xyz = tmp1.xyz * tmp0.xyz + tmp2.xyz;
                return o;
			}
#elif defined(DIRECTIONAL) && defined(LIGHTMAP_ON) && defined(LIGHTMAP_SHADOW_MIXING) && !defined(LIGHTPROBE_SH) && defined(SHADOWS_SCREEN) && !defined(SHADOWS_SHADOWMASK) && !defined(VERTEXLIGHT_ON)
			#include "UnityCG.cginc"
#include "AutoLight.cginc"
			struct v2f
			{
 UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord1 : TEXCOORD1;
				float3 texcoord2 : TEXCOORD2;
				float3 texcoord3 : TEXCOORD3;
				float3 texcoord4 : TEXCOORD4;
				float4 texcoord6 : TEXCOORD6;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 _Color;
			float4 ShadowColor;
			float4 LightColor;
			float _Opacity;
			float _Tendency;
			float _SelfShadowOpacity;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			sampler2D _Emission;
			
			// Keywords: DIRECTIONAL LIGHTMAP_ON LIGHTMAP_SHADOW_MIXING SHADOWS_SCREEN
			v2f vert(appdata_full v)
			{
 UNITY_SETUP_INSTANCE_ID(v);
                v2f o;
 UNITY_TRANSFER_INSTANCE_ID(v, o);
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0 = v.vertex.yyyy * float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
                tmp0 = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]) * v.vertex.xxxx + tmp0;
                tmp0 = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]) * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
                tmp0.xyz = float3(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3]) * v.vertex.www + tmp0.xyz;
                tmp2 = tmp1.yyyy * float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
                tmp2 = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]) * tmp1.xxxx + tmp2;
                tmp2 = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]) * tmp1.zzzz + tmp2;
                tmp1 = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]) * tmp1.wwww + tmp2;
                o.position = tmp1;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord1.xy = v.texcoord1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
                tmp2.x = dot(v.normal.xyz, float3(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0]));
                tmp2.y = dot(v.normal.xyz, float3(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1]));
                tmp2.z = dot(v.normal.xyz, float3(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2]));
                tmp0.w = dot(tmp2.xyz, tmp2.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord2.xyz = tmp0.www * tmp2.xyz;
                o.texcoord3.xyz = tmp0.xyz;
                tmp0.xyz = _WorldSpaceCameraPos - tmp0.xyz;
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord4.xyz = tmp0.www * tmp0.xyz;
                tmp0.xyz = tmp1.xyw * float3(0.5, 0.5, 0.5);
                o.texcoord6.zw = tmp1.zw;
                tmp0.w = tmp0.y * _ProjectionParams.x;
                o.texcoord6.xy = tmp0.zz + tmp0.xw;
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
                float4 tmp3;
                tmp0.xyz = inp.texcoord3.xyz - unity_ShadowFadeCenterAndType.xyz;
                tmp0.x = dot(tmp0.xyz, tmp0.xyz);
                tmp0.x = sqrt(tmp0.x);
                tmp0.yzw = _WorldSpaceCameraPos - inp.texcoord3.xyz;
                tmp1.x = unity_MatrixV._m20;
                tmp1.y = unity_MatrixV._m21;
                tmp1.z = unity_MatrixV._m22;
                tmp0.y = dot(tmp0.xyz, tmp1.xyz);
                tmp0.x = tmp0.x - tmp0.y;
                tmp0.x = unity_ShadowFadeCenterAndType.w * tmp0.x + tmp0.y;
                tmp0.x = saturate(tmp0.x * _LightShadowData.z + _LightShadowData.w);
                tmp0.y = tmp0.x < 1.0;
                tmp0.z = tmp0.x >= 1.0;
                tmp0.yz = tmp0.yz ? 1.0 : 0.0;
                tmp1.xy = inp.texcoord6.xy / inp.texcoord6.ww;
                tmp1 = tex2D(_ShadowMapTexture, tmp1.xy);
                tmp0.y = tmp0.y * tmp1.x + tmp0.z;
                tmp0.y = tmp0.y > 0.5;
                tmp0.x = tmp0.y ? 0.0 : tmp0.x;
                tmp0.y = tmp0.y ? 1.0 : 0.0;
                tmp0.x = tmp0.x + tmp0.y;
                tmp0.y = dot(_WorldSpaceLightPos0.xyz, inp.texcoord2.xyz);
                tmp0.y = tmp0.y - _Tendency;
                tmp0.y = saturate(tmp0.y * 100.0);
                tmp0.z = tmp0.y * -2.0 + 3.0;
                tmp0.y = tmp0.y * tmp0.y;
                tmp0.y = tmp0.y * tmp0.z;
                tmp0.xy = tmp0.xy * float2(_Opacity.x, _SelfShadowOpacity.x);
                tmp0.x = tmp0.x * tmp0.y;
                tmp0.yzw = LightColor.xyz - ShadowColor.xyz;
                tmp0.xyz = tmp0.xxx * tmp0.yzw + ShadowColor.xyz;
                tmp0.w = dot(inp.texcoord4.xyz, inp.texcoord2.xyz);
                tmp1.x = inp.texcoord3.x - inp.texcoord3.y;
                tmp0.w = tmp0.w * 5.0 + tmp1.x;
                tmp0.w = sin(tmp0.w);
                tmp1.xy = tmp0.ww + float2(0.4, 0.1);
                tmp1.xy = floor(tmp1.xy);
                tmp1.xy = max(tmp1.xy, float2(0.0, 0.0));
                tmp2 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0.w = -tmp2.w * _Color.w + 1.0;
                tmp1.yzw = tmp1.yyy * _LightColor0.xyz;
                tmp1 = tmp0.wwww * tmp1;
                tmp3 = tmp2 * _Color;
                tmp3.xyz = tmp1.xxx * tmp3.xyz;
                o.sv_target.w = tmp3.w;
                tmp0.w = sin(inp.texcoord.y);
                tmp0.w = max(tmp0.w, 0.5);
                tmp0.w = tmp0.w * 0.5;
                tmp2.xyz = tmp3.xyz * tmp0.www + tmp2.xyz;
                tmp1.xyz = tmp1.yzw * tmp0.www + tmp2.xyz;
                tmp1.xyz = tmp1.xyz * _LightColor0.xyz;
                tmp2 = tex2D(_Emission, inp.texcoord.xy);
                o.sv_target.xyz = tmp1.xyz * tmp0.xyz + tmp2.xyz;
                return o;
			}
#elif defined(DIRECTIONAL) && defined(LIGHTMAP_ON) && !defined(LIGHTMAP_SHADOW_MIXING) && !defined(LIGHTPROBE_SH) && defined(SHADOWS_SCREEN) && defined(SHADOWS_SHADOWMASK) && !defined(VERTEXLIGHT_ON)
			#include "UnityCG.cginc"
#include "AutoLight.cginc"
			struct v2f
			{
 UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord1 : TEXCOORD1;
				float3 texcoord2 : TEXCOORD2;
				float3 texcoord3 : TEXCOORD3;
				float3 texcoord4 : TEXCOORD4;
				float4 texcoord6 : TEXCOORD6;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 _Color;
			float4 ShadowColor;
			float4 LightColor;
			float _Opacity;
			float _Tendency;
			float _SelfShadowOpacity;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			sampler2D _Emission;
			
			// Keywords: DIRECTIONAL SHADOWS_SHADOWMASK LIGHTMAP_ON SHADOWS_SCREEN
			v2f vert(appdata_full v)
			{
 UNITY_SETUP_INSTANCE_ID(v);
                v2f o;
 UNITY_TRANSFER_INSTANCE_ID(v, o);
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0 = v.vertex.yyyy * float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
                tmp0 = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]) * v.vertex.xxxx + tmp0;
                tmp0 = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]) * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
                tmp0.xyz = float3(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3]) * v.vertex.www + tmp0.xyz;
                tmp2 = tmp1.yyyy * float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
                tmp2 = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]) * tmp1.xxxx + tmp2;
                tmp2 = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]) * tmp1.zzzz + tmp2;
                tmp1 = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]) * tmp1.wwww + tmp2;
                o.position = tmp1;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord1.xy = v.texcoord1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
                tmp2.x = dot(v.normal.xyz, float3(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0]));
                tmp2.y = dot(v.normal.xyz, float3(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1]));
                tmp2.z = dot(v.normal.xyz, float3(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2]));
                tmp0.w = dot(tmp2.xyz, tmp2.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord2.xyz = tmp0.www * tmp2.xyz;
                o.texcoord3.xyz = tmp0.xyz;
                tmp0.xyz = _WorldSpaceCameraPos - tmp0.xyz;
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord4.xyz = tmp0.www * tmp0.xyz;
                tmp0.xyz = tmp1.xyw * float3(0.5, 0.5, 0.5);
                o.texcoord6.zw = tmp1.zw;
                tmp0.w = tmp0.y * _ProjectionParams.x;
                o.texcoord6.xy = tmp0.zz + tmp0.xw;
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
                float4 tmp3;
                tmp0.xyz = inp.texcoord3.xyz - unity_ShadowFadeCenterAndType.xyz;
                tmp0.x = dot(tmp0.xyz, tmp0.xyz);
                tmp0.x = sqrt(tmp0.x);
                tmp0.yzw = _WorldSpaceCameraPos - inp.texcoord3.xyz;
                tmp1.x = unity_MatrixV._m20;
                tmp1.y = unity_MatrixV._m21;
                tmp1.z = unity_MatrixV._m22;
                tmp0.y = dot(tmp0.xyz, tmp1.xyz);
                tmp0.x = tmp0.x - tmp0.y;
                tmp0.x = unity_ShadowFadeCenterAndType.w * tmp0.x + tmp0.y;
                tmp0.x = saturate(tmp0.x * _LightShadowData.z + _LightShadowData.w);
                tmp0.y = tmp0.x < 1.0;
                tmp0.z = tmp0.x >= 1.0;
                tmp0.yz = tmp0.yz ? 1.0 : 0.0;
                tmp1.xy = inp.texcoord6.xy / inp.texcoord6.ww;
                tmp1 = tex2D(_ShadowMapTexture, tmp1.xy);
                tmp0.y = tmp0.y * tmp1.x + tmp0.z;
                tmp0.y = tmp0.y > 0.5;
                tmp0.z = tmp0.y ? -1.0 : -0.0;
                tmp1 = UNITY_SAMPLE_TEX2D_SAMPLER(unity_ShadowMask, unity_ShadowMask, inp.texcoord1.xy);
                tmp0.w = saturate(dot(tmp1, unity_OcclusionMaskSelector));
                tmp0.w = tmp0.w > 0.5;
                tmp0.yw = tmp0.yw ? 1.0 : 0.0;
                tmp0.z = tmp0.z + tmp0.w;
                tmp0.x = tmp0.x * tmp0.z + tmp0.y;
                tmp0.y = dot(_WorldSpaceLightPos0.xyz, inp.texcoord2.xyz);
                tmp0.y = tmp0.y - _Tendency;
                tmp0.y = saturate(tmp0.y * 100.0);
                tmp0.z = tmp0.y * -2.0 + 3.0;
                tmp0.y = tmp0.y * tmp0.y;
                tmp0.y = tmp0.y * tmp0.z;
                tmp0.xy = tmp0.xy * float2(_Opacity.x, _SelfShadowOpacity.x);
                tmp0.x = tmp0.x * tmp0.y;
                tmp0.yzw = LightColor.xyz - ShadowColor.xyz;
                tmp0.xyz = tmp0.xxx * tmp0.yzw + ShadowColor.xyz;
                tmp0.w = dot(inp.texcoord4.xyz, inp.texcoord2.xyz);
                tmp1.x = inp.texcoord3.x - inp.texcoord3.y;
                tmp0.w = tmp0.w * 5.0 + tmp1.x;
                tmp0.w = sin(tmp0.w);
                tmp1.xy = tmp0.ww + float2(0.4, 0.1);
                tmp1.xy = floor(tmp1.xy);
                tmp1.xy = max(tmp1.xy, float2(0.0, 0.0));
                tmp2 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0.w = -tmp2.w * _Color.w + 1.0;
                tmp1.yzw = tmp1.yyy * _LightColor0.xyz;
                tmp1 = tmp0.wwww * tmp1;
                tmp3 = tmp2 * _Color;
                tmp3.xyz = tmp1.xxx * tmp3.xyz;
                o.sv_target.w = tmp3.w;
                tmp0.w = sin(inp.texcoord.y);
                tmp0.w = max(tmp0.w, 0.5);
                tmp0.w = tmp0.w * 0.5;
                tmp2.xyz = tmp3.xyz * tmp0.www + tmp2.xyz;
                tmp1.xyz = tmp1.yzw * tmp0.www + tmp2.xyz;
                tmp1.xyz = tmp1.xyz * _LightColor0.xyz;
                tmp2 = tex2D(_Emission, inp.texcoord.xy);
                o.sv_target.xyz = tmp1.xyz * tmp0.xyz + tmp2.xyz;
                return o;
			}
#elif defined(DIRECTIONAL) && !defined(LIGHTMAP_ON) && !defined(LIGHTMAP_SHADOW_MIXING) && defined(LIGHTPROBE_SH) && defined(SHADOWS_SCREEN) && !defined(SHADOWS_SHADOWMASK) && defined(VERTEXLIGHT_ON)
			#include "UnityCG.cginc"
#include "AutoLight.cginc"
			struct v2f
			{
 UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float3 texcoord2 : TEXCOORD2;
				float3 texcoord3 : TEXCOORD3;
				float3 texcoord4 : TEXCOORD4;
				float4 texcoord6 : TEXCOORD6;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 _Color;
			float4 ShadowColor;
			float4 LightColor;
			float _Opacity;
			float _Tendency;
			float _SelfShadowOpacity;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			sampler2D _Emission;
			
			// Keywords: DIRECTIONAL LIGHTPROBE_SH SHADOWS_SCREEN VERTEXLIGHT_ON
			v2f vert(appdata_full v)
			{
 UNITY_SETUP_INSTANCE_ID(v);
                v2f o;
 UNITY_TRANSFER_INSTANCE_ID(v, o);
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0 = v.vertex.yyyy * float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
                tmp0 = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]) * v.vertex.xxxx + tmp0;
                tmp0 = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]) * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
                tmp0.xyz = float3(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3]) * v.vertex.www + tmp0.xyz;
                tmp2 = tmp1.yyyy * float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
                tmp2 = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]) * tmp1.xxxx + tmp2;
                tmp2 = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]) * tmp1.zzzz + tmp2;
                tmp1 = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]) * tmp1.wwww + tmp2;
                o.position = tmp1;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp2.x = dot(v.normal.xyz, float3(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0]));
                tmp2.y = dot(v.normal.xyz, float3(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1]));
                tmp2.z = dot(v.normal.xyz, float3(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2]));
                tmp0.w = dot(tmp2.xyz, tmp2.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord2.xyz = tmp0.www * tmp2.xyz;
                o.texcoord3.xyz = tmp0.xyz;
                tmp0.xyz = _WorldSpaceCameraPos - tmp0.xyz;
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord4.xyz = tmp0.www * tmp0.xyz;
                tmp0.xyz = tmp1.xyw * float3(0.5, 0.5, 0.5);
                o.texcoord6.zw = tmp1.zw;
                tmp0.w = tmp0.y * _ProjectionParams.x;
                o.texcoord6.xy = tmp0.zz + tmp0.xw;
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
                float4 tmp3;
                tmp0.xyz = inp.texcoord3.xyz - unity_ShadowFadeCenterAndType.xyz;
                tmp0.x = dot(tmp0.xyz, tmp0.xyz);
                tmp0.x = sqrt(tmp0.x);
                tmp0.yzw = _WorldSpaceCameraPos - inp.texcoord3.xyz;
                tmp1.x = unity_MatrixV._m20;
                tmp1.y = unity_MatrixV._m21;
                tmp1.z = unity_MatrixV._m22;
                tmp0.y = dot(tmp0.xyz, tmp1.xyz);
                tmp0.x = tmp0.x - tmp0.y;
                tmp0.x = unity_ShadowFadeCenterAndType.w * tmp0.x + tmp0.y;
                tmp0.x = saturate(tmp0.x * _LightShadowData.z + _LightShadowData.w);
                tmp0.y = tmp0.x < 1.0;
                tmp0.z = tmp0.x >= 1.0;
                tmp0.yz = tmp0.yz ? 1.0 : 0.0;
                tmp1.xy = inp.texcoord6.xy / inp.texcoord6.ww;
                tmp1 = tex2D(_ShadowMapTexture, tmp1.xy);
                tmp0.y = tmp0.y * tmp1.x + tmp0.z;
                tmp0.y = tmp0.y > 0.5;
                tmp0.x = tmp0.y ? 0.0 : tmp0.x;
                tmp0.y = tmp0.y ? 1.0 : 0.0;
                tmp0.x = tmp0.x + tmp0.y;
                tmp0.y = dot(_WorldSpaceLightPos0.xyz, inp.texcoord2.xyz);
                tmp0.y = tmp0.y - _Tendency;
                tmp0.y = saturate(tmp0.y * 100.0);
                tmp0.z = tmp0.y * -2.0 + 3.0;
                tmp0.y = tmp0.y * tmp0.y;
                tmp0.y = tmp0.y * tmp0.z;
                tmp0.xy = tmp0.xy * float2(_Opacity.x, _SelfShadowOpacity.x);
                tmp0.x = tmp0.x * tmp0.y;
                tmp0.yzw = LightColor.xyz - ShadowColor.xyz;
                tmp0.xyz = tmp0.xxx * tmp0.yzw + ShadowColor.xyz;
                tmp0.w = dot(inp.texcoord4.xyz, inp.texcoord2.xyz);
                tmp1.x = inp.texcoord3.x - inp.texcoord3.y;
                tmp0.w = tmp0.w * 5.0 + tmp1.x;
                tmp0.w = sin(tmp0.w);
                tmp1.xy = tmp0.ww + float2(0.4, 0.1);
                tmp1.xy = floor(tmp1.xy);
                tmp1.xy = max(tmp1.xy, float2(0.0, 0.0));
                tmp2 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0.w = -tmp2.w * _Color.w + 1.0;
                tmp1.yzw = tmp1.yyy * _LightColor0.xyz;
                tmp1 = tmp0.wwww * tmp1;
                tmp3 = tmp2 * _Color;
                tmp3.xyz = tmp1.xxx * tmp3.xyz;
                o.sv_target.w = tmp3.w;
                tmp0.w = sin(inp.texcoord.y);
                tmp0.w = max(tmp0.w, 0.5);
                tmp0.w = tmp0.w * 0.5;
                tmp2.xyz = tmp3.xyz * tmp0.www + tmp2.xyz;
                tmp1.xyz = tmp1.yzw * tmp0.www + tmp2.xyz;
                tmp1.xyz = tmp1.xyz * _LightColor0.xyz;
                tmp2 = tex2D(_Emission, inp.texcoord.xy);
                o.sv_target.xyz = tmp1.xyz * tmp0.xyz + tmp2.xyz;
                return o;
			}
#elif defined(DIRECTIONAL) && !defined(LIGHTMAP_ON) && defined(LIGHTMAP_SHADOW_MIXING) && !defined(LIGHTPROBE_SH) && defined(SHADOWS_SCREEN) && !defined(SHADOWS_SHADOWMASK) && defined(VERTEXLIGHT_ON)
			#include "UnityCG.cginc"
#include "AutoLight.cginc"
			struct v2f
			{
 UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float3 texcoord2 : TEXCOORD2;
				float3 texcoord3 : TEXCOORD3;
				float3 texcoord4 : TEXCOORD4;
				float4 texcoord6 : TEXCOORD6;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 _Color;
			float4 ShadowColor;
			float4 LightColor;
			float _Opacity;
			float _Tendency;
			float _SelfShadowOpacity;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			sampler2D _Emission;
			
			// Keywords: DIRECTIONAL LIGHTMAP_SHADOW_MIXING SHADOWS_SCREEN VERTEXLIGHT_ON
			v2f vert(appdata_full v)
			{
 UNITY_SETUP_INSTANCE_ID(v);
                v2f o;
 UNITY_TRANSFER_INSTANCE_ID(v, o);
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0 = v.vertex.yyyy * float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
                tmp0 = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]) * v.vertex.xxxx + tmp0;
                tmp0 = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]) * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
                tmp0.xyz = float3(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3]) * v.vertex.www + tmp0.xyz;
                tmp2 = tmp1.yyyy * float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
                tmp2 = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]) * tmp1.xxxx + tmp2;
                tmp2 = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]) * tmp1.zzzz + tmp2;
                tmp1 = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]) * tmp1.wwww + tmp2;
                o.position = tmp1;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp2.x = dot(v.normal.xyz, float3(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0]));
                tmp2.y = dot(v.normal.xyz, float3(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1]));
                tmp2.z = dot(v.normal.xyz, float3(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2]));
                tmp0.w = dot(tmp2.xyz, tmp2.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord2.xyz = tmp0.www * tmp2.xyz;
                o.texcoord3.xyz = tmp0.xyz;
                tmp0.xyz = _WorldSpaceCameraPos - tmp0.xyz;
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord4.xyz = tmp0.www * tmp0.xyz;
                tmp0.xyz = tmp1.xyw * float3(0.5, 0.5, 0.5);
                o.texcoord6.zw = tmp1.zw;
                tmp0.w = tmp0.y * _ProjectionParams.x;
                o.texcoord6.xy = tmp0.zz + tmp0.xw;
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
                float4 tmp3;
                tmp0.xyz = inp.texcoord3.xyz - unity_ShadowFadeCenterAndType.xyz;
                tmp0.x = dot(tmp0.xyz, tmp0.xyz);
                tmp0.x = sqrt(tmp0.x);
                tmp0.yzw = _WorldSpaceCameraPos - inp.texcoord3.xyz;
                tmp1.x = unity_MatrixV._m20;
                tmp1.y = unity_MatrixV._m21;
                tmp1.z = unity_MatrixV._m22;
                tmp0.y = dot(tmp0.xyz, tmp1.xyz);
                tmp0.x = tmp0.x - tmp0.y;
                tmp0.x = unity_ShadowFadeCenterAndType.w * tmp0.x + tmp0.y;
                tmp0.x = saturate(tmp0.x * _LightShadowData.z + _LightShadowData.w);
                tmp0.y = tmp0.x < 1.0;
                tmp0.z = tmp0.x >= 1.0;
                tmp0.yz = tmp0.yz ? 1.0 : 0.0;
                tmp1.xy = inp.texcoord6.xy / inp.texcoord6.ww;
                tmp1 = tex2D(_ShadowMapTexture, tmp1.xy);
                tmp0.y = tmp0.y * tmp1.x + tmp0.z;
                tmp0.y = tmp0.y > 0.5;
                tmp0.x = tmp0.y ? 0.0 : tmp0.x;
                tmp0.y = tmp0.y ? 1.0 : 0.0;
                tmp0.x = tmp0.x + tmp0.y;
                tmp0.y = dot(_WorldSpaceLightPos0.xyz, inp.texcoord2.xyz);
                tmp0.y = tmp0.y - _Tendency;
                tmp0.y = saturate(tmp0.y * 100.0);
                tmp0.z = tmp0.y * -2.0 + 3.0;
                tmp0.y = tmp0.y * tmp0.y;
                tmp0.y = tmp0.y * tmp0.z;
                tmp0.xy = tmp0.xy * float2(_Opacity.x, _SelfShadowOpacity.x);
                tmp0.x = tmp0.x * tmp0.y;
                tmp0.yzw = LightColor.xyz - ShadowColor.xyz;
                tmp0.xyz = tmp0.xxx * tmp0.yzw + ShadowColor.xyz;
                tmp0.w = dot(inp.texcoord4.xyz, inp.texcoord2.xyz);
                tmp1.x = inp.texcoord3.x - inp.texcoord3.y;
                tmp0.w = tmp0.w * 5.0 + tmp1.x;
                tmp0.w = sin(tmp0.w);
                tmp1.xy = tmp0.ww + float2(0.4, 0.1);
                tmp1.xy = floor(tmp1.xy);
                tmp1.xy = max(tmp1.xy, float2(0.0, 0.0));
                tmp2 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0.w = -tmp2.w * _Color.w + 1.0;
                tmp1.yzw = tmp1.yyy * _LightColor0.xyz;
                tmp1 = tmp0.wwww * tmp1;
                tmp3 = tmp2 * _Color;
                tmp3.xyz = tmp1.xxx * tmp3.xyz;
                o.sv_target.w = tmp3.w;
                tmp0.w = sin(inp.texcoord.y);
                tmp0.w = max(tmp0.w, 0.5);
                tmp0.w = tmp0.w * 0.5;
                tmp2.xyz = tmp3.xyz * tmp0.www + tmp2.xyz;
                tmp1.xyz = tmp1.yzw * tmp0.www + tmp2.xyz;
                tmp1.xyz = tmp1.xyz * _LightColor0.xyz;
                tmp2 = tex2D(_Emission, inp.texcoord.xy);
                o.sv_target.xyz = tmp1.xyz * tmp0.xyz + tmp2.xyz;
                return o;
			}
#elif defined(DIRECTIONAL) && !defined(LIGHTMAP_ON) && !defined(LIGHTMAP_SHADOW_MIXING) && !defined(LIGHTPROBE_SH) && defined(SHADOWS_SCREEN) && defined(SHADOWS_SHADOWMASK) && defined(VERTEXLIGHT_ON)
			#include "UnityCG.cginc"
#include "AutoLight.cginc"
			struct v2f
			{
 UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float3 texcoord2 : TEXCOORD2;
				float3 texcoord3 : TEXCOORD3;
				float3 texcoord4 : TEXCOORD4;
				float4 texcoord6 : TEXCOORD6;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 _Color;
			float4 ShadowColor;
			float4 LightColor;
			float _Opacity;
			float _Tendency;
			float _SelfShadowOpacity;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			sampler2D _Emission;
			
			// Keywords: DIRECTIONAL SHADOWS_SHADOWMASK SHADOWS_SCREEN VERTEXLIGHT_ON
			v2f vert(appdata_full v)
			{
 UNITY_SETUP_INSTANCE_ID(v);
                v2f o;
 UNITY_TRANSFER_INSTANCE_ID(v, o);
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0 = v.vertex.yyyy * float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
                tmp0 = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]) * v.vertex.xxxx + tmp0;
                tmp0 = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]) * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
                tmp0.xyz = float3(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3]) * v.vertex.www + tmp0.xyz;
                tmp2 = tmp1.yyyy * float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
                tmp2 = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]) * tmp1.xxxx + tmp2;
                tmp2 = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]) * tmp1.zzzz + tmp2;
                tmp1 = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]) * tmp1.wwww + tmp2;
                o.position = tmp1;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp2.x = dot(v.normal.xyz, float3(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0]));
                tmp2.y = dot(v.normal.xyz, float3(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1]));
                tmp2.z = dot(v.normal.xyz, float3(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2]));
                tmp0.w = dot(tmp2.xyz, tmp2.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord2.xyz = tmp0.www * tmp2.xyz;
                o.texcoord3.xyz = tmp0.xyz;
                tmp0.xyz = _WorldSpaceCameraPos - tmp0.xyz;
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord4.xyz = tmp0.www * tmp0.xyz;
                tmp0.xyz = tmp1.xyw * float3(0.5, 0.5, 0.5);
                o.texcoord6.zw = tmp1.zw;
                tmp0.w = tmp0.y * _ProjectionParams.x;
                o.texcoord6.xy = tmp0.zz + tmp0.xw;
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
                float4 tmp3;
                tmp0.xyz = inp.texcoord3.xyz - unity_ShadowFadeCenterAndType.xyz;
                tmp0.x = dot(tmp0.xyz, tmp0.xyz);
                tmp0.x = sqrt(tmp0.x);
                tmp0.yzw = _WorldSpaceCameraPos - inp.texcoord3.xyz;
                tmp1.x = unity_MatrixV._m20;
                tmp1.y = unity_MatrixV._m21;
                tmp1.z = unity_MatrixV._m22;
                tmp0.y = dot(tmp0.xyz, tmp1.xyz);
                tmp0.x = tmp0.x - tmp0.y;
                tmp0.x = unity_ShadowFadeCenterAndType.w * tmp0.x + tmp0.y;
                tmp0.x = saturate(tmp0.x * _LightShadowData.z + _LightShadowData.w);
                tmp0.y = tmp0.x < 1.0;
                tmp0.z = tmp0.x >= 1.0;
                tmp0.yz = tmp0.yz ? 1.0 : 0.0;
                tmp1.xy = inp.texcoord6.xy / inp.texcoord6.ww;
                tmp1 = tex2D(_ShadowMapTexture, tmp1.xy);
                tmp0.y = tmp0.y * tmp1.x + tmp0.z;
                tmp0.y = tmp0.y > 0.5;
                tmp0.x = tmp0.y ? 0.0 : tmp0.x;
                tmp0.y = tmp0.y ? 1.0 : 0.0;
                tmp0.x = tmp0.x + tmp0.y;
                tmp0.y = dot(_WorldSpaceLightPos0.xyz, inp.texcoord2.xyz);
                tmp0.y = tmp0.y - _Tendency;
                tmp0.y = saturate(tmp0.y * 100.0);
                tmp0.z = tmp0.y * -2.0 + 3.0;
                tmp0.y = tmp0.y * tmp0.y;
                tmp0.y = tmp0.y * tmp0.z;
                tmp0.xy = tmp0.xy * float2(_Opacity.x, _SelfShadowOpacity.x);
                tmp0.x = tmp0.x * tmp0.y;
                tmp0.yzw = LightColor.xyz - ShadowColor.xyz;
                tmp0.xyz = tmp0.xxx * tmp0.yzw + ShadowColor.xyz;
                tmp0.w = dot(inp.texcoord4.xyz, inp.texcoord2.xyz);
                tmp1.x = inp.texcoord3.x - inp.texcoord3.y;
                tmp0.w = tmp0.w * 5.0 + tmp1.x;
                tmp0.w = sin(tmp0.w);
                tmp1.xy = tmp0.ww + float2(0.4, 0.1);
                tmp1.xy = floor(tmp1.xy);
                tmp1.xy = max(tmp1.xy, float2(0.0, 0.0));
                tmp2 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0.w = -tmp2.w * _Color.w + 1.0;
                tmp1.yzw = tmp1.yyy * _LightColor0.xyz;
                tmp1 = tmp0.wwww * tmp1;
                tmp3 = tmp2 * _Color;
                tmp3.xyz = tmp1.xxx * tmp3.xyz;
                o.sv_target.w = tmp3.w;
                tmp0.w = sin(inp.texcoord.y);
                tmp0.w = max(tmp0.w, 0.5);
                tmp0.w = tmp0.w * 0.5;
                tmp2.xyz = tmp3.xyz * tmp0.www + tmp2.xyz;
                tmp1.xyz = tmp1.yzw * tmp0.www + tmp2.xyz;
                tmp1.xyz = tmp1.xyz * _LightColor0.xyz;
                tmp2 = tex2D(_Emission, inp.texcoord.xy);
                o.sv_target.xyz = tmp1.xyz * tmp0.xyz + tmp2.xyz;
                return o;
			}
#elif defined(DIRECTIONAL) && !defined(LIGHTMAP_ON) && !defined(LIGHTMAP_SHADOW_MIXING) && defined(LIGHTPROBE_SH) && !defined(SHADOWS_SCREEN) && defined(SHADOWS_SHADOWMASK) && !defined(VERTEXLIGHT_ON)
			#include "UnityCG.cginc"
#include "AutoLight.cginc"
			struct v2f
			{
 UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float3 texcoord2 : TEXCOORD2;
				float3 texcoord3 : TEXCOORD3;
				float3 texcoord4 : TEXCOORD4;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 _Color;
			float4 ShadowColor;
			float4 LightColor;
			float _Opacity;
			float _Tendency;
			float _SelfShadowOpacity;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			sampler2D _Emission;
			
			// Keywords: DIRECTIONAL LIGHTPROBE_SH SHADOWS_SHADOWMASK
			v2f vert(appdata_full v)
			{
 UNITY_SETUP_INSTANCE_ID(v);
                v2f o;
 UNITY_TRANSFER_INSTANCE_ID(v, o);
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0 = v.vertex.yyyy * float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
                tmp0 = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]) * v.vertex.xxxx + tmp0;
                tmp0 = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]) * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
                tmp0.xyz = float3(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3]) * v.vertex.www + tmp0.xyz;
                tmp2 = tmp1.yyyy * float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
                tmp2 = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]) * tmp1.xxxx + tmp2;
                tmp2 = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]) * tmp1.zzzz + tmp2;
                o.position = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]) * tmp1.wwww + tmp2;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp1.x = dot(v.normal.xyz, float3(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0]));
                tmp1.y = dot(v.normal.xyz, float3(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1]));
                tmp1.z = dot(v.normal.xyz, float3(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2]));
                tmp0.w = dot(tmp1.xyz, tmp1.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord2.xyz = tmp0.www * tmp1.xyz;
                o.texcoord3.xyz = tmp0.xyz;
                tmp0.xyz = _WorldSpaceCameraPos - tmp0.xyz;
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord4.xyz = tmp0.www * tmp0.xyz;
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
                float4 tmp3;
                tmp0.xyz = inp.texcoord3.xyz - unity_ShadowFadeCenterAndType.xyz;
                tmp0.x = dot(tmp0.xyz, tmp0.xyz);
                tmp0.x = sqrt(tmp0.x);
                tmp0.yzw = _WorldSpaceCameraPos - inp.texcoord3.xyz;
                tmp1.x = unity_MatrixV._m20;
                tmp1.y = unity_MatrixV._m21;
                tmp1.z = unity_MatrixV._m22;
                tmp0.y = dot(tmp0.xyz, tmp1.xyz);
                tmp0.x = tmp0.x - tmp0.y;
                tmp0.x = unity_ShadowFadeCenterAndType.w * tmp0.x + tmp0.y;
                tmp0.x = saturate(tmp0.x * _LightShadowData.z + _LightShadowData.w);
                tmp0.y = tmp0.x < 1.0;
                tmp0.z = tmp0.x >= 1.0;
                tmp0.yz = tmp0.yz ? 1.0 : 0.0;
                tmp0.y = tmp0.z + tmp0.y;
                tmp0.y = tmp0.y > 0.5;
                tmp0.x = tmp0.y ? 0.0 : tmp0.x;
                tmp0.y = tmp0.y ? 1.0 : 0.0;
                tmp0.x = tmp0.x + tmp0.y;
                tmp0.y = dot(_WorldSpaceLightPos0.xyz, inp.texcoord2.xyz);
                tmp0.y = tmp0.y - _Tendency;
                tmp0.y = saturate(tmp0.y * 100.0);
                tmp0.z = tmp0.y * -2.0 + 3.0;
                tmp0.y = tmp0.y * tmp0.y;
                tmp0.y = tmp0.y * tmp0.z;
                tmp0.xy = tmp0.xy * float2(_Opacity.x, _SelfShadowOpacity.x);
                tmp0.x = tmp0.x * tmp0.y;
                tmp0.yzw = LightColor.xyz - ShadowColor.xyz;
                tmp0.xyz = tmp0.xxx * tmp0.yzw + ShadowColor.xyz;
                tmp0.w = dot(inp.texcoord4.xyz, inp.texcoord2.xyz);
                tmp1.x = inp.texcoord3.x - inp.texcoord3.y;
                tmp0.w = tmp0.w * 5.0 + tmp1.x;
                tmp0.w = sin(tmp0.w);
                tmp1.xy = tmp0.ww + float2(0.4, 0.1);
                tmp1.xy = floor(tmp1.xy);
                tmp1.xy = max(tmp1.xy, float2(0.0, 0.0));
                tmp2 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0.w = -tmp2.w * _Color.w + 1.0;
                tmp1.yzw = tmp1.yyy * _LightColor0.xyz;
                tmp1 = tmp0.wwww * tmp1;
                tmp3 = tmp2 * _Color;
                tmp3.xyz = tmp1.xxx * tmp3.xyz;
                o.sv_target.w = tmp3.w;
                tmp0.w = sin(inp.texcoord.y);
                tmp0.w = max(tmp0.w, 0.5);
                tmp0.w = tmp0.w * 0.5;
                tmp2.xyz = tmp3.xyz * tmp0.www + tmp2.xyz;
                tmp1.xyz = tmp1.yzw * tmp0.www + tmp2.xyz;
                tmp1.xyz = tmp1.xyz * _LightColor0.xyz;
                tmp2 = tex2D(_Emission, inp.texcoord.xy);
                o.sv_target.xyz = tmp1.xyz * tmp0.xyz + tmp2.xyz;
                return o;
			}
#elif defined(DIRECTIONAL) && defined(LIGHTMAP_ON) && !defined(LIGHTMAP_SHADOW_MIXING) && defined(LIGHTPROBE_SH) && !defined(SHADOWS_SCREEN) && !defined(SHADOWS_SHADOWMASK) && !defined(VERTEXLIGHT_ON)
			#include "UnityCG.cginc"
#include "AutoLight.cginc"
			struct v2f
			{
 UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord1 : TEXCOORD1;
				float3 texcoord2 : TEXCOORD2;
				float3 texcoord3 : TEXCOORD3;
				float3 texcoord4 : TEXCOORD4;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 _Color;
			float4 ShadowColor;
			float4 LightColor;
			float _Opacity;
			float _Tendency;
			float _SelfShadowOpacity;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			sampler2D _Emission;
			
			// Keywords: DIRECTIONAL LIGHTPROBE_SH LIGHTMAP_ON
			v2f vert(appdata_full v)
			{
 UNITY_SETUP_INSTANCE_ID(v);
                v2f o;
 UNITY_TRANSFER_INSTANCE_ID(v, o);
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0 = v.vertex.yyyy * float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
                tmp0 = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]) * v.vertex.xxxx + tmp0;
                tmp0 = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]) * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
                tmp0.xyz = float3(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3]) * v.vertex.www + tmp0.xyz;
                tmp2 = tmp1.yyyy * float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
                tmp2 = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]) * tmp1.xxxx + tmp2;
                tmp2 = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]) * tmp1.zzzz + tmp2;
                o.position = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]) * tmp1.wwww + tmp2;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord1.xy = v.texcoord1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
                tmp1.x = dot(v.normal.xyz, float3(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0]));
                tmp1.y = dot(v.normal.xyz, float3(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1]));
                tmp1.z = dot(v.normal.xyz, float3(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2]));
                tmp0.w = dot(tmp1.xyz, tmp1.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord2.xyz = tmp0.www * tmp1.xyz;
                o.texcoord3.xyz = tmp0.xyz;
                tmp0.xyz = _WorldSpaceCameraPos - tmp0.xyz;
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord4.xyz = tmp0.www * tmp0.xyz;
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
                float4 tmp3;
                tmp0.xyz = inp.texcoord3.xyz - unity_ShadowFadeCenterAndType.xyz;
                tmp0.x = dot(tmp0.xyz, tmp0.xyz);
                tmp0.x = sqrt(tmp0.x);
                tmp0.yzw = _WorldSpaceCameraPos - inp.texcoord3.xyz;
                tmp1.x = unity_MatrixV._m20;
                tmp1.y = unity_MatrixV._m21;
                tmp1.z = unity_MatrixV._m22;
                tmp0.y = dot(tmp0.xyz, tmp1.xyz);
                tmp0.x = tmp0.x - tmp0.y;
                tmp0.x = unity_ShadowFadeCenterAndType.w * tmp0.x + tmp0.y;
                tmp0.x = saturate(tmp0.x * _LightShadowData.z + _LightShadowData.w);
                tmp0.y = tmp0.x < 1.0;
                tmp0.z = tmp0.x >= 1.0;
                tmp0.yz = tmp0.yz ? 1.0 : 0.0;
                tmp0.y = tmp0.z + tmp0.y;
                tmp0.y = tmp0.y > 0.5;
                tmp0.x = tmp0.y ? 0.0 : tmp0.x;
                tmp0.y = tmp0.y ? 1.0 : 0.0;
                tmp0.x = tmp0.x + tmp0.y;
                tmp0.y = dot(_WorldSpaceLightPos0.xyz, inp.texcoord2.xyz);
                tmp0.y = tmp0.y - _Tendency;
                tmp0.y = saturate(tmp0.y * 100.0);
                tmp0.z = tmp0.y * -2.0 + 3.0;
                tmp0.y = tmp0.y * tmp0.y;
                tmp0.y = tmp0.y * tmp0.z;
                tmp0.xy = tmp0.xy * float2(_Opacity.x, _SelfShadowOpacity.x);
                tmp0.x = tmp0.x * tmp0.y;
                tmp0.yzw = LightColor.xyz - ShadowColor.xyz;
                tmp0.xyz = tmp0.xxx * tmp0.yzw + ShadowColor.xyz;
                tmp0.w = dot(inp.texcoord4.xyz, inp.texcoord2.xyz);
                tmp1.x = inp.texcoord3.x - inp.texcoord3.y;
                tmp0.w = tmp0.w * 5.0 + tmp1.x;
                tmp0.w = sin(tmp0.w);
                tmp1.xy = tmp0.ww + float2(0.4, 0.1);
                tmp1.xy = floor(tmp1.xy);
                tmp1.xy = max(tmp1.xy, float2(0.0, 0.0));
                tmp2 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0.w = -tmp2.w * _Color.w + 1.0;
                tmp1.yzw = tmp1.yyy * _LightColor0.xyz;
                tmp1 = tmp0.wwww * tmp1;
                tmp3 = tmp2 * _Color;
                tmp3.xyz = tmp1.xxx * tmp3.xyz;
                o.sv_target.w = tmp3.w;
                tmp0.w = sin(inp.texcoord.y);
                tmp0.w = max(tmp0.w, 0.5);
                tmp0.w = tmp0.w * 0.5;
                tmp2.xyz = tmp3.xyz * tmp0.www + tmp2.xyz;
                tmp1.xyz = tmp1.yzw * tmp0.www + tmp2.xyz;
                tmp1.xyz = tmp1.xyz * _LightColor0.xyz;
                tmp2 = tex2D(_Emission, inp.texcoord.xy);
                o.sv_target.xyz = tmp1.xyz * tmp0.xyz + tmp2.xyz;
                return o;
			}
#elif defined(DIRECTIONAL) && defined(LIGHTMAP_ON) && defined(LIGHTMAP_SHADOW_MIXING) && !defined(LIGHTPROBE_SH) && !defined(SHADOWS_SCREEN) && !defined(SHADOWS_SHADOWMASK) && !defined(VERTEXLIGHT_ON)
			#include "UnityCG.cginc"
#include "AutoLight.cginc"
			struct v2f
			{
 UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord1 : TEXCOORD1;
				float3 texcoord2 : TEXCOORD2;
				float3 texcoord3 : TEXCOORD3;
				float3 texcoord4 : TEXCOORD4;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 _Color;
			float4 ShadowColor;
			float4 LightColor;
			float _Opacity;
			float _Tendency;
			float _SelfShadowOpacity;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			sampler2D _Emission;
			
			// Keywords: DIRECTIONAL LIGHTMAP_ON LIGHTMAP_SHADOW_MIXING
			v2f vert(appdata_full v)
			{
 UNITY_SETUP_INSTANCE_ID(v);
                v2f o;
 UNITY_TRANSFER_INSTANCE_ID(v, o);
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0 = v.vertex.yyyy * float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
                tmp0 = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]) * v.vertex.xxxx + tmp0;
                tmp0 = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]) * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
                tmp0.xyz = float3(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3]) * v.vertex.www + tmp0.xyz;
                tmp2 = tmp1.yyyy * float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
                tmp2 = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]) * tmp1.xxxx + tmp2;
                tmp2 = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]) * tmp1.zzzz + tmp2;
                o.position = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]) * tmp1.wwww + tmp2;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord1.xy = v.texcoord1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
                tmp1.x = dot(v.normal.xyz, float3(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0]));
                tmp1.y = dot(v.normal.xyz, float3(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1]));
                tmp1.z = dot(v.normal.xyz, float3(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2]));
                tmp0.w = dot(tmp1.xyz, tmp1.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord2.xyz = tmp0.www * tmp1.xyz;
                o.texcoord3.xyz = tmp0.xyz;
                tmp0.xyz = _WorldSpaceCameraPos - tmp0.xyz;
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord4.xyz = tmp0.www * tmp0.xyz;
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
                float4 tmp3;
                tmp0.xyz = inp.texcoord3.xyz - unity_ShadowFadeCenterAndType.xyz;
                tmp0.x = dot(tmp0.xyz, tmp0.xyz);
                tmp0.x = sqrt(tmp0.x);
                tmp0.yzw = _WorldSpaceCameraPos - inp.texcoord3.xyz;
                tmp1.x = unity_MatrixV._m20;
                tmp1.y = unity_MatrixV._m21;
                tmp1.z = unity_MatrixV._m22;
                tmp0.y = dot(tmp0.xyz, tmp1.xyz);
                tmp0.x = tmp0.x - tmp0.y;
                tmp0.x = unity_ShadowFadeCenterAndType.w * tmp0.x + tmp0.y;
                tmp0.x = saturate(tmp0.x * _LightShadowData.z + _LightShadowData.w);
                tmp0.y = tmp0.x < 1.0;
                tmp0.z = tmp0.x >= 1.0;
                tmp0.yz = tmp0.yz ? 1.0 : 0.0;
                tmp0.y = tmp0.z + tmp0.y;
                tmp0.y = tmp0.y > 0.5;
                tmp0.x = tmp0.y ? 0.0 : tmp0.x;
                tmp0.y = tmp0.y ? 1.0 : 0.0;
                tmp0.x = tmp0.x + tmp0.y;
                tmp0.y = dot(_WorldSpaceLightPos0.xyz, inp.texcoord2.xyz);
                tmp0.y = tmp0.y - _Tendency;
                tmp0.y = saturate(tmp0.y * 100.0);
                tmp0.z = tmp0.y * -2.0 + 3.0;
                tmp0.y = tmp0.y * tmp0.y;
                tmp0.y = tmp0.y * tmp0.z;
                tmp0.xy = tmp0.xy * float2(_Opacity.x, _SelfShadowOpacity.x);
                tmp0.x = tmp0.x * tmp0.y;
                tmp0.yzw = LightColor.xyz - ShadowColor.xyz;
                tmp0.xyz = tmp0.xxx * tmp0.yzw + ShadowColor.xyz;
                tmp0.w = dot(inp.texcoord4.xyz, inp.texcoord2.xyz);
                tmp1.x = inp.texcoord3.x - inp.texcoord3.y;
                tmp0.w = tmp0.w * 5.0 + tmp1.x;
                tmp0.w = sin(tmp0.w);
                tmp1.xy = tmp0.ww + float2(0.4, 0.1);
                tmp1.xy = floor(tmp1.xy);
                tmp1.xy = max(tmp1.xy, float2(0.0, 0.0));
                tmp2 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0.w = -tmp2.w * _Color.w + 1.0;
                tmp1.yzw = tmp1.yyy * _LightColor0.xyz;
                tmp1 = tmp0.wwww * tmp1;
                tmp3 = tmp2 * _Color;
                tmp3.xyz = tmp1.xxx * tmp3.xyz;
                o.sv_target.w = tmp3.w;
                tmp0.w = sin(inp.texcoord.y);
                tmp0.w = max(tmp0.w, 0.5);
                tmp0.w = tmp0.w * 0.5;
                tmp2.xyz = tmp3.xyz * tmp0.www + tmp2.xyz;
                tmp1.xyz = tmp1.yzw * tmp0.www + tmp2.xyz;
                tmp1.xyz = tmp1.xyz * _LightColor0.xyz;
                tmp2 = tex2D(_Emission, inp.texcoord.xy);
                o.sv_target.xyz = tmp1.xyz * tmp0.xyz + tmp2.xyz;
                return o;
			}
#elif defined(DIRECTIONAL) && defined(LIGHTMAP_ON) && !defined(LIGHTMAP_SHADOW_MIXING) && !defined(LIGHTPROBE_SH) && !defined(SHADOWS_SCREEN) && defined(SHADOWS_SHADOWMASK) && !defined(VERTEXLIGHT_ON)
			#include "UnityCG.cginc"
#include "AutoLight.cginc"
			struct v2f
			{
 UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord1 : TEXCOORD1;
				float3 texcoord2 : TEXCOORD2;
				float3 texcoord3 : TEXCOORD3;
				float3 texcoord4 : TEXCOORD4;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 _Color;
			float4 ShadowColor;
			float4 LightColor;
			float _Opacity;
			float _Tendency;
			float _SelfShadowOpacity;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			sampler2D _Emission;
			
			// Keywords: DIRECTIONAL SHADOWS_SHADOWMASK LIGHTMAP_ON
			v2f vert(appdata_full v)
			{
 UNITY_SETUP_INSTANCE_ID(v);
                v2f o;
 UNITY_TRANSFER_INSTANCE_ID(v, o);
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0 = v.vertex.yyyy * float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
                tmp0 = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]) * v.vertex.xxxx + tmp0;
                tmp0 = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]) * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
                tmp0.xyz = float3(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3]) * v.vertex.www + tmp0.xyz;
                tmp2 = tmp1.yyyy * float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
                tmp2 = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]) * tmp1.xxxx + tmp2;
                tmp2 = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]) * tmp1.zzzz + tmp2;
                o.position = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]) * tmp1.wwww + tmp2;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord1.xy = v.texcoord1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
                tmp1.x = dot(v.normal.xyz, float3(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0]));
                tmp1.y = dot(v.normal.xyz, float3(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1]));
                tmp1.z = dot(v.normal.xyz, float3(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2]));
                tmp0.w = dot(tmp1.xyz, tmp1.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord2.xyz = tmp0.www * tmp1.xyz;
                o.texcoord3.xyz = tmp0.xyz;
                tmp0.xyz = _WorldSpaceCameraPos - tmp0.xyz;
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord4.xyz = tmp0.www * tmp0.xyz;
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
                float4 tmp3;
                tmp0.xyz = inp.texcoord3.xyz - unity_ShadowFadeCenterAndType.xyz;
                tmp0.x = dot(tmp0.xyz, tmp0.xyz);
                tmp0.x = sqrt(tmp0.x);
                tmp0.yzw = _WorldSpaceCameraPos - inp.texcoord3.xyz;
                tmp1.x = unity_MatrixV._m20;
                tmp1.y = unity_MatrixV._m21;
                tmp1.z = unity_MatrixV._m22;
                tmp0.y = dot(tmp0.xyz, tmp1.xyz);
                tmp0.x = tmp0.x - tmp0.y;
                tmp0.x = unity_ShadowFadeCenterAndType.w * tmp0.x + tmp0.y;
                tmp0.x = saturate(tmp0.x * _LightShadowData.z + _LightShadowData.w);
                tmp0.y = tmp0.x < 1.0;
                tmp0.z = tmp0.x >= 1.0;
                tmp0.yz = tmp0.yz ? 1.0 : 0.0;
                tmp0.y = tmp0.z + tmp0.y;
                tmp0.y = tmp0.y > 0.5;
                tmp0.z = tmp0.y ? -1.0 : -0.0;
                tmp1 = UNITY_SAMPLE_TEX2D_SAMPLER(unity_ShadowMask, unity_ShadowMask, inp.texcoord1.xy);
                tmp0.w = saturate(dot(tmp1, unity_OcclusionMaskSelector));
                tmp0.w = tmp0.w > 0.5;
                tmp0.yw = tmp0.yw ? 1.0 : 0.0;
                tmp0.z = tmp0.z + tmp0.w;
                tmp0.x = tmp0.x * tmp0.z + tmp0.y;
                tmp0.y = dot(_WorldSpaceLightPos0.xyz, inp.texcoord2.xyz);
                tmp0.y = tmp0.y - _Tendency;
                tmp0.y = saturate(tmp0.y * 100.0);
                tmp0.z = tmp0.y * -2.0 + 3.0;
                tmp0.y = tmp0.y * tmp0.y;
                tmp0.y = tmp0.y * tmp0.z;
                tmp0.xy = tmp0.xy * float2(_Opacity.x, _SelfShadowOpacity.x);
                tmp0.x = tmp0.x * tmp0.y;
                tmp0.yzw = LightColor.xyz - ShadowColor.xyz;
                tmp0.xyz = tmp0.xxx * tmp0.yzw + ShadowColor.xyz;
                tmp0.w = dot(inp.texcoord4.xyz, inp.texcoord2.xyz);
                tmp1.x = inp.texcoord3.x - inp.texcoord3.y;
                tmp0.w = tmp0.w * 5.0 + tmp1.x;
                tmp0.w = sin(tmp0.w);
                tmp1.xy = tmp0.ww + float2(0.4, 0.1);
                tmp1.xy = floor(tmp1.xy);
                tmp1.xy = max(tmp1.xy, float2(0.0, 0.0));
                tmp2 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0.w = -tmp2.w * _Color.w + 1.0;
                tmp1.yzw = tmp1.yyy * _LightColor0.xyz;
                tmp1 = tmp0.wwww * tmp1;
                tmp3 = tmp2 * _Color;
                tmp3.xyz = tmp1.xxx * tmp3.xyz;
                o.sv_target.w = tmp3.w;
                tmp0.w = sin(inp.texcoord.y);
                tmp0.w = max(tmp0.w, 0.5);
                tmp0.w = tmp0.w * 0.5;
                tmp2.xyz = tmp3.xyz * tmp0.www + tmp2.xyz;
                tmp1.xyz = tmp1.yzw * tmp0.www + tmp2.xyz;
                tmp1.xyz = tmp1.xyz * _LightColor0.xyz;
                tmp2 = tex2D(_Emission, inp.texcoord.xy);
                o.sv_target.xyz = tmp1.xyz * tmp0.xyz + tmp2.xyz;
                return o;
			}
#elif defined(DIRECTIONAL) && !defined(LIGHTMAP_ON) && !defined(LIGHTMAP_SHADOW_MIXING) && defined(LIGHTPROBE_SH) && defined(SHADOWS_SCREEN) && !defined(SHADOWS_SHADOWMASK) && !defined(VERTEXLIGHT_ON)
			#include "UnityCG.cginc"
#include "AutoLight.cginc"
			struct v2f
			{
 UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float3 texcoord2 : TEXCOORD2;
				float3 texcoord3 : TEXCOORD3;
				float3 texcoord4 : TEXCOORD4;
				float4 texcoord6 : TEXCOORD6;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 _Color;
			float4 ShadowColor;
			float4 LightColor;
			float _Opacity;
			float _Tendency;
			float _SelfShadowOpacity;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			sampler2D _Emission;
			
			// Keywords: DIRECTIONAL LIGHTPROBE_SH SHADOWS_SCREEN
			v2f vert(appdata_full v)
			{
 UNITY_SETUP_INSTANCE_ID(v);
                v2f o;
 UNITY_TRANSFER_INSTANCE_ID(v, o);
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0 = v.vertex.yyyy * float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
                tmp0 = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]) * v.vertex.xxxx + tmp0;
                tmp0 = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]) * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
                tmp0.xyz = float3(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3]) * v.vertex.www + tmp0.xyz;
                tmp2 = tmp1.yyyy * float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
                tmp2 = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]) * tmp1.xxxx + tmp2;
                tmp2 = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]) * tmp1.zzzz + tmp2;
                tmp1 = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]) * tmp1.wwww + tmp2;
                o.position = tmp1;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp2.x = dot(v.normal.xyz, float3(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0]));
                tmp2.y = dot(v.normal.xyz, float3(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1]));
                tmp2.z = dot(v.normal.xyz, float3(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2]));
                tmp0.w = dot(tmp2.xyz, tmp2.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord2.xyz = tmp0.www * tmp2.xyz;
                o.texcoord3.xyz = tmp0.xyz;
                tmp0.xyz = _WorldSpaceCameraPos - tmp0.xyz;
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord4.xyz = tmp0.www * tmp0.xyz;
                tmp0.xyz = tmp1.xyw * float3(0.5, 0.5, 0.5);
                o.texcoord6.zw = tmp1.zw;
                tmp0.w = tmp0.y * _ProjectionParams.x;
                o.texcoord6.xy = tmp0.zz + tmp0.xw;
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
                float4 tmp3;
                tmp0.xyz = inp.texcoord3.xyz - unity_ShadowFadeCenterAndType.xyz;
                tmp0.x = dot(tmp0.xyz, tmp0.xyz);
                tmp0.x = sqrt(tmp0.x);
                tmp0.yzw = _WorldSpaceCameraPos - inp.texcoord3.xyz;
                tmp1.x = unity_MatrixV._m20;
                tmp1.y = unity_MatrixV._m21;
                tmp1.z = unity_MatrixV._m22;
                tmp0.y = dot(tmp0.xyz, tmp1.xyz);
                tmp0.x = tmp0.x - tmp0.y;
                tmp0.x = unity_ShadowFadeCenterAndType.w * tmp0.x + tmp0.y;
                tmp0.x = saturate(tmp0.x * _LightShadowData.z + _LightShadowData.w);
                tmp0.y = tmp0.x < 1.0;
                tmp0.z = tmp0.x >= 1.0;
                tmp0.yz = tmp0.yz ? 1.0 : 0.0;
                tmp1.xy = inp.texcoord6.xy / inp.texcoord6.ww;
                tmp1 = tex2D(_ShadowMapTexture, tmp1.xy);
                tmp0.y = tmp0.y * tmp1.x + tmp0.z;
                tmp0.y = tmp0.y > 0.5;
                tmp0.x = tmp0.y ? 0.0 : tmp0.x;
                tmp0.y = tmp0.y ? 1.0 : 0.0;
                tmp0.x = tmp0.x + tmp0.y;
                tmp0.y = dot(_WorldSpaceLightPos0.xyz, inp.texcoord2.xyz);
                tmp0.y = tmp0.y - _Tendency;
                tmp0.y = saturate(tmp0.y * 100.0);
                tmp0.z = tmp0.y * -2.0 + 3.0;
                tmp0.y = tmp0.y * tmp0.y;
                tmp0.y = tmp0.y * tmp0.z;
                tmp0.xy = tmp0.xy * float2(_Opacity.x, _SelfShadowOpacity.x);
                tmp0.x = tmp0.x * tmp0.y;
                tmp0.yzw = LightColor.xyz - ShadowColor.xyz;
                tmp0.xyz = tmp0.xxx * tmp0.yzw + ShadowColor.xyz;
                tmp0.w = dot(inp.texcoord4.xyz, inp.texcoord2.xyz);
                tmp1.x = inp.texcoord3.x - inp.texcoord3.y;
                tmp0.w = tmp0.w * 5.0 + tmp1.x;
                tmp0.w = sin(tmp0.w);
                tmp1.xy = tmp0.ww + float2(0.4, 0.1);
                tmp1.xy = floor(tmp1.xy);
                tmp1.xy = max(tmp1.xy, float2(0.0, 0.0));
                tmp2 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0.w = -tmp2.w * _Color.w + 1.0;
                tmp1.yzw = tmp1.yyy * _LightColor0.xyz;
                tmp1 = tmp0.wwww * tmp1;
                tmp3 = tmp2 * _Color;
                tmp3.xyz = tmp1.xxx * tmp3.xyz;
                o.sv_target.w = tmp3.w;
                tmp0.w = sin(inp.texcoord.y);
                tmp0.w = max(tmp0.w, 0.5);
                tmp0.w = tmp0.w * 0.5;
                tmp2.xyz = tmp3.xyz * tmp0.www + tmp2.xyz;
                tmp1.xyz = tmp1.yzw * tmp0.www + tmp2.xyz;
                tmp1.xyz = tmp1.xyz * _LightColor0.xyz;
                tmp2 = tex2D(_Emission, inp.texcoord.xy);
                o.sv_target.xyz = tmp1.xyz * tmp0.xyz + tmp2.xyz;
                return o;
			}
#elif defined(DIRECTIONAL) && defined(LIGHTMAP_ON) && !defined(LIGHTMAP_SHADOW_MIXING) && !defined(LIGHTPROBE_SH) && defined(SHADOWS_SCREEN) && !defined(SHADOWS_SHADOWMASK) && !defined(VERTEXLIGHT_ON)
			#include "UnityCG.cginc"
#include "AutoLight.cginc"
			struct v2f
			{
 UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord1 : TEXCOORD1;
				float3 texcoord2 : TEXCOORD2;
				float3 texcoord3 : TEXCOORD3;
				float3 texcoord4 : TEXCOORD4;
				float4 texcoord6 : TEXCOORD6;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 _Color;
			float4 ShadowColor;
			float4 LightColor;
			float _Opacity;
			float _Tendency;
			float _SelfShadowOpacity;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			sampler2D _Emission;
			
			// Keywords: DIRECTIONAL LIGHTMAP_ON SHADOWS_SCREEN
			v2f vert(appdata_full v)
			{
 UNITY_SETUP_INSTANCE_ID(v);
                v2f o;
 UNITY_TRANSFER_INSTANCE_ID(v, o);
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0 = v.vertex.yyyy * float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
                tmp0 = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]) * v.vertex.xxxx + tmp0;
                tmp0 = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]) * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
                tmp0.xyz = float3(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3]) * v.vertex.www + tmp0.xyz;
                tmp2 = tmp1.yyyy * float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
                tmp2 = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]) * tmp1.xxxx + tmp2;
                tmp2 = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]) * tmp1.zzzz + tmp2;
                tmp1 = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]) * tmp1.wwww + tmp2;
                o.position = tmp1;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord1.xy = v.texcoord1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
                tmp2.x = dot(v.normal.xyz, float3(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0]));
                tmp2.y = dot(v.normal.xyz, float3(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1]));
                tmp2.z = dot(v.normal.xyz, float3(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2]));
                tmp0.w = dot(tmp2.xyz, tmp2.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord2.xyz = tmp0.www * tmp2.xyz;
                o.texcoord3.xyz = tmp0.xyz;
                tmp0.xyz = _WorldSpaceCameraPos - tmp0.xyz;
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord4.xyz = tmp0.www * tmp0.xyz;
                tmp0.xyz = tmp1.xyw * float3(0.5, 0.5, 0.5);
                o.texcoord6.zw = tmp1.zw;
                tmp0.w = tmp0.y * _ProjectionParams.x;
                o.texcoord6.xy = tmp0.zz + tmp0.xw;
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
                float4 tmp3;
                tmp0.xyz = inp.texcoord3.xyz - unity_ShadowFadeCenterAndType.xyz;
                tmp0.x = dot(tmp0.xyz, tmp0.xyz);
                tmp0.x = sqrt(tmp0.x);
                tmp0.yzw = _WorldSpaceCameraPos - inp.texcoord3.xyz;
                tmp1.x = unity_MatrixV._m20;
                tmp1.y = unity_MatrixV._m21;
                tmp1.z = unity_MatrixV._m22;
                tmp0.y = dot(tmp0.xyz, tmp1.xyz);
                tmp0.x = tmp0.x - tmp0.y;
                tmp0.x = unity_ShadowFadeCenterAndType.w * tmp0.x + tmp0.y;
                tmp0.x = saturate(tmp0.x * _LightShadowData.z + _LightShadowData.w);
                tmp0.y = tmp0.x < 1.0;
                tmp0.z = tmp0.x >= 1.0;
                tmp0.yz = tmp0.yz ? 1.0 : 0.0;
                tmp1.xy = inp.texcoord6.xy / inp.texcoord6.ww;
                tmp1 = tex2D(_ShadowMapTexture, tmp1.xy);
                tmp0.y = tmp0.y * tmp1.x + tmp0.z;
                tmp0.y = tmp0.y > 0.5;
                tmp0.x = tmp0.y ? 0.0 : tmp0.x;
                tmp0.y = tmp0.y ? 1.0 : 0.0;
                tmp0.x = tmp0.x + tmp0.y;
                tmp0.y = dot(_WorldSpaceLightPos0.xyz, inp.texcoord2.xyz);
                tmp0.y = tmp0.y - _Tendency;
                tmp0.y = saturate(tmp0.y * 100.0);
                tmp0.z = tmp0.y * -2.0 + 3.0;
                tmp0.y = tmp0.y * tmp0.y;
                tmp0.y = tmp0.y * tmp0.z;
                tmp0.xy = tmp0.xy * float2(_Opacity.x, _SelfShadowOpacity.x);
                tmp0.x = tmp0.x * tmp0.y;
                tmp0.yzw = LightColor.xyz - ShadowColor.xyz;
                tmp0.xyz = tmp0.xxx * tmp0.yzw + ShadowColor.xyz;
                tmp0.w = dot(inp.texcoord4.xyz, inp.texcoord2.xyz);
                tmp1.x = inp.texcoord3.x - inp.texcoord3.y;
                tmp0.w = tmp0.w * 5.0 + tmp1.x;
                tmp0.w = sin(tmp0.w);
                tmp1.xy = tmp0.ww + float2(0.4, 0.1);
                tmp1.xy = floor(tmp1.xy);
                tmp1.xy = max(tmp1.xy, float2(0.0, 0.0));
                tmp2 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0.w = -tmp2.w * _Color.w + 1.0;
                tmp1.yzw = tmp1.yyy * _LightColor0.xyz;
                tmp1 = tmp0.wwww * tmp1;
                tmp3 = tmp2 * _Color;
                tmp3.xyz = tmp1.xxx * tmp3.xyz;
                o.sv_target.w = tmp3.w;
                tmp0.w = sin(inp.texcoord.y);
                tmp0.w = max(tmp0.w, 0.5);
                tmp0.w = tmp0.w * 0.5;
                tmp2.xyz = tmp3.xyz * tmp0.www + tmp2.xyz;
                tmp1.xyz = tmp1.yzw * tmp0.www + tmp2.xyz;
                tmp1.xyz = tmp1.xyz * _LightColor0.xyz;
                tmp2 = tex2D(_Emission, inp.texcoord.xy);
                o.sv_target.xyz = tmp1.xyz * tmp0.xyz + tmp2.xyz;
                return o;
			}
#elif defined(DIRECTIONAL) && !defined(LIGHTMAP_ON) && !defined(LIGHTMAP_SHADOW_MIXING) && defined(LIGHTPROBE_SH) && !defined(SHADOWS_SCREEN) && !defined(SHADOWS_SHADOWMASK) && defined(VERTEXLIGHT_ON)
			#include "UnityCG.cginc"
#include "AutoLight.cginc"
			struct v2f
			{
 UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float3 texcoord2 : TEXCOORD2;
				float3 texcoord3 : TEXCOORD3;
				float3 texcoord4 : TEXCOORD4;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 _Color;
			float4 ShadowColor;
			float4 LightColor;
			float _Opacity;
			float _Tendency;
			float _SelfShadowOpacity;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			sampler2D _Emission;
			
			// Keywords: DIRECTIONAL LIGHTPROBE_SH VERTEXLIGHT_ON
			v2f vert(appdata_full v)
			{
 UNITY_SETUP_INSTANCE_ID(v);
                v2f o;
 UNITY_TRANSFER_INSTANCE_ID(v, o);
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0 = v.vertex.yyyy * float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
                tmp0 = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]) * v.vertex.xxxx + tmp0;
                tmp0 = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]) * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
                tmp0.xyz = float3(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3]) * v.vertex.www + tmp0.xyz;
                tmp2 = tmp1.yyyy * float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
                tmp2 = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]) * tmp1.xxxx + tmp2;
                tmp2 = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]) * tmp1.zzzz + tmp2;
                o.position = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]) * tmp1.wwww + tmp2;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp1.x = dot(v.normal.xyz, float3(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0]));
                tmp1.y = dot(v.normal.xyz, float3(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1]));
                tmp1.z = dot(v.normal.xyz, float3(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2]));
                tmp0.w = dot(tmp1.xyz, tmp1.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord2.xyz = tmp0.www * tmp1.xyz;
                o.texcoord3.xyz = tmp0.xyz;
                tmp0.xyz = _WorldSpaceCameraPos - tmp0.xyz;
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord4.xyz = tmp0.www * tmp0.xyz;
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
                float4 tmp3;
                tmp0.xyz = inp.texcoord3.xyz - unity_ShadowFadeCenterAndType.xyz;
                tmp0.x = dot(tmp0.xyz, tmp0.xyz);
                tmp0.x = sqrt(tmp0.x);
                tmp0.yzw = _WorldSpaceCameraPos - inp.texcoord3.xyz;
                tmp1.x = unity_MatrixV._m20;
                tmp1.y = unity_MatrixV._m21;
                tmp1.z = unity_MatrixV._m22;
                tmp0.y = dot(tmp0.xyz, tmp1.xyz);
                tmp0.x = tmp0.x - tmp0.y;
                tmp0.x = unity_ShadowFadeCenterAndType.w * tmp0.x + tmp0.y;
                tmp0.x = saturate(tmp0.x * _LightShadowData.z + _LightShadowData.w);
                tmp0.y = tmp0.x < 1.0;
                tmp0.z = tmp0.x >= 1.0;
                tmp0.yz = tmp0.yz ? 1.0 : 0.0;
                tmp0.y = tmp0.z + tmp0.y;
                tmp0.y = tmp0.y > 0.5;
                tmp0.x = tmp0.y ? 0.0 : tmp0.x;
                tmp0.y = tmp0.y ? 1.0 : 0.0;
                tmp0.x = tmp0.x + tmp0.y;
                tmp0.y = dot(_WorldSpaceLightPos0.xyz, inp.texcoord2.xyz);
                tmp0.y = tmp0.y - _Tendency;
                tmp0.y = saturate(tmp0.y * 100.0);
                tmp0.z = tmp0.y * -2.0 + 3.0;
                tmp0.y = tmp0.y * tmp0.y;
                tmp0.y = tmp0.y * tmp0.z;
                tmp0.xy = tmp0.xy * float2(_Opacity.x, _SelfShadowOpacity.x);
                tmp0.x = tmp0.x * tmp0.y;
                tmp0.yzw = LightColor.xyz - ShadowColor.xyz;
                tmp0.xyz = tmp0.xxx * tmp0.yzw + ShadowColor.xyz;
                tmp0.w = dot(inp.texcoord4.xyz, inp.texcoord2.xyz);
                tmp1.x = inp.texcoord3.x - inp.texcoord3.y;
                tmp0.w = tmp0.w * 5.0 + tmp1.x;
                tmp0.w = sin(tmp0.w);
                tmp1.xy = tmp0.ww + float2(0.4, 0.1);
                tmp1.xy = floor(tmp1.xy);
                tmp1.xy = max(tmp1.xy, float2(0.0, 0.0));
                tmp2 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0.w = -tmp2.w * _Color.w + 1.0;
                tmp1.yzw = tmp1.yyy * _LightColor0.xyz;
                tmp1 = tmp0.wwww * tmp1;
                tmp3 = tmp2 * _Color;
                tmp3.xyz = tmp1.xxx * tmp3.xyz;
                o.sv_target.w = tmp3.w;
                tmp0.w = sin(inp.texcoord.y);
                tmp0.w = max(tmp0.w, 0.5);
                tmp0.w = tmp0.w * 0.5;
                tmp2.xyz = tmp3.xyz * tmp0.www + tmp2.xyz;
                tmp1.xyz = tmp1.yzw * tmp0.www + tmp2.xyz;
                tmp1.xyz = tmp1.xyz * _LightColor0.xyz;
                tmp2 = tex2D(_Emission, inp.texcoord.xy);
                o.sv_target.xyz = tmp1.xyz * tmp0.xyz + tmp2.xyz;
                return o;
			}
#elif defined(DIRECTIONAL) && !defined(LIGHTMAP_ON) && !defined(LIGHTMAP_SHADOW_MIXING) && !defined(LIGHTPROBE_SH) && defined(SHADOWS_SCREEN) && !defined(SHADOWS_SHADOWMASK) && defined(VERTEXLIGHT_ON)
			#include "UnityCG.cginc"
#include "AutoLight.cginc"
			struct v2f
			{
 UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float3 texcoord2 : TEXCOORD2;
				float3 texcoord3 : TEXCOORD3;
				float3 texcoord4 : TEXCOORD4;
				float4 texcoord6 : TEXCOORD6;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 _Color;
			float4 ShadowColor;
			float4 LightColor;
			float _Opacity;
			float _Tendency;
			float _SelfShadowOpacity;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			sampler2D _Emission;
			
			// Keywords: DIRECTIONAL SHADOWS_SCREEN VERTEXLIGHT_ON
			v2f vert(appdata_full v)
			{
 UNITY_SETUP_INSTANCE_ID(v);
                v2f o;
 UNITY_TRANSFER_INSTANCE_ID(v, o);
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0 = v.vertex.yyyy * float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
                tmp0 = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]) * v.vertex.xxxx + tmp0;
                tmp0 = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]) * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
                tmp0.xyz = float3(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3]) * v.vertex.www + tmp0.xyz;
                tmp2 = tmp1.yyyy * float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
                tmp2 = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]) * tmp1.xxxx + tmp2;
                tmp2 = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]) * tmp1.zzzz + tmp2;
                tmp1 = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]) * tmp1.wwww + tmp2;
                o.position = tmp1;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp2.x = dot(v.normal.xyz, float3(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0]));
                tmp2.y = dot(v.normal.xyz, float3(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1]));
                tmp2.z = dot(v.normal.xyz, float3(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2]));
                tmp0.w = dot(tmp2.xyz, tmp2.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord2.xyz = tmp0.www * tmp2.xyz;
                o.texcoord3.xyz = tmp0.xyz;
                tmp0.xyz = _WorldSpaceCameraPos - tmp0.xyz;
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord4.xyz = tmp0.www * tmp0.xyz;
                tmp0.xyz = tmp1.xyw * float3(0.5, 0.5, 0.5);
                o.texcoord6.zw = tmp1.zw;
                tmp0.w = tmp0.y * _ProjectionParams.x;
                o.texcoord6.xy = tmp0.zz + tmp0.xw;
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
                float4 tmp3;
                tmp0.xyz = inp.texcoord3.xyz - unity_ShadowFadeCenterAndType.xyz;
                tmp0.x = dot(tmp0.xyz, tmp0.xyz);
                tmp0.x = sqrt(tmp0.x);
                tmp0.yzw = _WorldSpaceCameraPos - inp.texcoord3.xyz;
                tmp1.x = unity_MatrixV._m20;
                tmp1.y = unity_MatrixV._m21;
                tmp1.z = unity_MatrixV._m22;
                tmp0.y = dot(tmp0.xyz, tmp1.xyz);
                tmp0.x = tmp0.x - tmp0.y;
                tmp0.x = unity_ShadowFadeCenterAndType.w * tmp0.x + tmp0.y;
                tmp0.x = saturate(tmp0.x * _LightShadowData.z + _LightShadowData.w);
                tmp0.y = tmp0.x < 1.0;
                tmp0.z = tmp0.x >= 1.0;
                tmp0.yz = tmp0.yz ? 1.0 : 0.0;
                tmp1.xy = inp.texcoord6.xy / inp.texcoord6.ww;
                tmp1 = tex2D(_ShadowMapTexture, tmp1.xy);
                tmp0.y = tmp0.y * tmp1.x + tmp0.z;
                tmp0.y = tmp0.y > 0.5;
                tmp0.x = tmp0.y ? 0.0 : tmp0.x;
                tmp0.y = tmp0.y ? 1.0 : 0.0;
                tmp0.x = tmp0.x + tmp0.y;
                tmp0.y = dot(_WorldSpaceLightPos0.xyz, inp.texcoord2.xyz);
                tmp0.y = tmp0.y - _Tendency;
                tmp0.y = saturate(tmp0.y * 100.0);
                tmp0.z = tmp0.y * -2.0 + 3.0;
                tmp0.y = tmp0.y * tmp0.y;
                tmp0.y = tmp0.y * tmp0.z;
                tmp0.xy = tmp0.xy * float2(_Opacity.x, _SelfShadowOpacity.x);
                tmp0.x = tmp0.x * tmp0.y;
                tmp0.yzw = LightColor.xyz - ShadowColor.xyz;
                tmp0.xyz = tmp0.xxx * tmp0.yzw + ShadowColor.xyz;
                tmp0.w = dot(inp.texcoord4.xyz, inp.texcoord2.xyz);
                tmp1.x = inp.texcoord3.x - inp.texcoord3.y;
                tmp0.w = tmp0.w * 5.0 + tmp1.x;
                tmp0.w = sin(tmp0.w);
                tmp1.xy = tmp0.ww + float2(0.4, 0.1);
                tmp1.xy = floor(tmp1.xy);
                tmp1.xy = max(tmp1.xy, float2(0.0, 0.0));
                tmp2 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0.w = -tmp2.w * _Color.w + 1.0;
                tmp1.yzw = tmp1.yyy * _LightColor0.xyz;
                tmp1 = tmp0.wwww * tmp1;
                tmp3 = tmp2 * _Color;
                tmp3.xyz = tmp1.xxx * tmp3.xyz;
                o.sv_target.w = tmp3.w;
                tmp0.w = sin(inp.texcoord.y);
                tmp0.w = max(tmp0.w, 0.5);
                tmp0.w = tmp0.w * 0.5;
                tmp2.xyz = tmp3.xyz * tmp0.www + tmp2.xyz;
                tmp1.xyz = tmp1.yzw * tmp0.www + tmp2.xyz;
                tmp1.xyz = tmp1.xyz * _LightColor0.xyz;
                tmp2 = tex2D(_Emission, inp.texcoord.xy);
                o.sv_target.xyz = tmp1.xyz * tmp0.xyz + tmp2.xyz;
                return o;
			}
#elif defined(DIRECTIONAL) && !defined(LIGHTMAP_ON) && !defined(LIGHTMAP_SHADOW_MIXING) && defined(LIGHTPROBE_SH) && !defined(SHADOWS_SCREEN) && !defined(SHADOWS_SHADOWMASK) && !defined(VERTEXLIGHT_ON)
			#include "UnityCG.cginc"
#include "AutoLight.cginc"
			struct v2f
			{
 UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float3 texcoord2 : TEXCOORD2;
				float3 texcoord3 : TEXCOORD3;
				float3 texcoord4 : TEXCOORD4;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 _Color;
			float4 ShadowColor;
			float4 LightColor;
			float _Opacity;
			float _Tendency;
			float _SelfShadowOpacity;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			sampler2D _Emission;
			
			// Keywords: DIRECTIONAL LIGHTPROBE_SH
			v2f vert(appdata_full v)
			{
 UNITY_SETUP_INSTANCE_ID(v);
                v2f o;
 UNITY_TRANSFER_INSTANCE_ID(v, o);
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0 = v.vertex.yyyy * float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
                tmp0 = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]) * v.vertex.xxxx + tmp0;
                tmp0 = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]) * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
                tmp0.xyz = float3(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3]) * v.vertex.www + tmp0.xyz;
                tmp2 = tmp1.yyyy * float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
                tmp2 = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]) * tmp1.xxxx + tmp2;
                tmp2 = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]) * tmp1.zzzz + tmp2;
                o.position = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]) * tmp1.wwww + tmp2;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp1.x = dot(v.normal.xyz, float3(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0]));
                tmp1.y = dot(v.normal.xyz, float3(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1]));
                tmp1.z = dot(v.normal.xyz, float3(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2]));
                tmp0.w = dot(tmp1.xyz, tmp1.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord2.xyz = tmp0.www * tmp1.xyz;
                o.texcoord3.xyz = tmp0.xyz;
                tmp0.xyz = _WorldSpaceCameraPos - tmp0.xyz;
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord4.xyz = tmp0.www * tmp0.xyz;
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
                float4 tmp3;
                tmp0.xyz = inp.texcoord3.xyz - unity_ShadowFadeCenterAndType.xyz;
                tmp0.x = dot(tmp0.xyz, tmp0.xyz);
                tmp0.x = sqrt(tmp0.x);
                tmp0.yzw = _WorldSpaceCameraPos - inp.texcoord3.xyz;
                tmp1.x = unity_MatrixV._m20;
                tmp1.y = unity_MatrixV._m21;
                tmp1.z = unity_MatrixV._m22;
                tmp0.y = dot(tmp0.xyz, tmp1.xyz);
                tmp0.x = tmp0.x - tmp0.y;
                tmp0.x = unity_ShadowFadeCenterAndType.w * tmp0.x + tmp0.y;
                tmp0.x = saturate(tmp0.x * _LightShadowData.z + _LightShadowData.w);
                tmp0.y = tmp0.x < 1.0;
                tmp0.z = tmp0.x >= 1.0;
                tmp0.yz = tmp0.yz ? 1.0 : 0.0;
                tmp0.y = tmp0.z + tmp0.y;
                tmp0.y = tmp0.y > 0.5;
                tmp0.x = tmp0.y ? 0.0 : tmp0.x;
                tmp0.y = tmp0.y ? 1.0 : 0.0;
                tmp0.x = tmp0.x + tmp0.y;
                tmp0.y = dot(_WorldSpaceLightPos0.xyz, inp.texcoord2.xyz);
                tmp0.y = tmp0.y - _Tendency;
                tmp0.y = saturate(tmp0.y * 100.0);
                tmp0.z = tmp0.y * -2.0 + 3.0;
                tmp0.y = tmp0.y * tmp0.y;
                tmp0.y = tmp0.y * tmp0.z;
                tmp0.xy = tmp0.xy * float2(_Opacity.x, _SelfShadowOpacity.x);
                tmp0.x = tmp0.x * tmp0.y;
                tmp0.yzw = LightColor.xyz - ShadowColor.xyz;
                tmp0.xyz = tmp0.xxx * tmp0.yzw + ShadowColor.xyz;
                tmp0.w = dot(inp.texcoord4.xyz, inp.texcoord2.xyz);
                tmp1.x = inp.texcoord3.x - inp.texcoord3.y;
                tmp0.w = tmp0.w * 5.0 + tmp1.x;
                tmp0.w = sin(tmp0.w);
                tmp1.xy = tmp0.ww + float2(0.4, 0.1);
                tmp1.xy = floor(tmp1.xy);
                tmp1.xy = max(tmp1.xy, float2(0.0, 0.0));
                tmp2 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0.w = -tmp2.w * _Color.w + 1.0;
                tmp1.yzw = tmp1.yyy * _LightColor0.xyz;
                tmp1 = tmp0.wwww * tmp1;
                tmp3 = tmp2 * _Color;
                tmp3.xyz = tmp1.xxx * tmp3.xyz;
                o.sv_target.w = tmp3.w;
                tmp0.w = sin(inp.texcoord.y);
                tmp0.w = max(tmp0.w, 0.5);
                tmp0.w = tmp0.w * 0.5;
                tmp2.xyz = tmp3.xyz * tmp0.www + tmp2.xyz;
                tmp1.xyz = tmp1.yzw * tmp0.www + tmp2.xyz;
                tmp1.xyz = tmp1.xyz * _LightColor0.xyz;
                tmp2 = tex2D(_Emission, inp.texcoord.xy);
                o.sv_target.xyz = tmp1.xyz * tmp0.xyz + tmp2.xyz;
                return o;
			}
#elif defined(DIRECTIONAL) && defined(LIGHTMAP_ON) && !defined(LIGHTMAP_SHADOW_MIXING) && !defined(LIGHTPROBE_SH) && !defined(SHADOWS_SCREEN) && !defined(SHADOWS_SHADOWMASK) && !defined(VERTEXLIGHT_ON)
			#include "UnityCG.cginc"
#include "AutoLight.cginc"
			struct v2f
			{
 UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord1 : TEXCOORD1;
				float3 texcoord2 : TEXCOORD2;
				float3 texcoord3 : TEXCOORD3;
				float3 texcoord4 : TEXCOORD4;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 _Color;
			float4 ShadowColor;
			float4 LightColor;
			float _Opacity;
			float _Tendency;
			float _SelfShadowOpacity;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			sampler2D _Emission;
			
			// Keywords: DIRECTIONAL LIGHTMAP_ON
			v2f vert(appdata_full v)
			{
 UNITY_SETUP_INSTANCE_ID(v);
                v2f o;
 UNITY_TRANSFER_INSTANCE_ID(v, o);
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0 = v.vertex.yyyy * float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
                tmp0 = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]) * v.vertex.xxxx + tmp0;
                tmp0 = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]) * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
                tmp0.xyz = float3(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3]) * v.vertex.www + tmp0.xyz;
                tmp2 = tmp1.yyyy * float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
                tmp2 = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]) * tmp1.xxxx + tmp2;
                tmp2 = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]) * tmp1.zzzz + tmp2;
                o.position = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]) * tmp1.wwww + tmp2;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord1.xy = v.texcoord1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
                tmp1.x = dot(v.normal.xyz, float3(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0]));
                tmp1.y = dot(v.normal.xyz, float3(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1]));
                tmp1.z = dot(v.normal.xyz, float3(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2]));
                tmp0.w = dot(tmp1.xyz, tmp1.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord2.xyz = tmp0.www * tmp1.xyz;
                o.texcoord3.xyz = tmp0.xyz;
                tmp0.xyz = _WorldSpaceCameraPos - tmp0.xyz;
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord4.xyz = tmp0.www * tmp0.xyz;
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
                float4 tmp3;
                tmp0.xyz = inp.texcoord3.xyz - unity_ShadowFadeCenterAndType.xyz;
                tmp0.x = dot(tmp0.xyz, tmp0.xyz);
                tmp0.x = sqrt(tmp0.x);
                tmp0.yzw = _WorldSpaceCameraPos - inp.texcoord3.xyz;
                tmp1.x = unity_MatrixV._m20;
                tmp1.y = unity_MatrixV._m21;
                tmp1.z = unity_MatrixV._m22;
                tmp0.y = dot(tmp0.xyz, tmp1.xyz);
                tmp0.x = tmp0.x - tmp0.y;
                tmp0.x = unity_ShadowFadeCenterAndType.w * tmp0.x + tmp0.y;
                tmp0.x = saturate(tmp0.x * _LightShadowData.z + _LightShadowData.w);
                tmp0.y = tmp0.x < 1.0;
                tmp0.z = tmp0.x >= 1.0;
                tmp0.yz = tmp0.yz ? 1.0 : 0.0;
                tmp0.y = tmp0.z + tmp0.y;
                tmp0.y = tmp0.y > 0.5;
                tmp0.x = tmp0.y ? 0.0 : tmp0.x;
                tmp0.y = tmp0.y ? 1.0 : 0.0;
                tmp0.x = tmp0.x + tmp0.y;
                tmp0.y = dot(_WorldSpaceLightPos0.xyz, inp.texcoord2.xyz);
                tmp0.y = tmp0.y - _Tendency;
                tmp0.y = saturate(tmp0.y * 100.0);
                tmp0.z = tmp0.y * -2.0 + 3.0;
                tmp0.y = tmp0.y * tmp0.y;
                tmp0.y = tmp0.y * tmp0.z;
                tmp0.xy = tmp0.xy * float2(_Opacity.x, _SelfShadowOpacity.x);
                tmp0.x = tmp0.x * tmp0.y;
                tmp0.yzw = LightColor.xyz - ShadowColor.xyz;
                tmp0.xyz = tmp0.xxx * tmp0.yzw + ShadowColor.xyz;
                tmp0.w = dot(inp.texcoord4.xyz, inp.texcoord2.xyz);
                tmp1.x = inp.texcoord3.x - inp.texcoord3.y;
                tmp0.w = tmp0.w * 5.0 + tmp1.x;
                tmp0.w = sin(tmp0.w);
                tmp1.xy = tmp0.ww + float2(0.4, 0.1);
                tmp1.xy = floor(tmp1.xy);
                tmp1.xy = max(tmp1.xy, float2(0.0, 0.0));
                tmp2 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0.w = -tmp2.w * _Color.w + 1.0;
                tmp1.yzw = tmp1.yyy * _LightColor0.xyz;
                tmp1 = tmp0.wwww * tmp1;
                tmp3 = tmp2 * _Color;
                tmp3.xyz = tmp1.xxx * tmp3.xyz;
                o.sv_target.w = tmp3.w;
                tmp0.w = sin(inp.texcoord.y);
                tmp0.w = max(tmp0.w, 0.5);
                tmp0.w = tmp0.w * 0.5;
                tmp2.xyz = tmp3.xyz * tmp0.www + tmp2.xyz;
                tmp1.xyz = tmp1.yzw * tmp0.www + tmp2.xyz;
                tmp1.xyz = tmp1.xyz * _LightColor0.xyz;
                tmp2 = tex2D(_Emission, inp.texcoord.xy);
                o.sv_target.xyz = tmp1.xyz * tmp0.xyz + tmp2.xyz;
                return o;
			}
#elif defined(DIRECTIONAL) && !defined(LIGHTMAP_ON) && !defined(LIGHTMAP_SHADOW_MIXING) && !defined(LIGHTPROBE_SH) && defined(SHADOWS_SCREEN) && !defined(SHADOWS_SHADOWMASK) && !defined(VERTEXLIGHT_ON)
			#include "UnityCG.cginc"
#include "AutoLight.cginc"
			struct v2f
			{
 UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float3 texcoord2 : TEXCOORD2;
				float3 texcoord3 : TEXCOORD3;
				float3 texcoord4 : TEXCOORD4;
				float4 texcoord6 : TEXCOORD6;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 _Color;
			float4 ShadowColor;
			float4 LightColor;
			float _Opacity;
			float _Tendency;
			float _SelfShadowOpacity;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			sampler2D _Emission;
			
			// Keywords: DIRECTIONAL SHADOWS_SCREEN
			v2f vert(appdata_full v)
			{
 UNITY_SETUP_INSTANCE_ID(v);
                v2f o;
 UNITY_TRANSFER_INSTANCE_ID(v, o);
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0 = v.vertex.yyyy * float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
                tmp0 = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]) * v.vertex.xxxx + tmp0;
                tmp0 = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]) * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
                tmp0.xyz = float3(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3]) * v.vertex.www + tmp0.xyz;
                tmp2 = tmp1.yyyy * float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
                tmp2 = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]) * tmp1.xxxx + tmp2;
                tmp2 = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]) * tmp1.zzzz + tmp2;
                tmp1 = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]) * tmp1.wwww + tmp2;
                o.position = tmp1;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp2.x = dot(v.normal.xyz, float3(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0]));
                tmp2.y = dot(v.normal.xyz, float3(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1]));
                tmp2.z = dot(v.normal.xyz, float3(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2]));
                tmp0.w = dot(tmp2.xyz, tmp2.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord2.xyz = tmp0.www * tmp2.xyz;
                o.texcoord3.xyz = tmp0.xyz;
                tmp0.xyz = _WorldSpaceCameraPos - tmp0.xyz;
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord4.xyz = tmp0.www * tmp0.xyz;
                tmp0.xyz = tmp1.xyw * float3(0.5, 0.5, 0.5);
                o.texcoord6.zw = tmp1.zw;
                tmp0.w = tmp0.y * _ProjectionParams.x;
                o.texcoord6.xy = tmp0.zz + tmp0.xw;
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
                float4 tmp3;
                tmp0.xyz = inp.texcoord3.xyz - unity_ShadowFadeCenterAndType.xyz;
                tmp0.x = dot(tmp0.xyz, tmp0.xyz);
                tmp0.x = sqrt(tmp0.x);
                tmp0.yzw = _WorldSpaceCameraPos - inp.texcoord3.xyz;
                tmp1.x = unity_MatrixV._m20;
                tmp1.y = unity_MatrixV._m21;
                tmp1.z = unity_MatrixV._m22;
                tmp0.y = dot(tmp0.xyz, tmp1.xyz);
                tmp0.x = tmp0.x - tmp0.y;
                tmp0.x = unity_ShadowFadeCenterAndType.w * tmp0.x + tmp0.y;
                tmp0.x = saturate(tmp0.x * _LightShadowData.z + _LightShadowData.w);
                tmp0.y = tmp0.x < 1.0;
                tmp0.z = tmp0.x >= 1.0;
                tmp0.yz = tmp0.yz ? 1.0 : 0.0;
                tmp1.xy = inp.texcoord6.xy / inp.texcoord6.ww;
                tmp1 = tex2D(_ShadowMapTexture, tmp1.xy);
                tmp0.y = tmp0.y * tmp1.x + tmp0.z;
                tmp0.y = tmp0.y > 0.5;
                tmp0.x = tmp0.y ? 0.0 : tmp0.x;
                tmp0.y = tmp0.y ? 1.0 : 0.0;
                tmp0.x = tmp0.x + tmp0.y;
                tmp0.y = dot(_WorldSpaceLightPos0.xyz, inp.texcoord2.xyz);
                tmp0.y = tmp0.y - _Tendency;
                tmp0.y = saturate(tmp0.y * 100.0);
                tmp0.z = tmp0.y * -2.0 + 3.0;
                tmp0.y = tmp0.y * tmp0.y;
                tmp0.y = tmp0.y * tmp0.z;
                tmp0.xy = tmp0.xy * float2(_Opacity.x, _SelfShadowOpacity.x);
                tmp0.x = tmp0.x * tmp0.y;
                tmp0.yzw = LightColor.xyz - ShadowColor.xyz;
                tmp0.xyz = tmp0.xxx * tmp0.yzw + ShadowColor.xyz;
                tmp0.w = dot(inp.texcoord4.xyz, inp.texcoord2.xyz);
                tmp1.x = inp.texcoord3.x - inp.texcoord3.y;
                tmp0.w = tmp0.w * 5.0 + tmp1.x;
                tmp0.w = sin(tmp0.w);
                tmp1.xy = tmp0.ww + float2(0.4, 0.1);
                tmp1.xy = floor(tmp1.xy);
                tmp1.xy = max(tmp1.xy, float2(0.0, 0.0));
                tmp2 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0.w = -tmp2.w * _Color.w + 1.0;
                tmp1.yzw = tmp1.yyy * _LightColor0.xyz;
                tmp1 = tmp0.wwww * tmp1;
                tmp3 = tmp2 * _Color;
                tmp3.xyz = tmp1.xxx * tmp3.xyz;
                o.sv_target.w = tmp3.w;
                tmp0.w = sin(inp.texcoord.y);
                tmp0.w = max(tmp0.w, 0.5);
                tmp0.w = tmp0.w * 0.5;
                tmp2.xyz = tmp3.xyz * tmp0.www + tmp2.xyz;
                tmp1.xyz = tmp1.yzw * tmp0.www + tmp2.xyz;
                tmp1.xyz = tmp1.xyz * _LightColor0.xyz;
                tmp2 = tex2D(_Emission, inp.texcoord.xy);
                o.sv_target.xyz = tmp1.xyz * tmp0.xyz + tmp2.xyz;
                return o;
			}
#elif defined(DIRECTIONAL) && !defined(LIGHTMAP_ON) && !defined(LIGHTMAP_SHADOW_MIXING) && !defined(LIGHTPROBE_SH) && !defined(SHADOWS_SCREEN) && !defined(SHADOWS_SHADOWMASK) && defined(VERTEXLIGHT_ON)
			#include "UnityCG.cginc"
#include "AutoLight.cginc"
			struct v2f
			{
 UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float3 texcoord2 : TEXCOORD2;
				float3 texcoord3 : TEXCOORD3;
				float3 texcoord4 : TEXCOORD4;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 _Color;
			float4 ShadowColor;
			float4 LightColor;
			float _Opacity;
			float _Tendency;
			float _SelfShadowOpacity;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			sampler2D _Emission;
			
			// Keywords: DIRECTIONAL VERTEXLIGHT_ON
			v2f vert(appdata_full v)
			{
 UNITY_SETUP_INSTANCE_ID(v);
                v2f o;
 UNITY_TRANSFER_INSTANCE_ID(v, o);
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0 = v.vertex.yyyy * float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
                tmp0 = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]) * v.vertex.xxxx + tmp0;
                tmp0 = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]) * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
                tmp0.xyz = float3(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3]) * v.vertex.www + tmp0.xyz;
                tmp2 = tmp1.yyyy * float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
                tmp2 = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]) * tmp1.xxxx + tmp2;
                tmp2 = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]) * tmp1.zzzz + tmp2;
                o.position = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]) * tmp1.wwww + tmp2;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp1.x = dot(v.normal.xyz, float3(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0]));
                tmp1.y = dot(v.normal.xyz, float3(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1]));
                tmp1.z = dot(v.normal.xyz, float3(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2]));
                tmp0.w = dot(tmp1.xyz, tmp1.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord2.xyz = tmp0.www * tmp1.xyz;
                o.texcoord3.xyz = tmp0.xyz;
                tmp0.xyz = _WorldSpaceCameraPos - tmp0.xyz;
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord4.xyz = tmp0.www * tmp0.xyz;
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
                float4 tmp3;
                tmp0.xyz = inp.texcoord3.xyz - unity_ShadowFadeCenterAndType.xyz;
                tmp0.x = dot(tmp0.xyz, tmp0.xyz);
                tmp0.x = sqrt(tmp0.x);
                tmp0.yzw = _WorldSpaceCameraPos - inp.texcoord3.xyz;
                tmp1.x = unity_MatrixV._m20;
                tmp1.y = unity_MatrixV._m21;
                tmp1.z = unity_MatrixV._m22;
                tmp0.y = dot(tmp0.xyz, tmp1.xyz);
                tmp0.x = tmp0.x - tmp0.y;
                tmp0.x = unity_ShadowFadeCenterAndType.w * tmp0.x + tmp0.y;
                tmp0.x = saturate(tmp0.x * _LightShadowData.z + _LightShadowData.w);
                tmp0.y = tmp0.x < 1.0;
                tmp0.z = tmp0.x >= 1.0;
                tmp0.yz = tmp0.yz ? 1.0 : 0.0;
                tmp0.y = tmp0.z + tmp0.y;
                tmp0.y = tmp0.y > 0.5;
                tmp0.x = tmp0.y ? 0.0 : tmp0.x;
                tmp0.y = tmp0.y ? 1.0 : 0.0;
                tmp0.x = tmp0.x + tmp0.y;
                tmp0.y = dot(_WorldSpaceLightPos0.xyz, inp.texcoord2.xyz);
                tmp0.y = tmp0.y - _Tendency;
                tmp0.y = saturate(tmp0.y * 100.0);
                tmp0.z = tmp0.y * -2.0 + 3.0;
                tmp0.y = tmp0.y * tmp0.y;
                tmp0.y = tmp0.y * tmp0.z;
                tmp0.xy = tmp0.xy * float2(_Opacity.x, _SelfShadowOpacity.x);
                tmp0.x = tmp0.x * tmp0.y;
                tmp0.yzw = LightColor.xyz - ShadowColor.xyz;
                tmp0.xyz = tmp0.xxx * tmp0.yzw + ShadowColor.xyz;
                tmp0.w = dot(inp.texcoord4.xyz, inp.texcoord2.xyz);
                tmp1.x = inp.texcoord3.x - inp.texcoord3.y;
                tmp0.w = tmp0.w * 5.0 + tmp1.x;
                tmp0.w = sin(tmp0.w);
                tmp1.xy = tmp0.ww + float2(0.4, 0.1);
                tmp1.xy = floor(tmp1.xy);
                tmp1.xy = max(tmp1.xy, float2(0.0, 0.0));
                tmp2 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0.w = -tmp2.w * _Color.w + 1.0;
                tmp1.yzw = tmp1.yyy * _LightColor0.xyz;
                tmp1 = tmp0.wwww * tmp1;
                tmp3 = tmp2 * _Color;
                tmp3.xyz = tmp1.xxx * tmp3.xyz;
                o.sv_target.w = tmp3.w;
                tmp0.w = sin(inp.texcoord.y);
                tmp0.w = max(tmp0.w, 0.5);
                tmp0.w = tmp0.w * 0.5;
                tmp2.xyz = tmp3.xyz * tmp0.www + tmp2.xyz;
                tmp1.xyz = tmp1.yzw * tmp0.www + tmp2.xyz;
                tmp1.xyz = tmp1.xyz * _LightColor0.xyz;
                tmp2 = tex2D(_Emission, inp.texcoord.xy);
                o.sv_target.xyz = tmp1.xyz * tmp0.xyz + tmp2.xyz;
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
				float2 texcoord : TEXCOORD0;
				float3 texcoord2 : TEXCOORD2;
				float3 texcoord3 : TEXCOORD3;
				float3 texcoord4 : TEXCOORD4;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 _Color;
			float4 ShadowColor;
			float4 LightColor;
			float _Opacity;
			float _Tendency;
			float _SelfShadowOpacity;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			sampler2D _Emission;
			
			// Keywords: DIRECTIONAL
			v2f vert(appdata_full v)
			{
 UNITY_SETUP_INSTANCE_ID(v);
                v2f o;
 UNITY_TRANSFER_INSTANCE_ID(v, o);
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0 = v.vertex.yyyy * float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
                tmp0 = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]) * v.vertex.xxxx + tmp0;
                tmp0 = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]) * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
                tmp0.xyz = float3(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3]) * v.vertex.www + tmp0.xyz;
                tmp2 = tmp1.yyyy * float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
                tmp2 = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]) * tmp1.xxxx + tmp2;
                tmp2 = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]) * tmp1.zzzz + tmp2;
                o.position = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]) * tmp1.wwww + tmp2;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp1.x = dot(v.normal.xyz, float3(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0]));
                tmp1.y = dot(v.normal.xyz, float3(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1]));
                tmp1.z = dot(v.normal.xyz, float3(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2]));
                tmp0.w = dot(tmp1.xyz, tmp1.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord2.xyz = tmp0.www * tmp1.xyz;
                o.texcoord3.xyz = tmp0.xyz;
                tmp0.xyz = _WorldSpaceCameraPos - tmp0.xyz;
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord4.xyz = tmp0.www * tmp0.xyz;
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
                float4 tmp3;
                tmp0.xyz = inp.texcoord3.xyz - unity_ShadowFadeCenterAndType.xyz;
                tmp0.x = dot(tmp0.xyz, tmp0.xyz);
                tmp0.x = sqrt(tmp0.x);
                tmp0.yzw = _WorldSpaceCameraPos - inp.texcoord3.xyz;
                tmp1.x = unity_MatrixV._m20;
                tmp1.y = unity_MatrixV._m21;
                tmp1.z = unity_MatrixV._m22;
                tmp0.y = dot(tmp0.xyz, tmp1.xyz);
                tmp0.x = tmp0.x - tmp0.y;
                tmp0.x = unity_ShadowFadeCenterAndType.w * tmp0.x + tmp0.y;
                tmp0.x = saturate(tmp0.x * _LightShadowData.z + _LightShadowData.w);
                tmp0.y = tmp0.x < 1.0;
                tmp0.z = tmp0.x >= 1.0;
                tmp0.yz = tmp0.yz ? 1.0 : 0.0;
                tmp0.y = tmp0.z + tmp0.y;
                tmp0.y = tmp0.y > 0.5;
                tmp0.x = tmp0.y ? 0.0 : tmp0.x;
                tmp0.y = tmp0.y ? 1.0 : 0.0;
                tmp0.x = tmp0.x + tmp0.y;
                tmp0.y = dot(_WorldSpaceLightPos0.xyz, inp.texcoord2.xyz);
                tmp0.y = tmp0.y - _Tendency;
                tmp0.y = saturate(tmp0.y * 100.0);
                tmp0.z = tmp0.y * -2.0 + 3.0;
                tmp0.y = tmp0.y * tmp0.y;
                tmp0.y = tmp0.y * tmp0.z;
                tmp0.xy = tmp0.xy * float2(_Opacity.x, _SelfShadowOpacity.x);
                tmp0.x = tmp0.x * tmp0.y;
                tmp0.yzw = LightColor.xyz - ShadowColor.xyz;
                tmp0.xyz = tmp0.xxx * tmp0.yzw + ShadowColor.xyz;
                tmp0.w = dot(inp.texcoord4.xyz, inp.texcoord2.xyz);
                tmp1.x = inp.texcoord3.x - inp.texcoord3.y;
                tmp0.w = tmp0.w * 5.0 + tmp1.x;
                tmp0.w = sin(tmp0.w);
                tmp1.xy = tmp0.ww + float2(0.4, 0.1);
                tmp1.xy = floor(tmp1.xy);
                tmp1.xy = max(tmp1.xy, float2(0.0, 0.0));
                tmp2 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0.w = -tmp2.w * _Color.w + 1.0;
                tmp1.yzw = tmp1.yyy * _LightColor0.xyz;
                tmp1 = tmp0.wwww * tmp1;
                tmp3 = tmp2 * _Color;
                tmp3.xyz = tmp1.xxx * tmp3.xyz;
                o.sv_target.w = tmp3.w;
                tmp0.w = sin(inp.texcoord.y);
                tmp0.w = max(tmp0.w, 0.5);
                tmp0.w = tmp0.w * 0.5;
                tmp2.xyz = tmp3.xyz * tmp0.www + tmp2.xyz;
                tmp1.xyz = tmp1.yzw * tmp0.www + tmp2.xyz;
                tmp1.xyz = tmp1.xyz * _LightColor0.xyz;
                tmp2 = tex2D(_Emission, inp.texcoord.xy);
                o.sv_target.xyz = tmp1.xyz * tmp0.xyz + tmp2.xyz;
                return o;
			}
#endif
			ENDCG
		}
	}
	Fallback "Diffuse"
}