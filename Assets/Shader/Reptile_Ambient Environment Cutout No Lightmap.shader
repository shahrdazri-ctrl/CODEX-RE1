Shader "Reptile/Ambient Environment Cutout No Lightmap" {
	Properties {
		_MainTex ("MainTex", 2D) = "white" {}
		_Emission ("Emission", 2D) = "black" {}
		[HideInInspector] _Opacity ("Projected Shadow", Range(0, 1)) = 1
		[HideInInspector] _SelfShadowOpacity ("Self Shadow", Range(0, 1)) = 1
		[HideInInspector] _Tendency ("Tendency", Range(-1, 1)) = -0.2
	}
	SubShader {
		Tags { "LIGHTMODE" = "FORWARDBASE" "QUEUE" = "AlphaTest" "RenderType" = "TransparentCutout" }
		Pass {
			Tags { "LIGHTMODE" = "FORWARDBASE" "QUEUE" = "AlphaTest" "RenderType" = "TransparentCutout" "SHADOWSUPPORT" = "true" }

CGPROGRAM
#pragma vertex vert
#pragma fragment frag
#pragma multi_compile __ DIRECTIONAL
#pragma target 3.5
#pragma multi_compile_instancing
#pragma multi_compile __ LIGHTMAP_ON
#pragma multi_compile __ LIGHTMAP_SHADOW_MIXING
#pragma multi_compile __ LIGHTPROBE_SH
#pragma multi_compile __ LOD_FADE_CROSSFADE
#pragma multi_compile __ SHADOWS_SCREEN
#pragma multi_compile __ SHADOWS_SHADOWMASK
#pragma multi_compile __ VERTEXLIGHT_ON
#if defined(DIRECTIONAL) && defined(LIGHTMAP_ON) && defined(LIGHTMAP_SHADOW_MIXING) && defined(LIGHTPROBE_SH) && defined(LOD_FADE_CROSSFADE) && defined(SHADOWS_SCREEN) && defined(SHADOWS_SHADOWMASK) && !defined(VERTEXLIGHT_ON)
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
				float4 texcoord4 : TEXCOORD4;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 ShadowColor;
			float4 LightColor;
			float _Opacity;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			sampler2D _Emission;
			
			// Keywords: LOD_FADE_CROSSFADE DIRECTIONAL LIGHTPROBE_SH SHADOWS_SHADOWMASK LIGHTMAP_ON LIGHTMAP_SHADOW_MIXING SHADOWS_SCREEN
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
                o.texcoord3.xyz = float3(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3]) * v.vertex.www + tmp0.xyz;
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
                o.texcoord2.xyz = tmp1.www * tmp1.xyz;
                tmp1.xyz = tmp0.xyw * float3(0.5, 0.5, 0.5);
                o.texcoord4.zw = tmp0.zw;
                tmp1.w = tmp1.y * _ProjectionParams.x;
                o.texcoord4.xy = tmp1.zz + tmp1.xw;
                return o;
			}
			// Keywords: LOD_FADE_CROSSFADE DIRECTIONAL LIGHTPROBE_SH SHADOWS_SHADOWMASK LIGHTMAP_ON LIGHTMAP_SHADOW_MIXING SHADOWS_SCREEN
			fout frag(v2f inp)
			{
 UNITY_SETUP_INSTANCE_ID(inp);
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = dot(inp.position.xy, float2(0.0671106, 0.0058372));
                tmp0.x = frac(tmp0.x);
                tmp0.x = tmp0.x * 52.98292;
                tmp0.x = frac(tmp0.x);
                tmp0.x = unity_LODFade.x - tmp0.x;
                tmp0.x = tmp0.x < 0.0;
                if (tmp0.x) {
                    discard;
                }
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1.x = tmp0.w - 0.5;
                tmp1.x = tmp1.x < 0.0;
                if (tmp1.x) {
                    discard;
                }
                tmp1.xyz = inp.texcoord3.xyz - unity_ShadowFadeCenterAndType.xyz;
                tmp1.x = dot(tmp1.xyz, tmp1.xyz);
                tmp1.x = sqrt(tmp1.x);
                tmp1.yzw = _WorldSpaceCameraPos - inp.texcoord3.xyz;
                tmp2.x = unity_MatrixV._m20;
                tmp2.y = unity_MatrixV._m21;
                tmp2.z = unity_MatrixV._m22;
                tmp1.y = dot(tmp1.xyz, tmp2.xyz);
                tmp1.x = tmp1.x - tmp1.y;
                tmp1.x = unity_ShadowFadeCenterAndType.w * tmp1.x + tmp1.y;
                tmp1.x = saturate(tmp1.x * _LightShadowData.z + _LightShadowData.w);
                tmp1.y = tmp1.x < 1.0;
                tmp1.z = tmp1.x >= 1.0;
                tmp1.yz = tmp1.yz ? 1.0 : 0.0;
                tmp2.xy = inp.texcoord4.xy / inp.texcoord4.ww;
                tmp2 = tex2D(_ShadowMapTexture, tmp2.xy);
                tmp1.y = tmp1.y * tmp2.x + tmp1.z;
                tmp1.y = tmp1.y > 0.5;
                tmp1.x = tmp1.y ? 0.0 : tmp1.x;
                tmp1.y = tmp1.y ? 1.0 : 0.0;
                tmp1.x = tmp1.x + tmp1.y;
                tmp1.x = tmp1.x * _Opacity;
                tmp1.y = dot(_WorldSpaceLightPos0.xyz, inp.texcoord2.xyz);
                tmp1.y = saturate(tmp1.y * 100.0);
                tmp1.z = tmp1.y * -2.0 + 3.0;
                tmp1.y = tmp1.y * tmp1.y;
                tmp1.y = tmp1.y * tmp1.z;
                tmp1.x = tmp1.x * tmp1.y;
                tmp1.yzw = LightColor.xyz - ShadowColor.xyz;
                tmp1.xyz = tmp1.xxx * tmp1.yzw + ShadowColor.xyz;
                tmp1.xyz = tmp0.xyz * tmp1.xyz;
                tmp0.xyz = tmp1.xyz * _LightColor0.xyz;
                tmp1 = tex2D(_Emission, inp.texcoord.xy);
                o.sv_target = tmp0 + tmp1;
                return o;
			}
#elif defined(DIRECTIONAL) && !defined(LIGHTMAP_ON) && defined(LIGHTMAP_SHADOW_MIXING) && defined(LIGHTPROBE_SH) && defined(LOD_FADE_CROSSFADE) && defined(SHADOWS_SCREEN) && defined(SHADOWS_SHADOWMASK) && defined(VERTEXLIGHT_ON)
			#include "UnityCG.cginc"
#include "AutoLight.cginc"
			struct v2f
			{
 UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float3 texcoord2 : TEXCOORD2;
				float3 texcoord3 : TEXCOORD3;
				float4 texcoord4 : TEXCOORD4;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 ShadowColor;
			float4 LightColor;
			float _Opacity;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			sampler2D _Emission;
			
			// Keywords: LOD_FADE_CROSSFADE DIRECTIONAL LIGHTPROBE_SH SHADOWS_SHADOWMASK LIGHTMAP_SHADOW_MIXING SHADOWS_SCREEN VERTEXLIGHT_ON
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
                o.texcoord3.xyz = float3(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3]) * v.vertex.www + tmp0.xyz;
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
                o.texcoord2.xyz = tmp1.www * tmp1.xyz;
                tmp1.xyz = tmp0.xyw * float3(0.5, 0.5, 0.5);
                o.texcoord4.zw = tmp0.zw;
                tmp1.w = tmp1.y * _ProjectionParams.x;
                o.texcoord4.xy = tmp1.zz + tmp1.xw;
                return o;
			}
			// Keywords: LOD_FADE_CROSSFADE DIRECTIONAL LIGHTPROBE_SH SHADOWS_SHADOWMASK LIGHTMAP_SHADOW_MIXING SHADOWS_SCREEN
			fout frag(v2f inp)
			{
 UNITY_SETUP_INSTANCE_ID(inp);
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = dot(inp.position.xy, float2(0.0671106, 0.0058372));
                tmp0.x = frac(tmp0.x);
                tmp0.x = tmp0.x * 52.98292;
                tmp0.x = frac(tmp0.x);
                tmp0.x = unity_LODFade.x - tmp0.x;
                tmp0.x = tmp0.x < 0.0;
                if (tmp0.x) {
                    discard;
                }
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1.x = tmp0.w - 0.5;
                tmp1.x = tmp1.x < 0.0;
                if (tmp1.x) {
                    discard;
                }
                tmp1.xyz = inp.texcoord3.xyz - unity_ShadowFadeCenterAndType.xyz;
                tmp1.x = dot(tmp1.xyz, tmp1.xyz);
                tmp1.x = sqrt(tmp1.x);
                tmp1.yzw = _WorldSpaceCameraPos - inp.texcoord3.xyz;
                tmp2.x = unity_MatrixV._m20;
                tmp2.y = unity_MatrixV._m21;
                tmp2.z = unity_MatrixV._m22;
                tmp1.y = dot(tmp1.xyz, tmp2.xyz);
                tmp1.x = tmp1.x - tmp1.y;
                tmp1.x = unity_ShadowFadeCenterAndType.w * tmp1.x + tmp1.y;
                tmp1.x = saturate(tmp1.x * _LightShadowData.z + _LightShadowData.w);
                tmp1.y = tmp1.x < 1.0;
                tmp1.z = tmp1.x >= 1.0;
                tmp1.yz = tmp1.yz ? 1.0 : 0.0;
                tmp2.xy = inp.texcoord4.xy / inp.texcoord4.ww;
                tmp2 = tex2D(_ShadowMapTexture, tmp2.xy);
                tmp1.y = tmp1.y * tmp2.x + tmp1.z;
                tmp1.y = tmp1.y > 0.5;
                tmp1.x = tmp1.y ? 0.0 : tmp1.x;
                tmp1.y = tmp1.y ? 1.0 : 0.0;
                tmp1.x = tmp1.x + tmp1.y;
                tmp1.x = tmp1.x * _Opacity;
                tmp1.y = dot(_WorldSpaceLightPos0.xyz, inp.texcoord2.xyz);
                tmp1.y = saturate(tmp1.y * 100.0);
                tmp1.z = tmp1.y * -2.0 + 3.0;
                tmp1.y = tmp1.y * tmp1.y;
                tmp1.y = tmp1.y * tmp1.z;
                tmp1.x = tmp1.x * tmp1.y;
                tmp1.yzw = LightColor.xyz - ShadowColor.xyz;
                tmp1.xyz = tmp1.xxx * tmp1.yzw + ShadowColor.xyz;
                tmp1.xyz = tmp0.xyz * tmp1.xyz;
                tmp0.xyz = tmp1.xyz * _LightColor0.xyz;
                tmp1 = tex2D(_Emission, inp.texcoord.xy);
                o.sv_target = tmp0 + tmp1;
                return o;
			}
#elif defined(DIRECTIONAL) && defined(LIGHTMAP_ON) && defined(LIGHTMAP_SHADOW_MIXING) && defined(LIGHTPROBE_SH) && !defined(LOD_FADE_CROSSFADE) && defined(SHADOWS_SCREEN) && defined(SHADOWS_SHADOWMASK) && !defined(VERTEXLIGHT_ON)
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
				float4 texcoord4 : TEXCOORD4;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 ShadowColor;
			float4 LightColor;
			float _Opacity;
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
                tmp0 = v.vertex.yyyy * float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
                tmp0 = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]) * v.vertex.xxxx + tmp0;
                tmp0 = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]) * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
                o.texcoord3.xyz = float3(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3]) * v.vertex.www + tmp0.xyz;
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
                o.texcoord2.xyz = tmp1.www * tmp1.xyz;
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
                float4 tmp2;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1.x = tmp0.w - 0.5;
                tmp1.x = tmp1.x < 0.0;
                if (tmp1.x) {
                    discard;
                }
                tmp1.xyz = inp.texcoord3.xyz - unity_ShadowFadeCenterAndType.xyz;
                tmp1.x = dot(tmp1.xyz, tmp1.xyz);
                tmp1.x = sqrt(tmp1.x);
                tmp1.yzw = _WorldSpaceCameraPos - inp.texcoord3.xyz;
                tmp2.x = unity_MatrixV._m20;
                tmp2.y = unity_MatrixV._m21;
                tmp2.z = unity_MatrixV._m22;
                tmp1.y = dot(tmp1.xyz, tmp2.xyz);
                tmp1.x = tmp1.x - tmp1.y;
                tmp1.x = unity_ShadowFadeCenterAndType.w * tmp1.x + tmp1.y;
                tmp1.x = saturate(tmp1.x * _LightShadowData.z + _LightShadowData.w);
                tmp1.y = tmp1.x < 1.0;
                tmp1.z = tmp1.x >= 1.0;
                tmp1.yz = tmp1.yz ? 1.0 : 0.0;
                tmp2.xy = inp.texcoord4.xy / inp.texcoord4.ww;
                tmp2 = tex2D(_ShadowMapTexture, tmp2.xy);
                tmp1.y = tmp1.y * tmp2.x + tmp1.z;
                tmp1.y = tmp1.y > 0.5;
                tmp1.x = tmp1.y ? 0.0 : tmp1.x;
                tmp1.y = tmp1.y ? 1.0 : 0.0;
                tmp1.x = tmp1.x + tmp1.y;
                tmp1.x = tmp1.x * _Opacity;
                tmp1.y = dot(_WorldSpaceLightPos0.xyz, inp.texcoord2.xyz);
                tmp1.y = saturate(tmp1.y * 100.0);
                tmp1.z = tmp1.y * -2.0 + 3.0;
                tmp1.y = tmp1.y * tmp1.y;
                tmp1.y = tmp1.y * tmp1.z;
                tmp1.x = tmp1.x * tmp1.y;
                tmp1.yzw = LightColor.xyz - ShadowColor.xyz;
                tmp1.xyz = tmp1.xxx * tmp1.yzw + ShadowColor.xyz;
                tmp1.xyz = tmp0.xyz * tmp1.xyz;
                tmp0.xyz = tmp1.xyz * _LightColor0.xyz;
                tmp1 = tex2D(_Emission, inp.texcoord.xy);
                o.sv_target = tmp0 + tmp1;
                return o;
			}
#elif defined(DIRECTIONAL) && !defined(LIGHTMAP_ON) && defined(LIGHTMAP_SHADOW_MIXING) && defined(LIGHTPROBE_SH) && !defined(LOD_FADE_CROSSFADE) && defined(SHADOWS_SCREEN) && defined(SHADOWS_SHADOWMASK) && defined(VERTEXLIGHT_ON)
			#include "UnityCG.cginc"
#include "AutoLight.cginc"
			struct v2f
			{
 UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float3 texcoord2 : TEXCOORD2;
				float3 texcoord3 : TEXCOORD3;
				float4 texcoord4 : TEXCOORD4;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 ShadowColor;
			float4 LightColor;
			float _Opacity;
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
                tmp0 = v.vertex.yyyy * float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
                tmp0 = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]) * v.vertex.xxxx + tmp0;
                tmp0 = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]) * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
                o.texcoord3.xyz = float3(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3]) * v.vertex.www + tmp0.xyz;
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
                o.texcoord2.xyz = tmp1.www * tmp1.xyz;
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
                float4 tmp2;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1.x = tmp0.w - 0.5;
                tmp1.x = tmp1.x < 0.0;
                if (tmp1.x) {
                    discard;
                }
                tmp1.xyz = inp.texcoord3.xyz - unity_ShadowFadeCenterAndType.xyz;
                tmp1.x = dot(tmp1.xyz, tmp1.xyz);
                tmp1.x = sqrt(tmp1.x);
                tmp1.yzw = _WorldSpaceCameraPos - inp.texcoord3.xyz;
                tmp2.x = unity_MatrixV._m20;
                tmp2.y = unity_MatrixV._m21;
                tmp2.z = unity_MatrixV._m22;
                tmp1.y = dot(tmp1.xyz, tmp2.xyz);
                tmp1.x = tmp1.x - tmp1.y;
                tmp1.x = unity_ShadowFadeCenterAndType.w * tmp1.x + tmp1.y;
                tmp1.x = saturate(tmp1.x * _LightShadowData.z + _LightShadowData.w);
                tmp1.y = tmp1.x < 1.0;
                tmp1.z = tmp1.x >= 1.0;
                tmp1.yz = tmp1.yz ? 1.0 : 0.0;
                tmp2.xy = inp.texcoord4.xy / inp.texcoord4.ww;
                tmp2 = tex2D(_ShadowMapTexture, tmp2.xy);
                tmp1.y = tmp1.y * tmp2.x + tmp1.z;
                tmp1.y = tmp1.y > 0.5;
                tmp1.x = tmp1.y ? 0.0 : tmp1.x;
                tmp1.y = tmp1.y ? 1.0 : 0.0;
                tmp1.x = tmp1.x + tmp1.y;
                tmp1.x = tmp1.x * _Opacity;
                tmp1.y = dot(_WorldSpaceLightPos0.xyz, inp.texcoord2.xyz);
                tmp1.y = saturate(tmp1.y * 100.0);
                tmp1.z = tmp1.y * -2.0 + 3.0;
                tmp1.y = tmp1.y * tmp1.y;
                tmp1.y = tmp1.y * tmp1.z;
                tmp1.x = tmp1.x * tmp1.y;
                tmp1.yzw = LightColor.xyz - ShadowColor.xyz;
                tmp1.xyz = tmp1.xxx * tmp1.yzw + ShadowColor.xyz;
                tmp1.xyz = tmp0.xyz * tmp1.xyz;
                tmp0.xyz = tmp1.xyz * _LightColor0.xyz;
                tmp1 = tex2D(_Emission, inp.texcoord.xy);
                o.sv_target = tmp0 + tmp1;
                return o;
			}
#elif defined(DIRECTIONAL) && defined(LIGHTMAP_ON) && defined(LIGHTMAP_SHADOW_MIXING) && defined(LIGHTPROBE_SH) && defined(LOD_FADE_CROSSFADE) && !defined(SHADOWS_SCREEN) && defined(SHADOWS_SHADOWMASK) && !defined(VERTEXLIGHT_ON)
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
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 ShadowColor;
			float4 LightColor;
			float _Opacity;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			sampler2D _Emission;
			
			// Keywords: LOD_FADE_CROSSFADE DIRECTIONAL LIGHTPROBE_SH SHADOWS_SHADOWMASK LIGHTMAP_ON LIGHTMAP_SHADOW_MIXING
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
                o.texcoord3.xyz = float3(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3]) * v.vertex.www + tmp0.xyz;
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
                o.texcoord2.xyz = tmp0.www * tmp0.xyz;
                return o;
			}
			// Keywords: LOD_FADE_CROSSFADE DIRECTIONAL LIGHTPROBE_SH SHADOWS_SHADOWMASK LIGHTMAP_ON LIGHTMAP_SHADOW_MIXING
			fout frag(v2f inp)
			{
 UNITY_SETUP_INSTANCE_ID(inp);
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = dot(inp.position.xy, float2(0.0671106, 0.0058372));
                tmp0.x = frac(tmp0.x);
                tmp0.x = tmp0.x * 52.98292;
                tmp0.x = frac(tmp0.x);
                tmp0.x = unity_LODFade.x - tmp0.x;
                tmp0.x = tmp0.x < 0.0;
                if (tmp0.x) {
                    discard;
                }
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1.x = tmp0.w - 0.5;
                tmp1.x = tmp1.x < 0.0;
                if (tmp1.x) {
                    discard;
                }
                tmp1.xyz = inp.texcoord3.xyz - unity_ShadowFadeCenterAndType.xyz;
                tmp1.x = dot(tmp1.xyz, tmp1.xyz);
                tmp1.x = sqrt(tmp1.x);
                tmp1.yzw = _WorldSpaceCameraPos - inp.texcoord3.xyz;
                tmp2.x = unity_MatrixV._m20;
                tmp2.y = unity_MatrixV._m21;
                tmp2.z = unity_MatrixV._m22;
                tmp1.y = dot(tmp1.xyz, tmp2.xyz);
                tmp1.x = tmp1.x - tmp1.y;
                tmp1.x = unity_ShadowFadeCenterAndType.w * tmp1.x + tmp1.y;
                tmp1.x = saturate(tmp1.x * _LightShadowData.z + _LightShadowData.w);
                tmp1.y = tmp1.x < 1.0;
                tmp1.z = tmp1.x >= 1.0;
                tmp1.yz = tmp1.yz ? 1.0 : 0.0;
                tmp1.y = tmp1.z + tmp1.y;
                tmp1.y = tmp1.y > 0.5;
                tmp1.x = tmp1.y ? 0.0 : tmp1.x;
                tmp1.y = tmp1.y ? 1.0 : 0.0;
                tmp1.x = tmp1.x + tmp1.y;
                tmp1.x = tmp1.x * _Opacity;
                tmp1.y = dot(_WorldSpaceLightPos0.xyz, inp.texcoord2.xyz);
                tmp1.y = saturate(tmp1.y * 100.0);
                tmp1.z = tmp1.y * -2.0 + 3.0;
                tmp1.y = tmp1.y * tmp1.y;
                tmp1.y = tmp1.y * tmp1.z;
                tmp1.x = tmp1.x * tmp1.y;
                tmp1.yzw = LightColor.xyz - ShadowColor.xyz;
                tmp1.xyz = tmp1.xxx * tmp1.yzw + ShadowColor.xyz;
                tmp1.xyz = tmp0.xyz * tmp1.xyz;
                tmp0.xyz = tmp1.xyz * _LightColor0.xyz;
                tmp1 = tex2D(_Emission, inp.texcoord.xy);
                o.sv_target = tmp0 + tmp1;
                return o;
			}
#elif defined(DIRECTIONAL) && !defined(LIGHTMAP_ON) && defined(LIGHTMAP_SHADOW_MIXING) && defined(LIGHTPROBE_SH) && defined(LOD_FADE_CROSSFADE) && defined(SHADOWS_SCREEN) && defined(SHADOWS_SHADOWMASK) && !defined(VERTEXLIGHT_ON)
			#include "UnityCG.cginc"
#include "AutoLight.cginc"
			struct v2f
			{
 UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float3 texcoord2 : TEXCOORD2;
				float3 texcoord3 : TEXCOORD3;
				float4 texcoord4 : TEXCOORD4;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 ShadowColor;
			float4 LightColor;
			float _Opacity;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			sampler2D _Emission;
			
			// Keywords: LOD_FADE_CROSSFADE DIRECTIONAL LIGHTPROBE_SH SHADOWS_SHADOWMASK LIGHTMAP_SHADOW_MIXING SHADOWS_SCREEN
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
                o.texcoord3.xyz = float3(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3]) * v.vertex.www + tmp0.xyz;
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
                o.texcoord2.xyz = tmp1.www * tmp1.xyz;
                tmp1.xyz = tmp0.xyw * float3(0.5, 0.5, 0.5);
                o.texcoord4.zw = tmp0.zw;
                tmp1.w = tmp1.y * _ProjectionParams.x;
                o.texcoord4.xy = tmp1.zz + tmp1.xw;
                return o;
			}
			// Keywords: LOD_FADE_CROSSFADE DIRECTIONAL LIGHTPROBE_SH SHADOWS_SHADOWMASK LIGHTMAP_SHADOW_MIXING SHADOWS_SCREEN
			fout frag(v2f inp)
			{
 UNITY_SETUP_INSTANCE_ID(inp);
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = dot(inp.position.xy, float2(0.0671106, 0.0058372));
                tmp0.x = frac(tmp0.x);
                tmp0.x = tmp0.x * 52.98292;
                tmp0.x = frac(tmp0.x);
                tmp0.x = unity_LODFade.x - tmp0.x;
                tmp0.x = tmp0.x < 0.0;
                if (tmp0.x) {
                    discard;
                }
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1.x = tmp0.w - 0.5;
                tmp1.x = tmp1.x < 0.0;
                if (tmp1.x) {
                    discard;
                }
                tmp1.xyz = inp.texcoord3.xyz - unity_ShadowFadeCenterAndType.xyz;
                tmp1.x = dot(tmp1.xyz, tmp1.xyz);
                tmp1.x = sqrt(tmp1.x);
                tmp1.yzw = _WorldSpaceCameraPos - inp.texcoord3.xyz;
                tmp2.x = unity_MatrixV._m20;
                tmp2.y = unity_MatrixV._m21;
                tmp2.z = unity_MatrixV._m22;
                tmp1.y = dot(tmp1.xyz, tmp2.xyz);
                tmp1.x = tmp1.x - tmp1.y;
                tmp1.x = unity_ShadowFadeCenterAndType.w * tmp1.x + tmp1.y;
                tmp1.x = saturate(tmp1.x * _LightShadowData.z + _LightShadowData.w);
                tmp1.y = tmp1.x < 1.0;
                tmp1.z = tmp1.x >= 1.0;
                tmp1.yz = tmp1.yz ? 1.0 : 0.0;
                tmp2.xy = inp.texcoord4.xy / inp.texcoord4.ww;
                tmp2 = tex2D(_ShadowMapTexture, tmp2.xy);
                tmp1.y = tmp1.y * tmp2.x + tmp1.z;
                tmp1.y = tmp1.y > 0.5;
                tmp1.x = tmp1.y ? 0.0 : tmp1.x;
                tmp1.y = tmp1.y ? 1.0 : 0.0;
                tmp1.x = tmp1.x + tmp1.y;
                tmp1.x = tmp1.x * _Opacity;
                tmp1.y = dot(_WorldSpaceLightPos0.xyz, inp.texcoord2.xyz);
                tmp1.y = saturate(tmp1.y * 100.0);
                tmp1.z = tmp1.y * -2.0 + 3.0;
                tmp1.y = tmp1.y * tmp1.y;
                tmp1.y = tmp1.y * tmp1.z;
                tmp1.x = tmp1.x * tmp1.y;
                tmp1.yzw = LightColor.xyz - ShadowColor.xyz;
                tmp1.xyz = tmp1.xxx * tmp1.yzw + ShadowColor.xyz;
                tmp1.xyz = tmp0.xyz * tmp1.xyz;
                tmp0.xyz = tmp1.xyz * _LightColor0.xyz;
                tmp1 = tex2D(_Emission, inp.texcoord.xy);
                o.sv_target = tmp0 + tmp1;
                return o;
			}
#elif defined(DIRECTIONAL) && defined(LIGHTMAP_ON) && defined(LIGHTMAP_SHADOW_MIXING) && defined(LIGHTPROBE_SH) && defined(LOD_FADE_CROSSFADE) && defined(SHADOWS_SCREEN) && !defined(SHADOWS_SHADOWMASK) && !defined(VERTEXLIGHT_ON)
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
				float4 texcoord4 : TEXCOORD4;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 ShadowColor;
			float4 LightColor;
			float _Opacity;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			sampler2D _Emission;
			
			// Keywords: LOD_FADE_CROSSFADE DIRECTIONAL LIGHTPROBE_SH LIGHTMAP_ON LIGHTMAP_SHADOW_MIXING SHADOWS_SCREEN
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
                o.texcoord3.xyz = float3(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3]) * v.vertex.www + tmp0.xyz;
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
                o.texcoord2.xyz = tmp1.www * tmp1.xyz;
                tmp1.xyz = tmp0.xyw * float3(0.5, 0.5, 0.5);
                o.texcoord4.zw = tmp0.zw;
                tmp1.w = tmp1.y * _ProjectionParams.x;
                o.texcoord4.xy = tmp1.zz + tmp1.xw;
                return o;
			}
			// Keywords: LOD_FADE_CROSSFADE DIRECTIONAL LIGHTPROBE_SH LIGHTMAP_ON LIGHTMAP_SHADOW_MIXING SHADOWS_SCREEN
			fout frag(v2f inp)
			{
 UNITY_SETUP_INSTANCE_ID(inp);
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = dot(inp.position.xy, float2(0.0671106, 0.0058372));
                tmp0.x = frac(tmp0.x);
                tmp0.x = tmp0.x * 52.98292;
                tmp0.x = frac(tmp0.x);
                tmp0.x = unity_LODFade.x - tmp0.x;
                tmp0.x = tmp0.x < 0.0;
                if (tmp0.x) {
                    discard;
                }
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1.x = tmp0.w - 0.5;
                tmp1.x = tmp1.x < 0.0;
                if (tmp1.x) {
                    discard;
                }
                tmp1.xyz = inp.texcoord3.xyz - unity_ShadowFadeCenterAndType.xyz;
                tmp1.x = dot(tmp1.xyz, tmp1.xyz);
                tmp1.x = sqrt(tmp1.x);
                tmp1.yzw = _WorldSpaceCameraPos - inp.texcoord3.xyz;
                tmp2.x = unity_MatrixV._m20;
                tmp2.y = unity_MatrixV._m21;
                tmp2.z = unity_MatrixV._m22;
                tmp1.y = dot(tmp1.xyz, tmp2.xyz);
                tmp1.x = tmp1.x - tmp1.y;
                tmp1.x = unity_ShadowFadeCenterAndType.w * tmp1.x + tmp1.y;
                tmp1.x = saturate(tmp1.x * _LightShadowData.z + _LightShadowData.w);
                tmp1.y = tmp1.x < 1.0;
                tmp1.z = tmp1.x >= 1.0;
                tmp1.yz = tmp1.yz ? 1.0 : 0.0;
                tmp2.xy = inp.texcoord4.xy / inp.texcoord4.ww;
                tmp2 = tex2D(_ShadowMapTexture, tmp2.xy);
                tmp1.y = tmp1.y * tmp2.x + tmp1.z;
                tmp1.y = tmp1.y > 0.5;
                tmp1.x = tmp1.y ? 0.0 : tmp1.x;
                tmp1.y = tmp1.y ? 1.0 : 0.0;
                tmp1.x = tmp1.x + tmp1.y;
                tmp1.x = tmp1.x * _Opacity;
                tmp1.y = dot(_WorldSpaceLightPos0.xyz, inp.texcoord2.xyz);
                tmp1.y = saturate(tmp1.y * 100.0);
                tmp1.z = tmp1.y * -2.0 + 3.0;
                tmp1.y = tmp1.y * tmp1.y;
                tmp1.y = tmp1.y * tmp1.z;
                tmp1.x = tmp1.x * tmp1.y;
                tmp1.yzw = LightColor.xyz - ShadowColor.xyz;
                tmp1.xyz = tmp1.xxx * tmp1.yzw + ShadowColor.xyz;
                tmp1.xyz = tmp0.xyz * tmp1.xyz;
                tmp0.xyz = tmp1.xyz * _LightColor0.xyz;
                tmp1 = tex2D(_Emission, inp.texcoord.xy);
                o.sv_target = tmp0 + tmp1;
                return o;
			}
