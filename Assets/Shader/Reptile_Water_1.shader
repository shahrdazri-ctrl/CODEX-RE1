Shader "Reptile/Water" {
	Properties {
		_DepthGradientShallow ("Depth Gradient Shallow", Color) = (0.325,0.807,0.971,0.725)
		_DepthGradientDeep ("Depth Gradient Deep", Color) = (0.086,0.407,1,0.749)
		_DepthMaxDistance ("Depth Maximum Distance", Float) = 1
		_FoamColor ("Foam Color", Color) = (1,1,1,1)
		_SurfaceNoise ("Surface Noise", 2D) = "white" {}
		_SurfaceNoiseScroll ("Surface Noise Scroll Amount", Vector) = (0.03,0.03,0,0)
		_SurfaceNoiseCutoff ("Surface Noise Cutoff", Range(0, 1)) = 0.777
		_SurfaceDistortion ("Surface Distortion", 2D) = "white" {}
		_SurfaceDistortionAmount ("Surface Distortion Amount", Range(0, 1)) = 0.27
		_FoamMaxDistance ("Foam Maximum Distance", Float) = 0.4
		_FoamMinDistance ("Foam Minimum Distance", Float) = 0.04
	}
	SubShader {
		Tags { "QUEUE" = "Transparent" }
		Pass {
			Tags { "QUEUE" = "Transparent" }
			Blend SrcAlpha OneMinusSrcAlpha, SrcAlpha OneMinusSrcAlpha
			ZWrite Off

CGPROGRAM
#pragma vertex vert
#pragma fragment frag
#pragma target 3.5
#pragma multi_compile_instancing
#if 1
			#include "UnityCG.cginc"
			struct v2f
			{
 UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
				float3 normal : NORMAL0;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _SurfaceNoise_ST;
			float4 _SurfaceDistortion_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _DepthGradientShallow;
			float4 _DepthGradientDeep;
			float4 _FoamColor;
			float _DepthMaxDistance;
			float _FoamMaxDistance;
			float _FoamMinDistance;
			float _SurfaceNoiseCutoff;
			float _SurfaceDistortionAmount;
			float2 _SurfaceNoiseScroll;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _CameraDepthTexture;
			sampler2D _CameraNormalsTexture;
			sampler2D _SurfaceDistortion;
			sampler2D _SurfaceNoise;
			
			// Keywords: 
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
                o.texcoord1.xy = v.texcoord.xy * _SurfaceDistortion_ST.xy + _SurfaceDistortion_ST.zw;
                o.texcoord.xy = v.texcoord.xy * _SurfaceNoise_ST.xy + _SurfaceNoise_ST.zw;
                tmp0.y = tmp0.y * _ProjectionParams.x;
                tmp1.xzw = tmp0.xwy * float3(0.5, 0.5, 0.5);
                o.texcoord2.zw = tmp0.zw;
                o.texcoord2.xy = tmp1.zz + tmp1.xw;
                tmp0.xyz = float3(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1]) * float3(unity_MatrixInvV[1][0], unity_MatrixInvV[1][0], unity_MatrixInvV[1][0]);
                tmp0.xyz = float3(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0]) * float3(unity_MatrixInvV[0][0], unity_MatrixInvV[0][0], unity_MatrixInvV[0][0]) + tmp0.xyz;
                tmp0.xyz = float3(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2]) * float3(unity_MatrixInvV[2][0], unity_MatrixInvV[2][0], unity_MatrixInvV[2][0]) + tmp0.xyz;
                tmp0.xyz = float3(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3]) * float3(unity_MatrixInvV[3][0], unity_MatrixInvV[3][0], unity_MatrixInvV[3][0]) + tmp0.xyz;
                tmp0.x = dot(tmp0.xyz, v.normal.xyz);
                tmp1.xyz = float3(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1]) * float3(unity_MatrixInvV[1][1], unity_MatrixInvV[1][1], unity_MatrixInvV[1][1]);
                tmp1.xyz = float3(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0]) * float3(unity_MatrixInvV[0][1], unity_MatrixInvV[0][1], unity_MatrixInvV[0][1]) + tmp1.xyz;
                tmp1.xyz = float3(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2]) * float3(unity_MatrixInvV[2][1], unity_MatrixInvV[2][1], unity_MatrixInvV[2][1]) + tmp1.xyz;
                tmp1.xyz = float3(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3]) * float3(unity_MatrixInvV[3][1], unity_MatrixInvV[3][1], unity_MatrixInvV[3][1]) + tmp1.xyz;
                tmp0.y = dot(tmp1.xyz, v.normal.xyz);
                tmp1.xyz = float3(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1]) * float3(unity_MatrixInvV[1][2], unity_MatrixInvV[1][2], unity_MatrixInvV[1][2]);
                tmp1.xyz = float3(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0]) * float3(unity_MatrixInvV[0][2], unity_MatrixInvV[0][2], unity_MatrixInvV[0][2]) + tmp1.xyz;
                tmp1.xyz = float3(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2]) * float3(unity_MatrixInvV[2][2], unity_MatrixInvV[2][2], unity_MatrixInvV[2][2]) + tmp1.xyz;
                tmp1.xyz = float3(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3]) * float3(unity_MatrixInvV[3][2], unity_MatrixInvV[3][2], unity_MatrixInvV[3][2]) + tmp1.xyz;
                tmp0.z = dot(tmp1.xyz, v.normal.xyz);
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.normal.xyz = tmp0.www * tmp0.xyz;
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
                tmp0 = tex2D(_SurfaceDistortion, inp.texcoord1.xy);
                tmp0.xy = tmp0.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp0.zw = _Time.yy * _SurfaceNoiseScroll + inp.texcoord.xy;
                tmp0.xy = tmp0.xy * _SurfaceDistortionAmount.xx + tmp0.zw;
                tmp0 = tex2D(_SurfaceNoise, tmp0.xy);
                tmp0.yz = inp.texcoord2.xy / inp.texcoord2.ww;
                tmp1 = tex2D(_CameraNormalsTexture, tmp0.yz);
                tmp2 = tex2D(_CameraDepthTexture, tmp0.yz);
                tmp0.y = _ZBufferParams.z * tmp2.x + _ZBufferParams.w;
                tmp0.y = 1.0 / tmp0.y;
                tmp0.y = tmp0.y - inp.texcoord2.w;
                tmp0.z = saturate(dot(tmp1.xyz, inp.normal.xyz));
                tmp0.w = _FoamMinDistance - _FoamMaxDistance;
                tmp0.z = tmp0.z * tmp0.w + _FoamMaxDistance;
                tmp0.z = saturate(tmp0.y / tmp0.z);
                tmp0.y = saturate(tmp0.y / _DepthMaxDistance);
                tmp0.z = tmp0.z * _SurfaceNoiseCutoff + -0.01;
                tmp0.x = tmp0.x - tmp0.z;
                tmp0.x = saturate(tmp0.x * 50.0);
                tmp0.z = tmp0.x * -2.0 + 3.0;
                tmp0.x = tmp0.x * tmp0.x;
                tmp0.x = tmp0.x * tmp0.z;
                tmp0.z = -_FoamColor.w * tmp0.x + 1.0;
                tmp1 = _DepthGradientDeep - _DepthGradientShallow;
                tmp1 = tmp0.yyyy * tmp1 + _DepthGradientShallow;
                tmp1 = tmp0.zzzz * tmp1;
                tmp0.y = tmp0.x * _FoamColor.w;
                o.sv_target.w = _FoamColor.w * tmp0.x + tmp1.w;
                o.sv_target.xyz = _FoamColor.xyz * tmp0.yyy + tmp1.xyz;
                return o;
			}
#endif
			ENDCG
		}
	}
}