#elif defined(DIRECTIONAL) && defined(LIGHTMAP_ON) && !defined(LIGHTMAP_SHADOW_MIXING) && defined(LIGHTPROBE_SH) && defined(LOD_FADE_CROSSFADE) && defined(SHADOWS_SCREEN) && defined(SHADOWS_SHADOWMASK) && !defined(VERTEXLIGHT_ON)
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
				float4 texcoord4 : TEXCOORD4;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 ShadowColor;
			float4 LightColor;
			float _Opacity;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			sampler2D _Emission;
			
			// Keywords: LOD_FADE_CROSSFADE DIRECTIONAL LIGHTPROBE_SH SHADOWS_SHADOWMASK LIGHTMAP_ON SHADOWS_SCREEN
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
                o.texcoord3.xyz = float3(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3]) * v.vertex.www + tmp0.xyz;
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
                o.texcoord2.xyz = tmp1.www * tmp1.xyz;
                tmp1.xyz = tmp0.xyw * float3(0.5, 0.5, 0.5);
                o.texcoord4.zw = tmp0.zw;
                tmp1.w = tmp1.y * _ProjectionParams.x;
                o.texcoord4.xy = tmp1.zz + tmp1.xw;
                return o;
			}
			// Keywords: LOD_FADE_CROSSFADE DIRECTIONAL LIGHTPROBE_SH SHADOWS_SHADOWMASK LIGHTMAP_ON SHADOWS_SCREEN
			fout frag(v2f inp)
			{
 UNITY_SETUP_INSTANCE_ID(inp);
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = dot(inp.position.xy, float2(0.0671106, 0.0058372));
                tmp0.x = frac(tmp0.x);
                tmp0.x = tmp0.x * 52.98292;
                tmp0.x = frac(tmp0.x);
                tmp0.x = unity_LODFade.x - tmp0.x;
                tmp0.x = tmp0.x < 0.0;
                if (tmp0.x) {
                    discard;
                }
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1.x = tmp0.w - 0.5;
                tmp1.x = tmp1.x < 0.0;
                if (tmp1.x) {
                    discard;
                }
                tmp1.xyz = inp.texcoord3.xyz - unity_ShadowFadeCenterAndType.xyz;
                tmp1.x = dot(tmp1.xyz, tmp1.xyz);
                tmp1.x = sqrt(tmp1.x);
                tmp1.yzw = _WorldSpaceCameraPos - inp.texcoord3.xyz;
                tmp2.x = unity_MatrixV._m20;
                tmp2.y = unity_MatrixV._m21;
                tmp2.z = unity_MatrixV._m22;
                tmp1.y = dot(tmp1.xyz, tmp2.xyz);
                tmp1.x = tmp1.x - tmp1.y;
                tmp1.x = unity_ShadowFadeCenterAndType.w * tmp1.x + tmp1.y;
                tmp1.x = saturate(tmp1.x * _LightShadowData.z + _LightShadowData.w);
                tmp1.y = tmp1.x < 1.0;
                tmp1.z = tmp1.x >= 1.0;
                tmp1.yz = tmp1.yz ? 1.0 : 0.0;
                tmp2.xy = inp.texcoord4.xy / inp.texcoord4.ww;
                tmp2 = tex2D(_ShadowMapTexture, tmp2.xy);
                tmp1.y = tmp1.y * tmp2.x + tmp1.z;
                tmp1.y = tmp1.y > 0.5;
                tmp1.x = tmp1.y ? 0.0 : tmp1.x;
                tmp1.y = tmp1.y ? 1.0 : 0.0;
                tmp1.x = tmp1.x + tmp1.y;
                tmp1.x = tmp1.x * _Opacity;
                tmp1.y = dot(_WorldSpaceLightPos0.xyz, inp.texcoord2.xyz);
                tmp1.y = saturate(tmp1.y * 100.0);
                tmp1.z = tmp1.y * -2.0 + 3.0;
                tmp1.y = tmp1.y * tmp1.y;
                tmp1.y = tmp1.y * tmp1.z;
                tmp1.x = tmp1.x * tmp1.y;
                tmp1.yzw = LightColor.xyz - ShadowColor.xyz;
                tmp1.xyz = tmp1.xxx * tmp1.yzw + ShadowColor.xyz;
                tmp1.xyz = tmp0.xyz * tmp1.xyz;
                tmp0.xyz = tmp1.xyz * _LightColor0.xyz;
                tmp1 = tex2D(_Emission, inp.texcoord.xy);
                o.sv_target = tmp0 + tmp1;
                return o;
			}
#elif defined(DIRECTIONAL) && defined(LIGHTMAP_ON) && defined(LIGHTMAP_SHADOW_MIXING) && !defined(LIGHTPROBE_SH) && defined(LOD_FADE_CROSSFADE) && defined(SHADOWS_SCREEN) && defined(SHADOWS_SHADOWMASK) && !defined(VERTEXLIGHT_ON)
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
				float4 texcoord4 : TEXCOORD4;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 ShadowColor;
			float4 LightColor;
			float _Opacity;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			sampler2D _Emission;
			
			// Keywords: LOD_FADE_CROSSFADE DIRECTIONAL SHADOWS_SHADOWMASK LIGHTMAP_ON LIGHTMAP_SHADOW_MIXING SHADOWS_SCREEN
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
                o.texcoord3.xyz = float3(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3]) * v.vertex.www + tmp0.xyz;
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
                o.texcoord2.xyz = tmp1.www * tmp1.xyz;
                tmp1.xyz = tmp0.xyw * float3(0.5, 0.5, 0.5);
                o.texcoord4.zw = tmp0.zw;
                tmp1.w = tmp1.y * _ProjectionParams.x;
                o.texcoord4.xy = tmp1.zz + tmp1.xw;
                return o;
			}
			// Keywords: LOD_FADE_CROSSFADE DIRECTIONAL SHADOWS_SHADOWMASK LIGHTMAP_ON LIGHTMAP_SHADOW_MIXING SHADOWS_SCREEN
			fout frag(v2f inp)
			{
 UNITY_SETUP_INSTANCE_ID(inp);
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = dot(inp.position.xy, float2(0.0671106, 0.0058372));
                tmp0.x = frac(tmp0.x);
                tmp0.x = tmp0.x * 52.98292;
                tmp0.x = frac(tmp0.x);
                tmp0.x = unity_LODFade.x - tmp0.x;
                tmp0.x = tmp0.x < 0.0;
                if (tmp0.x) {
                    discard;
                }
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1.x = tmp0.w - 0.5;
                tmp1.x = tmp1.x < 0.0;
                if (tmp1.x) {
                    discard;
                }
                tmp1.xyz = inp.texcoord3.xyz - unity_ShadowFadeCenterAndType.xyz;
                tmp1.x = dot(tmp1.xyz, tmp1.xyz);
                tmp1.x = sqrt(tmp1.x);
                tmp1.yzw = _WorldSpaceCameraPos - inp.texcoord3.xyz;
                tmp2.x = unity_MatrixV._m20;
                tmp2.y = unity_MatrixV._m21;
                tmp2.z = unity_MatrixV._m22;
                tmp1.y = dot(tmp1.xyz, tmp2.xyz);
                tmp1.x = tmp1.x - tmp1.y;
                tmp1.x = unity_ShadowFadeCenterAndType.w * tmp1.x + tmp1.y;
                tmp1.x = saturate(tmp1.x * _LightShadowData.z + _LightShadowData.w);
                tmp1.y = tmp1.x < 1.0;
                tmp1.z = tmp1.x >= 1.0;
                tmp1.yz = tmp1.yz ? 1.0 : 0.0;
                tmp2.xy = inp.texcoord4.xy / inp.texcoord4.ww;
                tmp2 = tex2D(_ShadowMapTexture, tmp2.xy);
                tmp1.y = tmp1.y * tmp2.x + tmp1.z;
                tmp1.y = tmp1.y > 0.5;
                tmp1.x = tmp1.y ? 0.0 : tmp1.x;
                tmp1.y = tmp1.y ? 1.0 : 0.0;
                tmp1.x = tmp1.x + tmp1.y;
                tmp1.x = tmp1.x * _Opacity;
                tmp1.y = dot(_WorldSpaceLightPos0.xyz, inp.texcoord2.xyz);
                tmp1.y = saturate(tmp1.y * 100.0);
                tmp1.z = tmp1.y * -2.0 + 3.0;
                tmp1.y = tmp1.y * tmp1.y;
                tmp1.y = tmp1.y * tmp1.z;
                tmp1.x = tmp1.x * tmp1.y;
                tmp1.yzw = LightColor.xyz - ShadowColor.xyz;
                tmp1.xyz = tmp1.xxx * tmp1.yzw + ShadowColor.xyz;
                tmp1.xyz = tmp0.xyz * tmp1.xyz;
                tmp0.xyz = tmp1.xyz * _LightColor0.xyz;
                tmp1 = tex2D(_Emission, inp.texcoord.xy);
                o.sv_target = tmp0 + tmp1;
                return o;
			}
#elif defined(DIRECTIONAL) && !defined(LIGHTMAP_ON) && defined(LIGHTMAP_SHADOW_MIXING) && defined(LIGHTPROBE_SH) && defined(LOD_FADE_CROSSFADE) && defined(SHADOWS_SCREEN) && !defined(SHADOWS_SHADOWMASK) && defined(VERTEXLIGHT_ON)
			#include "UnityCG.cginc"
#include "AutoLight.cginc"
			struct v2f
			{
 UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float3 texcoord2 : TEXCOORD2;
				float3 texcoord3 : TEXCOORD3;
				float4 texcoord4 : TEXCOORD4;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 ShadowColor;
			float4 LightColor;
			float _Opacity;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			sampler2D _Emission;
			
			// Keywords: LOD_FADE_CROSSFADE DIRECTIONAL LIGHTPROBE_SH LIGHTMAP_SHADOW_MIXING SHADOWS_SCREEN VERTEXLIGHT_ON
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
                o.texcoord3.xyz = float3(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3]) * v.vertex.www + tmp0.xyz;
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
                o.texcoord2.xyz = tmp1.www * tmp1.xyz;
                tmp1.xyz = tmp0.xyw * float3(0.5, 0.5, 0.5);
                o.texcoord4.zw = tmp0.zw;
                tmp1.w = tmp1.y * _ProjectionParams.x;
                o.texcoord4.xy = tmp1.zz + tmp1.xw;
                return o;
			}
			// Keywords: LOD_FADE_CROSSFADE DIRECTIONAL LIGHTPROBE_SH LIGHTMAP_SHADOW_MIXING SHADOWS_SCREEN
			fout frag(v2f inp)
			{
 UNITY_SETUP_INSTANCE_ID(inp);
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = dot(inp.position.xy, float2(0.0671106, 0.0058372));
                tmp0.x = frac(tmp0.x);
                tmp0.x = tmp0.x * 52.98292;
                tmp0.x = frac(tmp0.x);
                tmp0.x = unity_LODFade.x - tmp0.x;
                tmp0.x = tmp0.x < 0.0;
                if (tmp0.x) {
                    discard;
                }
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1.x = tmp0.w - 0.5;
                tmp1.x = tmp1.x < 0.0;
                if (tmp1.x) {
                    discard;
                }
                tmp1.xyz = inp.texcoord3.xyz - unity_ShadowFadeCenterAndType.xyz;
                tmp1.x = dot(tmp1.xyz, tmp1.xyz);
                tmp1.x = sqrt(tmp1.x);
                tmp1.yzw = _WorldSpaceCameraPos - inp.texcoord3.xyz;
                tmp2.x = unity_MatrixV._m20;
                tmp2.y = unity_MatrixV._m21;
                tmp2.z = unity_MatrixV._m22;
                tmp1.y = dot(tmp1.xyz, tmp2.xyz);
                tmp1.x = tmp1.x - tmp1.y;
                tmp1.x = unity_ShadowFadeCenterAndType.w * tmp1.x + tmp1.y;
                tmp1.x = saturate(tmp1.x * _LightShadowData.z + _LightShadowData.w);
                tmp1.y = tmp1.x < 1.0;
                tmp1.z = tmp1.x >= 1.0;
                tmp1.yz = tmp1.yz ? 1.0 : 0.0;
                tmp2.xy = inp.texcoord4.xy / inp.texcoord4.ww;
                tmp2 = tex2D(_ShadowMapTexture, tmp2.xy);
                tmp1.y = tmp1.y * tmp2.x + tmp1.z;
                tmp1.y = tmp1.y > 0.5;
                tmp1.x = tmp1.y ? 0.0 : tmp1.x;
                tmp1.y = tmp1.y ? 1.0 : 0.0;
                tmp1.x = tmp1.x + tmp1.y;
                tmp1.x = tmp1.x * _Opacity;
                tmp1.y = dot(_WorldSpaceLightPos0.xyz, inp.texcoord2.xyz);
                tmp1.y = saturate(tmp1.y * 100.0);
                tmp1.z = tmp1.y * -2.0 + 3.0;
                tmp1.y = tmp1.y * tmp1.y;
                tmp1.y = tmp1.y * tmp1.z;
                tmp1.x = tmp1.x * tmp1.y;
                tmp1.yzw = LightColor.xyz - ShadowColor.xyz;
                tmp1.xyz = tmp1.xxx * tmp1.yzw + ShadowColor.xyz;
                tmp1.xyz = tmp0.xyz * tmp1.xyz;
                tmp0.xyz = tmp1.xyz * _LightColor0.xyz;
                tmp1 = tex2D(_Emission, inp.texcoord.xy);
                o.sv_target = tmp0 + tmp1;
                return o;
			}
#elif defined(DIRECTIONAL) && !defined(LIGHTMAP_ON) && !defined(LIGHTMAP_SHADOW_MIXING) && defined(LIGHTPROBE_SH) && defined(LOD_FADE_CROSSFADE) && defined(SHADOWS_SCREEN) && defined(SHADOWS_SHADOWMASK) && defined(VERTEXLIGHT_ON)
			#include "UnityCG.cginc"
#include "AutoLight.cginc"
			struct v2f
			{
 UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float3 texcoord2 : TEXCOORD2;
				float3 texcoord3 : TEXCOORD3;
				float4 texcoord4 : TEXCOORD4;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 ShadowColor;
			float4 LightColor;
			float _Opacity;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			sampler2D _Emission;
			
			// Keywords: LOD_FADE_CROSSFADE DIRECTIONAL LIGHTPROBE_SH SHADOWS_SHADOWMASK SHADOWS_SCREEN VERTEXLIGHT_ON
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
                o.texcoord3.xyz = float3(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3]) * v.vertex.www + tmp0.xyz;
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
                o.texcoord2.xyz = tmp1.www * tmp1.xyz;
                tmp1.xyz = tmp0.xyw * float3(0.5, 0.5, 0.5);
                o.texcoord4.zw = tmp0.zw;
                tmp1.w = tmp1.y * _ProjectionParams.x;
                o.texcoord4.xy = tmp1.zz + tmp1.xw;
                return o;
			}
			// Keywords: LOD_FADE_CROSSFADE DIRECTIONAL LIGHTPROBE_SH SHADOWS_SHADOWMASK SHADOWS_SCREEN
			fout frag(v2f inp)
			{
 UNITY_SETUP_INSTANCE_ID(inp);
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = dot(inp.position.xy, float2(0.0671106, 0.0058372));
                tmp0.x = frac(tmp0.x);
                tmp0.x = tmp0.x * 52.98292;
                tmp0.x = frac(tmp0.x);
                tmp0.x = unity_LODFade.x - tmp0.x;
                tmp0.x = tmp0.x < 0.0;
                if (tmp0.x) {
                    discard;
                }
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1.x = tmp0.w - 0.5;
                tmp1.x = tmp1.x < 0.0;
                if (tmp1.x) {
                    discard;
                }
                tmp1.xyz = inp.texcoord3.xyz - unity_ShadowFadeCenterAndType.xyz;
                tmp1.x = dot(tmp1.xyz, tmp1.xyz);
                tmp1.x = sqrt(tmp1.x);
                tmp1.yzw = _WorldSpaceCameraPos - inp.texcoord3.xyz;
                tmp2.x = unity_MatrixV._m20;
                tmp2.y = unity_MatrixV._m21;
                tmp2.z = unity_MatrixV._m22;
                tmp1.y = dot(tmp1.xyz, tmp2.xyz);
                tmp1.x = tmp1.x - tmp1.y;
                tmp1.x = unity_ShadowFadeCenterAndType.w * tmp1.x + tmp1.y;
                tmp1.x = saturate(tmp1.x * _LightShadowData.z + _LightShadowData.w);
                tmp1.y = tmp1.x < 1.0;
                tmp1.z = tmp1.x >= 1.0;
                tmp1.yz = tmp1.yz ? 1.0 : 0.0;
                tmp2.xy = inp.texcoord4.xy / inp.texcoord4.ww;
                tmp2 = tex2D(_ShadowMapTexture, tmp2.xy);
                tmp1.y = tmp1.y * tmp2.x + tmp1.z;
                tmp1.y = tmp1.y > 0.5;
                tmp1.x = tmp1.y ? 0.0 : tmp1.x;
                tmp1.y = tmp1.y ? 1.0 : 0.0;
                tmp1.x = tmp1.x + tmp1.y;
                tmp1.x = tmp1.x * _Opacity;
                tmp1.y = dot(_WorldSpaceLightPos0.xyz, inp.texcoord2.xyz);
                tmp1.y = saturate(tmp1.y * 100.0);
                tmp1.z = tmp1.y * -2.0 + 3.0;
                tmp1.y = tmp1.y * tmp1.y;
                tmp1.y = tmp1.y * tmp1.z;
                tmp1.x = tmp1.x * tmp1.y;
                tmp1.yzw = LightColor.xyz - ShadowColor.xyz;
                tmp1.xyz = tmp1.xxx * tmp1.yzw + ShadowColor.xyz;
                tmp1.xyz = tmp0.xyz * tmp1.xyz;
                tmp0.xyz = tmp1.xyz * _LightColor0.xyz;
                tmp1 = tex2D(_Emission, inp.texcoord.xy);
                o.sv_target = tmp0 + tmp1;
                return o;
			}
#elif defined(DIRECTIONAL) && !defined(LIGHTMAP_ON) && defined(LIGHTMAP_SHADOW_MIXING) && !defined(LIGHTPROBE_SH) && defined(LOD_FADE_CROSSFADE) && defined(SHADOWS_SCREEN) && defined(SHADOWS_SHADOWMASK) && defined(VERTEXLIGHT_ON)
			#include "UnityCG.cginc"
#include "AutoLight.cginc"
			struct v2f
			{
 UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float3 texcoord2 : TEXCOORD2;
				float3 texcoord3 : TEXCOORD3;
				float4 texcoord4 : TEXCOORD4;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 ShadowColor;
			float4 LightColor;
			float _Opacity;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			sampler2D _Emission;
			
			// Keywords: LOD_FADE_CROSSFADE DIRECTIONAL SHADOWS_SHADOWMASK LIGHTMAP_SHADOW_MIXING SHADOWS_SCREEN VERTEXLIGHT_ON
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
                o.texcoord3.xyz = float3(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3]) * v.vertex.www + tmp0.xyz;
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
                o.texcoord2.xyz = tmp1.www * tmp1.xyz;
                tmp1.xyz = tmp0.xyw * float3(0.5, 0.5, 0.5);
                o.texcoord4.zw = tmp0.zw;
                tmp1.w = tmp1.y * _ProjectionParams.x;
                o.texcoord4.xy = tmp1.zz + tmp1.xw;
                return o;
			}
			// Keywords: LOD_FADE_CROSSFADE DIRECTIONAL SHADOWS_SCREEN
			fout frag(v2f inp)
			{
 UNITY_SETUP_INSTANCE_ID(inp);
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = dot(inp.position.xy, float2(0.0671106, 0.0058372));
                tmp0.x = frac(tmp0.x);
                tmp0.x = tmp0.x * 52.98292;
                tmp0.x = frac(tmp0.x);
                tmp0.x = unity_LODFade.x - tmp0.x;
                tmp0.x = tmp0.x < 0.0;
                if (tmp0.x) {
                    discard;
                }
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1.x = tmp0.w - 0.5;
                tmp1.x = tmp1.x < 0.0;
                if (tmp1.x) {
                    discard;
                }
                tmp1.xyz = inp.texcoord3.xyz - unity_ShadowFadeCenterAndType.xyz;
                tmp1.x = dot(tmp1.xyz, tmp1.xyz);
                tmp1.x = sqrt(tmp1.x);
                tmp1.yzw = _WorldSpaceCameraPos - inp.texcoord3.xyz;
                tmp2.x = unity_MatrixV._m20;
                tmp2.y = unity_MatrixV._m21;
                tmp2.z = unity_MatrixV._m22;
                tmp1.y = dot(tmp1.xyz, tmp2.xyz);
                tmp1.x = tmp1.x - tmp1.y;
                tmp1.x = unity_ShadowFadeCenterAndType.w * tmp1.x + tmp1.y;
                tmp1.x = saturate(tmp1.x * _LightShadowData.z + _LightShadowData.w);
                tmp1.y = tmp1.x < 1.0;
                tmp1.z = tmp1.x >= 1.0;
                tmp1.yz = tmp1.yz ? 1.0 : 0.0;
                tmp2.xy = inp.texcoord4.xy / inp.texcoord4.ww;
                tmp2 = tex2D(_ShadowMapTexture, tmp2.xy);
                tmp1.y = tmp1.y * tmp2.x + tmp1.z;
                tmp1.y = tmp1.y > 0.5;
                tmp1.x = tmp1.y ? 0.0 : tmp1.x;
                tmp1.y = tmp1.y ? 1.0 : 0.0;
                tmp1.x = tmp1.x + tmp1.y;
                tmp1.x = tmp1.x * _Opacity;
                tmp1.y = dot(_WorldSpaceLightPos0.xyz, inp.texcoord2.xyz);
                tmp1.y = saturate(tmp1.y * 100.0);
                tmp1.z = tmp1.y * -2.0 + 3.0;
                tmp1.y = tmp1.y * tmp1.y;
                tmp1.y = tmp1.y * tmp1.z;
                tmp1.x = tmp1.x * tmp1.y;
                tmp1.yzw = LightColor.xyz - ShadowColor.xyz;
                tmp1.xyz = tmp1.xxx * tmp1.yzw + ShadowColor.xyz;
                tmp1.xyz = tmp0.xyz * tmp1.xyz;
                tmp0.xyz = tmp1.xyz * _LightColor0.xyz;
                tmp1 = tex2D(_Emission, inp.texcoord.xy);
                o.sv_target = tmp0 + tmp1;
                return o;
			}
#elif defined(DIRECTIONAL) && defined(LIGHTMAP_ON) && defined(LIGHTMAP_SHADOW_MIXING) && defined(LIGHTPROBE_SH) && !defined(LOD_FADE_CROSSFADE) && !defined(SHADOWS_SCREEN) && defined(SHADOWS_SHADOWMASK) && !defined(VERTEXLIGHT_ON)
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
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 ShadowColor;
			float4 LightColor;
			float _Opacity;
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
                tmp0 = v.vertex.yyyy * float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
                tmp0 = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]) * v.vertex.xxxx + tmp0;
                tmp0 = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]) * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
                o.texcoord3.xyz = float3(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3]) * v.vertex.www + tmp0.xyz;
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
                o.texcoord2.xyz = tmp0.www * tmp0.xyz;
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
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1.x = tmp0.w - 0.5;
                tmp1.x = tmp1.x < 0.0;
                if (tmp1.x) {
                    discard;
                }
                tmp1.xyz = inp.texcoord3.xyz - unity_ShadowFadeCenterAndType.xyz;
                tmp1.x = dot(tmp1.xyz, tmp1.xyz);
                tmp1.x = sqrt(tmp1.x);
                tmp1.yzw = _WorldSpaceCameraPos - inp.texcoord3.xyz;
                tmp2.x = unity_MatrixV._m20;
                tmp2.y = unity_MatrixV._m21;
                tmp2.z = unity_MatrixV._m22;
                tmp1.y = dot(tmp1.xyz, tmp2.xyz);
                tmp1.x = tmp1.x - tmp1.y;
                tmp1.x = unity_ShadowFadeCenterAndType.w * tmp1.x + tmp1.y;
                tmp1.x = saturate(tmp1.x * _LightShadowData.z + _LightShadowData.w);
                tmp1.y = tmp1.x < 1.0;
                tmp1.z = tmp1.x >= 1.0;
                tmp1.yz = tmp1.yz ? 1.0 : 0.0;
                tmp1.y = tmp1.z + tmp1.y;
                tmp1.y = tmp1.y > 0.5;
                tmp1.x = tmp1.y ? 0.0 : tmp1.x;
                tmp1.y = tmp1.y ? 1.0 : 0.0;
                tmp1.x = tmp1.x + tmp1.y;
                tmp1.x = tmp1.x * _Opacity;
                tmp1.y = dot(_WorldSpaceLightPos0.xyz, inp.texcoord2.xyz);
                tmp1.y = saturate(tmp1.y * 100.0);
                tmp1.z = tmp1.y * -2.0 + 3.0;
                tmp1.y = tmp1.y * tmp1.y;
                tmp1.y = tmp1.y * tmp1.z;
                tmp1.x = tmp1.x * tmp1.y;
                tmp1.yzw = LightColor.xyz - ShadowColor.xyz;
                tmp1.xyz = tmp1.xxx * tmp1.yzw + ShadowColor.xyz;
                tmp1.xyz = tmp0.xyz * tmp1.xyz;
                tmp0.xyz = tmp1.xyz * _LightColor0.xyz;
                tmp1 = tex2D(_Emission, inp.texcoord.xy);
                o.sv_target = tmp0 + tmp1;
                return o;
			}
#elif defined(DIRECTIONAL) && !defined(LIGHTMAP_ON) && defined(LIGHTMAP_SHADOW_MIXING) && defined(LIGHTPROBE_SH) && !defined(LOD_FADE_CROSSFADE) && defined(SHADOWS_SCREEN) && defined(SHADOWS_SHADOWMASK) && !defined(VERTEXLIGHT_ON)
			#include "UnityCG.cginc"
#include "AutoLight.cginc"
			struct v2f
			{
 UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float3 texcoord2 : TEXCOORD2;
				float3 texcoord3 : TEXCOORD3;
				float4 texcoord4 : TEXCOORD4;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 ShadowColor;
			float4 LightColor;
			float _Opacity;
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
                tmp0 = v.vertex.yyyy * float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
                tmp0 = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]) * v.vertex.xxxx + tmp0;
                tmp0 = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]) * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
                o.texcoord3.xyz = float3(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3]) * v.vertex.www + tmp0.xyz;
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
                o.texcoord2.xyz = tmp1.www * tmp1.xyz;
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
                float4 tmp2;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1.x = tmp0.w - 0.5;
                tmp1.x = tmp1.x < 0.0;
                if (tmp1.x) {
                    discard;
                }
                tmp1.xyz = inp.texcoord3.xyz - unity_ShadowFadeCenterAndType.xyz;
                tmp1.x = dot(tmp1.xyz, tmp1.xyz);
                tmp1.x = sqrt(tmp1.x);
                tmp1.yzw = _WorldSpaceCameraPos - inp.texcoord3.xyz;
                tmp2.x = unity_MatrixV._m20;
                tmp2.y = unity_MatrixV._m21;
                tmp2.z = unity_MatrixV._m22;
                tmp1.y = dot(tmp1.xyz, tmp2.xyz);
                tmp1.x = tmp1.x - tmp1.y;
                tmp1.x = unity_ShadowFadeCenterAndType.w * tmp1.x + tmp1.y;
                tmp1.x = saturate(tmp1.x * _LightShadowData.z + _LightShadowData.w);
                tmp1.y = tmp1.x < 1.0;
                tmp1.z = tmp1.x >= 1.0;
                tmp1.yz = tmp1.yz ? 1.0 : 0.0;
                tmp2.xy = inp.texcoord4.xy / inp.texcoord4.ww;
                tmp2 = tex2D(_ShadowMapTexture, tmp2.xy);
                tmp1.y = tmp1.y * tmp2.x + tmp1.z;
                tmp1.y = tmp1.y > 0.5;
                tmp1.x = tmp1.y ? 0.0 : tmp1.x;
                tmp1.y = tmp1.y ? 1.0 : 0.0;
                tmp1.x = tmp1.x + tmp1.y;
                tmp1.x = tmp1.x * _Opacity;
                tmp1.y = dot(_WorldSpaceLightPos0.xyz, inp.texcoord2.xyz);
                tmp1.y = saturate(tmp1.y * 100.0);
                tmp1.z = tmp1.y * -2.0 + 3.0;
                tmp1.y = tmp1.y * tmp1.y;
                tmp1.y = tmp1.y * tmp1.z;
                tmp1.x = tmp1.x * tmp1.y;
                tmp1.yzw = LightColor.xyz - ShadowColor.xyz;
                tmp1.xyz = tmp1.xxx * tmp1.yzw + ShadowColor.xyz;
                tmp1.xyz = tmp0.xyz * tmp1.xyz;
                tmp0.xyz = tmp1.xyz * _LightColor0.xyz;
                tmp1 = tex2D(_Emission, inp.texcoord.xy);
                o.sv_target = tmp0 + tmp1;
                return o;
			}
#elif defined(DIRECTIONAL) && defined(LIGHTMAP_ON) && defined(LIGHTMAP_SHADOW_MIXING) && defined(LIGHTPROBE_SH) && !defined(LOD_FADE_CROSSFADE) && defined(SHADOWS_SCREEN) && !defined(SHADOWS_SHADOWMASK) && !defined(VERTEXLIGHT_ON)
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
				float4 texcoord4 : TEXCOORD4;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 ShadowColor;
			float4 LightColor;
			float _Opacity;
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
                tmp0 = v.vertex.yyyy * float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
                tmp0 = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]) * v.vertex.xxxx + tmp0;
                tmp0 = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]) * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
                o.texcoord3.xyz = float3(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3]) * v.vertex.www + tmp0.xyz;
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
                o.texcoord2.xyz = tmp1.www * tmp1.xyz;
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
                float4 tmp2;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1.x = tmp0.w - 0.5;
                tmp1.x = tmp1.x < 0.0;
                if (tmp1.x) {
                    discard;
                }
                tmp1.xyz = inp.texcoord3.xyz - unity_ShadowFadeCenterAndType.xyz;
                tmp1.x = dot(tmp1.xyz, tmp1.xyz);
                tmp1.x = sqrt(tmp1.x);
                tmp1.yzw = _WorldSpaceCameraPos - inp.texcoord3.xyz;
                tmp2.x = unity_MatrixV._m20;
                tmp2.y = unity_MatrixV._m21;
                tmp2.z = unity_MatrixV._m22;
                tmp1.y = dot(tmp1.xyz, tmp2.xyz);
                tmp1.x = tmp1.x - tmp1.y;
                tmp1.x = unity_ShadowFadeCenterAndType.w * tmp1.x + tmp1.y;
                tmp1.x = saturate(tmp1.x * _LightShadowData.z + _LightShadowData.w);
                tmp1.y = tmp1.x < 1.0;
                tmp1.z = tmp1.x >= 1.0;
                tmp1.yz = tmp1.yz ? 1.0 : 0.0;
                tmp2.xy = inp.texcoord4.xy / inp.texcoord4.ww;
                tmp2 = tex2D(_ShadowMapTexture, tmp2.xy);
                tmp1.y = tmp1.y * tmp2.x + tmp1.z;
                tmp1.y = tmp1.y > 0.5;
                tmp1.x = tmp1.y ? 0.0 : tmp1.x;
                tmp1.y = tmp1.y ? 1.0 : 0.0;
                tmp1.x = tmp1.x + tmp1.y;
                tmp1.x = tmp1.x * _Opacity;
                tmp1.y = dot(_WorldSpaceLightPos0.xyz, inp.texcoord2.xyz);
                tmp1.y = saturate(tmp1.y * 100.0);
                tmp1.z = tmp1.y * -2.0 + 3.0;
                tmp1.y = tmp1.y * tmp1.y;
                tmp1.y = tmp1.y * tmp1.z;
                tmp1.x = tmp1.x * tmp1.y;
                tmp1.yzw = LightColor.xyz - ShadowColor.xyz;
                tmp1.xyz = tmp1.xxx * tmp1.yzw + ShadowColor.xyz;
                tmp1.xyz = tmp0.xyz * tmp1.xyz;
                tmp0.xyz = tmp1.xyz * _LightColor0.xyz;
                tmp1 = tex2D(_Emission, inp.texcoord.xy);
                o.sv_target = tmp0 + tmp1;
                return o;
			}
#elif defined(DIRECTIONAL) && defined(LIGHTMAP_ON) && !defined(LIGHTMAP_SHADOW_MIXING) && defined(LIGHTPROBE_SH) && !defined(LOD_FADE_CROSSFADE) && defined(SHADOWS_SCREEN) && defined(SHADOWS_SHADOWMASK) && !defined(VERTEXLIGHT_ON)
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
				float4 texcoord4 : TEXCOORD4;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 ShadowColor;
			float4 LightColor;
			float _Opacity;
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
                tmp0 = v.vertex.yyyy * float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
                tmp0 = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]) * v.vertex.xxxx + tmp0;
                tmp0 = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]) * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
                o.texcoord3.xyz = float3(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3]) * v.vertex.www + tmp0.xyz;
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
                o.texcoord2.xyz = tmp1.www * tmp1.xyz;
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
                float4 tmp2;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1.x = tmp0.w - 0.5;
                tmp1.x = tmp1.x < 0.0;
                if (tmp1.x) {
                    discard;
                }
                tmp1.xyz = inp.texcoord3.xyz - unity_ShadowFadeCenterAndType.xyz;
                tmp1.x = dot(tmp1.xyz, tmp1.xyz);
                tmp1.x = sqrt(tmp1.x);
                tmp1.yzw = _WorldSpaceCameraPos - inp.texcoord3.xyz;
                tmp2.x = unity_MatrixV._m20;
                tmp2.y = unity_MatrixV._m21;
                tmp2.z = unity_MatrixV._m22;
                tmp1.y = dot(tmp1.xyz, tmp2.xyz);
                tmp1.x = tmp1.x - tmp1.y;
                tmp1.x = unity_ShadowFadeCenterAndType.w * tmp1.x + tmp1.y;
                tmp1.x = saturate(tmp1.x * _LightShadowData.z + _LightShadowData.w);
                tmp1.y = tmp1.x < 1.0;
                tmp1.z = tmp1.x >= 1.0;
                tmp1.yz = tmp1.yz ? 1.0 : 0.0;
                tmp2.xy = inp.texcoord4.xy / inp.texcoord4.ww;
                tmp2 = tex2D(_ShadowMapTexture, tmp2.xy);
                tmp1.y = tmp1.y * tmp2.x + tmp1.z;
                tmp1.y = tmp1.y > 0.5;
                tmp1.x = tmp1.y ? 0.0 : tmp1.x;
                tmp1.y = tmp1.y ? 1.0 : 0.0;
                tmp1.x = tmp1.x + tmp1.y;
                tmp1.x = tmp1.x * _Opacity;
                tmp1.y = dot(_WorldSpaceLightPos0.xyz, inp.texcoord2.xyz);
                tmp1.y = saturate(tmp1.y * 100.0);
                tmp1.z = tmp1.y * -2.0 + 3.0;
                tmp1.y = tmp1.y * tmp1.y;
                tmp1.y = tmp1.y * tmp1.z;
                tmp1.x = tmp1.x * tmp1.y;
                tmp1.yzw = LightColor.xyz - ShadowColor.xyz;
                tmp1.xyz = tmp1.xxx * tmp1.yzw + ShadowColor.xyz;
                tmp1.xyz = tmp0.xyz * tmp1.xyz;
                tmp0.xyz = tmp1.xyz * _LightColor0.xyz;
                tmp1 = tex2D(_Emission, inp.texcoord.xy);
                o.sv_target = tmp0 + tmp1;
                return o;
			}
#elif defined(DIRECTIONAL) && defined(LIGHTMAP_ON) && defined(LIGHTMAP_SHADOW_MIXING) && !defined(LIGHTPROBE_SH) && !defined(LOD_FADE_CROSSFADE) && defined(SHADOWS_SCREEN) && defined(SHADOWS_SHADOWMASK) && !defined(VERTEXLIGHT_ON)
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
				float4 texcoord4 : TEXCOORD4;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 ShadowColor;
			float4 LightColor;
			float _Opacity;
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
                tmp0 = v.vertex.yyyy * float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
                tmp0 = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]) * v.vertex.xxxx + tmp0;
                tmp0 = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]) * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
                o.texcoord3.xyz = float3(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3]) * v.vertex.www + tmp0.xyz;
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
                o.texcoord2.xyz = tmp1.www * tmp1.xyz;
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
                float4 tmp2;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1.x = tmp0.w - 0.5;
                tmp1.x = tmp1.x < 0.0;
                if (tmp1.x) {
                    discard;
                }
                tmp1.xyz = inp.texcoord3.xyz - unity_ShadowFadeCenterAndType.xyz;
                tmp1.x = dot(tmp1.xyz, tmp1.xyz);
                tmp1.x = sqrt(tmp1.x);
                tmp1.yzw = _WorldSpaceCameraPos - inp.texcoord3.xyz;
                tmp2.x = unity_MatrixV._m20;
                tmp2.y = unity_MatrixV._m21;
                tmp2.z = unity_MatrixV._m22;
                tmp1.y = dot(tmp1.xyz, tmp2.xyz);
                tmp1.x = tmp1.x - tmp1.y;
                tmp1.x = unity_ShadowFadeCenterAndType.w * tmp1.x + tmp1.y;
                tmp1.x = saturate(tmp1.x * _LightShadowData.z + _LightShadowData.w);
                tmp1.y = tmp1.x < 1.0;
                tmp1.z = tmp1.x >= 1.0;
                tmp1.yz = tmp1.yz ? 1.0 : 0.0;
                tmp2.xy = inp.texcoord4.xy / inp.texcoord4.ww;
                tmp2 = tex2D(_ShadowMapTexture, tmp2.xy);
                tmp1.y = tmp1.y * tmp2.x + tmp1.z;
                tmp1.y = tmp1.y > 0.5;
                tmp1.x = tmp1.y ? 0.0 : tmp1.x;
                tmp1.y = tmp1.y ? 1.0 : 0.0;
                tmp1.x = tmp1.x + tmp1.y;
                tmp1.x = tmp1.x * _Opacity;
                tmp1.y = dot(_WorldSpaceLightPos0.xyz, inp.texcoord2.xyz);
                tmp1.y = saturate(tmp1.y * 100.0);
                tmp1.z = tmp1.y * -2.0 + 3.0;
                tmp1.y = tmp1.y * tmp1.y;
                tmp1.y = tmp1.y * tmp1.z;
                tmp1.x = tmp1.x * tmp1.y;
                tmp1.yzw = LightColor.xyz - ShadowColor.xyz;
                tmp1.xyz = tmp1.xxx * tmp1.yzw + ShadowColor.xyz;
                tmp1.xyz = tmp0.xyz * tmp1.xyz;
                tmp0.xyz = tmp1.xyz * _LightColor0.xyz;
                tmp1 = tex2D(_Emission, inp.texcoord.xy);
                o.sv_target = tmp0 + tmp1;
                return o;
			}
#elif defined(DIRECTIONAL) && !defined(LIGHTMAP_ON) && defined(LIGHTMAP_SHADOW_MIXING) && defined(LIGHTPROBE_SH) && !defined(LOD_FADE_CROSSFADE) && defined(SHADOWS_SCREEN) && !defined(SHADOWS_SHADOWMASK) && defined(VERTEXLIGHT_ON)
			#include "UnityCG.cginc"
#include "AutoLight.cginc"
			struct v2f
			{
 UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float3 texcoord2 : TEXCOORD2;
				float3 texcoord3 : TEXCOORD3;
				float4 texcoord4 : TEXCOORD4;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 ShadowColor;
			float4 LightColor;
			float _Opacity;
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
                tmp0 = v.vertex.yyyy * float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
                tmp0 = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]) * v.vertex.xxxx + tmp0;
                tmp0 = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]) * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
                o.texcoord3.xyz = float3(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3]) * v.vertex.www + tmp0.xyz;
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
                o.texcoord2.xyz = tmp1.www * tmp1.xyz;
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
                float4 tmp2;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1.x = tmp0.w - 0.5;
                tmp1.x = tmp1.x < 0.0;
                if (tmp1.x) {
                    discard;
                }
                tmp1.xyz = inp.texcoord3.xyz - unity_ShadowFadeCenterAndType.xyz;
                tmp1.x = dot(tmp1.xyz, tmp1.xyz);
                tmp1.x = sqrt(tmp1.x);
                tmp1.yzw = _WorldSpaceCameraPos - inp.texcoord3.xyz;
                tmp2.x = unity_MatrixV._m20;
                tmp2.y = unity_MatrixV._m21;
                tmp2.z = unity_MatrixV._m22;
                tmp1.y = dot(tmp1.xyz, tmp2.xyz);
                tmp1.x = tmp1.x - tmp1.y;
                tmp1.x = unity_ShadowFadeCenterAndType.w * tmp1.x + tmp1.y;
                tmp1.x = saturate(tmp1.x * _LightShadowData.z + _LightShadowData.w);
                tmp1.y = tmp1.x < 1.0;
                tmp1.z = tmp1.x >= 1.0;
                tmp1.yz = tmp1.yz ? 1.0 : 0.0;
                tmp2.xy = inp.texcoord4.xy / inp.texcoord4.ww;
                tmp2 = tex2D(_ShadowMapTexture, tmp2.xy);
                tmp1.y = tmp1.y * tmp2.x + tmp1.z;
                tmp1.y = tmp1.y > 0.5;
                tmp1.x = tmp1.y ? 0.0 : tmp1.x;
                tmp1.y = tmp1.y ? 1.0 : 0.0;
                tmp1.x = tmp1.x + tmp1.y;
                tmp1.x = tmp1.x * _Opacity;
                tmp1.y = dot(_WorldSpaceLightPos0.xyz, inp.texcoord2.xyz);
                tmp1.y = saturate(tmp1.y * 100.0);
                tmp1.z = tmp1.y * -2.0 + 3.0;
                tmp1.y = tmp1.y * tmp1.y;
                tmp1.y = tmp1.y * tmp1.z;
                tmp1.x = tmp1.x * tmp1.y;
                tmp1.yzw = LightColor.xyz - ShadowColor.xyz;
                tmp1.xyz = tmp1.xxx * tmp1.yzw + ShadowColor.xyz;
                tmp1.xyz = tmp0.xyz * tmp1.xyz;
                tmp0.xyz = tmp1.xyz * _LightColor0.xyz;
                tmp1 = tex2D(_Emission, inp.texcoord.xy);
                o.sv_target = tmp0 + tmp1;
                return o;
			}
#elif defined(DIRECTIONAL) && !defined(LIGHTMAP_ON) && !defined(LIGHTMAP_SHADOW_MIXING) && defined(LIGHTPROBE_SH) && !defined(LOD_FADE_CROSSFADE) && defined(SHADOWS_SCREEN) && defined(SHADOWS_SHADOWMASK) && defined(VERTEXLIGHT_ON)
			#include "UnityCG.cginc"
#include "AutoLight.cginc"
			struct v2f
			{
 UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float3 texcoord2 : TEXCOORD2;
				float3 texcoord3 : TEXCOORD3;
				float4 texcoord4 : TEXCOORD4;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 ShadowColor;
			float4 LightColor;
			float _Opacity;
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
                tmp0 = v.vertex.yyyy * float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
                tmp0 = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]) * v.vertex.xxxx + tmp0;
                tmp0 = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]) * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
                o.texcoord3.xyz = float3(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3]) * v.vertex.www + tmp0.xyz;
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
                o.texcoord2.xyz = tmp1.www * tmp1.xyz;
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
                float4 tmp2;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1.x = tmp0.w - 0.5;
                tmp1.x = tmp1.x < 0.0;
                if (tmp1.x) {
                    discard;
                }
                tmp1.xyz = inp.texcoord3.xyz - unity_ShadowFadeCenterAndType.xyz;
                tmp1.x = dot(tmp1.xyz, tmp1.xyz);
                tmp1.x = sqrt(tmp1.x);
                tmp1.yzw = _WorldSpaceCameraPos - inp.texcoord3.xyz;
                tmp2.x = unity_MatrixV._m20;
                tmp2.y = unity_MatrixV._m21;
                tmp2.z = unity_MatrixV._m22;
                tmp1.y = dot(tmp1.xyz, tmp2.xyz);
                tmp1.x = tmp1.x - tmp1.y;
                tmp1.x = unity_ShadowFadeCenterAndType.w * tmp1.x + tmp1.y;
                tmp1.x = saturate(tmp1.x * _LightShadowData.z + _LightShadowData.w);
                tmp1.y = tmp1.x < 1.0;
                tmp1.z = tmp1.x >= 1.0;
                tmp1.yz = tmp1.yz ? 1.0 : 0.0;
                tmp2.xy = inp.texcoord4.xy / inp.texcoord4.ww;
                tmp2 = tex2D(_ShadowMapTexture, tmp2.xy);
                tmp1.y = tmp1.y * tmp2.x + tmp1.z;
                tmp1.y = tmp1.y > 0.5;
                tmp1.x = tmp1.y ? 0.0 : tmp1.x;
                tmp1.y = tmp1.y ? 1.0 : 0.0;
                tmp1.x = tmp1.x + tmp1.y;
                tmp1.x = tmp1.x * _Opacity;
                tmp1.y = dot(_WorldSpaceLightPos0.xyz, inp.texcoord2.xyz);
                tmp1.y = saturate(tmp1.y * 100.0);
                tmp1.z = tmp1.y * -2.0 + 3.0;
                tmp1.y = tmp1.y * tmp1.y;
                tmp1.y = tmp1.y * tmp1.z;
                tmp1.x = tmp1.x * tmp1.y;
                tmp1.yzw = LightColor.xyz - ShadowColor.xyz;
                tmp1.xyz = tmp1.xxx * tmp1.yzw + ShadowColor.xyz;
                tmp1.xyz = tmp0.xyz * tmp1.xyz;
                tmp0.xyz = tmp1.xyz * _LightColor0.xyz;
                tmp1 = tex2D(_Emission, inp.texcoord.xy);
                o.sv_target = tmp0 + tmp1;
                return o;
			}
#elif defined(DIRECTIONAL) && !defined(LIGHTMAP_ON) && defined(LIGHTMAP_SHADOW_MIXING) && !defined(LIGHTPROBE_SH) && !defined(LOD_FADE_CROSSFADE) && defined(SHADOWS_SCREEN) && defined(SHADOWS_SHADOWMASK) && defined(VERTEXLIGHT_ON)
			#include "UnityCG.cginc"
#include "AutoLight.cginc"
			struct v2f
			{
 UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float3 texcoord2 : TEXCOORD2;
				float3 texcoord3 : TEXCOORD3;
				float4 texcoord4 : TEXCOORD4;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 ShadowColor;
			float4 LightColor;
			float _Opacity;
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
                tmp0 = v.vertex.yyyy * float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
                tmp0 = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]) * v.vertex.xxxx + tmp0;
                tmp0 = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]) * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
                o.texcoord3.xyz = float3(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3]) * v.vertex.www + tmp0.xyz;
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
                o.texcoord2.xyz = tmp1.www * tmp1.xyz;
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
                float4 tmp2;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1.x = tmp0.w - 0.5;
                tmp1.x = tmp1.x < 0.0;
                if (tmp1.x) {
                    discard;
                }
                tmp1.xyz = inp.texcoord3.xyz - unity_ShadowFadeCenterAndType.xyz;
                tmp1.x = dot(tmp1.xyz, tmp1.xyz);
                tmp1.x = sqrt(tmp1.x);
                tmp1.yzw = _WorldSpaceCameraPos - inp.texcoord3.xyz;
                tmp2.x = unity_MatrixV._m20;
                tmp2.y = unity_MatrixV._m21;
                tmp2.z = unity_MatrixV._m22;
                tmp1.y = dot(tmp1.xyz, tmp2.xyz);
                tmp1.x = tmp1.x - tmp1.y;
                tmp1.x = unity_ShadowFadeCenterAndType.w * tmp1.x + tmp1.y;
                tmp1.x = saturate(tmp1.x * _LightShadowData.z + _LightShadowData.w);
                tmp1.y = tmp1.x < 1.0;
                tmp1.z = tmp1.x >= 1.0;
                tmp1.yz = tmp1.yz ? 1.0 : 0.0;
                tmp2.xy = inp.texcoord4.xy / inp.texcoord4.ww;
                tmp2 = tex2D(_ShadowMapTexture, tmp2.xy);
                tmp1.y = tmp1.y * tmp2.x + tmp1.z;
                tmp1.y = tmp1.y > 0.5;
                tmp1.x = tmp1.y ? 0.0 : tmp1.x;
                tmp1.y = tmp1.y ? 1.0 : 0.0;
                tmp1.x = tmp1.x + tmp1.y;
                tmp1.x = tmp1.x * _Opacity;
                tmp1.y = dot(_WorldSpaceLightPos0.xyz, inp.texcoord2.xyz);
                tmp1.y = saturate(tmp1.y * 100.0);
                tmp1.z = tmp1.y * -2.0 + 3.0;
                tmp1.y = tmp1.y * tmp1.y;
                tmp1.y = tmp1.y * tmp1.z;
                tmp1.x = tmp1.x * tmp1.y;
                tmp1.yzw = LightColor.xyz - ShadowColor.xyz;
                tmp1.xyz = tmp1.xxx * tmp1.yzw + ShadowColor.xyz;
                tmp1.xyz = tmp0.xyz * tmp1.xyz;
                tmp0.xyz = tmp1.xyz * _LightColor0.xyz;
                tmp1 = tex2D(_Emission, inp.texcoord.xy);
                o.sv_target = tmp0 + tmp1;
                return o;
			}
#elif defined(DIRECTIONAL) && defined(LIGHTMAP_ON) && defined(LIGHTMAP_SHADOW_MIXING) && defined(LIGHTPROBE_SH) && defined(LOD_FADE_CROSSFADE) && !defined(SHADOWS_SCREEN) && !defined(SHADOWS_SHADOWMASK) && !defined(VERTEXLIGHT_ON)
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
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 ShadowColor;
			float4 LightColor;
			float _Opacity;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			sampler2D _Emission;
			
			// Keywords: LOD_FADE_CROSSFADE DIRECTIONAL LIGHTPROBE_SH LIGHTMAP_ON LIGHTMAP_SHADOW_MIXING
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
                o.texcoord3.xyz = float3(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3]) * v.vertex.www + tmp0.xyz;
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
                o.texcoord2.xyz = tmp0.www * tmp0.xyz;
                return o;
			}
			// Keywords: LOD_FADE_CROSSFADE DIRECTIONAL LIGHTPROBE_SH LIGHTMAP_ON LIGHTMAP_SHADOW_MIXING
			fout frag(v2f inp)
			{
 UNITY_SETUP_INSTANCE_ID(inp);
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = dot(inp.position.xy, float2(0.0671106, 0.0058372));
                tmp0.x = frac(tmp0.x);
                tmp0.x = tmp0.x * 52.98292;
                tmp0.x = frac(tmp0.x);
                tmp0.x = unity_LODFade.x - tmp0.x;
                tmp0.x = tmp0.x < 0.0;
                if (tmp0.x) {
                    discard;
                }
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1.x = tmp0.w - 0.5;
                tmp1.x = tmp1.x < 0.0;
                if (tmp1.x) {
                    discard;
                }
                tmp1.xyz = inp.texcoord3.xyz - unity_ShadowFadeCenterAndType.xyz;
                tmp1.x = dot(tmp1.xyz, tmp1.xyz);
                tmp1.x = sqrt(tmp1.x);
                tmp1.yzw = _WorldSpaceCameraPos - inp.texcoord3.xyz;
                tmp2.x = unity_MatrixV._m20;
                tmp2.y = unity_MatrixV._m21;
                tmp2.z = unity_MatrixV._m22;
                tmp1.y = dot(tmp1.xyz, tmp2.xyz);
                tmp1.x = tmp1.x - tmp1.y;
                tmp1.x = unity_ShadowFadeCenterAndType.w * tmp1.x + tmp1.y;
                tmp1.x = saturate(tmp1.x * _LightShadowData.z + _LightShadowData.w);
                tmp1.y = tmp1.x < 1.0;
                tmp1.z = tmp1.x >= 1.0;
                tmp1.yz = tmp1.yz ? 1.0 : 0.0;
                tmp1.y = tmp1.z + tmp1.y;
                tmp1.y = tmp1.y > 0.5;
                tmp1.x = tmp1.y ? 0.0 : tmp1.x;
                tmp1.y = tmp1.y ? 1.0 : 0.0;
                tmp1.x = tmp1.x + tmp1.y;
                tmp1.x = tmp1.x * _Opacity;
                tmp1.y = dot(_WorldSpaceLightPos0.xyz, inp.texcoord2.xyz);
                tmp1.y = saturate(tmp1.y * 100.0);
                tmp1.z = tmp1.y * -2.0 + 3.0;
                tmp1.y = tmp1.y * tmp1.y;
                tmp1.y = tmp1.y * tmp1.z;
                tmp1.x = tmp1.x * tmp1.y;
                tmp1.yzw = LightColor.xyz - ShadowColor.xyz;
                tmp1.xyz = tmp1.xxx * tmp1.yzw + ShadowColor.xyz;
                tmp1.xyz = tmp0.xyz * tmp1.xyz;
                tmp0.xyz = tmp1.xyz * _LightColor0.xyz;
                tmp1 = tex2D(_Emission, inp.texcoord.xy);
                o.sv_target = tmp0 + tmp1;
                return o;
			}
#elif defined(DIRECTIONAL) && defined(LIGHTMAP_ON) && !defined(LIGHTMAP_SHADOW_MIXING) && defined(LIGHTPROBE_SH) && defined(LOD_FADE_CROSSFADE) && !defined(SHADOWS_SCREEN) && defined(SHADOWS_SHADOWMASK) && !defined(VERTEXLIGHT_ON)
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
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 ShadowColor;
			float4 LightColor;
			float _Opacity;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			sampler2D _Emission;
			
			// Keywords: LOD_FADE_CROSSFADE DIRECTIONAL LIGHTPROBE_SH SHADOWS_SHADOWMASK LIGHTMAP_ON
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
                o.texcoord3.xyz = float3(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3]) * v.vertex.www + tmp0.xyz;
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
                o.texcoord2.xyz = tmp0.www * tmp0.xyz;
                return o;
			}
			// Keywords: LOD_FADE_CROSSFADE DIRECTIONAL LIGHTPROBE_SH SHADOWS_SHADOWMASK LIGHTMAP_ON
			fout frag(v2f inp)
			{
 UNITY_SETUP_INSTANCE_ID(inp);
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = dot(inp.position.xy, float2(0.0671106, 0.0058372));
                tmp0.x = frac(tmp0.x);
                tmp0.x = tmp0.x * 52.98292;
                tmp0.x = frac(tmp0.x);
                tmp0.x = unity_LODFade.x - tmp0.x;
                tmp0.x = tmp0.x < 0.0;
                if (tmp0.x) {
                    discard;
                }
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1.x = tmp0.w - 0.5;
                tmp1.x = tmp1.x < 0.0;
                if (tmp1.x) {
                    discard;
                }
                tmp1.xyz = inp.texcoord3.xyz - unity_ShadowFadeCenterAndType.xyz;
                tmp1.x = dot(tmp1.xyz, tmp1.xyz);
                tmp1.x = sqrt(tmp1.x);
                tmp1.yzw = _WorldSpaceCameraPos - inp.texcoord3.xyz;
                tmp2.x = unity_MatrixV._m20;
                tmp2.y = unity_MatrixV._m21;
                tmp2.z = unity_MatrixV._m22;
                tmp1.y = dot(tmp1.xyz, tmp2.xyz);
                tmp1.x = tmp1.x - tmp1.y;
                tmp1.x = unity_ShadowFadeCenterAndType.w * tmp1.x + tmp1.y;
                tmp1.x = saturate(tmp1.x * _LightShadowData.z + _LightShadowData.w);
                tmp1.y = tmp1.x < 1.0;
                tmp1.z = tmp1.x >= 1.0;
                tmp1.yz = tmp1.yz ? 1.0 : 0.0;
                tmp1.y = tmp1.z + tmp1.y;
                tmp1.y = tmp1.y > 0.5;
                tmp1.x = tmp1.y ? 0.0 : tmp1.x;
                tmp1.y = tmp1.y ? 1.0 : 0.0;
                tmp1.x = tmp1.x + tmp1.y;
                tmp1.x = tmp1.x * _Opacity;
                tmp1.y = dot(_WorldSpaceLightPos0.xyz, inp.texcoord2.xyz);
                tmp1.y = saturate(tmp1.y * 100.0);
                tmp1.z = tmp1.y * -2.0 + 3.0;
                tmp1.y = tmp1.y * tmp1.y;
                tmp1.y = tmp1.y * tmp1.z;
                tmp1.x = tmp1.x * tmp1.y;
                tmp1.yzw = LightColor.xyz - ShadowColor.xyz;
                tmp1.xyz = tmp1.xxx * tmp1.yzw + ShadowColor.xyz;
                tmp1.xyz = tmp0.xyz * tmp1.xyz;
                tmp0.xyz = tmp1.xyz * _LightColor0.xyz;
                tmp1 = tex2D(_Emission, inp.texcoord.xy);
                o.sv_target = tmp0 + tmp1;
                return o;
			}
#elif defined(DIRECTIONAL) && defined(LIGHTMAP_ON) && defined(LIGHTMAP_SHADOW_MIXING) && !defined(LIGHTPROBE_SH) && defined(LOD_FADE_CROSSFADE) && !defined(SHADOWS_SCREEN) && defined(SHADOWS_SHADOWMASK) && !defined(VERTEXLIGHT_ON)
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
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 ShadowColor;
			float4 LightColor;
			float _Opacity;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			sampler2D _Emission;
			
			// Keywords: LOD_FADE_CROSSFADE DIRECTIONAL SHADOWS_SHADOWMASK LIGHTMAP_ON LIGHTMAP_SHADOW_MIXING
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
                o.texcoord3.xyz = float3(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3]) * v.vertex.www + tmp0.xyz;
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
                o.texcoord2.xyz = tmp0.www * tmp0.xyz;
                return o;
			}
			// Keywords: LOD_FADE_CROSSFADE DIRECTIONAL SHADOWS_SHADOWMASK LIGHTMAP_ON LIGHTMAP_SHADOW_MIXING
			fout frag(v2f inp)
			{
 UNITY_SETUP_INSTANCE_ID(inp);
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = dot(inp.position.xy, float2(0.0671106, 0.0058372));
                tmp0.x = frac(tmp0.x);
                tmp0.x = tmp0.x * 52.98292;
                tmp0.x = frac(tmp0.x);
                tmp0.x = unity_LODFade.x - tmp0.x;
                tmp0.x = tmp0.x < 0.0;
                if (tmp0.x) {
                    discard;
                }
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1.x = tmp0.w - 0.5;
                tmp1.x = tmp1.x < 0.0;
                if (tmp1.x) {
                    discard;
                }
                tmp1.xyz = inp.texcoord3.xyz - unity_ShadowFadeCenterAndType.xyz;
                tmp1.x = dot(tmp1.xyz, tmp1.xyz);
                tmp1.x = sqrt(tmp1.x);
                tmp1.yzw = _WorldSpaceCameraPos - inp.texcoord3.xyz;
                tmp2.x = unity_MatrixV._m20;
                tmp2.y = unity_MatrixV._m21;
                tmp2.z = unity_MatrixV._m22;
                tmp1.y = dot(tmp1.xyz, tmp2.xyz);
                tmp1.x = tmp1.x - tmp1.y;
                tmp1.x = unity_ShadowFadeCenterAndType.w * tmp1.x + tmp1.y;
                tmp1.x = saturate(tmp1.x * _LightShadowData.z + _LightShadowData.w);
                tmp1.y = tmp1.x < 1.0;
                tmp1.z = tmp1.x >= 1.0;
                tmp1.yz = tmp1.yz ? 1.0 : 0.0;
                tmp1.y = tmp1.z + tmp1.y;
                tmp1.y = tmp1.y > 0.5;
                tmp1.x = tmp1.y ? 0.0 : tmp1.x;
                tmp1.y = tmp1.y ? 1.0 : 0.0;
                tmp1.x = tmp1.x + tmp1.y;
                tmp1.x = tmp1.x * _Opacity;
                tmp1.y = dot(_WorldSpaceLightPos0.xyz, inp.texcoord2.xyz);
                tmp1.y = saturate(tmp1.y * 100.0);
                tmp1.z = tmp1.y * -2.0 + 3.0;
                tmp1.y = tmp1.y * tmp1.y;
                tmp1.y = tmp1.y * tmp1.z;
                tmp1.x = tmp1.x * tmp1.y;
                tmp1.yzw = LightColor.xyz - ShadowColor.xyz;
                tmp1.xyz = tmp1.xxx * tmp1.yzw + ShadowColor.xyz;
                tmp1.xyz = tmp0.xyz * tmp1.xyz;
                tmp0.xyz = tmp1.xyz * _LightColor0.xyz;
                tmp1 = tex2D(_Emission, inp.texcoord.xy);
                o.sv_target = tmp0 + tmp1;
                return o;
			}
#elif defined(DIRECTIONAL) && !defined(LIGHTMAP_ON) && defined(LIGHTMAP_SHADOW_MIXING) && defined(LIGHTPROBE_SH) && defined(LOD_FADE_CROSSFADE) && defined(SHADOWS_SCREEN) && !defined(SHADOWS_SHADOWMASK) && !defined(VERTEXLIGHT_ON)
			#include "UnityCG.cginc"
#include "AutoLight.cginc"
			struct v2f
			{
 UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float3 texcoord2 : TEXCOORD2;
				float3 texcoord3 : TEXCOORD3;
				float4 texcoord4 : TEXCOORD4;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 ShadowColor;
			float4 LightColor;
			float _Opacity;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			sampler2D _Emission;
			
			// Keywords: LOD_FADE_CROSSFADE DIRECTIONAL LIGHTPROBE_SH LIGHTMAP_SHADOW_MIXING SHADOWS_SCREEN
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
                o.texcoord3.xyz = float3(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3]) * v.vertex.www + tmp0.xyz;
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
                o.texcoord2.xyz = tmp1.www * tmp1.xyz;
                tmp1.xyz = tmp0.xyw * float3(0.5, 0.5, 0.5);
                o.texcoord4.zw = tmp0.zw;
                tmp1.w = tmp1.y * _ProjectionParams.x;
                o.texcoord4.xy = tmp1.zz + tmp1.xw;
                return o;
			}
			// Keywords: LOD_FADE_CROSSFADE DIRECTIONAL LIGHTPROBE_SH LIGHTMAP_SHADOW_MIXING SHADOWS_SCREEN
			fout frag(v2f inp)
			{
 UNITY_SETUP_INSTANCE_ID(inp);
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = dot(inp.position.xy, float2(0.0671106, 0.0058372));
                tmp0.x = frac(tmp0.x);
                tmp0.x = tmp0.x * 52.98292;
                tmp0.x = frac(tmp0.x);
                tmp0.x = unity_LODFade.x - tmp0.x;
                tmp0.x = tmp0.x < 0.0;
                if (tmp0.x) {
                    discard;
                }
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1.x = tmp0.w - 0.5;
                tmp1.x = tmp1.x < 0.0;
                if (tmp1.x) {
                    discard;
                }
                tmp1.xyz = inp.texcoord3.xyz - unity_ShadowFadeCenterAndType.xyz;
                tmp1.x = dot(tmp1.xyz, tmp1.xyz);
                tmp1.x = sqrt(tmp1.x);
                tmp1.yzw = _WorldSpaceCameraPos - inp.texcoord3.xyz;
                tmp2.x = unity_MatrixV._m20;
                tmp2.y = unity_MatrixV._m21;
                tmp2.z = unity_MatrixV._m22;
                tmp1.y = dot(tmp1.xyz, tmp2.xyz);
                tmp1.x = tmp1.x - tmp1.y;
                tmp1.x = unity_ShadowFadeCenterAndType.w * tmp1.x + tmp1.y;
                tmp1.x = saturate(tmp1.x * _LightShadowData.z + _LightShadowData.w);
                tmp1.y = tmp1.x < 1.0;
                tmp1.z = tmp1.x >= 1.0;
                tmp1.yz = tmp1.yz ? 1.0 : 0.0;
                tmp2.xy = inp.texcoord4.xy / inp.texcoord4.ww;
                tmp2 = tex2D(_ShadowMapTexture, tmp2.xy);
                tmp1.y = tmp1.y * tmp2.x + tmp1.z;
                tmp1.y = tmp1.y > 0.5;
                tmp1.x = tmp1.y ? 0.0 : tmp1.x;
                tmp1.y = tmp1.y ? 1.0 : 0.0;
                tmp1.x = tmp1.x + tmp1.y;
                tmp1.x = tmp1.x * _Opacity;
                tmp1.y = dot(_WorldSpaceLightPos0.xyz, inp.texcoord2.xyz);
                tmp1.y = saturate(tmp1.y * 100.0);
                tmp1.z = tmp1.y * -2.0 + 3.0;
                tmp1.y = tmp1.y * tmp1.y;
                tmp1.y = tmp1.y * tmp1.z;
                tmp1.x = tmp1.x * tmp1.y;
                tmp1.yzw = LightColor.xyz - ShadowColor.xyz;
                tmp1.xyz = tmp1.xxx * tmp1.yzw + ShadowColor.xyz;
                tmp1.xyz = tmp0.xyz * tmp1.xyz;
                tmp0.xyz = tmp1.xyz * _LightColor0.xyz;
                tmp1 = tex2D(_Emission, inp.texcoord.xy);
                o.sv_target = tmp0 + tmp1;
                return o;
			}
#elif defined(DIRECTIONAL) && !defined(LIGHTMAP_ON) && !defined(LIGHTMAP_SHADOW_MIXING) && defined(LIGHTPROBE_SH) && defined(LOD_FADE_CROSSFADE) && defined(SHADOWS_SCREEN) && defined(SHADOWS_SHADOWMASK) && !defined(VERTEXLIGHT_ON)
			#include "UnityCG.cginc"
#include "AutoLight.cginc"
			struct v2f
			{
 UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float3 texcoord2 : TEXCOORD2;
				float3 texcoord3 : TEXCOORD3;
				float4 texcoord4 : TEXCOORD4;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 ShadowColor;
			float4 LightColor;
			float _Opacity;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			sampler2D _Emission;
			
			// Keywords: LOD_FADE_CROSSFADE DIRECTIONAL LIGHTPROBE_SH SHADOWS_SHADOWMASK SHADOWS_SCREEN
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
                o.texcoord3.xyz = float3(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3]) * v.vertex.www + tmp0.xyz;
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
                o.texcoord2.xyz = tmp1.www * tmp1.xyz;
                tmp1.xyz = tmp0.xyw * float3(0.5, 0.5, 0.5);
                o.texcoord4.zw = tmp0.zw;
                tmp1.w = tmp1.y * _ProjectionParams.x;
                o.texcoord4.xy = tmp1.zz + tmp1.xw;
                return o;
			}
			// Keywords: LOD_FADE_CROSSFADE DIRECTIONAL LIGHTPROBE_SH SHADOWS_SHADOWMASK SHADOWS_SCREEN
			fout frag(v2f inp)
			{
 UNITY_SETUP_INSTANCE_ID(inp);
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = dot(inp.position.xy, float2(0.0671106, 0.0058372));
                tmp0.x = frac(tmp0.x);
                tmp0.x = tmp0.x * 52.98292;
                tmp0.x = frac(tmp0.x);
                tmp0.x = unity_LODFade.x - tmp0.x;
                tmp0.x = tmp0.x < 0.0;
                if (tmp0.x) {
                    discard;
                }
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1.x = tmp0.w - 0.5;
                tmp1.x = tmp1.x < 0.0;
                if (tmp1.x) {
                    discard;
                }
                tmp1.xyz = inp.texcoord3.xyz - unity_ShadowFadeCenterAndType.xyz;
                tmp1.x = dot(tmp1.xyz, tmp1.xyz);
                tmp1.x = sqrt(tmp1.x);
                tmp1.yzw = _WorldSpaceCameraPos - inp.texcoord3.xyz;
                tmp2.x = unity_MatrixV._m20;
                tmp2.y = unity_MatrixV._m21;
                tmp2.z = unity_MatrixV._m22;
                tmp1.y = dot(tmp1.xyz, tmp2.xyz);
                tmp1.x = tmp1.x - tmp1.y;
                tmp1.x = unity_ShadowFadeCenterAndType.w * tmp1.x + tmp1.y;
                tmp1.x = saturate(tmp1.x * _LightShadowData.z + _LightShadowData.w);
                tmp1.y = tmp1.x < 1.0;
                tmp1.z = tmp1.x >= 1.0;
                tmp1.yz = tmp1.yz ? 1.0 : 0.0;
                tmp2.xy = inp.texcoord4.xy / inp.texcoord4.ww;
                tmp2 = tex2D(_ShadowMapTexture, tmp2.xy);
                tmp1.y = tmp1.y * tmp2.x + tmp1.z;
                tmp1.y = tmp1.y > 0.5;
                tmp1.x = tmp1.y ? 0.0 : tmp1.x;
                tmp1.y = tmp1.y ? 1.0 : 0.0;
                tmp1.x = tmp1.x + tmp1.y;
                tmp1.x = tmp1.x * _Opacity;
                tmp1.y = dot(_WorldSpaceLightPos0.xyz, inp.texcoord2.xyz);
                tmp1.y = saturate(tmp1.y * 100.0);
                tmp1.z = tmp1.y * -2.0 + 3.0;
                tmp1.y = tmp1.y * tmp1.y;
                tmp1.y = tmp1.y * tmp1.z;
                tmp1.x = tmp1.x * tmp1.y;
                tmp1.yzw = LightColor.xyz - ShadowColor.xyz;
                tmp1.xyz = tmp1.xxx * tmp1.yzw + ShadowColor.xyz;
                tmp1.xyz = tmp0.xyz * tmp1.xyz;
                tmp0.xyz = tmp1.xyz * _LightColor0.xyz;
                tmp1 = tex2D(_Emission, inp.texcoord.xy);
                o.sv_target = tmp0 + tmp1;
                return o;
			}
#elif defined(DIRECTIONAL) && defined(LIGHTMAP_ON) && !defined(LIGHTMAP_SHADOW_MIXING) && defined(LIGHTPROBE_SH) && defined(LOD_FADE_CROSSFADE) && defined(SHADOWS_SCREEN) && !defined(SHADOWS_SHADOWMASK) && !defined(VERTEXLIGHT_ON)
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
				float4 texcoord4 : TEXCOORD4;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 ShadowColor;
			float4 LightColor;
			float _Opacity;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			sampler2D _Emission;
			
			// Keywords: LOD_FADE_CROSSFADE DIRECTIONAL LIGHTPROBE_SH LIGHTMAP_ON SHADOWS_SCREEN
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
                o.texcoord3.xyz = float3(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3]) * v.vertex.www + tmp0.xyz;
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
                o.texcoord2.xyz = tmp1.www * tmp1.xyz;
                tmp1.xyz = tmp0.xyw * float3(0.5, 0.5, 0.5);
                o.texcoord4.zw = tmp0.zw;
                tmp1.w = tmp1.y * _ProjectionParams.x;
                o.texcoord4.xy = tmp1.zz + tmp1.xw;
                return o;
			}
			// Keywords: LOD_FADE_CROSSFADE DIRECTIONAL LIGHTPROBE_SH LIGHTMAP_ON SHADOWS_SCREEN
			fout frag(v2f inp)
			{
 UNITY_SETUP_INSTANCE_ID(inp);
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = dot(inp.position.xy, float2(0.0671106, 0.0058372));
                tmp0.x = frac(tmp0.x);
                tmp0.x = tmp0.x * 52.98292;
                tmp0.x = frac(tmp0.x);
                tmp0.x = unity_LODFade.x - tmp0.x;
                tmp0.x = tmp0.x < 0.0;
                if (tmp0.x) {
                    discard;
                }
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1.x = tmp0.w - 0.5;
                tmp1.x = tmp1.x < 0.0;
                if (tmp1.x) {
                    discard;
                }
                tmp1.xyz = inp.texcoord3.xyz - unity_ShadowFadeCenterAndType.xyz;
                tmp1.x = dot(tmp1.xyz, tmp1.xyz);
                tmp1.x = sqrt(tmp1.x);
                tmp1.yzw = _WorldSpaceCameraPos - inp.texcoord3.xyz;
                tmp2.x = unity_MatrixV._m20;
                tmp2.y = unity_MatrixV._m21;
                tmp2.z = unity_MatrixV._m22;
                tmp1.y = dot(tmp1.xyz, tmp2.xyz);
                tmp1.x = tmp1.x - tmp1.y;
                tmp1.x = unity_ShadowFadeCenterAndType.w * tmp1.x + tmp1.y;
                tmp1.x = saturate(tmp1.x * _LightShadowData.z + _LightShadowData.w);
                tmp1.y = tmp1.x < 1.0;
                tmp1.z = tmp1.x >= 1.0;
                tmp1.yz = tmp1.yz ? 1.0 : 0.0;
                tmp2.xy = inp.texcoord4.xy / inp.texcoord4.ww;
                tmp2 = tex2D(_ShadowMapTexture, tmp2.xy);
                tmp1.y = tmp1.y * tmp2.x + tmp1.z;
                tmp1.y = tmp1.y > 0.5;
                tmp1.x = tmp1.y ? 0.0 : tmp1.x;
                tmp1.y = tmp1.y ? 1.0 : 0.0;
                tmp1.x = tmp1.x + tmp1.y;
                tmp1.x = tmp1.x * _Opacity;
                tmp1.y = dot(_WorldSpaceLightPos0.xyz, inp.texcoord2.xyz);
                tmp1.y = saturate(tmp1.y * 100.0);
                tmp1.z = tmp1.y * -2.0 + 3.0;
                tmp1.y = tmp1.y * tmp1.y;
                tmp1.y = tmp1.y * tmp1.z;
                tmp1.x = tmp1.x * tmp1.y;
                tmp1.yzw = LightColor.xyz - ShadowColor.xyz;
                tmp1.xyz = tmp1.xxx * tmp1.yzw + ShadowColor.xyz;
                tmp1.xyz = tmp0.xyz * tmp1.xyz;
                tmp0.xyz = tmp1.xyz * _LightColor0.xyz;
                tmp1 = tex2D(_Emission, inp.texcoord.xy);
                o.sv_target = tmp0 + tmp1;
                return o;
			}
#elif defined(DIRECTIONAL) && defined(LIGHTMAP_ON) && defined(LIGHTMAP_SHADOW_MIXING) && !defined(LIGHTPROBE_SH) && defined(LOD_FADE_CROSSFADE) && defined(SHADOWS_SCREEN) && !defined(SHADOWS_SHADOWMASK) && !defined(VERTEXLIGHT_ON)
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
				float4 texcoord4 : TEXCOORD4;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 ShadowColor;
			float4 LightColor;
			float _Opacity;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			sampler2D _Emission;
			
			// Keywords: LOD_FADE_CROSSFADE DIRECTIONAL LIGHTMAP_ON LIGHTMAP_SHADOW_MIXING SHADOWS_SCREEN
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
                o.texcoord3.xyz = float3(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3]) * v.vertex.www + tmp0.xyz;
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
                o.texcoord2.xyz = tmp1.www * tmp1.xyz;
                tmp1.xyz = tmp0.xyw * float3(0.5, 0.5, 0.5);
                o.texcoord4.zw = tmp0.zw;
                tmp1.w = tmp1.y * _ProjectionParams.x;
                o.texcoord4.xy = tmp1.zz + tmp1.xw;
                return o;
			}
			// Keywords: LOD_FADE_CROSSFADE DIRECTIONAL LIGHTMAP_ON LIGHTMAP_SHADOW_MIXING SHADOWS_SCREEN
			fout frag(v2f inp)
			{
 UNITY_SETUP_INSTANCE_ID(inp);
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = dot(inp.position.xy, float2(0.0671106, 0.0058372));
                tmp0.x = frac(tmp0.x);
                tmp0.x = tmp0.x * 52.98292;
                tmp0.x = frac(tmp0.x);
                tmp0.x = unity_LODFade.x - tmp0.x;
                tmp0.x = tmp0.x < 0.0;
                if (tmp0.x) {
                    discard;
                }
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1.x = tmp0.w - 0.5;
                tmp1.x = tmp1.x < 0.0;
                if (tmp1.x) {
                    discard;
                }
                tmp1.xyz = inp.texcoord3.xyz - unity_ShadowFadeCenterAndType.xyz;
                tmp1.x = dot(tmp1.xyz, tmp1.xyz);
                tmp1.x = sqrt(tmp1.x);
                tmp1.yzw = _WorldSpaceCameraPos - inp.texcoord3.xyz;
                tmp2.x = unity_MatrixV._m20;
                tmp2.y = unity_MatrixV._m21;
                tmp2.z = unity_MatrixV._m22;
                tmp1.y = dot(tmp1.xyz, tmp2.xyz);
                tmp1.x = tmp1.x - tmp1.y;
                tmp1.x = unity_ShadowFadeCenterAndType.w * tmp1.x + tmp1.y;
                tmp1.x = saturate(tmp1.x * _LightShadowData.z + _LightShadowData.w);
                tmp1.y = tmp1.x < 1.0;
                tmp1.z = tmp1.x >= 1.0;
                tmp1.yz = tmp1.yz ? 1.0 : 0.0;
                tmp2.xy = inp.texcoord4.xy / inp.texcoord4.ww;
                tmp2 = tex2D(_ShadowMapTexture, tmp2.xy);
                tmp1.y = tmp1.y * tmp2.x + tmp1.z;
                tmp1.y = tmp1.y > 0.5;
                tmp1.x = tmp1.y ? 0.0 : tmp1.x;
                tmp1.y = tmp1.y ? 1.0 : 0.0;
                tmp1.x = tmp1.x + tmp1.y;
                tmp1.x = tmp1.x * _Opacity;
                tmp1.y = dot(_WorldSpaceLightPos0.xyz, inp.texcoord2.xyz);
                tmp1.y = saturate(tmp1.y * 100.0);
                tmp1.z = tmp1.y * -2.0 + 3.0;
                tmp1.y = tmp1.y * tmp1.y;
                tmp1.y = tmp1.y * tmp1.z;
                tmp1.x = tmp1.x * tmp1.y;
                tmp1.yzw = LightColor.xyz - ShadowColor.xyz;
                tmp1.xyz = tmp1.xxx * tmp1.yzw + ShadowColor.xyz;
                tmp1.xyz = tmp0.xyz * tmp1.xyz;
                tmp0.xyz = tmp1.xyz * _LightColor0.xyz;
                tmp1 = tex2D(_Emission, inp.texcoord.xy);
                o.sv_target = tmp0 + tmp1;
                return o;
			}
#elif defined(DIRECTIONAL) && defined(LIGHTMAP_ON) && !defined(LIGHTMAP_SHADOW_MIXING) && !defined(LIGHTPROBE_SH) && defined(LOD_FADE_CROSSFADE) && defined(SHADOWS_SCREEN) && defined(SHADOWS_SHADOWMASK) && !defined(VERTEXLIGHT_ON)
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
				float4 texcoord4 : TEXCOORD4;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 ShadowColor;
			float4 LightColor;
			float _Opacity;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			sampler2D _Emission;
			
			// Keywords: LOD_FADE_CROSSFADE DIRECTIONAL SHADOWS_SHADOWMASK LIGHTMAP_ON SHADOWS_SCREEN
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
                o.texcoord3.xyz = float3(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3]) * v.vertex.www + tmp0.xyz;
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
                o.texcoord2.xyz = tmp1.www * tmp1.xyz;
                tmp1.xyz = tmp0.xyw * float3(0.5, 0.5, 0.5);
                o.texcoord4.zw = tmp0.zw;
                tmp1.w = tmp1.y * _ProjectionParams.x;
                o.texcoord4.xy = tmp1.zz + tmp1.xw;
                return o;
			}
			// Keywords: LOD_FADE_CROSSFADE DIRECTIONAL SHADOWS_SHADOWMASK LIGHTMAP_ON SHADOWS_SCREEN
			fout frag(v2f inp)
			{
 UNITY_SETUP_INSTANCE_ID(inp);
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = dot(inp.position.xy, float2(0.0671106, 0.0058372));
                tmp0.x = frac(tmp0.x);
                tmp0.x = tmp0.x * 52.98292;
                tmp0.x = frac(tmp0.x);
                tmp0.x = unity_LODFade.x - tmp0.x;
                tmp0.x = tmp0.x < 0.0;
                if (tmp0.x) {
                    discard;
                }
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1.x = tmp0.w - 0.5;
                tmp1.x = tmp1.x < 0.0;
                if (tmp1.x) {
                    discard;
                }
                tmp1.xyz = inp.texcoord3.xyz - unity_ShadowFadeCenterAndType.xyz;
                tmp1.x = dot(tmp1.xyz, tmp1.xyz);
                tmp1.x = sqrt(tmp1.x);
                tmp1.yzw = _WorldSpaceCameraPos - inp.texcoord3.xyz;
                tmp2.x = unity_MatrixV._m20;
                tmp2.y = unity_MatrixV._m21;
                tmp2.z = unity_MatrixV._m22;
                tmp1.y = dot(tmp1.xyz, tmp2.xyz);
                tmp1.x = tmp1.x - tmp1.y;
                tmp1.x = unity_ShadowFadeCenterAndType.w * tmp1.x + tmp1.y;
                tmp1.x = saturate(tmp1.x * _LightShadowData.z + _LightShadowData.w);
                tmp1.y = tmp1.x < 1.0;
                tmp1.z = tmp1.x >= 1.0;
                tmp1.yz = tmp1.yz ? 1.0 : 0.0;
                tmp2.xy = inp.texcoord4.xy / inp.texcoord4.ww;
                tmp2 = tex2D(_ShadowMapTexture, tmp2.xy);
                tmp1.y = tmp1.y * tmp2.x + tmp1.z;
                tmp1.y = tmp1.y > 0.5;
                tmp1.x = tmp1.y ? 0.0 : tmp1.x;
                tmp1.y = tmp1.y ? 1.0 : 0.0;
                tmp1.x = tmp1.x + tmp1.y;
                tmp1.x = tmp1.x * _Opacity;
                tmp1.y = dot(_WorldSpaceLightPos0.xyz, inp.texcoord2.xyz);
                tmp1.y = saturate(tmp1.y * 100.0);
                tmp1.z = tmp1.y * -2.0 + 3.0;
                tmp1.y = tmp1.y * tmp1.y;
                tmp1.y = tmp1.y * tmp1.z;
                tmp1.x = tmp1.x * tmp1.y;
                tmp1.yzw = LightColor.xyz - ShadowColor.xyz;
                tmp1.xyz = tmp1.xxx * tmp1.yzw + ShadowColor.xyz;
                tmp1.xyz = tmp0.xyz * tmp1.xyz;
                tmp0.xyz = tmp1.xyz * _LightColor0.xyz;
                tmp1 = tex2D(_Emission, inp.texcoord.xy);
                o.sv_target = tmp0 + tmp1;
                return o;
			}
#elif defined(DIRECTIONAL) && !defined(LIGHTMAP_ON) && !defined(LIGHTMAP_SHADOW_MIXING) && defined(LIGHTPROBE_SH) && defined(LOD_FADE_CROSSFADE) && defined(SHADOWS_SCREEN) && !defined(SHADOWS_SHADOWMASK) && defined(VERTEXLIGHT_ON)
			#include "UnityCG.cginc"
#include "AutoLight.cginc"
			struct v2f
			{
 UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float3 texcoord2 : TEXCOORD2;
				float3 texcoord3 : TEXCOORD3;
				float4 texcoord4 : TEXCOORD4;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 ShadowColor;
			float4 LightColor;
			float _Opacity;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			sampler2D _Emission;
			
			// Keywords: LOD_FADE_CROSSFADE DIRECTIONAL LIGHTPROBE_SH SHADOWS_SCREEN VERTEXLIGHT_ON
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
                o.texcoord3.xyz = float3(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3]) * v.vertex.www + tmp0.xyz;
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
                o.texcoord2.xyz = tmp1.www * tmp1.xyz;
                tmp1.xyz = tmp0.xyw * float3(0.5, 0.5, 0.5);
                o.texcoord4.zw = tmp0.zw;
                tmp1.w = tmp1.y * _ProjectionParams.x;
                o.texcoord4.xy = tmp1.zz + tmp1.xw;
                return o;
			}
			// Keywords: LOD_FADE_CROSSFADE DIRECTIONAL LIGHTPROBE_SH SHADOWS_SCREEN
			fout frag(v2f inp)
			{
 UNITY_SETUP_INSTANCE_ID(inp);
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = dot(inp.position.xy, float2(0.0671106, 0.0058372));
                tmp0.x = frac(tmp0.x);
                tmp0.x = tmp0.x * 52.98292;
                tmp0.x = frac(tmp0.x);
                tmp0.x = unity_LODFade.x - tmp0.x;
                tmp0.x = tmp0.x < 0.0;
                if (tmp0.x) {
                    discard;
                }
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1.x = tmp0.w - 0.5;
                tmp1.x = tmp1.x < 0.0;
                if (tmp1.x) {
                    discard;
                }
                tmp1.xyz = inp.texcoord3.xyz - unity_ShadowFadeCenterAndType.xyz;
                tmp1.x = dot(tmp1.xyz, tmp1.xyz);
                tmp1.x = sqrt(tmp1.x);
                tmp1.yzw = _WorldSpaceCameraPos - inp.texcoord3.xyz;
                tmp2.x = unity_MatrixV._m20;
                tmp2.y = unity_MatrixV._m21;
                tmp2.z = unity_MatrixV._m22;
                tmp1.y = dot(tmp1.xyz, tmp2.xyz);
                tmp1.x = tmp1.x - tmp1.y;
                tmp1.x = unity_ShadowFadeCenterAndType.w * tmp1.x + tmp1.y;
                tmp1.x = saturate(tmp1.x * _LightShadowData.z + _LightShadowData.w);
                tmp1.y = tmp1.x < 1.0;
                tmp1.z = tmp1.x >= 1.0;
                tmp1.yz = tmp1.yz ? 1.0 : 0.0;
                tmp2.xy = inp.texcoord4.xy / inp.texcoord4.ww;
                tmp2 = tex2D(_ShadowMapTexture, tmp2.xy);
                tmp1.y = tmp1.y * tmp2.x + tmp1.z;
                tmp1.y = tmp1.y > 0.5;
                tmp1.x = tmp1.y ? 0.0 : tmp1.x;
                tmp1.y = tmp1.y ? 1.0 : 0.0;
                tmp1.x = tmp1.x + tmp1.y;
                tmp1.x = tmp1.x * _Opacity;
                tmp1.y = dot(_WorldSpaceLightPos0.xyz, inp.texcoord2.xyz);
                tmp1.y = saturate(tmp1.y * 100.0);
                tmp1.z = tmp1.y * -2.0 + 3.0;
                tmp1.y = tmp1.y * tmp1.y;
                tmp1.y = tmp1.y * tmp1.z;
                tmp1.x = tmp1.x * tmp1.y;
                tmp1.yzw = LightColor.xyz - ShadowColor.xyz;
                tmp1.xyz = tmp1.xxx * tmp1.yzw + ShadowColor.xyz;
                tmp1.xyz = tmp0.xyz * tmp1.xyz;
                tmp0.xyz = tmp1.xyz * _LightColor0.xyz;
                tmp1 = tex2D(_Emission, inp.texcoord.xy);
                o.sv_target = tmp0 + tmp1;
                return o;
			}
#elif defined(DIRECTIONAL) && !defined(LIGHTMAP_ON) && defined(LIGHTMAP_SHADOW_MIXING) && !defined(LIGHTPROBE_SH) && defined(LOD_FADE_CROSSFADE) && defined(SHADOWS_SCREEN) && !defined(SHADOWS_SHADOWMASK) && defined(VERTEXLIGHT_ON)
			#include "UnityCG.cginc"
#include "AutoLight.cginc"
			struct v2f
			{
 UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float3 texcoord2 : TEXCOORD2;
				float3 texcoord3 : TEXCOORD3;
				float4 texcoord4 : TEXCOORD4;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 ShadowColor;
			float4 LightColor;
			float _Opacity;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			sampler2D _Emission;
			
			// Keywords: LOD_FADE_CROSSFADE DIRECTIONAL LIGHTMAP_SHADOW_MIXING SHADOWS_SCREEN VERTEXLIGHT_ON
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
                o.texcoord3.xyz = float3(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3]) * v.vertex.www + tmp0.xyz;
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
                o.texcoord2.xyz = tmp1.www * tmp1.xyz;
                tmp1.xyz = tmp0.xyw * float3(0.5, 0.5, 0.5);
                o.texcoord4.zw = tmp0.zw;
                tmp1.w = tmp1.y * _ProjectionParams.x;
                o.texcoord4.xy = tmp1.zz + tmp1.xw;
                return o;
			}
			// Keywords: LOD_FADE_CROSSFADE DIRECTIONAL SHADOWS_SCREEN
			fout frag(v2f inp)
			{
 UNITY_SETUP_INSTANCE_ID(inp);
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = dot(inp.position.xy, float2(0.0671106, 0.0058372));
                tmp0.x = frac(tmp0.x);
                tmp0.x = tmp0.x * 52.98292;
                tmp0.x = frac(tmp0.x);
                tmp0.x = unity_LODFade.x - tmp0.x;
                tmp0.x = tmp0.x < 0.0;
                if (tmp0.x) {
                    discard;
                }
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1.x = tmp0.w - 0.5;
                tmp1.x = tmp1.x < 0.0;
                if (tmp1.x) {
                    discard;
                }
                tmp1.xyz = inp.texcoord3.xyz - unity_ShadowFadeCenterAndType.xyz;
                tmp1.x = dot(tmp1.xyz, tmp1.xyz);
                tmp1.x = sqrt(tmp1.x);
                tmp1.yzw = _WorldSpaceCameraPos - inp.texcoord3.xyz;
                tmp2.x = unity_MatrixV._m20;
                tmp2.y = unity_MatrixV._m21;
                tmp2.z = unity_MatrixV._m22;
                tmp1.y = dot(tmp1.xyz, tmp2.xyz);
                tmp1.x = tmp1.x - tmp1.y;
                tmp1.x = unity_ShadowFadeCenterAndType.w * tmp1.x + tmp1.y;
                tmp1.x = saturate(tmp1.x * _LightShadowData.z + _LightShadowData.w);
                tmp1.y = tmp1.x < 1.0;
                tmp1.z = tmp1.x >= 1.0;
                tmp1.yz = tmp1.yz ? 1.0 : 0.0;
                tmp2.xy = inp.texcoord4.xy / inp.texcoord4.ww;
                tmp2 = tex2D(_ShadowMapTexture, tmp2.xy);
                tmp1.y = tmp1.y * tmp2.x + tmp1.z;
                tmp1.y = tmp1.y > 0.5;
                tmp1.x = tmp1.y ? 0.0 : tmp1.x;
                tmp1.y = tmp1.y ? 1.0 : 0.0;
                tmp1.x = tmp1.x + tmp1.y;
                tmp1.x = tmp1.x * _Opacity;
                tmp1.y = dot(_WorldSpaceLightPos0.xyz, inp.texcoord2.xyz);
                tmp1.y = saturate(tmp1.y * 100.0);
                tmp1.z = tmp1.y * -2.0 + 3.0;
                tmp1.y = tmp1.y * tmp1.y;
                tmp1.y = tmp1.y * tmp1.z;
                tmp1.x = tmp1.x * tmp1.y;
                tmp1.yzw = LightColor.xyz - ShadowColor.xyz;
                tmp1.xyz = tmp1.xxx * tmp1.yzw + ShadowColor.xyz;
                tmp1.xyz = tmp0.xyz * tmp1.xyz;
                tmp0.xyz = tmp1.xyz * _LightColor0.xyz;
                tmp1 = tex2D(_Emission, inp.texcoord.xy);
                o.sv_target = tmp0 + tmp1;
                return o;
			}
#elif defined(DIRECTIONAL) && !defined(LIGHTMAP_ON) && !defined(LIGHTMAP_SHADOW_MIXING) && !defined(LIGHTPROBE_SH) && defined(LOD_FADE_CROSSFADE) && defined(SHADOWS_SCREEN) && defined(SHADOWS_SHADOWMASK) && defined(VERTEXLIGHT_ON)
			#include "UnityCG.cginc"
#include "AutoLight.cginc"
			struct v2f
			{
 UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float3 texcoord2 : TEXCOORD2;
				float3 texcoord3 : TEXCOORD3;
				float4 texcoord4 : TEXCOORD4;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 ShadowColor;
			float4 LightColor;
			float _Opacity;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			sampler2D _Emission;
			
			// Keywords: LOD_FADE_CROSSFADE DIRECTIONAL SHADOWS_SHADOWMASK SHADOWS_SCREEN VERTEXLIGHT_ON
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
                o.texcoord3.xyz = float3(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3]) * v.vertex.www + tmp0.xyz;
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
                o.texcoord2.xyz = tmp1.www * tmp1.xyz;
                tmp1.xyz = tmp0.xyw * float3(0.5, 0.5, 0.5);
                o.texcoord4.zw = tmp0.zw;
                tmp1.w = tmp1.y * _ProjectionParams.x;
                o.texcoord4.xy = tmp1.zz + tmp1.xw;
                return o;
			}
			// Keywords: LOD_FADE_CROSSFADE DIRECTIONAL SHADOWS_SCREEN
			fout frag(v2f inp)
			{
 UNITY_SETUP_INSTANCE_ID(inp);
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = dot(inp.position.xy, float2(0.0671106, 0.0058372));
                tmp0.x = frac(tmp0.x);
                tmp0.x = tmp0.x * 52.98292;
                tmp0.x = frac(tmp0.x);
                tmp0.x = unity_LODFade.x - tmp0.x;
                tmp0.x = tmp0.x < 0.0;
                if (tmp0.x) {
                    discard;
                }
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1.x = tmp0.w - 0.5;
                tmp1.x = tmp1.x < 0.0;
                if (tmp1.x) {
                    discard;
                }
                tmp1.xyz = inp.texcoord3.xyz - unity_ShadowFadeCenterAndType.xyz;
                tmp1.x = dot(tmp1.xyz, tmp1.xyz);
                tmp1.x = sqrt(tmp1.x);
                tmp1.yzw = _WorldSpaceCameraPos - inp.texcoord3.xyz;
                tmp2.x = unity_MatrixV._m20;
                tmp2.y = unity_MatrixV._m21;
                tmp2.z = unity_MatrixV._m22;
                tmp1.y = dot(tmp1.xyz, tmp2.xyz);
                tmp1.x = tmp1.x - tmp1.y;
                tmp1.x = unity_ShadowFadeCenterAndType.w * tmp1.x + tmp1.y;
                tmp1.x = saturate(tmp1.x * _LightShadowData.z + _LightShadowData.w);
                tmp1.y = tmp1.x < 1.0;
                tmp1.z = tmp1.x >= 1.0;
                tmp1.yz = tmp1.yz ? 1.0 : 0.0;
                tmp2.xy = inp.texcoord4.xy / inp.texcoord4.ww;
                tmp2 = tex2D(_ShadowMapTexture, tmp2.xy);
                tmp1.y = tmp1.y * tmp2.x + tmp1.z;
                tmp1.y = tmp1.y > 0.5;
                tmp1.x = tmp1.y ? 0.0 : tmp1.x;
                tmp1.y = tmp1.y ? 1.0 : 0.0;
                tmp1.x = tmp1.x + tmp1.y;
                tmp1.x = tmp1.x * _Opacity;
                tmp1.y = dot(_WorldSpaceLightPos0.xyz, inp.texcoord2.xyz);
                tmp1.y = saturate(tmp1.y * 100.0);
                tmp1.z = tmp1.y * -2.0 + 3.0;
                tmp1.y = tmp1.y * tmp1.y;
                tmp1.y = tmp1.y * tmp1.z;
                tmp1.x = tmp1.x * tmp1.y;
                tmp1.yzw = LightColor.xyz - ShadowColor.xyz;
                tmp1.xyz = tmp1.xxx * tmp1.yzw + ShadowColor.xyz;
                tmp1.xyz = tmp0.xyz * tmp1.xyz;
                tmp0.xyz = tmp1.xyz * _LightColor0.xyz;
                tmp1 = tex2D(_Emission, inp.texcoord.xy);
                o.sv_target = tmp0 + tmp1;
                return o;
			}
#elif defined(DIRECTIONAL) && defined(LIGHTMAP_ON) && defined(LIGHTMAP_SHADOW_MIXING) && defined(LIGHTPROBE_SH) && !defined(LOD_FADE_CROSSFADE) && !defined(SHADOWS_SCREEN) && !defined(SHADOWS_SHADOWMASK) && !defined(VERTEXLIGHT_ON)
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
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 ShadowColor;
			float4 LightColor;
			float _Opacity;
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
                tmp0 = v.vertex.yyyy * float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
                tmp0 = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]) * v.vertex.xxxx + tmp0;
                tmp0 = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]) * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
                o.texcoord3.xyz = float3(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3]) * v.vertex.www + tmp0.xyz;
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
                o.texcoord2.xyz = tmp0.www * tmp0.xyz;
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
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1.x = tmp0.w - 0.5;
                tmp1.x = tmp1.x < 0.0;
                if (tmp1.x) {
                    discard;
                }
                tmp1.xyz = inp.texcoord3.xyz - unity_ShadowFadeCenterAndType.xyz;
                tmp1.x = dot(tmp1.xyz, tmp1.xyz);
                tmp1.x = sqrt(tmp1.x);
                tmp1.yzw = _WorldSpaceCameraPos - inp.texcoord3.xyz;
                tmp2.x = unity_MatrixV._m20;
                tmp2.y = unity_MatrixV._m21;
                tmp2.z = unity_MatrixV._m22;
                tmp1.y = dot(tmp1.xyz, tmp2.xyz);
                tmp1.x = tmp1.x - tmp1.y;
                tmp1.x = unity_ShadowFadeCenterAndType.w * tmp1.x + tmp1.y;
                tmp1.x = saturate(tmp1.x * _LightShadowData.z + _LightShadowData.w);
                tmp1.y = tmp1.x < 1.0;
                tmp1.z = tmp1.x >= 1.0;
                tmp1.yz = tmp1.yz ? 1.0 : 0.0;
                tmp1.y = tmp1.z + tmp1.y;
                tmp1.y = tmp1.y > 0.5;
                tmp1.x = tmp1.y ? 0.0 : tmp1.x;
                tmp1.y = tmp1.y ? 1.0 : 0.0;
                tmp1.x = tmp1.x + tmp1.y;
                tmp1.x = tmp1.x * _Opacity;
                tmp1.y = dot(_WorldSpaceLightPos0.xyz, inp.texcoord2.xyz);
                tmp1.y = saturate(tmp1.y * 100.0);
                tmp1.z = tmp1.y * -2.0 + 3.0;
                tmp1.y = tmp1.y * tmp1.y;
                tmp1.y = tmp1.y * tmp1.z;
                tmp1.x = tmp1.x * tmp1.y;
                tmp1.yzw = LightColor.xyz - ShadowColor.xyz;
                tmp1.xyz = tmp1.xxx * tmp1.yzw + ShadowColor.xyz;
                tmp1.xyz = tmp0.xyz * tmp1.xyz;
                tmp0.xyz = tmp1.xyz * _LightColor0.xyz;
                tmp1 = tex2D(_Emission, inp.texcoord.xy);
                o.sv_target = tmp0 + tmp1;
                return o;
			}
#elif defined(DIRECTIONAL) && defined(LIGHTMAP_ON) && !defined(LIGHTMAP_SHADOW_MIXING) && defined(LIGHTPROBE_SH) && !defined(LOD_FADE_CROSSFADE) && !defined(SHADOWS_SCREEN) && defined(SHADOWS_SHADOWMASK) && !defined(VERTEXLIGHT_ON)
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
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 ShadowColor;
			float4 LightColor;
			float _Opacity;
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
                tmp0 = v.vertex.yyyy * float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
                tmp0 = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]) * v.vertex.xxxx + tmp0;
                tmp0 = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]) * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
                o.texcoord3.xyz = float3(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3]) * v.vertex.www + tmp0.xyz;
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
                o.texcoord2.xyz = tmp0.www * tmp0.xyz;
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
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1.x = tmp0.w - 0.5;
                tmp1.x = tmp1.x < 0.0;
                if (tmp1.x) {
                    discard;
                }
                tmp1.xyz = inp.texcoord3.xyz - unity_ShadowFadeCenterAndType.xyz;
                tmp1.x = dot(tmp1.xyz, tmp1.xyz);
                tmp1.x = sqrt(tmp1.x);
                tmp1.yzw = _WorldSpaceCameraPos - inp.texcoord3.xyz;
                tmp2.x = unity_MatrixV._m20;
                tmp2.y = unity_MatrixV._m21;
                tmp2.z = unity_MatrixV._m22;
                tmp1.y = dot(tmp1.xyz, tmp2.xyz);
                tmp1.x = tmp1.x - tmp1.y;
                tmp1.x = unity_ShadowFadeCenterAndType.w * tmp1.x + tmp1.y;
                tmp1.x = saturate(tmp1.x * _LightShadowData.z + _LightShadowData.w);
                tmp1.y = tmp1.x < 1.0;
                tmp1.z = tmp1.x >= 1.0;
                tmp1.yz = tmp1.yz ? 1.0 : 0.0;
                tmp1.y = tmp1.z + tmp1.y;
                tmp1.y = tmp1.y > 0.5;
                tmp1.x = tmp1.y ? 0.0 : tmp1.x;
                tmp1.y = tmp1.y ? 1.0 : 0.0;
                tmp1.x = tmp1.x + tmp1.y;
                tmp1.x = tmp1.x * _Opacity;
                tmp1.y = dot(_WorldSpaceLightPos0.xyz, inp.texcoord2.xyz);
                tmp1.y = saturate(tmp1.y * 100.0);
                tmp1.z = tmp1.y * -2.0 + 3.0;
                tmp1.y = tmp1.y * tmp1.y;
                tmp1.y = tmp1.y * tmp1.z;
                tmp1.x = tmp1.x * tmp1.y;
                tmp1.yzw = LightColor.xyz - ShadowColor.xyz;
                tmp1.xyz = tmp1.xxx * tmp1.yzw + ShadowColor.xyz;
                tmp1.xyz = tmp0.xyz * tmp1.xyz;
                tmp0.xyz = tmp1.xyz * _LightColor0.xyz;
                tmp1 = tex2D(_Emission, inp.texcoord.xy);
                o.sv_target = tmp0 + tmp1;
                return o;
			}
#elif defined(DIRECTIONAL) && defined(LIGHTMAP_ON) && defined(LIGHTMAP_SHADOW_MIXING) && !defined(LIGHTPROBE_SH) && !defined(LOD_FADE_CROSSFADE) && !defined(SHADOWS_SCREEN) && defined(SHADOWS_SHADOWMASK) && !defined(VERTEXLIGHT_ON)
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
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 ShadowColor;
			float4 LightColor;
			float _Opacity;
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
                tmp0 = v.vertex.yyyy * float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
                tmp0 = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]) * v.vertex.xxxx + tmp0;
                tmp0 = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]) * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
                o.texcoord3.xyz = float3(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3]) * v.vertex.www + tmp0.xyz;
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
                o.texcoord2.xyz = tmp0.www * tmp0.xyz;
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
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1.x = tmp0.w - 0.5;
                tmp1.x = tmp1.x < 0.0;
                if (tmp1.x) {
                    discard;
                }
                tmp1.xyz = inp.texcoord3.xyz - unity_ShadowFadeCenterAndType.xyz;
                tmp1.x = dot(tmp1.xyz, tmp1.xyz);
                tmp1.x = sqrt(tmp1.x);
                tmp1.yzw = _WorldSpaceCameraPos - inp.texcoord3.xyz;
                tmp2.x = unity_MatrixV._m20;
                tmp2.y = unity_MatrixV._m21;
                tmp2.z = unity_MatrixV._m22;
                tmp1.y = dot(tmp1.xyz, tmp2.xyz);
                tmp1.x = tmp1.x - tmp1.y;
                tmp1.x = unity_ShadowFadeCenterAndType.w * tmp1.x + tmp1.y;
                tmp1.x = saturate(tmp1.x * _LightShadowData.z + _LightShadowData.w);
                tmp1.y = tmp1.x < 1.0;
                tmp1.z = tmp1.x >= 1.0;
                tmp1.yz = tmp1.yz ? 1.0 : 0.0;
                tmp1.y = tmp1.z + tmp1.y;
                tmp1.y = tmp1.y > 0.5;
                tmp1.x = tmp1.y ? 0.0 : tmp1.x;
                tmp1.y = tmp1.y ? 1.0 : 0.0;
                tmp1.x = tmp1.x + tmp1.y;
                tmp1.x = tmp1.x * _Opacity;
                tmp1.y = dot(_WorldSpaceLightPos0.xyz, inp.texcoord2.xyz);
                tmp1.y = saturate(tmp1.y * 100.0);
                tmp1.z = tmp1.y * -2.0 + 3.0;
                tmp1.y = tmp1.y * tmp1.y;
                tmp1.y = tmp1.y * tmp1.z;
                tmp1.x = tmp1.x * tmp1.y;
                tmp1.yzw = LightColor.xyz - ShadowColor.xyz;
                tmp1.xyz = tmp1.xxx * tmp1.yzw + ShadowColor.xyz;
                tmp1.xyz = tmp0.xyz * tmp1.xyz;
                tmp0.xyz = tmp1.xyz * _LightColor0.xyz;
                tmp1 = tex2D(_Emission, inp.texcoord.xy);
                o.sv_target = tmp0 + tmp1;
                return o;
			}
#elif defined(DIRECTIONAL) && !defined(LIGHTMAP_ON) && defined(LIGHTMAP_SHADOW_MIXING) && defined(LIGHTPROBE_SH) && !defined(LOD_FADE_CROSSFADE) && defined(SHADOWS_SCREEN) && !defined(SHADOWS_SHADOWMASK) && !defined(VERTEXLIGHT_ON)
			#include "UnityCG.cginc"
#include "AutoLight.cginc"
			struct v2f
			{
 UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float3 texcoord2 : TEXCOORD2;
				float3 texcoord3 : TEXCOORD3;
				float4 texcoord4 : TEXCOORD4;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 ShadowColor;
			float4 LightColor;
			float _Opacity;
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
                tmp0 = v.vertex.yyyy * float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
                tmp0 = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]) * v.vertex.xxxx + tmp0;
                tmp0 = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]) * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
                o.texcoord3.xyz = float3(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3]) * v.vertex.www + tmp0.xyz;
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
                o.texcoord2.xyz = tmp1.www * tmp1.xyz;
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
                float4 tmp2;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1.x = tmp0.w - 0.5;
                tmp1.x = tmp1.x < 0.0;
                if (tmp1.x) {
                    discard;
                }
                tmp1.xyz = inp.texcoord3.xyz - unity_ShadowFadeCenterAndType.xyz;
                tmp1.x = dot(tmp1.xyz, tmp1.xyz);
                tmp1.x = sqrt(tmp1.x);
                tmp1.yzw = _WorldSpaceCameraPos - inp.texcoord3.xyz;
                tmp2.x = unity_MatrixV._m20;
                tmp2.y = unity_MatrixV._m21;
                tmp2.z = unity_MatrixV._m22;
                tmp1.y = dot(tmp1.xyz, tmp2.xyz);
                tmp1.x = tmp1.x - tmp1.y;
                tmp1.x = unity_ShadowFadeCenterAndType.w * tmp1.x + tmp1.y;
                tmp1.x = saturate(tmp1.x * _LightShadowData.z + _LightShadowData.w);
                tmp1.y = tmp1.x < 1.0;
                tmp1.z = tmp1.x >= 1.0;
                tmp1.yz = tmp1.yz ? 1.0 : 0.0;
                tmp2.xy = inp.texcoord4.xy / inp.texcoord4.ww;
                tmp2 = tex2D(_ShadowMapTexture, tmp2.xy);
                tmp1.y = tmp1.y * tmp2.x + tmp1.z;
                tmp1.y = tmp1.y > 0.5;
                tmp1.x = tmp1.y ? 0.0 : tmp1.x;
                tmp1.y = tmp1.y ? 1.0 : 0.0;
                tmp1.x = tmp1.x + tmp1.y;
                tmp1.x = tmp1.x * _Opacity;
                tmp1.y = dot(_WorldSpaceLightPos0.xyz, inp.texcoord2.xyz);
                tmp1.y = saturate(tmp1.y * 100.0);
                tmp1.z = tmp1.y * -2.0 + 3.0;
                tmp1.y = tmp1.y * tmp1.y;
                tmp1.y = tmp1.y * tmp1.z;
                tmp1.x = tmp1.x * tmp1.y;
                tmp1.yzw = LightColor.xyz - ShadowColor.xyz;
                tmp1.xyz = tmp1.xxx * tmp1.yzw + ShadowColor.xyz;
                tmp1.xyz = tmp0.xyz * tmp1.xyz;
                tmp0.xyz = tmp1.xyz * _LightColor0.xyz;
                tmp1 = tex2D(_Emission, inp.texcoord.xy);
                o.sv_target = tmp0 + tmp1;
                return o;
			}
#elif defined(DIRECTIONAL) && !defined(LIGHTMAP_ON) && !defined(LIGHTMAP_SHADOW_MIXING) && defined(LIGHTPROBE_SH) && !defined(LOD_FADE_CROSSFADE) && defined(SHADOWS_SCREEN) && defined(SHADOWS_SHADOWMASK) && !defined(VERTEXLIGHT_ON)
			#include "UnityCG.cginc"
#include "AutoLight.cginc"
			struct v2f
			{
 UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float3 texcoord2 : TEXCOORD2;
				float3 texcoord3 : TEXCOORD3;
				float4 texcoord4 : TEXCOORD4;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 ShadowColor;
			float4 LightColor;
			float _Opacity;
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
                tmp0 = v.vertex.yyyy * float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
                tmp0 = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]) * v.vertex.xxxx + tmp0;
                tmp0 = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]) * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
                o.texcoord3.xyz = float3(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3]) * v.vertex.www + tmp0.xyz;
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
                o.texcoord2.xyz = tmp1.www * tmp1.xyz;
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
                float4 tmp2;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1.x = tmp0.w - 0.5;
                tmp1.x = tmp1.x < 0.0;
                if (tmp1.x) {
                    discard;
                }
                tmp1.xyz = inp.texcoord3.xyz - unity_ShadowFadeCenterAndType.xyz;
                tmp1.x = dot(tmp1.xyz, tmp1.xyz);
                tmp1.x = sqrt(tmp1.x);
                tmp1.yzw = _WorldSpaceCameraPos - inp.texcoord3.xyz;
                tmp2.x = unity_MatrixV._m20;
                tmp2.y = unity_MatrixV._m21;
                tmp2.z = unity_MatrixV._m22;
                tmp1.y = dot(tmp1.xyz, tmp2.xyz);
                tmp1.x = tmp1.x - tmp1.y;
                tmp1.x = unity_ShadowFadeCenterAndType.w * tmp1.x + tmp1.y;
                tmp1.x = saturate(tmp1.x * _LightShadowData.z + _LightShadowData.w);
                tmp1.y = tmp1.x < 1.0;
                tmp1.z = tmp1.x >= 1.0;
                tmp1.yz = tmp1.yz ? 1.0 : 0.0;
                tmp2.xy = inp.texcoord4.xy / inp.texcoord4.ww;
                tmp2 = tex2D(_ShadowMapTexture, tmp2.xy);
                tmp1.y = tmp1.y * tmp2.x + tmp1.z;
                tmp1.y = tmp1.y > 0.5;
                tmp1.x = tmp1.y ? 0.0 : tmp1.x;
                tmp1.y = tmp1.y ? 1.0 : 0.0;
                tmp1.x = tmp1.x + tmp1.y;
                tmp1.x = tmp1.x * _Opacity;
                tmp1.y = dot(_WorldSpaceLightPos0.xyz, inp.texcoord2.xyz);
                tmp1.y = saturate(tmp1.y * 100.0);
                tmp1.z = tmp1.y * -2.0 + 3.0;
                tmp1.y = tmp1.y * tmp1.y;
                tmp1.y = tmp1.y * tmp1.z;
                tmp1.x = tmp1.x * tmp1.y;
                tmp1.yzw = LightColor.xyz - ShadowColor.xyz;
                tmp1.xyz = tmp1.xxx * tmp1.yzw + ShadowColor.xyz;
                tmp1.xyz = tmp0.xyz * tmp1.xyz;
                tmp0.xyz = tmp1.xyz * _LightColor0.xyz;
                tmp1 = tex2D(_Emission, inp.texcoord.xy);
                o.sv_target = tmp0 + tmp1;
                return o;
			}
#elif defined(DIRECTIONAL) && defined(LIGHTMAP_ON) && !defined(LIGHTMAP_SHADOW_MIXING) && defined(LIGHTPROBE_SH) && !defined(LOD_FADE_CROSSFADE) && defined(SHADOWS_SCREEN) && !defined(SHADOWS_SHADOWMASK) && !defined(VERTEXLIGHT_ON)
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
				float4 texcoord4 : TEXCOORD4;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 ShadowColor;
			float4 LightColor;
			float _Opacity;
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
                tmp0 = v.vertex.yyyy * float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
                tmp0 = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]) * v.vertex.xxxx + tmp0;
                tmp0 = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]) * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
                o.texcoord3.xyz = float3(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3]) * v.vertex.www + tmp0.xyz;
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
                o.texcoord2.xyz = tmp1.www * tmp1.xyz;
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
                float4 tmp2;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1.x = tmp0.w - 0.5;
                tmp1.x = tmp1.x < 0.0;
                if (tmp1.x) {
                    discard;
                }
                tmp1.xyz = inp.texcoord3.xyz - unity_ShadowFadeCenterAndType.xyz;
                tmp1.x = dot(tmp1.xyz, tmp1.xyz);
                tmp1.x = sqrt(tmp1.x);
                tmp1.yzw = _WorldSpaceCameraPos - inp.texcoord3.xyz;
                tmp2.x = unity_MatrixV._m20;
                tmp2.y = unity_MatrixV._m21;
                tmp2.z = unity_MatrixV._m22;
                tmp1.y = dot(tmp1.xyz, tmp2.xyz);
                tmp1.x = tmp1.x - tmp1.y;
                tmp1.x = unity_ShadowFadeCenterAndType.w * tmp1.x + tmp1.y;
                tmp1.x = saturate(tmp1.x * _LightShadowData.z + _LightShadowData.w);
                tmp1.y = tmp1.x < 1.0;
                tmp1.z = tmp1.x >= 1.0;
                tmp1.yz = tmp1.yz ? 1.0 : 0.0;
                tmp2.xy = inp.texcoord4.xy / inp.texcoord4.ww;
                tmp2 = tex2D(_ShadowMapTexture, tmp2.xy);
                tmp1.y = tmp1.y * tmp2.x + tmp1.z;
                tmp1.y = tmp1.y > 0.5;
                tmp1.x = tmp1.y ? 0.0 : tmp1.x;
                tmp1.y = tmp1.y ? 1.0 : 0.0;
                tmp1.x = tmp1.x + tmp1.y;
                tmp1.x = tmp1.x * _Opacity;
                tmp1.y = dot(_WorldSpaceLightPos0.xyz, inp.texcoord2.xyz);
                tmp1.y = saturate(tmp1.y * 100.0);
                tmp1.z = tmp1.y * -2.0 + 3.0;
                tmp1.y = tmp1.y * tmp1.y;
                tmp1.y = tmp1.y * tmp1.z;
                tmp1.x = tmp1.x * tmp1.y;
                tmp1.yzw = LightColor.xyz - ShadowColor.xyz;
                tmp1.xyz = tmp1.xxx * tmp1.yzw + ShadowColor.xyz;
                tmp1.xyz = tmp0.xyz * tmp1.xyz;
                tmp0.xyz = tmp1.xyz * _LightColor0.xyz;
                tmp1 = tex2D(_Emission, inp.texcoord.xy);
                o.sv_target = tmp0 + tmp1;
                return o;
			}
#elif defined(DIRECTIONAL) && defined(LIGHTMAP_ON) && defined(LIGHTMAP_SHADOW_MIXING) && !defined(LIGHTPROBE_SH) && !defined(LOD_FADE_CROSSFADE) && defined(SHADOWS_SCREEN) && !defined(SHADOWS_SHADOWMASK) && !defined(VERTEXLIGHT_ON)
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
				float4 texcoord4 : TEXCOORD4;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 ShadowColor;
			float4 LightColor;
			float _Opacity;
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
                tmp0 = v.vertex.yyyy * float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
                tmp0 = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]) * v.vertex.xxxx + tmp0;
                tmp0 = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]) * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
                o.texcoord3.xyz = float3(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3]) * v.vertex.www + tmp0.xyz;
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
                o.texcoord2.xyz = tmp1.www * tmp1.xyz;
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
                float4 tmp2;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1.x = tmp0.w - 0.5;
                tmp1.x = tmp1.x < 0.0;
                if (tmp1.x) {
                    discard;
                }
                tmp1.xyz = inp.texcoord3.xyz - unity_ShadowFadeCenterAndType.xyz;
                tmp1.x = dot(tmp1.xyz, tmp1.xyz);
                tmp1.x = sqrt(tmp1.x);
                tmp1.yzw = _WorldSpaceCameraPos - inp.texcoord3.xyz;
                tmp2.x = unity_MatrixV._m20;
                tmp2.y = unity_MatrixV._m21;
                tmp2.z = unity_MatrixV._m22;
                tmp1.y = dot(tmp1.xyz, tmp2.xyz);
                tmp1.x = tmp1.x - tmp1.y;
                tmp1.x = unity_ShadowFadeCenterAndType.w * tmp1.x + tmp1.y;
                tmp1.x = saturate(tmp1.x * _LightShadowData.z + _LightShadowData.w);
                tmp1.y = tmp1.x < 1.0;
                tmp1.z = tmp1.x >= 1.0;
                tmp1.yz = tmp1.yz ? 1.0 : 0.0;
                tmp2.xy = inp.texcoord4.xy / inp.texcoord4.ww;
                tmp2 = tex2D(_ShadowMapTexture, tmp2.xy);
                tmp1.y = tmp1.y * tmp2.x + tmp1.z;
                tmp1.y = tmp1.y > 0.5;
                tmp1.x = tmp1.y ? 0.0 : tmp1.x;
                tmp1.y = tmp1.y ? 1.0 : 0.0;
                tmp1.x = tmp1.x + tmp1.y;
                tmp1.x = tmp1.x * _Opacity;
                tmp1.y = dot(_WorldSpaceLightPos0.xyz, inp.texcoord2.xyz);
                tmp1.y = saturate(tmp1.y * 100.0);
                tmp1.z = tmp1.y * -2.0 + 3.0;
                tmp1.y = tmp1.y * tmp1.y;
                tmp1.y = tmp1.y * tmp1.z;
                tmp1.x = tmp1.x * tmp1.y;
                tmp1.yzw = LightColor.xyz - ShadowColor.xyz;
                tmp1.xyz = tmp1.xxx * tmp1.yzw + ShadowColor.xyz;
                tmp1.xyz = tmp0.xyz * tmp1.xyz;
                tmp0.xyz = tmp1.xyz * _LightColor0.xyz;
                tmp1 = tex2D(_Emission, inp.texcoord.xy);
                o.sv_target = tmp0 + tmp1;
                return o;
			}
#elif defined(DIRECTIONAL) && defined(LIGHTMAP_ON) && !defined(LIGHTMAP_SHADOW_MIXING) && !defined(LIGHTPROBE_SH) && !defined(LOD_FADE_CROSSFADE) && defined(SHADOWS_SCREEN) && defined(SHADOWS_SHADOWMASK) && !defined(VERTEXLIGHT_ON)
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
				float4 texcoord4 : TEXCOORD4;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 ShadowColor;
			float4 LightColor;
			float _Opacity;
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
                tmp0 = v.vertex.yyyy * float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
                tmp0 = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]) * v.vertex.xxxx + tmp0;
                tmp0 = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]) * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
                o.texcoord3.xyz = float3(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3]) * v.vertex.www + tmp0.xyz;
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
                o.texcoord2.xyz = tmp1.www * tmp1.xyz;
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
                float4 tmp2;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1.x = tmp0.w - 0.5;
                tmp1.x = tmp1.x < 0.0;
                if (tmp1.x) {
                    discard;
                }
                tmp1.xyz = inp.texcoord3.xyz - unity_ShadowFadeCenterAndType.xyz;
                tmp1.x = dot(tmp1.xyz, tmp1.xyz);
                tmp1.x = sqrt(tmp1.x);
                tmp1.yzw = _WorldSpaceCameraPos - inp.texcoord3.xyz;
                tmp2.x = unity_MatrixV._m20;
                tmp2.y = unity_MatrixV._m21;
                tmp2.z = unity_MatrixV._m22;
                tmp1.y = dot(tmp1.xyz, tmp2.xyz);
                tmp1.x = tmp1.x - tmp1.y;
                tmp1.x = unity_ShadowFadeCenterAndType.w * tmp1.x + tmp1.y;
                tmp1.x = saturate(tmp1.x * _LightShadowData.z + _LightShadowData.w);
                tmp1.y = tmp1.x < 1.0;
                tmp1.z = tmp1.x >= 1.0;
                tmp1.yz = tmp1.yz ? 1.0 : 0.0;
                tmp2.xy = inp.texcoord4.xy / inp.texcoord4.ww;
                tmp2 = tex2D(_ShadowMapTexture, tmp2.xy);
                tmp1.y = tmp1.y * tmp2.x + tmp1.z;
                tmp1.y = tmp1.y > 0.5;
                tmp1.x = tmp1.y ? 0.0 : tmp1.x;
                tmp1.y = tmp1.y ? 1.0 : 0.0;
                tmp1.x = tmp1.x + tmp1.y;
                tmp1.x = tmp1.x * _Opacity;
                tmp1.y = dot(_WorldSpaceLightPos0.xyz, inp.texcoord2.xyz);
                tmp1.y = saturate(tmp1.y * 100.0);
                tmp1.z = tmp1.y * -2.0 + 3.0;
                tmp1.y = tmp1.y * tmp1.y;
                tmp1.y = tmp1.y * tmp1.z;
                tmp1.x = tmp1.x * tmp1.y;
                tmp1.yzw = LightColor.xyz - ShadowColor.xyz;
                tmp1.xyz = tmp1.xxx * tmp1.yzw + ShadowColor.xyz;
                tmp1.xyz = tmp0.xyz * tmp1.xyz;
                tmp0.xyz = tmp1.xyz * _LightColor0.xyz;
                tmp1 = tex2D(_Emission, inp.texcoord.xy);
                o.sv_target = tmp0 + tmp1;
                return o;
			}
#elif defined(DIRECTIONAL) && !defined(LIGHTMAP_ON) && !defined(LIGHTMAP_SHADOW_MIXING) && defined(LIGHTPROBE_SH) && !defined(LOD_FADE_CROSSFADE) && defined(SHADOWS_SCREEN) && !defined(SHADOWS_SHADOWMASK) && defined(VERTEXLIGHT_ON)
			#include "UnityCG.cginc"
#include "AutoLight.cginc"
			struct v2f
			{
 UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float3 texcoord2 : TEXCOORD2;
				float3 texcoord3 : TEXCOORD3;
				float4 texcoord4 : TEXCOORD4;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 ShadowColor;
			float4 LightColor;
			float _Opacity;
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
                tmp0 = v.vertex.yyyy * float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
                tmp0 = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]) * v.vertex.xxxx + tmp0;
                tmp0 = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]) * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
                o.texcoord3.xyz = float3(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3]) * v.vertex.www + tmp0.xyz;
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
                o.texcoord2.xyz = tmp1.www * tmp1.xyz;
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
                float4 tmp2;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1.x = tmp0.w - 0.5;
                tmp1.x = tmp1.x < 0.0;
                if (tmp1.x) {
                    discard;
                }
                tmp1.xyz = inp.texcoord3.xyz - unity_ShadowFadeCenterAndType.xyz;
                tmp1.x = dot(tmp1.xyz, tmp1.xyz);
                tmp1.x = sqrt(tmp1.x);
                tmp1.yzw = _WorldSpaceCameraPos - inp.texcoord3.xyz;
                tmp2.x = unity_MatrixV._m20;
                tmp2.y = unity_MatrixV._m21;
                tmp2.z = unity_MatrixV._m22;
                tmp1.y = dot(tmp1.xyz, tmp2.xyz);
                tmp1.x = tmp1.x - tmp1.y;
                tmp1.x = unity_ShadowFadeCenterAndType.w * tmp1.x + tmp1.y;
                tmp1.x = saturate(tmp1.x * _LightShadowData.z + _LightShadowData.w);
                tmp1.y = tmp1.x < 1.0;
                tmp1.z = tmp1.x >= 1.0;
                tmp1.yz = tmp1.yz ? 1.0 : 0.0;
                tmp2.xy = inp.texcoord4.xy / inp.texcoord4.ww;
                tmp2 = tex2D(_ShadowMapTexture, tmp2.xy);
                tmp1.y = tmp1.y * tmp2.x + tmp1.z;
                tmp1.y = tmp1.y > 0.5;
                tmp1.x = tmp1.y ? 0.0 : tmp1.x;
                tmp1.y = tmp1.y ? 1.0 : 0.0;
                tmp1.x = tmp1.x + tmp1.y;
                tmp1.x = tmp1.x * _Opacity;
                tmp1.y = dot(_WorldSpaceLightPos0.xyz, inp.texcoord2.xyz);
                tmp1.y = saturate(tmp1.y * 100.0);
                tmp1.z = tmp1.y * -2.0 + 3.0;
                tmp1.y = tmp1.y * tmp1.y;
                tmp1.y = tmp1.y * tmp1.z;
                tmp1.x = tmp1.x * tmp1.y;
                tmp1.yzw = LightColor.xyz - ShadowColor.xyz;
                tmp1.xyz = tmp1.xxx * tmp1.yzw + ShadowColor.xyz;
                tmp1.xyz = tmp0.xyz * tmp1.xyz;
                tmp0.xyz = tmp1.xyz * _LightColor0.xyz;
                tmp1 = tex2D(_Emission, inp.texcoord.xy);
                o.sv_target = tmp0 + tmp1;
                return o;
			}
#elif defined(DIRECTIONAL) && !defined(LIGHTMAP_ON) && defined(LIGHTMAP_SHADOW_MIXING) && !defined(LIGHTPROBE_SH) && !defined(LOD_FADE_CROSSFADE) && defined(SHADOWS_SCREEN) && !defined(SHADOWS_SHADOWMASK) && defined(VERTEXLIGHT_ON)
			#include "UnityCG.cginc"
#include "AutoLight.cginc"
			struct v2f
			{
 UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float3 texcoord2 : TEXCOORD2;
				float3 texcoord3 : TEXCOORD3;
				float4 texcoord4 : TEXCOORD4;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 ShadowColor;
			float4 LightColor;
			float _Opacity;
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
                tmp0 = v.vertex.yyyy * float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
                tmp0 = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]) * v.vertex.xxxx + tmp0;
                tmp0 = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]) * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
                o.texcoord3.xyz = float3(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3]) * v.vertex.www + tmp0.xyz;
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
                o.texcoord2.xyz = tmp1.www * tmp1.xyz;
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
                float4 tmp2;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1.x = tmp0.w - 0.5;
                tmp1.x = tmp1.x < 0.0;
                if (tmp1.x) {
                    discard;
                }
                tmp1.xyz = inp.texcoord3.xyz - unity_ShadowFadeCenterAndType.xyz;
                tmp1.x = dot(tmp1.xyz, tmp1.xyz);
                tmp1.x = sqrt(tmp1.x);
                tmp1.yzw = _WorldSpaceCameraPos - inp.texcoord3.xyz;
                tmp2.x = unity_MatrixV._m20;
                tmp2.y = unity_MatrixV._m21;
                tmp2.z = unity_MatrixV._m22;
                tmp1.y = dot(tmp1.xyz, tmp2.xyz);
                tmp1.x = tmp1.x - tmp1.y;
                tmp1.x = unity_ShadowFadeCenterAndType.w * tmp1.x + tmp1.y;
                tmp1.x = saturate(tmp1.x * _LightShadowData.z + _LightShadowData.w);
                tmp1.y = tmp1.x < 1.0;
                tmp1.z = tmp1.x >= 1.0;
                tmp1.yz = tmp1.yz ? 1.0 : 0.0;
                tmp2.xy = inp.texcoord4.xy / inp.texcoord4.ww;
                tmp2 = tex2D(_ShadowMapTexture, tmp2.xy);
                tmp1.y = tmp1.y * tmp2.x + tmp1.z;
                tmp1.y = tmp1.y > 0.5;
                tmp1.x = tmp1.y ? 0.0 : tmp1.x;
                tmp1.y = tmp1.y ? 1.0 : 0.0;
                tmp1.x = tmp1.x + tmp1.y;
                tmp1.x = tmp1.x * _Opacity;
                tmp1.y = dot(_WorldSpaceLightPos0.xyz, inp.texcoord2.xyz);
                tmp1.y = saturate(tmp1.y * 100.0);
                tmp1.z = tmp1.y * -2.0 + 3.0;
                tmp1.y = tmp1.y * tmp1.y;
                tmp1.y = tmp1.y * tmp1.z;
                tmp1.x = tmp1.x * tmp1.y;
                tmp1.yzw = LightColor.xyz - ShadowColor.xyz;
                tmp1.xyz = tmp1.xxx * tmp1.yzw + ShadowColor.xyz;
                tmp1.xyz = tmp0.xyz * tmp1.xyz;
                tmp0.xyz = tmp1.xyz * _LightColor0.xyz;
                tmp1 = tex2D(_Emission, inp.texcoord.xy);
                o.sv_target = tmp0 + tmp1;
                return o;
			}
#elif defined(DIRECTIONAL) && !defined(LIGHTMAP_ON) && !defined(LIGHTMAP_SHADOW_MIXING) && !defined(LIGHTPROBE_SH) && !defined(LOD_FADE_CROSSFADE) && defined(SHADOWS_SCREEN) && defined(SHADOWS_SHADOWMASK) && defined(VERTEXLIGHT_ON)
			#include "UnityCG.cginc"
#include "AutoLight.cginc"
			struct v2f
			{
 UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float3 texcoord2 : TEXCOORD2;
				float3 texcoord3 : TEXCOORD3;
				float4 texcoord4 : TEXCOORD4;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 ShadowColor;
			float4 LightColor;
			float _Opacity;
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
                tmp0 = v.vertex.yyyy * float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
                tmp0 = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]) * v.vertex.xxxx + tmp0;
                tmp0 = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]) * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
                o.texcoord3.xyz = float3(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3]) * v.vertex.www + tmp0.xyz;
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
                o.texcoord2.xyz = tmp1.www * tmp1.xyz;
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
                float4 tmp2;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1.x = tmp0.w - 0.5;
                tmp1.x = tmp1.x < 0.0;
                if (tmp1.x) {
                    discard;
                }
                tmp1.xyz = inp.texcoord3.xyz - unity_ShadowFadeCenterAndType.xyz;
                tmp1.x = dot(tmp1.xyz, tmp1.xyz);
                tmp1.x = sqrt(tmp1.x);
                tmp1.yzw = _WorldSpaceCameraPos - inp.texcoord3.xyz;
                tmp2.x = unity_MatrixV._m20;
                tmp2.y = unity_MatrixV._m21;
                tmp2.z = unity_MatrixV._m22;
                tmp1.y = dot(tmp1.xyz, tmp2.xyz);
                tmp1.x = tmp1.x - tmp1.y;
                tmp1.x = unity_ShadowFadeCenterAndType.w * tmp1.x + tmp1.y;
                tmp1.x = saturate(tmp1.x * _LightShadowData.z + _LightShadowData.w);
                tmp1.y = tmp1.x < 1.0;
                tmp1.z = tmp1.x >= 1.0;
                tmp1.yz = tmp1.yz ? 1.0 : 0.0;
                tmp2.xy = inp.texcoord4.xy / inp.texcoord4.ww;
                tmp2 = tex2D(_ShadowMapTexture, tmp2.xy);
                tmp1.y = tmp1.y * tmp2.x + tmp1.z;
                tmp1.y = tmp1.y > 0.5;
                tmp1.x = tmp1.y ? 0.0 : tmp1.x;
                tmp1.y = tmp1.y ? 1.0 : 0.0;
                tmp1.x = tmp1.x + tmp1.y;
                tmp1.x = tmp1.x * _Opacity;
                tmp1.y = dot(_WorldSpaceLightPos0.xyz, inp.texcoord2.xyz);
                tmp1.y = saturate(tmp1.y * 100.0);
                tmp1.z = tmp1.y * -2.0 + 3.0;
                tmp1.y = tmp1.y * tmp1.y;
                tmp1.y = tmp1.y * tmp1.z;
                tmp1.x = tmp1.x * tmp1.y;
                tmp1.yzw = LightColor.xyz - ShadowColor.xyz;
                tmp1.xyz = tmp1.xxx * tmp1.yzw + ShadowColor.xyz;
                tmp1.xyz = tmp0.xyz * tmp1.xyz;
                tmp0.xyz = tmp1.xyz * _LightColor0.xyz;
                tmp1 = tex2D(_Emission, inp.texcoord.xy);
                o.sv_target = tmp0 + tmp1;
                return o;
			}
#elif defined(DIRECTIONAL) && !defined(LIGHTMAP_ON) && !defined(LIGHTMAP_SHADOW_MIXING) && defined(LIGHTPROBE_SH) && defined(LOD_FADE_CROSSFADE) && !defined(SHADOWS_SCREEN) && defined(SHADOWS_SHADOWMASK) && !defined(VERTEXLIGHT_ON)
			#include "UnityCG.cginc"
#include "AutoLight.cginc"
			struct v2f
			{
 UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float3 texcoord2 : TEXCOORD2;
				float3 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 ShadowColor;
			float4 LightColor;
			float _Opacity;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			sampler2D _Emission;
			
			// Keywords: LOD_FADE_CROSSFADE DIRECTIONAL LIGHTPROBE_SH SHADOWS_SHADOWMASK
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
                o.texcoord3.xyz = float3(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3]) * v.vertex.www + tmp0.xyz;
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
                o.texcoord2.xyz = tmp0.www * tmp0.xyz;
                return o;
			}
			// Keywords: LOD_FADE_CROSSFADE DIRECTIONAL LIGHTPROBE_SH SHADOWS_SHADOWMASK
			fout frag(v2f inp)
			{
 UNITY_SETUP_INSTANCE_ID(inp);
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = dot(inp.position.xy, float2(0.0671106, 0.0058372));
                tmp0.x = frac(tmp0.x);
                tmp0.x = tmp0.x * 52.98292;
                tmp0.x = frac(tmp0.x);
                tmp0.x = unity_LODFade.x - tmp0.x;
                tmp0.x = tmp0.x < 0.0;
                if (tmp0.x) {
                    discard;
                }
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1.x = tmp0.w - 0.5;
                tmp1.x = tmp1.x < 0.0;
                if (tmp1.x) {
                    discard;
                }
                tmp1.xyz = inp.texcoord3.xyz - unity_ShadowFadeCenterAndType.xyz;
                tmp1.x = dot(tmp1.xyz, tmp1.xyz);
                tmp1.x = sqrt(tmp1.x);
                tmp1.yzw = _WorldSpaceCameraPos - inp.texcoord3.xyz;
                tmp2.x = unity_MatrixV._m20;
                tmp2.y = unity_MatrixV._m21;
                tmp2.z = unity_MatrixV._m22;
                tmp1.y = dot(tmp1.xyz, tmp2.xyz);
                tmp1.x = tmp1.x - tmp1.y;
                tmp1.x = unity_ShadowFadeCenterAndType.w * tmp1.x + tmp1.y;
                tmp1.x = saturate(tmp1.x * _LightShadowData.z + _LightShadowData.w);
                tmp1.y = tmp1.x < 1.0;
                tmp1.z = tmp1.x >= 1.0;
                tmp1.yz = tmp1.yz ? 1.0 : 0.0;
                tmp1.y = tmp1.z + tmp1.y;
                tmp1.y = tmp1.y > 0.5;
                tmp1.x = tmp1.y ? 0.0 : tmp1.x;
                tmp1.y = tmp1.y ? 1.0 : 0.0;
                tmp1.x = tmp1.x + tmp1.y;
                tmp1.x = tmp1.x * _Opacity;
                tmp1.y = dot(_WorldSpaceLightPos0.xyz, inp.texcoord2.xyz);
                tmp1.y = saturate(tmp1.y * 100.0);
                tmp1.z = tmp1.y * -2.0 + 3.0;
                tmp1.y = tmp1.y * tmp1.y;
                tmp1.y = tmp1.y * tmp1.z;
                tmp1.x = tmp1.x * tmp1.y;
                tmp1.yzw = LightColor.xyz - ShadowColor.xyz;
                tmp1.xyz = tmp1.xxx * tmp1.yzw + ShadowColor.xyz;
                tmp1.xyz = tmp0.xyz * tmp1.xyz;
                tmp0.xyz = tmp1.xyz * _LightColor0.xyz;
                tmp1 = tex2D(_Emission, inp.texcoord.xy);
                o.sv_target = tmp0 + tmp1;
                return o;
			}
#elif defined(DIRECTIONAL) && defined(LIGHTMAP_ON) && !defined(LIGHTMAP_SHADOW_MIXING) && defined(LIGHTPROBE_SH) && defined(LOD_FADE_CROSSFADE) && !defined(SHADOWS_SCREEN) && !defined(SHADOWS_SHADOWMASK) && !defined(VERTEXLIGHT_ON)
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
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 ShadowColor;
			float4 LightColor;
			float _Opacity;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			sampler2D _Emission;
			
			// Keywords: LOD_FADE_CROSSFADE DIRECTIONAL LIGHTPROBE_SH LIGHTMAP_ON
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
                o.texcoord3.xyz = float3(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3]) * v.vertex.www + tmp0.xyz;
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
                o.texcoord2.xyz = tmp0.www * tmp0.xyz;
                return o;
			}
			// Keywords: LOD_FADE_CROSSFADE DIRECTIONAL LIGHTPROBE_SH LIGHTMAP_ON
			fout frag(v2f inp)
			{
 UNITY_SETUP_INSTANCE_ID(inp);
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = dot(inp.position.xy, float2(0.0671106, 0.0058372));
                tmp0.x = frac(tmp0.x);
                tmp0.x = tmp0.x * 52.98292;
                tmp0.x = frac(tmp0.x);
                tmp0.x = unity_LODFade.x - tmp0.x;
                tmp0.x = tmp0.x < 0.0;
                if (tmp0.x) {
                    discard;
                }
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1.x = tmp0.w - 0.5;
                tmp1.x = tmp1.x < 0.0;
                if (tmp1.x) {
                    discard;
                }
                tmp1.xyz = inp.texcoord3.xyz - unity_ShadowFadeCenterAndType.xyz;
                tmp1.x = dot(tmp1.xyz, tmp1.xyz);
                tmp1.x = sqrt(tmp1.x);
                tmp1.yzw = _WorldSpaceCameraPos - inp.texcoord3.xyz;
                tmp2.x = unity_MatrixV._m20;
                tmp2.y = unity_MatrixV._m21;
                tmp2.z = unity_MatrixV._m22;
                tmp1.y = dot(tmp1.xyz, tmp2.xyz);
                tmp1.x = tmp1.x - tmp1.y;
                tmp1.x = unity_ShadowFadeCenterAndType.w * tmp1.x + tmp1.y;
                tmp1.x = saturate(tmp1.x * _LightShadowData.z + _LightShadowData.w);
                tmp1.y = tmp1.x < 1.0;
                tmp1.z = tmp1.x >= 1.0;
                tmp1.yz = tmp1.yz ? 1.0 : 0.0;
                tmp1.y = tmp1.z + tmp1.y;
                tmp1.y = tmp1.y > 0.5;
                tmp1.x = tmp1.y ? 0.0 : tmp1.x;
                tmp1.y = tmp1.y ? 1.0 : 0.0;
                tmp1.x = tmp1.x + tmp1.y;
                tmp1.x = tmp1.x * _Opacity;
                tmp1.y = dot(_WorldSpaceLightPos0.xyz, inp.texcoord2.xyz);
                tmp1.y = saturate(tmp1.y * 100.0);
                tmp1.z = tmp1.y * -2.0 + 3.0;
                tmp1.y = tmp1.y * tmp1.y;
                tmp1.y = tmp1.y * tmp1.z;
                tmp1.x = tmp1.x * tmp1.y;
                tmp1.yzw = LightColor.xyz - ShadowColor.xyz;
                tmp1.xyz = tmp1.xxx * tmp1.yzw + ShadowColor.xyz;
                tmp1.xyz = tmp0.xyz * tmp1.xyz;
                tmp0.xyz = tmp1.xyz * _LightColor0.xyz;
                tmp1 = tex2D(_Emission, inp.texcoord.xy);
                o.sv_target = tmp0 + tmp1;
                return o;
			}
#elif defined(DIRECTIONAL) && defined(LIGHTMAP_ON) && defined(LIGHTMAP_SHADOW_MIXING) && !defined(LIGHTPROBE_SH) && defined(LOD_FADE_CROSSFADE) && !defined(SHADOWS_SCREEN) && !defined(SHADOWS_SHADOWMASK) && !defined(VERTEXLIGHT_ON)
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
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 ShadowColor;
			float4 LightColor;
			float _Opacity;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			sampler2D _Emission;
			
			// Keywords: LOD_FADE_CROSSFADE DIRECTIONAL LIGHTMAP_ON LIGHTMAP_SHADOW_MIXING
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
                o.texcoord3.xyz = float3(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3]) * v.vertex.www + tmp0.xyz;
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
                o.texcoord2.xyz = tmp0.www * tmp0.xyz;
                return o;
			}
			// Keywords: LOD_FADE_CROSSFADE DIRECTIONAL LIGHTMAP_ON LIGHTMAP_SHADOW_MIXING
			fout frag(v2f inp)
			{
 UNITY_SETUP_INSTANCE_ID(inp);
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = dot(inp.position.xy, float2(0.0671106, 0.0058372));
                tmp0.x = frac(tmp0.x);
                tmp0.x = tmp0.x * 52.98292;
                tmp0.x = frac(tmp0.x);
                tmp0.x = unity_LODFade.x - tmp0.x;
                tmp0.x = tmp0.x < 0.0;
                if (tmp0.x) {
                    discard;
                }
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1.x = tmp0.w - 0.5;
                tmp1.x = tmp1.x < 0.0;
                if (tmp1.x) {
                    discard;
                }
                tmp1.xyz = inp.texcoord3.xyz - unity_ShadowFadeCenterAndType.xyz;
                tmp1.x = dot(tmp1.xyz, tmp1.xyz);
                tmp1.x = sqrt(tmp1.x);
                tmp1.yzw = _WorldSpaceCameraPos - inp.texcoord3.xyz;
                tmp2.x = unity_MatrixV._m20;
                tmp2.y = unity_MatrixV._m21;
                tmp2.z = unity_MatrixV._m22;
                tmp1.y = dot(tmp1.xyz, tmp2.xyz);
                tmp1.x = tmp1.x - tmp1.y;
                tmp1.x = unity_ShadowFadeCenterAndType.w * tmp1.x + tmp1.y;
                tmp1.x = saturate(tmp1.x * _LightShadowData.z + _LightShadowData.w);
                tmp1.y = tmp1.x < 1.0;
                tmp1.z = tmp1.x >= 1.0;
                tmp1.yz = tmp1.yz ? 1.0 : 0.0;
                tmp1.y = tmp1.z + tmp1.y;
                tmp1.y = tmp1.y > 0.5;
                tmp1.x = tmp1.y ? 0.0 : tmp1.x;
                tmp1.y = tmp1.y ? 1.0 : 0.0;
                tmp1.x = tmp1.x + tmp1.y;
                tmp1.x = tmp1.x * _Opacity;
                tmp1.y = dot(_WorldSpaceLightPos0.xyz, inp.texcoord2.xyz);
                tmp1.y = saturate(tmp1.y * 100.0);
                tmp1.z = tmp1.y * -2.0 + 3.0;
                tmp1.y = tmp1.y * tmp1.y;
                tmp1.y = tmp1.y * tmp1.z;
                tmp1.x = tmp1.x * tmp1.y;
                tmp1.yzw = LightColor.xyz - ShadowColor.xyz;
                tmp1.xyz = tmp1.xxx * tmp1.yzw + ShadowColor.xyz;
                tmp1.xyz = tmp0.xyz * tmp1.xyz;
                tmp0.xyz = tmp1.xyz * _LightColor0.xyz;
                tmp1 = tex2D(_Emission, inp.texcoord.xy);
                o.sv_target = tmp0 + tmp1;
                return o;
			}
#elif defined(DIRECTIONAL) && defined(LIGHTMAP_ON) && !defined(LIGHTMAP_SHADOW_MIXING) && !defined(LIGHTPROBE_SH) && defined(LOD_FADE_CROSSFADE) && !defined(SHADOWS_SCREEN) && defined(SHADOWS_SHADOWMASK) && !defined(VERTEXLIGHT_ON)
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
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 ShadowColor;
			float4 LightColor;
			float _Opacity;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			sampler2D _Emission;
			
			// Keywords: LOD_FADE_CROSSFADE DIRECTIONAL SHADOWS_SHADOWMASK LIGHTMAP_ON
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
                o.texcoord3.xyz = float3(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3]) * v.vertex.www + tmp0.xyz;
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
                o.texcoord2.xyz = tmp0.www * tmp0.xyz;
                return o;
			}
			// Keywords: LOD_FADE_CROSSFADE DIRECTIONAL SHADOWS_SHADOWMASK LIGHTMAP_ON
			fout frag(v2f inp)
			{
 UNITY_SETUP_INSTANCE_ID(inp);
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = dot(inp.position.xy, float2(0.0671106, 0.0058372));
                tmp0.x = frac(tmp0.x);
                tmp0.x = tmp0.x * 52.98292;
                tmp0.x = frac(tmp0.x);
                tmp0.x = unity_LODFade.x - tmp0.x;
                tmp0.x = tmp0.x < 0.0;
                if (tmp0.x) {
                    discard;
                }
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1.x = tmp0.w - 0.5;
                tmp1.x = tmp1.x < 0.0;
                if (tmp1.x) {
                    discard;
                }
                tmp1.xyz = inp.texcoord3.xyz - unity_ShadowFadeCenterAndType.xyz;
                tmp1.x = dot(tmp1.xyz, tmp1.xyz);
                tmp1.x = sqrt(tmp1.x);
                tmp1.yzw = _WorldSpaceCameraPos - inp.texcoord3.xyz;
                tmp2.x = unity_MatrixV._m20;
                tmp2.y = unity_MatrixV._m21;
                tmp2.z = unity_MatrixV._m22;
                tmp1.y = dot(tmp1.xyz, tmp2.xyz);
                tmp1.x = tmp1.x - tmp1.y;
                tmp1.x = unity_ShadowFadeCenterAndType.w * tmp1.x + tmp1.y;
                tmp1.x = saturate(tmp1.x * _LightShadowData.z + _LightShadowData.w);
                tmp1.y = tmp1.x < 1.0;
                tmp1.z = tmp1.x >= 1.0;
                tmp1.yz = tmp1.yz ? 1.0 : 0.0;
                tmp1.y = tmp1.z + tmp1.y;
                tmp1.y = tmp1.y > 0.5;
                tmp1.x = tmp1.y ? 0.0 : tmp1.x;
                tmp1.y = tmp1.y ? 1.0 : 0.0;
                tmp1.x = tmp1.x + tmp1.y;
                tmp1.x = tmp1.x * _Opacity;
                tmp1.y = dot(_WorldSpaceLightPos0.xyz, inp.texcoord2.xyz);
                tmp1.y = saturate(tmp1.y * 100.0);
                tmp1.z = tmp1.y * -2.0 + 3.0;
                tmp1.y = tmp1.y * tmp1.y;
                tmp1.y = tmp1.y * tmp1.z;
                tmp1.x = tmp1.x * tmp1.y;
                tmp1.yzw = LightColor.xyz - ShadowColor.xyz;
                tmp1.xyz = tmp1.xxx * tmp1.yzw + ShadowColor.xyz;
                tmp1.xyz = tmp0.xyz * tmp1.xyz;
                tmp0.xyz = tmp1.xyz * _LightColor0.xyz;
                tmp1 = tex2D(_Emission, inp.texcoord.xy);
                o.sv_target = tmp0 + tmp1;
                return o;
			}
#elif defined(DIRECTIONAL) && !defined(LIGHTMAP_ON) && !defined(LIGHTMAP_SHADOW_MIXING) && defined(LIGHTPROBE_SH) && defined(LOD_FADE_CROSSFADE) && defined(SHADOWS_SCREEN) && !defined(SHADOWS_SHADOWMASK) && !defined(VERTEXLIGHT_ON)
			#include "UnityCG.cginc"
#include "AutoLight.cginc"
			struct v2f
			{
 UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float3 texcoord2 : TEXCOORD2;
				float3 texcoord3 : TEXCOORD3;
				float4 texcoord4 : TEXCOORD4;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 ShadowColor;
			float4 LightColor;
			float _Opacity;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			sampler2D _Emission;
			
			// Keywords: LOD_FADE_CROSSFADE DIRECTIONAL LIGHTPROBE_SH SHADOWS_SCREEN
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
                o.texcoord3.xyz = float3(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3]) * v.vertex.www + tmp0.xyz;
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
                o.texcoord2.xyz = tmp1.www * tmp1.xyz;
                tmp1.xyz = tmp0.xyw * float3(0.5, 0.5, 0.5);
                o.texcoord4.zw = tmp0.zw;
                tmp1.w = tmp1.y * _ProjectionParams.x;
                o.texcoord4.xy = tmp1.zz + tmp1.xw;
                return o;
			}
			// Keywords: LOD_FADE_CROSSFADE DIRECTIONAL LIGHTPROBE_SH SHADOWS_SCREEN
			fout frag(v2f inp)
			{
 UNITY_SETUP_INSTANCE_ID(inp);
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = dot(inp.position.xy, float2(0.0671106, 0.0058372));
                tmp0.x = frac(tmp0.x);
                tmp0.x = tmp0.x * 52.98292;
                tmp0.x = frac(tmp0.x);
                tmp0.x = unity_LODFade.x - tmp0.x;
                tmp0.x = tmp0.x < 0.0;
                if (tmp0.x) {
                    discard;
                }
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1.x = tmp0.w - 0.5;
                tmp1.x = tmp1.x < 0.0;
                if (tmp1.x) {
                    discard;
                }
                tmp1.xyz = inp.texcoord3.xyz - unity_ShadowFadeCenterAndType.xyz;
                tmp1.x = dot(tmp1.xyz, tmp1.xyz);
                tmp1.x = sqrt(tmp1.x);
                tmp1.yzw = _WorldSpaceCameraPos - inp.texcoord3.xyz;
                tmp2.x = unity_MatrixV._m20;
                tmp2.y = unity_MatrixV._m21;
                tmp2.z = unity_MatrixV._m22;
                tmp1.y = dot(tmp1.xyz, tmp2.xyz);
                tmp1.x = tmp1.x - tmp1.y;
                tmp1.x = unity_ShadowFadeCenterAndType.w * tmp1.x + tmp1.y;
                tmp1.x = saturate(tmp1.x * _LightShadowData.z + _LightShadowData.w);
                tmp1.y = tmp1.x < 1.0;
                tmp1.z = tmp1.x >= 1.0;
                tmp1.yz = tmp1.yz ? 1.0 : 0.0;
                tmp2.xy = inp.texcoord4.xy / inp.texcoord4.ww;
                tmp2 = tex2D(_ShadowMapTexture, tmp2.xy);
                tmp1.y = tmp1.y * tmp2.x + tmp1.z;
                tmp1.y = tmp1.y > 0.5;
                tmp1.x = tmp1.y ? 0.0 : tmp1.x;
                tmp1.y = tmp1.y ? 1.0 : 0.0;
                tmp1.x = tmp1.x + tmp1.y;
                tmp1.x = tmp1.x * _Opacity;
                tmp1.y = dot(_WorldSpaceLightPos0.xyz, inp.texcoord2.xyz);
                tmp1.y = saturate(tmp1.y * 100.0);
                tmp1.z = tmp1.y * -2.0 + 3.0;
                tmp1.y = tmp1.y * tmp1.y;
                tmp1.y = tmp1.y * tmp1.z;
                tmp1.x = tmp1.x * tmp1.y;
                tmp1.yzw = LightColor.xyz - ShadowColor.xyz;
                tmp1.xyz = tmp1.xxx * tmp1.yzw + ShadowColor.xyz;
                tmp1.xyz = tmp0.xyz * tmp1.xyz;
                tmp0.xyz = tmp1.xyz * _LightColor0.xyz;
                tmp1 = tex2D(_Emission, inp.texcoord.xy);
                o.sv_target = tmp0 + tmp1;
                return o;
			}
#elif defined(DIRECTIONAL) && defined(LIGHTMAP_ON) && !defined(LIGHTMAP_SHADOW_MIXING) && !defined(LIGHTPROBE_SH) && defined(LOD_FADE_CROSSFADE) && defined(SHADOWS_SCREEN) && !defined(SHADOWS_SHADOWMASK) && !defined(VERTEXLIGHT_ON)
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
				float4 texcoord4 : TEXCOORD4;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 ShadowColor;
			float4 LightColor;
			float _Opacity;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			sampler2D _Emission;
			
			// Keywords: LOD_FADE_CROSSFADE DIRECTIONAL LIGHTMAP_ON SHADOWS_SCREEN
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
                o.texcoord3.xyz = float3(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3]) * v.vertex.www + tmp0.xyz;
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
                o.texcoord2.xyz = tmp1.www * tmp1.xyz;
                tmp1.xyz = tmp0.xyw * float3(0.5, 0.5, 0.5);
                o.texcoord4.zw = tmp0.zw;
                tmp1.w = tmp1.y * _ProjectionParams.x;
                o.texcoord4.xy = tmp1.zz + tmp1.xw;
                return o;
			}
			// Keywords: LOD_FADE_CROSSFADE DIRECTIONAL LIGHTMAP_ON SHADOWS_SCREEN
			fout frag(v2f inp)
			{
 UNITY_SETUP_INSTANCE_ID(inp);
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = dot(inp.position.xy, float2(0.0671106, 0.0058372));
                tmp0.x = frac(tmp0.x);
                tmp0.x = tmp0.x * 52.98292;
                tmp0.x = frac(tmp0.x);
                tmp0.x = unity_LODFade.x - tmp0.x;
                tmp0.x = tmp0.x < 0.0;
                if (tmp0.x) {
                    discard;
                }
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1.x = tmp0.w - 0.5;
                tmp1.x = tmp1.x < 0.0;
                if (tmp1.x) {
                    discard;
                }
                tmp1.xyz = inp.texcoord3.xyz - unity_ShadowFadeCenterAndType.xyz;
                tmp1.x = dot(tmp1.xyz, tmp1.xyz);
                tmp1.x = sqrt(tmp1.x);
                tmp1.yzw = _WorldSpaceCameraPos - inp.texcoord3.xyz;
                tmp2.x = unity_MatrixV._m20;
                tmp2.y = unity_MatrixV._m21;
                tmp2.z = unity_MatrixV._m22;
                tmp1.y = dot(tmp1.xyz, tmp2.xyz);
                tmp1.x = tmp1.x - tmp1.y;
                tmp1.x = unity_ShadowFadeCenterAndType.w * tmp1.x + tmp1.y;
                tmp1.x = saturate(tmp1.x * _LightShadowData.z + _LightShadowData.w);
                tmp1.y = tmp1.x < 1.0;
                tmp1.z = tmp1.x >= 1.0;
                tmp1.yz = tmp1.yz ? 1.0 : 0.0;
                tmp2.xy = inp.texcoord4.xy / inp.texcoord4.ww;
                tmp2 = tex2D(_ShadowMapTexture, tmp2.xy);
                tmp1.y = tmp1.y * tmp2.x + tmp1.z;
                tmp1.y = tmp1.y > 0.5;
                tmp1.x = tmp1.y ? 0.0 : tmp1.x;
                tmp1.y = tmp1.y ? 1.0 : 0.0;
                tmp1.x = tmp1.x + tmp1.y;
                tmp1.x = tmp1.x * _Opacity;
                tmp1.y = dot(_WorldSpaceLightPos0.xyz, inp.texcoord2.xyz);
                tmp1.y = saturate(tmp1.y * 100.0);
                tmp1.z = tmp1.y * -2.0 + 3.0;
                tmp1.y = tmp1.y * tmp1.y;
                tmp1.y = tmp1.y * tmp1.z;
                tmp1.x = tmp1.x * tmp1.y;
                tmp1.yzw = LightColor.xyz - ShadowColor.xyz;
                tmp1.xyz = tmp1.xxx * tmp1.yzw + ShadowColor.xyz;
                tmp1.xyz = tmp0.xyz * tmp1.xyz;
                tmp0.xyz = tmp1.xyz * _LightColor0.xyz;
                tmp1 = tex2D(_Emission, inp.texcoord.xy);
                o.sv_target = tmp0 + tmp1;
                return o;
			}
#elif defined(DIRECTIONAL) && !defined(LIGHTMAP_ON) && !defined(LIGHTMAP_SHADOW_MIXING) && defined(LIGHTPROBE_SH) && defined(LOD_FADE_CROSSFADE) && !defined(SHADOWS_SCREEN) && !defined(SHADOWS_SHADOWMASK) && defined(VERTEXLIGHT_ON)
			#include "UnityCG.cginc"
#include "AutoLight.cginc"
			struct v2f
			{
 UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float3 texcoord2 : TEXCOORD2;
				float3 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 ShadowColor;
			float4 LightColor;
			float _Opacity;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			sampler2D _Emission;
			
			// Keywords: LOD_FADE_CROSSFADE DIRECTIONAL LIGHTPROBE_SH VERTEXLIGHT_ON
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
                o.texcoord3.xyz = float3(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3]) * v.vertex.www + tmp0.xyz;
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
                o.texcoord2.xyz = tmp0.www * tmp0.xyz;
                return o;
			}
			// Keywords: LOD_FADE_CROSSFADE DIRECTIONAL LIGHTPROBE_SH
			fout frag(v2f inp)
			{
 UNITY_SETUP_INSTANCE_ID(inp);
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = dot(inp.position.xy, float2(0.0671106, 0.0058372));
                tmp0.x = frac(tmp0.x);
                tmp0.x = tmp0.x * 52.98292;
                tmp0.x = frac(tmp0.x);
                tmp0.x = unity_LODFade.x - tmp0.x;
                tmp0.x = tmp0.x < 0.0;
                if (tmp0.x) {
                    discard;
                }
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1.x = tmp0.w - 0.5;
                tmp1.x = tmp1.x < 0.0;
                if (tmp1.x) {
                    discard;
                }
                tmp1.xyz = inp.texcoord3.xyz - unity_ShadowFadeCenterAndType.xyz;
                tmp1.x = dot(tmp1.xyz, tmp1.xyz);
                tmp1.x = sqrt(tmp1.x);
                tmp1.yzw = _WorldSpaceCameraPos - inp.texcoord3.xyz;
                tmp2.x = unity_MatrixV._m20;
                tmp2.y = unity_MatrixV._m21;
                tmp2.z = unity_MatrixV._m22;
                tmp1.y = dot(tmp1.xyz, tmp2.xyz);
                tmp1.x = tmp1.x - tmp1.y;
                tmp1.x = unity_ShadowFadeCenterAndType.w * tmp1.x + tmp1.y;
                tmp1.x = saturate(tmp1.x * _LightShadowData.z + _LightShadowData.w);
                tmp1.y = tmp1.x < 1.0;
                tmp1.z = tmp1.x >= 1.0;
                tmp1.yz = tmp1.yz ? 1.0 : 0.0;
                tmp1.y = tmp1.z + tmp1.y;
                tmp1.y = tmp1.y > 0.5;
                tmp1.x = tmp1.y ? 0.0 : tmp1.x;
                tmp1.y = tmp1.y ? 1.0 : 0.0;
                tmp1.x = tmp1.x + tmp1.y;
                tmp1.x = tmp1.x * _Opacity;
                tmp1.y = dot(_WorldSpaceLightPos0.xyz, inp.texcoord2.xyz);
                tmp1.y = saturate(tmp1.y * 100.0);
                tmp1.z = tmp1.y * -2.0 + 3.0;
                tmp1.y = tmp1.y * tmp1.y;
                tmp1.y = tmp1.y * tmp1.z;
                tmp1.x = tmp1.x * tmp1.y;
                tmp1.yzw = LightColor.xyz - ShadowColor.xyz;
                tmp1.xyz = tmp1.xxx * tmp1.yzw + ShadowColor.xyz;
                tmp1.xyz = tmp0.xyz * tmp1.xyz;
                tmp0.xyz = tmp1.xyz * _LightColor0.xyz;
                tmp1 = tex2D(_Emission, inp.texcoord.xy);
                o.sv_target = tmp0 + tmp1;
                return o;
			}
#elif defined(DIRECTIONAL) && !defined(LIGHTMAP_ON) && !defined(LIGHTMAP_SHADOW_MIXING) && !defined(LIGHTPROBE_SH) && defined(LOD_FADE_CROSSFADE) && defined(SHADOWS_SCREEN) && !defined(SHADOWS_SHADOWMASK) && defined(VERTEXLIGHT_ON)
			#include "UnityCG.cginc"
#include "AutoLight.cginc"
			struct v2f
			{
 UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float3 texcoord2 : TEXCOORD2;
				float3 texcoord3 : TEXCOORD3;
				float4 texcoord4 : TEXCOORD4;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 ShadowColor;
			float4 LightColor;
			float _Opacity;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			sampler2D _Emission;
			
			// Keywords: LOD_FADE_CROSSFADE DIRECTIONAL SHADOWS_SCREEN VERTEXLIGHT_ON
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
                o.texcoord3.xyz = float3(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3]) * v.vertex.www + tmp0.xyz;
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
                o.texcoord2.xyz = tmp1.www * tmp1.xyz;
                tmp1.xyz = tmp0.xyw * float3(0.5, 0.5, 0.5);
                o.texcoord4.zw = tmp0.zw;
                tmp1.w = tmp1.y * _ProjectionParams.x;
                o.texcoord4.xy = tmp1.zz + tmp1.xw;
                return o;
			}
			// Keywords: LOD_FADE_CROSSFADE DIRECTIONAL SHADOWS_SCREEN
			fout frag(v2f inp)
			{
 UNITY_SETUP_INSTANCE_ID(inp);
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = dot(inp.position.xy, float2(0.0671106, 0.0058372));
                tmp0.x = frac(tmp0.x);
                tmp0.x = tmp0.x * 52.98292;
                tmp0.x = frac(tmp0.x);
                tmp0.x = unity_LODFade.x - tmp0.x;
                tmp0.x = tmp0.x < 0.0;
                if (tmp0.x) {
                    discard;
                }
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1.x = tmp0.w - 0.5;
                tmp1.x = tmp1.x < 0.0;
                if (tmp1.x) {
                    discard;
                }
                tmp1.xyz = inp.texcoord3.xyz - unity_ShadowFadeCenterAndType.xyz;
                tmp1.x = dot(tmp1.xyz, tmp1.xyz);
                tmp1.x = sqrt(tmp1.x);
                tmp1.yzw = _WorldSpaceCameraPos - inp.texcoord3.xyz;
                tmp2.x = unity_MatrixV._m20;
                tmp2.y = unity_MatrixV._m21;
                tmp2.z = unity_MatrixV._m22;
                tmp1.y = dot(tmp1.xyz, tmp2.xyz);
                tmp1.x = tmp1.x - tmp1.y;
                tmp1.x = unity_ShadowFadeCenterAndType.w * tmp1.x + tmp1.y;
                tmp1.x = saturate(tmp1.x * _LightShadowData.z + _LightShadowData.w);
                tmp1.y = tmp1.x < 1.0;
                tmp1.z = tmp1.x >= 1.0;
                tmp1.yz = tmp1.yz ? 1.0 : 0.0;
                tmp2.xy = inp.texcoord4.xy / inp.texcoord4.ww;
                tmp2 = tex2D(_ShadowMapTexture, tmp2.xy);
                tmp1.y = tmp1.y * tmp2.x + tmp1.z;
                tmp1.y = tmp1.y > 0.5;
                tmp1.x = tmp1.y ? 0.0 : tmp1.x;
                tmp1.y = tmp1.y ? 1.0 : 0.0;
                tmp1.x = tmp1.x + tmp1.y;
                tmp1.x = tmp1.x * _Opacity;
                tmp1.y = dot(_WorldSpaceLightPos0.xyz, inp.texcoord2.xyz);
                tmp1.y = saturate(tmp1.y * 100.0);
                tmp1.z = tmp1.y * -2.0 + 3.0;
                tmp1.y = tmp1.y * tmp1.y;
                tmp1.y = tmp1.y * tmp1.z;
                tmp1.x = tmp1.x * tmp1.y;
                tmp1.yzw = LightColor.xyz - ShadowColor.xyz;
                tmp1.xyz = tmp1.xxx * tmp1.yzw + ShadowColor.xyz;
                tmp1.xyz = tmp0.xyz * tmp1.xyz;
                tmp0.xyz = tmp1.xyz * _LightColor0.xyz;
                tmp1 = tex2D(_Emission, inp.texcoord.xy);
                o.sv_target = tmp0 + tmp1;
                return o;
			}
#elif defined(DIRECTIONAL) && !defined(LIGHTMAP_ON) && !defined(LIGHTMAP_SHADOW_MIXING) && defined(LIGHTPROBE_SH) && !defined(LOD_FADE_CROSSFADE) && !defined(SHADOWS_SCREEN) && defined(SHADOWS_SHADOWMASK) && !defined(VERTEXLIGHT_ON)
			#include "UnityCG.cginc"
#include "AutoLight.cginc"
			struct v2f
			{
 UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float3 texcoord2 : TEXCOORD2;
				float3 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 ShadowColor;
			float4 LightColor;
			float _Opacity;
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
                tmp0 = v.vertex.yyyy * float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
                tmp0 = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]) * v.vertex.xxxx + tmp0;
                tmp0 = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]) * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
                o.texcoord3.xyz = float3(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3]) * v.vertex.www + tmp0.xyz;
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
                o.texcoord2.xyz = tmp0.www * tmp0.xyz;
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
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1.x = tmp0.w - 0.5;
                tmp1.x = tmp1.x < 0.0;
                if (tmp1.x) {
                    discard;
                }
                tmp1.xyz = inp.texcoord3.xyz - unity_ShadowFadeCenterAndType.xyz;
                tmp1.x = dot(tmp1.xyz, tmp1.xyz);
                tmp1.x = sqrt(tmp1.x);
                tmp1.yzw = _WorldSpaceCameraPos - inp.texcoord3.xyz;
                tmp2.x = unity_MatrixV._m20;
                tmp2.y = unity_MatrixV._m21;
                tmp2.z = unity_MatrixV._m22;
                tmp1.y = dot(tmp1.xyz, tmp2.xyz);
                tmp1.x = tmp1.x - tmp1.y;
                tmp1.x = unity_ShadowFadeCenterAndType.w * tmp1.x + tmp1.y;
                tmp1.x = saturate(tmp1.x * _LightShadowData.z + _LightShadowData.w);
                tmp1.y = tmp1.x < 1.0;
                tmp1.z = tmp1.x >= 1.0;
                tmp1.yz = tmp1.yz ? 1.0 : 0.0;
                tmp1.y = tmp1.z + tmp1.y;
                tmp1.y = tmp1.y > 0.5;
                tmp1.x = tmp1.y ? 0.0 : tmp1.x;
                tmp1.y = tmp1.y ? 1.0 : 0.0;
                tmp1.x = tmp1.x + tmp1.y;
                tmp1.x = tmp1.x * _Opacity;
                tmp1.y = dot(_WorldSpaceLightPos0.xyz, inp.texcoord2.xyz);
                tmp1.y = saturate(tmp1.y * 100.0);
                tmp1.z = tmp1.y * -2.0 + 3.0;
                tmp1.y = tmp1.y * tmp1.y;
                tmp1.y = tmp1.y * tmp1.z;
                tmp1.x = tmp1.x * tmp1.y;
                tmp1.yzw = LightColor.xyz - ShadowColor.xyz;
                tmp1.xyz = tmp1.xxx * tmp1.yzw + ShadowColor.xyz;
                tmp1.xyz = tmp0.xyz * tmp1.xyz;
                tmp0.xyz = tmp1.xyz * _LightColor0.xyz;
                tmp1 = tex2D(_Emission, inp.texcoord.xy);
                o.sv_target = tmp0 + tmp1;
                return o;
			}
#elif defined(DIRECTIONAL) && defined(LIGHTMAP_ON) && !defined(LIGHTMAP_SHADOW_MIXING) && defined(LIGHTPROBE_SH) && !defined(LOD_FADE_CROSSFADE) && !defined(SHADOWS_SCREEN) && !defined(SHADOWS_SHADOWMASK) && !defined(VERTEXLIGHT_ON)
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
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 ShadowColor;
			float4 LightColor;
			float _Opacity;
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
                tmp0 = v.vertex.yyyy * float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
                tmp0 = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]) * v.vertex.xxxx + tmp0;
                tmp0 = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]) * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
                o.texcoord3.xyz = float3(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3]) * v.vertex.www + tmp0.xyz;
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
                o.texcoord2.xyz = tmp0.www * tmp0.xyz;
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
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1.x = tmp0.w - 0.5;
                tmp1.x = tmp1.x < 0.0;
                if (tmp1.x) {
                    discard;
                }
                tmp1.xyz = inp.texcoord3.xyz - unity_ShadowFadeCenterAndType.xyz;
                tmp1.x = dot(tmp1.xyz, tmp1.xyz);
                tmp1.x = sqrt(tmp1.x);
                tmp1.yzw = _WorldSpaceCameraPos - inp.texcoord3.xyz;
                tmp2.x = unity_MatrixV._m20;
                tmp2.y = unity_MatrixV._m21;
                tmp2.z = unity_MatrixV._m22;
                tmp1.y = dot(tmp1.xyz, tmp2.xyz);
                tmp1.x = tmp1.x - tmp1.y;
                tmp1.x = unity_ShadowFadeCenterAndType.w * tmp1.x + tmp1.y;
                tmp1.x = saturate(tmp1.x * _LightShadowData.z + _LightShadowData.w);
                tmp1.y = tmp1.x < 1.0;
                tmp1.z = tmp1.x >= 1.0;
                tmp1.yz = tmp1.yz ? 1.0 : 0.0;
                tmp1.y = tmp1.z + tmp1.y;
                tmp1.y = tmp1.y > 0.5;
                tmp1.x = tmp1.y ? 0.0 : tmp1.x;
                tmp1.y = tmp1.y ? 1.0 : 0.0;
                tmp1.x = tmp1.x + tmp1.y;
                tmp1.x = tmp1.x * _Opacity;
                tmp1.y = dot(_WorldSpaceLightPos0.xyz, inp.texcoord2.xyz);
                tmp1.y = saturate(tmp1.y * 100.0);
                tmp1.z = tmp1.y * -2.0 + 3.0;
                tmp1.y = tmp1.y * tmp1.y;
                tmp1.y = tmp1.y * tmp1.z;
                tmp1.x = tmp1.x * tmp1.y;
                tmp1.yzw = LightColor.xyz - ShadowColor.xyz;
                tmp1.xyz = tmp1.xxx * tmp1.yzw + ShadowColor.xyz;
                tmp1.xyz = tmp0.xyz * tmp1.xyz;
                tmp0.xyz = tmp1.xyz * _LightColor0.xyz;
                tmp1 = tex2D(_Emission, inp.texcoord.xy);
                o.sv_target = tmp0 + tmp1;
                return o;
			}
#elif defined(DIRECTIONAL) && defined(LIGHTMAP_ON) && defined(LIGHTMAP_SHADOW_MIXING) && !defined(LIGHTPROBE_SH) && !defined(LOD_FADE_CROSSFADE) && !defined(SHADOWS_SCREEN) && !defined(SHADOWS_SHADOWMASK) && !defined(VERTEXLIGHT_ON)
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
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 ShadowColor;
			float4 LightColor;
			float _Opacity;
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
                tmp0 = v.vertex.yyyy * float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
                tmp0 = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]) * v.vertex.xxxx + tmp0;
                tmp0 = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]) * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
                o.texcoord3.xyz = float3(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3]) * v.vertex.www + tmp0.xyz;
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
                o.texcoord2.xyz = tmp0.www * tmp0.xyz;
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
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1.x = tmp0.w - 0.5;
                tmp1.x = tmp1.x < 0.0;
                if (tmp1.x) {
                    discard;
                }
                tmp1.xyz = inp.texcoord3.xyz - unity_ShadowFadeCenterAndType.xyz;
                tmp1.x = dot(tmp1.xyz, tmp1.xyz);
                tmp1.x = sqrt(tmp1.x);
                tmp1.yzw = _WorldSpaceCameraPos - inp.texcoord3.xyz;
                tmp2.x = unity_MatrixV._m20;
                tmp2.y = unity_MatrixV._m21;
                tmp2.z = unity_MatrixV._m22;
                tmp1.y = dot(tmp1.xyz, tmp2.xyz);
                tmp1.x = tmp1.x - tmp1.y;
                tmp1.x = unity_ShadowFadeCenterAndType.w * tmp1.x + tmp1.y;
                tmp1.x = saturate(tmp1.x * _LightShadowData.z + _LightShadowData.w);
                tmp1.y = tmp1.x < 1.0;
                tmp1.z = tmp1.x >= 1.0;
                tmp1.yz = tmp1.yz ? 1.0 : 0.0;
                tmp1.y = tmp1.z + tmp1.y;
                tmp1.y = tmp1.y > 0.5;
                tmp1.x = tmp1.y ? 0.0 : tmp1.x;
                tmp1.y = tmp1.y ? 1.0 : 0.0;
                tmp1.x = tmp1.x + tmp1.y;
                tmp1.x = tmp1.x * _Opacity;
                tmp1.y = dot(_WorldSpaceLightPos0.xyz, inp.texcoord2.xyz);
                tmp1.y = saturate(tmp1.y * 100.0);
                tmp1.z = tmp1.y * -2.0 + 3.0;
                tmp1.y = tmp1.y * tmp1.y;
                tmp1.y = tmp1.y * tmp1.z;
                tmp1.x = tmp1.x * tmp1.y;
                tmp1.yzw = LightColor.xyz - ShadowColor.xyz;
                tmp1.xyz = tmp1.xxx * tmp1.yzw + ShadowColor.xyz;
                tmp1.xyz = tmp0.xyz * tmp1.xyz;
                tmp0.xyz = tmp1.xyz * _LightColor0.xyz;
                tmp1 = tex2D(_Emission, inp.texcoord.xy);
                o.sv_target = tmp0 + tmp1;
                return o;
			}
#elif defined(DIRECTIONAL) && defined(LIGHTMAP_ON) && !defined(LIGHTMAP_SHADOW_MIXING) && !defined(LIGHTPROBE_SH) && !defined(LOD_FADE_CROSSFADE) && !defined(SHADOWS_SCREEN) && defined(SHADOWS_SHADOWMASK) && !defined(VERTEXLIGHT_ON)
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
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 ShadowColor;
			float4 LightColor;
			float _Opacity;
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
                tmp0 = v.vertex.yyyy * float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
                tmp0 = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]) * v.vertex.xxxx + tmp0;
                tmp0 = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]) * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
                o.texcoord3.xyz = float3(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3]) * v.vertex.www + tmp0.xyz;
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
                o.texcoord2.xyz = tmp0.www * tmp0.xyz;
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
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1.x = tmp0.w - 0.5;
                tmp1.x = tmp1.x < 0.0;
                if (tmp1.x) {
                    discard;
                }
                tmp1.xyz = inp.texcoord3.xyz - unity_ShadowFadeCenterAndType.xyz;
                tmp1.x = dot(tmp1.xyz, tmp1.xyz);
                tmp1.x = sqrt(tmp1.x);
                tmp1.yzw = _WorldSpaceCameraPos - inp.texcoord3.xyz;
                tmp2.x = unity_MatrixV._m20;
                tmp2.y = unity_MatrixV._m21;
                tmp2.z = unity_MatrixV._m22;
                tmp1.y = dot(tmp1.xyz, tmp2.xyz);
                tmp1.x = tmp1.x - tmp1.y;
                tmp1.x = unity_ShadowFadeCenterAndType.w * tmp1.x + tmp1.y;
                tmp1.x = saturate(tmp1.x * _LightShadowData.z + _LightShadowData.w);
                tmp1.y = tmp1.x < 1.0;
                tmp1.z = tmp1.x >= 1.0;
                tmp1.yz = tmp1.yz ? 1.0 : 0.0;
                tmp1.y = tmp1.z + tmp1.y;
                tmp1.y = tmp1.y > 0.5;
                tmp1.x = tmp1.y ? 0.0 : tmp1.x;
                tmp1.y = tmp1.y ? 1.0 : 0.0;
                tmp1.x = tmp1.x + tmp1.y;
                tmp1.x = tmp1.x * _Opacity;
                tmp1.y = dot(_WorldSpaceLightPos0.xyz, inp.texcoord2.xyz);
                tmp1.y = saturate(tmp1.y * 100.0);
                tmp1.z = tmp1.y * -2.0 + 3.0;
                tmp1.y = tmp1.y * tmp1.y;
                tmp1.y = tmp1.y * tmp1.z;
                tmp1.x = tmp1.x * tmp1.y;
                tmp1.yzw = LightColor.xyz - ShadowColor.xyz;
                tmp1.xyz = tmp1.xxx * tmp1.yzw + ShadowColor.xyz;
                tmp1.xyz = tmp0.xyz * tmp1.xyz;
                tmp0.xyz = tmp1.xyz * _LightColor0.xyz;
                tmp1 = tex2D(_Emission, inp.texcoord.xy);
                o.sv_target = tmp0 + tmp1;
                return o;
			}
#elif defined(DIRECTIONAL) && !defined(LIGHTMAP_ON) && !defined(LIGHTMAP_SHADOW_MIXING) && defined(LIGHTPROBE_SH) && !defined(LOD_FADE_CROSSFADE) && defined(SHADOWS_SCREEN) && !defined(SHADOWS_SHADOWMASK) && !defined(VERTEXLIGHT_ON)
			#include "UnityCG.cginc"
#include "AutoLight.cginc"
			struct v2f
			{
 UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float3 texcoord2 : TEXCOORD2;
				float3 texcoord3 : TEXCOORD3;
				float4 texcoord4 : TEXCOORD4;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 ShadowColor;
			float4 LightColor;
			float _Opacity;
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
                tmp0 = v.vertex.yyyy * float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
                tmp0 = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]) * v.vertex.xxxx + tmp0;
                tmp0 = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]) * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
                o.texcoord3.xyz = float3(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3]) * v.vertex.www + tmp0.xyz;
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
                o.texcoord2.xyz = tmp1.www * tmp1.xyz;
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
                float4 tmp2;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1.x = tmp0.w - 0.5;
                tmp1.x = tmp1.x < 0.0;
                if (tmp1.x) {
                    discard;
                }
                tmp1.xyz = inp.texcoord3.xyz - unity_ShadowFadeCenterAndType.xyz;
                tmp1.x = dot(tmp1.xyz, tmp1.xyz);
                tmp1.x = sqrt(tmp1.x);
                tmp1.yzw = _WorldSpaceCameraPos - inp.texcoord3.xyz;
                tmp2.x = unity_MatrixV._m20;
                tmp2.y = unity_MatrixV._m21;
                tmp2.z = unity_MatrixV._m22;
                tmp1.y = dot(tmp1.xyz, tmp2.xyz);
                tmp1.x = tmp1.x - tmp1.y;
                tmp1.x = unity_ShadowFadeCenterAndType.w * tmp1.x + tmp1.y;
                tmp1.x = saturate(tmp1.x * _LightShadowData.z + _LightShadowData.w);
                tmp1.y = tmp1.x < 1.0;
                tmp1.z = tmp1.x >= 1.0;
                tmp1.yz = tmp1.yz ? 1.0 : 0.0;
                tmp2.xy = inp.texcoord4.xy / inp.texcoord4.ww;
                tmp2 = tex2D(_ShadowMapTexture, tmp2.xy);
                tmp1.y = tmp1.y * tmp2.x + tmp1.z;
                tmp1.y = tmp1.y > 0.5;
                tmp1.x = tmp1.y ? 0.0 : tmp1.x;
                tmp1.y = tmp1.y ? 1.0 : 0.0;
                tmp1.x = tmp1.x + tmp1.y;
                tmp1.x = tmp1.x * _Opacity;
                tmp1.y = dot(_WorldSpaceLightPos0.xyz, inp.texcoord2.xyz);
                tmp1.y = saturate(tmp1.y * 100.0);
                tmp1.z = tmp1.y * -2.0 + 3.0;
                tmp1.y = tmp1.y * tmp1.y;
                tmp1.y = tmp1.y * tmp1.z;
                tmp1.x = tmp1.x * tmp1.y;
                tmp1.yzw = LightColor.xyz - ShadowColor.xyz;
                tmp1.xyz = tmp1.xxx * tmp1.yzw + ShadowColor.xyz;
                tmp1.xyz = tmp0.xyz * tmp1.xyz;
                tmp0.xyz = tmp1.xyz * _LightColor0.xyz;
                tmp1 = tex2D(_Emission, inp.texcoord.xy);
                o.sv_target = tmp0 + tmp1;
                return o;
			}
#elif defined(DIRECTIONAL) && defined(LIGHTMAP_ON) && !defined(LIGHTMAP_SHADOW_MIXING) && !defined(LIGHTPROBE_SH) && !defined(LOD_FADE_CROSSFADE) && defined(SHADOWS_SCREEN) && !defined(SHADOWS_SHADOWMASK) && !defined(VERTEXLIGHT_ON)
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
				float4 texcoord4 : TEXCOORD4;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 ShadowColor;
			float4 LightColor;
			float _Opacity;
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
                tmp0 = v.vertex.yyyy * float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
                tmp0 = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]) * v.vertex.xxxx + tmp0;
                tmp0 = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]) * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
                o.texcoord3.xyz = float3(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3]) * v.vertex.www + tmp0.xyz;
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
                o.texcoord2.xyz = tmp1.www * tmp1.xyz;
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
                float4 tmp2;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1.x = tmp0.w - 0.5;
                tmp1.x = tmp1.x < 0.0;
                if (tmp1.x) {
                    discard;
                }
                tmp1.xyz = inp.texcoord3.xyz - unity_ShadowFadeCenterAndType.xyz;
                tmp1.x = dot(tmp1.xyz, tmp1.xyz);
                tmp1.x = sqrt(tmp1.x);
                tmp1.yzw = _WorldSpaceCameraPos - inp.texcoord3.xyz;
                tmp2.x = unity_MatrixV._m20;
                tmp2.y = unity_MatrixV._m21;
                tmp2.z = unity_MatrixV._m22;
                tmp1.y = dot(tmp1.xyz, tmp2.xyz);
                tmp1.x = tmp1.x - tmp1.y;
                tmp1.x = unity_ShadowFadeCenterAndType.w * tmp1.x + tmp1.y;
                tmp1.x = saturate(tmp1.x * _LightShadowData.z + _LightShadowData.w);
                tmp1.y = tmp1.x < 1.0;
                tmp1.z = tmp1.x >= 1.0;
                tmp1.yz = tmp1.yz ? 1.0 : 0.0;
                tmp2.xy = inp.texcoord4.xy / inp.texcoord4.ww;
                tmp2 = tex2D(_ShadowMapTexture, tmp2.xy);
                tmp1.y = tmp1.y * tmp2.x + tmp1.z;
                tmp1.y = tmp1.y > 0.5;
                tmp1.x = tmp1.y ? 0.0 : tmp1.x;
                tmp1.y = tmp1.y ? 1.0 : 0.0;
                tmp1.x = tmp1.x + tmp1.y;
                tmp1.x = tmp1.x * _Opacity;
                tmp1.y = dot(_WorldSpaceLightPos0.xyz, inp.texcoord2.xyz);
                tmp1.y = saturate(tmp1.y * 100.0);
                tmp1.z = tmp1.y * -2.0 + 3.0;
                tmp1.y = tmp1.y * tmp1.y;
                tmp1.y = tmp1.y * tmp1.z;
                tmp1.x = tmp1.x * tmp1.y;
                tmp1.yzw = LightColor.xyz - ShadowColor.xyz;
                tmp1.xyz = tmp1.xxx * tmp1.yzw + ShadowColor.xyz;
                tmp1.xyz = tmp0.xyz * tmp1.xyz;
                tmp0.xyz = tmp1.xyz * _LightColor0.xyz;
                tmp1 = tex2D(_Emission, inp.texcoord.xy);
                o.sv_target = tmp0 + tmp1;
                return o;
			}
#elif defined(DIRECTIONAL) && !defined(LIGHTMAP_ON) && !defined(LIGHTMAP_SHADOW_MIXING) && defined(LIGHTPROBE_SH) && !defined(LOD_FADE_CROSSFADE) && !defined(SHADOWS_SCREEN) && !defined(SHADOWS_SHADOWMASK) && defined(VERTEXLIGHT_ON)
			#include "UnityCG.cginc"
#include "AutoLight.cginc"
			struct v2f
			{
 UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float3 texcoord2 : TEXCOORD2;
				float3 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 ShadowColor;
			float4 LightColor;
			float _Opacity;
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
                tmp0 = v.vertex.yyyy * float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
                tmp0 = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]) * v.vertex.xxxx + tmp0;
                tmp0 = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]) * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
                o.texcoord3.xyz = float3(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3]) * v.vertex.www + tmp0.xyz;
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
                o.texcoord2.xyz = tmp0.www * tmp0.xyz;
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
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1.x = tmp0.w - 0.5;
                tmp1.x = tmp1.x < 0.0;
                if (tmp1.x) {
                    discard;
                }
                tmp1.xyz = inp.texcoord3.xyz - unity_ShadowFadeCenterAndType.xyz;
                tmp1.x = dot(tmp1.xyz, tmp1.xyz);
                tmp1.x = sqrt(tmp1.x);
                tmp1.yzw = _WorldSpaceCameraPos - inp.texcoord3.xyz;
                tmp2.x = unity_MatrixV._m20;
                tmp2.y = unity_MatrixV._m21;
                tmp2.z = unity_MatrixV._m22;
                tmp1.y = dot(tmp1.xyz, tmp2.xyz);
                tmp1.x = tmp1.x - tmp1.y;
                tmp1.x = unity_ShadowFadeCenterAndType.w * tmp1.x + tmp1.y;
                tmp1.x = saturate(tmp1.x * _LightShadowData.z + _LightShadowData.w);
                tmp1.y = tmp1.x < 1.0;
                tmp1.z = tmp1.x >= 1.0;
                tmp1.yz = tmp1.yz ? 1.0 : 0.0;
                tmp1.y = tmp1.z + tmp1.y;
                tmp1.y = tmp1.y > 0.5;
                tmp1.x = tmp1.y ? 0.0 : tmp1.x;
                tmp1.y = tmp1.y ? 1.0 : 0.0;
                tmp1.x = tmp1.x + tmp1.y;
                tmp1.x = tmp1.x * _Opacity;
                tmp1.y = dot(_WorldSpaceLightPos0.xyz, inp.texcoord2.xyz);
                tmp1.y = saturate(tmp1.y * 100.0);
                tmp1.z = tmp1.y * -2.0 + 3.0;
                tmp1.y = tmp1.y * tmp1.y;
                tmp1.y = tmp1.y * tmp1.z;
                tmp1.x = tmp1.x * tmp1.y;
                tmp1.yzw = LightColor.xyz - ShadowColor.xyz;
                tmp1.xyz = tmp1.xxx * tmp1.yzw + ShadowColor.xyz;
                tmp1.xyz = tmp0.xyz * tmp1.xyz;
                tmp0.xyz = tmp1.xyz * _LightColor0.xyz;
                tmp1 = tex2D(_Emission, inp.texcoord.xy);
                o.sv_target = tmp0 + tmp1;
                return o;
			}
#elif defined(DIRECTIONAL) && !defined(LIGHTMAP_ON) && !defined(LIGHTMAP_SHADOW_MIXING) && !defined(LIGHTPROBE_SH) && !defined(LOD_FADE_CROSSFADE) && defined(SHADOWS_SCREEN) && !defined(SHADOWS_SHADOWMASK) && defined(VERTEXLIGHT_ON)
			#include "UnityCG.cginc"
#include "AutoLight.cginc"
			struct v2f
			{
 UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float3 texcoord2 : TEXCOORD2;
				float3 texcoord3 : TEXCOORD3;
				float4 texcoord4 : TEXCOORD4;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 ShadowColor;
			float4 LightColor;
			float _Opacity;
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
                tmp0 = v.vertex.yyyy * float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
                tmp0 = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]) * v.vertex.xxxx + tmp0;
                tmp0 = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]) * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
                o.texcoord3.xyz = float3(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3]) * v.vertex.www + tmp0.xyz;
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
                o.texcoord2.xyz = tmp1.www * tmp1.xyz;
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
                float4 tmp2;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1.x = tmp0.w - 0.5;
                tmp1.x = tmp1.x < 0.0;
                if (tmp1.x) {
                    discard;
                }
                tmp1.xyz = inp.texcoord3.xyz - unity_ShadowFadeCenterAndType.xyz;
                tmp1.x = dot(tmp1.xyz, tmp1.xyz);
                tmp1.x = sqrt(tmp1.x);
                tmp1.yzw = _WorldSpaceCameraPos - inp.texcoord3.xyz;
                tmp2.x = unity_MatrixV._m20;
                tmp2.y = unity_MatrixV._m21;
                tmp2.z = unity_MatrixV._m22;
                tmp1.y = dot(tmp1.xyz, tmp2.xyz);
                tmp1.x = tmp1.x - tmp1.y;
                tmp1.x = unity_ShadowFadeCenterAndType.w * tmp1.x + tmp1.y;
                tmp1.x = saturate(tmp1.x * _LightShadowData.z + _LightShadowData.w);
                tmp1.y = tmp1.x < 1.0;
                tmp1.z = tmp1.x >= 1.0;
                tmp1.yz = tmp1.yz ? 1.0 : 0.0;
                tmp2.xy = inp.texcoord4.xy / inp.texcoord4.ww;
                tmp2 = tex2D(_ShadowMapTexture, tmp2.xy);
                tmp1.y = tmp1.y * tmp2.x + tmp1.z;
                tmp1.y = tmp1.y > 0.5;
                tmp1.x = tmp1.y ? 0.0 : tmp1.x;
                tmp1.y = tmp1.y ? 1.0 : 0.0;
                tmp1.x = tmp1.x + tmp1.y;
                tmp1.x = tmp1.x * _Opacity;
                tmp1.y = dot(_WorldSpaceLightPos0.xyz, inp.texcoord2.xyz);
                tmp1.y = saturate(tmp1.y * 100.0);
                tmp1.z = tmp1.y * -2.0 + 3.0;
                tmp1.y = tmp1.y * tmp1.y;
                tmp1.y = tmp1.y * tmp1.z;
                tmp1.x = tmp1.x * tmp1.y;
                tmp1.yzw = LightColor.xyz - ShadowColor.xyz;
                tmp1.xyz = tmp1.xxx * tmp1.yzw + ShadowColor.xyz;
                tmp1.xyz = tmp0.xyz * tmp1.xyz;
                tmp0.xyz = tmp1.xyz * _LightColor0.xyz;
                tmp1 = tex2D(_Emission, inp.texcoord.xy);
                o.sv_target = tmp0 + tmp1;
                return o;
			}
#elif defined(DIRECTIONAL) && !defined(LIGHTMAP_ON) && !defined(LIGHTMAP_SHADOW_MIXING) && defined(LIGHTPROBE_SH) && defined(LOD_FADE_CROSSFADE) && !defined(SHADOWS_SCREEN) && !defined(SHADOWS_SHADOWMASK) && !defined(VERTEXLIGHT_ON)
			#include "UnityCG.cginc"
#include "AutoLight.cginc"
			struct v2f
			{
 UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float3 texcoord2 : TEXCOORD2;
				float3 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 ShadowColor;
			float4 LightColor;
			float _Opacity;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			sampler2D _Emission;
			
			// Keywords: LOD_FADE_CROSSFADE DIRECTIONAL LIGHTPROBE_SH
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
                o.texcoord3.xyz = float3(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3]) * v.vertex.www + tmp0.xyz;
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
                o.texcoord2.xyz = tmp0.www * tmp0.xyz;
                return o;
			}
			// Keywords: LOD_FADE_CROSSFADE DIRECTIONAL LIGHTPROBE_SH
			fout frag(v2f inp)
			{
 UNITY_SETUP_INSTANCE_ID(inp);
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = dot(inp.position.xy, float2(0.0671106, 0.0058372));
                tmp0.x = frac(tmp0.x);
                tmp0.x = tmp0.x * 52.98292;
                tmp0.x = frac(tmp0.x);
                tmp0.x = unity_LODFade.x - tmp0.x;
                tmp0.x = tmp0.x < 0.0;
                if (tmp0.x) {
                    discard;
                }
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1.x = tmp0.w - 0.5;
                tmp1.x = tmp1.x < 0.0;
                if (tmp1.x) {
                    discard;
                }
                tmp1.xyz = inp.texcoord3.xyz - unity_ShadowFadeCenterAndType.xyz;
                tmp1.x = dot(tmp1.xyz, tmp1.xyz);
                tmp1.x = sqrt(tmp1.x);
                tmp1.yzw = _WorldSpaceCameraPos - inp.texcoord3.xyz;
                tmp2.x = unity_MatrixV._m20;
                tmp2.y = unity_MatrixV._m21;
                tmp2.z = unity_MatrixV._m22;
                tmp1.y = dot(tmp1.xyz, tmp2.xyz);
                tmp1.x = tmp1.x - tmp1.y;
                tmp1.x = unity_ShadowFadeCenterAndType.w * tmp1.x + tmp1.y;
                tmp1.x = saturate(tmp1.x * _LightShadowData.z + _LightShadowData.w);
                tmp1.y = tmp1.x < 1.0;
                tmp1.z = tmp1.x >= 1.0;
                tmp1.yz = tmp1.yz ? 1.0 : 0.0;
                tmp1.y = tmp1.z + tmp1.y;
                tmp1.y = tmp1.y > 0.5;
                tmp1.x = tmp1.y ? 0.0 : tmp1.x;
                tmp1.y = tmp1.y ? 1.0 : 0.0;
                tmp1.x = tmp1.x + tmp1.y;
                tmp1.x = tmp1.x * _Opacity;
                tmp1.y = dot(_WorldSpaceLightPos0.xyz, inp.texcoord2.xyz);
                tmp1.y = saturate(tmp1.y * 100.0);
                tmp1.z = tmp1.y * -2.0 + 3.0;
                tmp1.y = tmp1.y * tmp1.y;
                tmp1.y = tmp1.y * tmp1.z;
                tmp1.x = tmp1.x * tmp1.y;
                tmp1.yzw = LightColor.xyz - ShadowColor.xyz;
                tmp1.xyz = tmp1.xxx * tmp1.yzw + ShadowColor.xyz;
                tmp1.xyz = tmp0.xyz * tmp1.xyz;
                tmp0.xyz = tmp1.xyz * _LightColor0.xyz;
                tmp1 = tex2D(_Emission, inp.texcoord.xy);
                o.sv_target = tmp0 + tmp1;
                return o;
			}
#elif defined(DIRECTIONAL) && defined(LIGHTMAP_ON) && !defined(LIGHTMAP_SHADOW_MIXING) && !defined(LIGHTPROBE_SH) && defined(LOD_FADE_CROSSFADE) && !defined(SHADOWS_SCREEN) && !defined(SHADOWS_SHADOWMASK) && !defined(VERTEXLIGHT_ON)
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
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 ShadowColor;
			float4 LightColor;
			float _Opacity;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			sampler2D _Emission;
			
			// Keywords: LOD_FADE_CROSSFADE DIRECTIONAL LIGHTMAP_ON
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
                o.texcoord3.xyz = float3(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3]) * v.vertex.www + tmp0.xyz;
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
                o.texcoord2.xyz = tmp0.www * tmp0.xyz;
                return o;
			}
			// Keywords: LOD_FADE_CROSSFADE DIRECTIONAL LIGHTMAP_ON
			fout frag(v2f inp)
			{
 UNITY_SETUP_INSTANCE_ID(inp);
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = dot(inp.position.xy, float2(0.0671106, 0.0058372));
                tmp0.x = frac(tmp0.x);
                tmp0.x = tmp0.x * 52.98292;
                tmp0.x = frac(tmp0.x);
                tmp0.x = unity_LODFade.x - tmp0.x;
                tmp0.x = tmp0.x < 0.0;
                if (tmp0.x) {
                    discard;
                }
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1.x = tmp0.w - 0.5;
                tmp1.x = tmp1.x < 0.0;
                if (tmp1.x) {
                    discard;
                }
                tmp1.xyz = inp.texcoord3.xyz - unity_ShadowFadeCenterAndType.xyz;
                tmp1.x = dot(tmp1.xyz, tmp1.xyz);
                tmp1.x = sqrt(tmp1.x);
                tmp1.yzw = _WorldSpaceCameraPos - inp.texcoord3.xyz;
                tmp2.x = unity_MatrixV._m20;
                tmp2.y = unity_MatrixV._m21;
                tmp2.z = unity_MatrixV._m22;
                tmp1.y = dot(tmp1.xyz, tmp2.xyz);
                tmp1.x = tmp1.x - tmp1.y;
                tmp1.x = unity_ShadowFadeCenterAndType.w * tmp1.x + tmp1.y;
                tmp1.x = saturate(tmp1.x * _LightShadowData.z + _LightShadowData.w);
                tmp1.y = tmp1.x < 1.0;
                tmp1.z = tmp1.x >= 1.0;
                tmp1.yz = tmp1.yz ? 1.0 : 0.0;
                tmp1.y = tmp1.z + tmp1.y;
                tmp1.y = tmp1.y > 0.5;
                tmp1.x = tmp1.y ? 0.0 : tmp1.x;
                tmp1.y = tmp1.y ? 1.0 : 0.0;
                tmp1.x = tmp1.x + tmp1.y;
                tmp1.x = tmp1.x * _Opacity;
                tmp1.y = dot(_WorldSpaceLightPos0.xyz, inp.texcoord2.xyz);
                tmp1.y = saturate(tmp1.y * 100.0);
                tmp1.z = tmp1.y * -2.0 + 3.0;
                tmp1.y = tmp1.y * tmp1.y;
                tmp1.y = tmp1.y * tmp1.z;
                tmp1.x = tmp1.x * tmp1.y;
                tmp1.yzw = LightColor.xyz - ShadowColor.xyz;
                tmp1.xyz = tmp1.xxx * tmp1.yzw + ShadowColor.xyz;
                tmp1.xyz = tmp0.xyz * tmp1.xyz;
                tmp0.xyz = tmp1.xyz * _LightColor0.xyz;
                tmp1 = tex2D(_Emission, inp.texcoord.xy);
                o.sv_target = tmp0 + tmp1;
                return o;
			}
#elif defined(DIRECTIONAL) && !defined(LIGHTMAP_ON) && !defined(LIGHTMAP_SHADOW_MIXING) && !defined(LIGHTPROBE_SH) && defined(LOD_FADE_CROSSFADE) && defined(SHADOWS_SCREEN) && !defined(SHADOWS_SHADOWMASK) && !defined(VERTEXLIGHT_ON)
			#include "UnityCG.cginc"
#include "AutoLight.cginc"
			struct v2f
			{
 UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float3 texcoord2 : TEXCOORD2;
				float3 texcoord3 : TEXCOORD3;
				float4 texcoord4 : TEXCOORD4;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 ShadowColor;
			float4 LightColor;
			float _Opacity;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			sampler2D _Emission;
			
			// Keywords: LOD_FADE_CROSSFADE DIRECTIONAL SHADOWS_SCREEN
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
                o.texcoord3.xyz = float3(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3]) * v.vertex.www + tmp0.xyz;
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
                o.texcoord2.xyz = tmp1.www * tmp1.xyz;
                tmp1.xyz = tmp0.xyw * float3(0.5, 0.5, 0.5);
                o.texcoord4.zw = tmp0.zw;
                tmp1.w = tmp1.y * _ProjectionParams.x;
                o.texcoord4.xy = tmp1.zz + tmp1.xw;
                return o;
			}
			// Keywords: LOD_FADE_CROSSFADE DIRECTIONAL SHADOWS_SCREEN
			fout frag(v2f inp)
			{
 UNITY_SETUP_INSTANCE_ID(inp);
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = dot(inp.position.xy, float2(0.0671106, 0.0058372));
                tmp0.x = frac(tmp0.x);
                tmp0.x = tmp0.x * 52.98292;
                tmp0.x = frac(tmp0.x);
                tmp0.x = unity_LODFade.x - tmp0.x;
                tmp0.x = tmp0.x < 0.0;
                if (tmp0.x) {
                    discard;
                }
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1.x = tmp0.w - 0.5;
                tmp1.x = tmp1.x < 0.0;
                if (tmp1.x) {
                    discard;
                }
                tmp1.xyz = inp.texcoord3.xyz - unity_ShadowFadeCenterAndType.xyz;
                tmp1.x = dot(tmp1.xyz, tmp1.xyz);
                tmp1.x = sqrt(tmp1.x);
                tmp1.yzw = _WorldSpaceCameraPos - inp.texcoord3.xyz;
                tmp2.x = unity_MatrixV._m20;
                tmp2.y = unity_MatrixV._m21;
                tmp2.z = unity_MatrixV._m22;
                tmp1.y = dot(tmp1.xyz, tmp2.xyz);
                tmp1.x = tmp1.x - tmp1.y;
                tmp1.x = unity_ShadowFadeCenterAndType.w * tmp1.x + tmp1.y;
                tmp1.x = saturate(tmp1.x * _LightShadowData.z + _LightShadowData.w);
                tmp1.y = tmp1.x < 1.0;
                tmp1.z = tmp1.x >= 1.0;
                tmp1.yz = tmp1.yz ? 1.0 : 0.0;
                tmp2.xy = inp.texcoord4.xy / inp.texcoord4.ww;
                tmp2 = tex2D(_ShadowMapTexture, tmp2.xy);
                tmp1.y = tmp1.y * tmp2.x + tmp1.z;
                tmp1.y = tmp1.y > 0.5;
                tmp1.x = tmp1.y ? 0.0 : tmp1.x;
                tmp1.y = tmp1.y ? 1.0 : 0.0;
                tmp1.x = tmp1.x + tmp1.y;
                tmp1.x = tmp1.x * _Opacity;
                tmp1.y = dot(_WorldSpaceLightPos0.xyz, inp.texcoord2.xyz);
                tmp1.y = saturate(tmp1.y * 100.0);
                tmp1.z = tmp1.y * -2.0 + 3.0;
                tmp1.y = tmp1.y * tmp1.y;
                tmp1.y = tmp1.y * tmp1.z;
                tmp1.x = tmp1.x * tmp1.y;
                tmp1.yzw = LightColor.xyz - ShadowColor.xyz;
                tmp1.xyz = tmp1.xxx * tmp1.yzw + ShadowColor.xyz;
                tmp1.xyz = tmp0.xyz * tmp1.xyz;
                tmp0.xyz = tmp1.xyz * _LightColor0.xyz;
                tmp1 = tex2D(_Emission, inp.texcoord.xy);
                o.sv_target = tmp0 + tmp1;
                return o;
			}
#elif defined(DIRECTIONAL) && !defined(LIGHTMAP_ON) && !defined(LIGHTMAP_SHADOW_MIXING) && !defined(LIGHTPROBE_SH) && defined(LOD_FADE_CROSSFADE) && !defined(SHADOWS_SCREEN) && !defined(SHADOWS_SHADOWMASK) && defined(VERTEXLIGHT_ON)
			#include "UnityCG.cginc"
#include "AutoLight.cginc"
			struct v2f
			{
 UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float3 texcoord2 : TEXCOORD2;
				float3 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 ShadowColor;
			float4 LightColor;
			float _Opacity;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			sampler2D _Emission;
			
			// Keywords: LOD_FADE_CROSSFADE DIRECTIONAL VERTEXLIGHT_ON
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
                o.texcoord3.xyz = float3(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3]) * v.vertex.www + tmp0.xyz;
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
                o.texcoord2.xyz = tmp0.www * tmp0.xyz;
                return o;
			}
			// Keywords: LOD_FADE_CROSSFADE DIRECTIONAL
			fout frag(v2f inp)
			{
 UNITY_SETUP_INSTANCE_ID(inp);
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = dot(inp.position.xy, float2(0.0671106, 0.0058372));
                tmp0.x = frac(tmp0.x);
                tmp0.x = tmp0.x * 52.98292;
                tmp0.x = frac(tmp0.x);
                tmp0.x = unity_LODFade.x - tmp0.x;
                tmp0.x = tmp0.x < 0.0;
                if (tmp0.x) {
                    discard;
                }
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1.x = tmp0.w - 0.5;
                tmp1.x = tmp1.x < 0.0;
                if (tmp1.x) {
                    discard;
                }
                tmp1.xyz = inp.texcoord3.xyz - unity_ShadowFadeCenterAndType.xyz;
                tmp1.x = dot(tmp1.xyz, tmp1.xyz);
                tmp1.x = sqrt(tmp1.x);
                tmp1.yzw = _WorldSpaceCameraPos - inp.texcoord3.xyz;
                tmp2.x = unity_MatrixV._m20;
                tmp2.y = unity_MatrixV._m21;
                tmp2.z = unity_MatrixV._m22;
                tmp1.y = dot(tmp1.xyz, tmp2.xyz);
                tmp1.x = tmp1.x - tmp1.y;
                tmp1.x = unity_ShadowFadeCenterAndType.w * tmp1.x + tmp1.y;
                tmp1.x = saturate(tmp1.x * _LightShadowData.z + _LightShadowData.w);
                tmp1.y = tmp1.x < 1.0;
                tmp1.z = tmp1.x >= 1.0;
                tmp1.yz = tmp1.yz ? 1.0 : 0.0;
                tmp1.y = tmp1.z + tmp1.y;
                tmp1.y = tmp1.y > 0.5;
                tmp1.x = tmp1.y ? 0.0 : tmp1.x;
                tmp1.y = tmp1.y ? 1.0 : 0.0;
                tmp1.x = tmp1.x + tmp1.y;
                tmp1.x = tmp1.x * _Opacity;
                tmp1.y = dot(_WorldSpaceLightPos0.xyz, inp.texcoord2.xyz);
                tmp1.y = saturate(tmp1.y * 100.0);
                tmp1.z = tmp1.y * -2.0 + 3.0;
                tmp1.y = tmp1.y * tmp1.y;
                tmp1.y = tmp1.y * tmp1.z;
                tmp1.x = tmp1.x * tmp1.y;
                tmp1.yzw = LightColor.xyz - ShadowColor.xyz;
                tmp1.xyz = tmp1.xxx * tmp1.yzw + ShadowColor.xyz;
                tmp1.xyz = tmp0.xyz * tmp1.xyz;
                tmp0.xyz = tmp1.xyz * _LightColor0.xyz;
                tmp1 = tex2D(_Emission, inp.texcoord.xy);
                o.sv_target = tmp0 + tmp1;
                return o;
			}
#elif defined(DIRECTIONAL) && !defined(LIGHTMAP_ON) && !defined(LIGHTMAP_SHADOW_MIXING) && defined(LIGHTPROBE_SH) && !defined(LOD_FADE_CROSSFADE) && !defined(SHADOWS_SCREEN) && !defined(SHADOWS_SHADOWMASK) && !defined(VERTEXLIGHT_ON)
			#include "UnityCG.cginc"
#include "AutoLight.cginc"
			struct v2f
			{
 UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float3 texcoord2 : TEXCOORD2;
				float3 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 ShadowColor;
			float4 LightColor;
			float _Opacity;
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
                tmp0 = v.vertex.yyyy * float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
                tmp0 = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]) * v.vertex.xxxx + tmp0;
                tmp0 = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]) * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
                o.texcoord3.xyz = float3(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3]) * v.vertex.www + tmp0.xyz;
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
                o.texcoord2.xyz = tmp0.www * tmp0.xyz;
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
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1.x = tmp0.w - 0.5;
                tmp1.x = tmp1.x < 0.0;
                if (tmp1.x) {
                    discard;
                }
                tmp1.xyz = inp.texcoord3.xyz - unity_ShadowFadeCenterAndType.xyz;
                tmp1.x = dot(tmp1.xyz, tmp1.xyz);
                tmp1.x = sqrt(tmp1.x);
                tmp1.yzw = _WorldSpaceCameraPos - inp.texcoord3.xyz;
                tmp2.x = unity_MatrixV._m20;
                tmp2.y = unity_MatrixV._m21;
                tmp2.z = unity_MatrixV._m22;
                tmp1.y = dot(tmp1.xyz, tmp2.xyz);
                tmp1.x = tmp1.x - tmp1.y;
                tmp1.x = unity_ShadowFadeCenterAndType.w * tmp1.x + tmp1.y;
                tmp1.x = saturate(tmp1.x * _LightShadowData.z + _LightShadowData.w);
                tmp1.y = tmp1.x < 1.0;
                tmp1.z = tmp1.x >= 1.0;
                tmp1.yz = tmp1.yz ? 1.0 : 0.0;
                tmp1.y = tmp1.z + tmp1.y;
                tmp1.y = tmp1.y > 0.5;
                tmp1.x = tmp1.y ? 0.0 : tmp1.x;
                tmp1.y = tmp1.y ? 1.0 : 0.0;
                tmp1.x = tmp1.x + tmp1.y;
                tmp1.x = tmp1.x * _Opacity;
                tmp1.y = dot(_WorldSpaceLightPos0.xyz, inp.texcoord2.xyz);
                tmp1.y = saturate(tmp1.y * 100.0);
                tmp1.z = tmp1.y * -2.0 + 3.0;
                tmp1.y = tmp1.y * tmp1.y;
                tmp1.y = tmp1.y * tmp1.z;
                tmp1.x = tmp1.x * tmp1.y;
                tmp1.yzw = LightColor.xyz - ShadowColor.xyz;
                tmp1.xyz = tmp1.xxx * tmp1.yzw + ShadowColor.xyz;
                tmp1.xyz = tmp0.xyz * tmp1.xyz;
                tmp0.xyz = tmp1.xyz * _LightColor0.xyz;
                tmp1 = tex2D(_Emission, inp.texcoord.xy);
                o.sv_target = tmp0 + tmp1;
                return o;
			}
#elif defined(DIRECTIONAL) && defined(LIGHTMAP_ON) && !defined(LIGHTMAP_SHADOW_MIXING) && !defined(LIGHTPROBE_SH) && !defined(LOD_FADE_CROSSFADE) && !defined(SHADOWS_SCREEN) && !defined(SHADOWS_SHADOWMASK) && !defined(VERTEXLIGHT_ON)
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
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 ShadowColor;
			float4 LightColor;
			float _Opacity;
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
                tmp0 = v.vertex.yyyy * float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
                tmp0 = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]) * v.vertex.xxxx + tmp0;
                tmp0 = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]) * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
                o.texcoord3.xyz = float3(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3]) * v.vertex.www + tmp0.xyz;
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
                o.texcoord2.xyz = tmp0.www * tmp0.xyz;
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
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1.x = tmp0.w - 0.5;
                tmp1.x = tmp1.x < 0.0;
                if (tmp1.x) {
                    discard;
                }
                tmp1.xyz = inp.texcoord3.xyz - unity_ShadowFadeCenterAndType.xyz;
                tmp1.x = dot(tmp1.xyz, tmp1.xyz);
                tmp1.x = sqrt(tmp1.x);
                tmp1.yzw = _WorldSpaceCameraPos - inp.texcoord3.xyz;
                tmp2.x = unity_MatrixV._m20;
                tmp2.y = unity_MatrixV._m21;
                tmp2.z = unity_MatrixV._m22;
                tmp1.y = dot(tmp1.xyz, tmp2.xyz);
                tmp1.x = tmp1.x - tmp1.y;
                tmp1.x = unity_ShadowFadeCenterAndType.w * tmp1.x + tmp1.y;
                tmp1.x = saturate(tmp1.x * _LightShadowData.z + _LightShadowData.w);
                tmp1.y = tmp1.x < 1.0;
                tmp1.z = tmp1.x >= 1.0;
                tmp1.yz = tmp1.yz ? 1.0 : 0.0;
                tmp1.y = tmp1.z + tmp1.y;
                tmp1.y = tmp1.y > 0.5;
                tmp1.x = tmp1.y ? 0.0 : tmp1.x;
                tmp1.y = tmp1.y ? 1.0 : 0.0;
                tmp1.x = tmp1.x + tmp1.y;
                tmp1.x = tmp1.x * _Opacity;
                tmp1.y = dot(_WorldSpaceLightPos0.xyz, inp.texcoord2.xyz);
                tmp1.y = saturate(tmp1.y * 100.0);
                tmp1.z = tmp1.y * -2.0 + 3.0;
                tmp1.y = tmp1.y * tmp1.y;
                tmp1.y = tmp1.y * tmp1.z;
                tmp1.x = tmp1.x * tmp1.y;
                tmp1.yzw = LightColor.xyz - ShadowColor.xyz;
                tmp1.xyz = tmp1.xxx * tmp1.yzw + ShadowColor.xyz;
                tmp1.xyz = tmp0.xyz * tmp1.xyz;
                tmp0.xyz = tmp1.xyz * _LightColor0.xyz;
                tmp1 = tex2D(_Emission, inp.texcoord.xy);
                o.sv_target = tmp0 + tmp1;
                return o;
			}
#elif defined(DIRECTIONAL) && !defined(LIGHTMAP_ON) && !defined(LIGHTMAP_SHADOW_MIXING) && !defined(LIGHTPROBE_SH) && !defined(LOD_FADE_CROSSFADE) && defined(SHADOWS_SCREEN) && !defined(SHADOWS_SHADOWMASK) && !defined(VERTEXLIGHT_ON)
			#include "UnityCG.cginc"
#include "AutoLight.cginc"
			struct v2f
			{
 UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float3 texcoord2 : TEXCOORD2;
				float3 texcoord3 : TEXCOORD3;
				float4 texcoord4 : TEXCOORD4;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 ShadowColor;
			float4 LightColor;
			float _Opacity;
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
                tmp0 = v.vertex.yyyy * float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
                tmp0 = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]) * v.vertex.xxxx + tmp0;
                tmp0 = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]) * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
                o.texcoord3.xyz = float3(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3]) * v.vertex.www + tmp0.xyz;
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
                o.texcoord2.xyz = tmp1.www * tmp1.xyz;
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
                float4 tmp2;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1.x = tmp0.w - 0.5;
                tmp1.x = tmp1.x < 0.0;
                if (tmp1.x) {
                    discard;
                }
                tmp1.xyz = inp.texcoord3.xyz - unity_ShadowFadeCenterAndType.xyz;
                tmp1.x = dot(tmp1.xyz, tmp1.xyz);
                tmp1.x = sqrt(tmp1.x);
                tmp1.yzw = _WorldSpaceCameraPos - inp.texcoord3.xyz;
                tmp2.x = unity_MatrixV._m20;
                tmp2.y = unity_MatrixV._m21;
                tmp2.z = unity_MatrixV._m22;
                tmp1.y = dot(tmp1.xyz, tmp2.xyz);
                tmp1.x = tmp1.x - tmp1.y;
                tmp1.x = unity_ShadowFadeCenterAndType.w * tmp1.x + tmp1.y;
                tmp1.x = saturate(tmp1.x * _LightShadowData.z + _LightShadowData.w);
                tmp1.y = tmp1.x < 1.0;
                tmp1.z = tmp1.x >= 1.0;
                tmp1.yz = tmp1.yz ? 1.0 : 0.0;
                tmp2.xy = inp.texcoord4.xy / inp.texcoord4.ww;
                tmp2 = tex2D(_ShadowMapTexture, tmp2.xy);
                tmp1.y = tmp1.y * tmp2.x + tmp1.z;
                tmp1.y = tmp1.y > 0.5;
                tmp1.x = tmp1.y ? 0.0 : tmp1.x;
                tmp1.y = tmp1.y ? 1.0 : 0.0;
                tmp1.x = tmp1.x + tmp1.y;
                tmp1.x = tmp1.x * _Opacity;
                tmp1.y = dot(_WorldSpaceLightPos0.xyz, inp.texcoord2.xyz);
                tmp1.y = saturate(tmp1.y * 100.0);
                tmp1.z = tmp1.y * -2.0 + 3.0;
                tmp1.y = tmp1.y * tmp1.y;
                tmp1.y = tmp1.y * tmp1.z;
                tmp1.x = tmp1.x * tmp1.y;
                tmp1.yzw = LightColor.xyz - ShadowColor.xyz;
                tmp1.xyz = tmp1.xxx * tmp1.yzw + ShadowColor.xyz;
                tmp1.xyz = tmp0.xyz * tmp1.xyz;
                tmp0.xyz = tmp1.xyz * _LightColor0.xyz;
                tmp1 = tex2D(_Emission, inp.texcoord.xy);
                o.sv_target = tmp0 + tmp1;
                return o;
			}
#elif defined(DIRECTIONAL) && !defined(LIGHTMAP_ON) && !defined(LIGHTMAP_SHADOW_MIXING) && !defined(LIGHTPROBE_SH) && !defined(LOD_FADE_CROSSFADE) && !defined(SHADOWS_SCREEN) && !defined(SHADOWS_SHADOWMASK) && defined(VERTEXLIGHT_ON)
			#include "UnityCG.cginc"
#include "AutoLight.cginc"
			struct v2f
			{
 UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float3 texcoord2 : TEXCOORD2;
				float3 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 ShadowColor;
			float4 LightColor;
			float _Opacity;
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
                tmp0 = v.vertex.yyyy * float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
                tmp0 = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]) * v.vertex.xxxx + tmp0;
                tmp0 = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]) * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
                o.texcoord3.xyz = float3(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3]) * v.vertex.www + tmp0.xyz;
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
                o.texcoord2.xyz = tmp0.www * tmp0.xyz;
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
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1.x = tmp0.w - 0.5;
                tmp1.x = tmp1.x < 0.0;
                if (tmp1.x) {
                    discard;
                }
                tmp1.xyz = inp.texcoord3.xyz - unity_ShadowFadeCenterAndType.xyz;
                tmp1.x = dot(tmp1.xyz, tmp1.xyz);
                tmp1.x = sqrt(tmp1.x);
                tmp1.yzw = _WorldSpaceCameraPos - inp.texcoord3.xyz;
                tmp2.x = unity_MatrixV._m20;
                tmp2.y = unity_MatrixV._m21;
                tmp2.z = unity_MatrixV._m22;
                tmp1.y = dot(tmp1.xyz, tmp2.xyz);
                tmp1.x = tmp1.x - tmp1.y;
                tmp1.x = unity_ShadowFadeCenterAndType.w * tmp1.x + tmp1.y;
                tmp1.x = saturate(tmp1.x * _LightShadowData.z + _LightShadowData.w);
                tmp1.y = tmp1.x < 1.0;
                tmp1.z = tmp1.x >= 1.0;
                tmp1.yz = tmp1.yz ? 1.0 : 0.0;
                tmp1.y = tmp1.z + tmp1.y;
                tmp1.y = tmp1.y > 0.5;
                tmp1.x = tmp1.y ? 0.0 : tmp1.x;
                tmp1.y = tmp1.y ? 1.0 : 0.0;
                tmp1.x = tmp1.x + tmp1.y;
                tmp1.x = tmp1.x * _Opacity;
                tmp1.y = dot(_WorldSpaceLightPos0.xyz, inp.texcoord2.xyz);
                tmp1.y = saturate(tmp1.y * 100.0);
                tmp1.z = tmp1.y * -2.0 + 3.0;
                tmp1.y = tmp1.y * tmp1.y;
                tmp1.y = tmp1.y * tmp1.z;
                tmp1.x = tmp1.x * tmp1.y;
                tmp1.yzw = LightColor.xyz - ShadowColor.xyz;
                tmp1.xyz = tmp1.xxx * tmp1.yzw + ShadowColor.xyz;
                tmp1.xyz = tmp0.xyz * tmp1.xyz;
                tmp0.xyz = tmp1.xyz * _LightColor0.xyz;
                tmp1 = tex2D(_Emission, inp.texcoord.xy);
                o.sv_target = tmp0 + tmp1;
                return o;
			}
#elif defined(DIRECTIONAL) && !defined(LIGHTMAP_ON) && !defined(LIGHTMAP_SHADOW_MIXING) && !defined(LIGHTPROBE_SH) && defined(LOD_FADE_CROSSFADE) && !defined(SHADOWS_SCREEN) && !defined(SHADOWS_SHADOWMASK) && !defined(VERTEXLIGHT_ON)
			#include "UnityCG.cginc"
#include "AutoLight.cginc"
			struct v2f
			{
 UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float3 texcoord2 : TEXCOORD2;
				float3 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 ShadowColor;
			float4 LightColor;
			float _Opacity;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			sampler2D _Emission;
			
			// Keywords: LOD_FADE_CROSSFADE DIRECTIONAL
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
                o.texcoord3.xyz = float3(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3]) * v.vertex.www + tmp0.xyz;
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
                o.texcoord2.xyz = tmp0.www * tmp0.xyz;
                return o;
			}
			// Keywords: LOD_FADE_CROSSFADE DIRECTIONAL
			fout frag(v2f inp)
			{
 UNITY_SETUP_INSTANCE_ID(inp);
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = dot(inp.position.xy, float2(0.0671106, 0.0058372));
                tmp0.x = frac(tmp0.x);
                tmp0.x = tmp0.x * 52.98292;
                tmp0.x = frac(tmp0.x);
                tmp0.x = unity_LODFade.x - tmp0.x;
                tmp0.x = tmp0.x < 0.0;
                if (tmp0.x) {
                    discard;
                }
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1.x = tmp0.w - 0.5;
                tmp1.x = tmp1.x < 0.0;
                if (tmp1.x) {
                    discard;
                }
                tmp1.xyz = inp.texcoord3.xyz - unity_ShadowFadeCenterAndType.xyz;
                tmp1.x = dot(tmp1.xyz, tmp1.xyz);
                tmp1.x = sqrt(tmp1.x);
                tmp1.yzw = _WorldSpaceCameraPos - inp.texcoord3.xyz;
                tmp2.x = unity_MatrixV._m20;
                tmp2.y = unity_MatrixV._m21;
                tmp2.z = unity_MatrixV._m22;
                tmp1.y = dot(tmp1.xyz, tmp2.xyz);
                tmp1.x = tmp1.x - tmp1.y;
                tmp1.x = unity_ShadowFadeCenterAndType.w * tmp1.x + tmp1.y;
                tmp1.x = saturate(tmp1.x * _LightShadowData.z + _LightShadowData.w);
                tmp1.y = tmp1.x < 1.0;
                tmp1.z = tmp1.x >= 1.0;
                tmp1.yz = tmp1.yz ? 1.0 : 0.0;
                tmp1.y = tmp1.z + tmp1.y;
                tmp1.y = tmp1.y > 0.5;
                tmp1.x = tmp1.y ? 0.0 : tmp1.x;
                tmp1.y = tmp1.y ? 1.0 : 0.0;
                tmp1.x = tmp1.x + tmp1.y;
                tmp1.x = tmp1.x * _Opacity;
                tmp1.y = dot(_WorldSpaceLightPos0.xyz, inp.texcoord2.xyz);
                tmp1.y = saturate(tmp1.y * 100.0);
                tmp1.z = tmp1.y * -2.0 + 3.0;
                tmp1.y = tmp1.y * tmp1.y;
                tmp1.y = tmp1.y * tmp1.z;
                tmp1.x = tmp1.x * tmp1.y;
                tmp1.yzw = LightColor.xyz - ShadowColor.xyz;
                tmp1.xyz = tmp1.xxx * tmp1.yzw + ShadowColor.xyz;
                tmp1.xyz = tmp0.xyz * tmp1.xyz;
                tmp0.xyz = tmp1.xyz * _LightColor0.xyz;
                tmp1 = tex2D(_Emission, inp.texcoord.xy);
                o.sv_target = tmp0 + tmp1;
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
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 ShadowColor;
			float4 LightColor;
			float _Opacity;
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
                tmp0 = v.vertex.yyyy * float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
                tmp0 = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]) * v.vertex.xxxx + tmp0;
                tmp0 = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]) * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
                o.texcoord3.xyz = float3(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3]) * v.vertex.www + tmp0.xyz;
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
                o.texcoord2.xyz = tmp0.www * tmp0.xyz;
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
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1.x = tmp0.w - 0.5;
                tmp1.x = tmp1.x < 0.0;
                if (tmp1.x) {
                    discard;
                }
                tmp1.xyz = inp.texcoord3.xyz - unity_ShadowFadeCenterAndType.xyz;
                tmp1.x = dot(tmp1.xyz, tmp1.xyz);
                tmp1.x = sqrt(tmp1.x);
                tmp1.yzw = _WorldSpaceCameraPos - inp.texcoord3.xyz;
                tmp2.x = unity_MatrixV._m20;
                tmp2.y = unity_MatrixV._m21;
                tmp2.z = unity_MatrixV._m22;
                tmp1.y = dot(tmp1.xyz, tmp2.xyz);
                tmp1.x = tmp1.x - tmp1.y;
                tmp1.x = unity_ShadowFadeCenterAndType.w * tmp1.x + tmp1.y;
                tmp1.x = saturate(tmp1.x * _LightShadowData.z + _LightShadowData.w);
                tmp1.y = tmp1.x < 1.0;
                tmp1.z = tmp1.x >= 1.0;
                tmp1.yz = tmp1.yz ? 1.0 : 0.0;
                tmp1.y = tmp1.z + tmp1.y;
                tmp1.y = tmp1.y > 0.5;
                tmp1.x = tmp1.y ? 0.0 : tmp1.x;
                tmp1.y = tmp1.y ? 1.0 : 0.0;
                tmp1.x = tmp1.x + tmp1.y;
                tmp1.x = tmp1.x * _Opacity;
                tmp1.y = dot(_WorldSpaceLightPos0.xyz, inp.texcoord2.xyz);
                tmp1.y = saturate(tmp1.y * 100.0);
                tmp1.z = tmp1.y * -2.0 + 3.0;
                tmp1.y = tmp1.y * tmp1.y;
                tmp1.y = tmp1.y * tmp1.z;
                tmp1.x = tmp1.x * tmp1.y;
                tmp1.yzw = LightColor.xyz - ShadowColor.xyz;
                tmp1.xyz = tmp1.xxx * tmp1.yzw + ShadowColor.xyz;
                tmp1.xyz = tmp0.xyz * tmp1.xyz;
                tmp0.xyz = tmp1.xyz * _LightColor0.xyz;
                tmp1 = tex2D(_Emission, inp.texcoord.xy);
                o.sv_target = tmp0 + tmp1;
                return o;
			}
#endif
			ENDCG
		}
	}
	Fallback "Diffuse"
}