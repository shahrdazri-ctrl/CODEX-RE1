Shader "Reptile/Unlit/Empty ED Swirl" {
	Properties {
		_MainTex ("Texture", 2D) = "white" {}
		_Color ("Swirl Color", Color) = (0.9568627,0.827451,0.2588235,1)
		_BorderMultiplier ("Border Multiplier", Float) = 1.05
		_SwirlControl ("Swirl Control", Float) = 1
	}
	SubShader {
		Tags { "IGNOREPROJECTOR" = "true" "PreviewType" = "Plane" "QUEUE" = "Transparent+1" "RenderType" = "Transparent" }
		Pass {
			Tags { "IGNOREPROJECTOR" = "true" "PreviewType" = "Plane" "QUEUE" = "Transparent+1" "RenderType" = "Transparent" }
			Blend SrcAlpha OneMinusSrcAlpha, SrcAlpha OneMinusSrcAlpha
			ZWrite Off
			Cull Off
			Offset -1, -1

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
				float2 texcoord : TEXCOORD0;
				float4 position : SV_POSITION0;
				float4 texcoord1 : TEXCOORD1;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			float _BorderMultiplier;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _MainTex_TexelSize;
			float4 _Color;
			float _SwirlControl;
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
                tmp0.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp0.z = -_BorderMultiplier * 0.5 + 0.5;
                o.texcoord.xy = tmp0.xy * _BorderMultiplier.xx + tmp0.zz;
                tmp0 = v.vertex.yyyy * float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
                tmp0 = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]) * v.vertex.xxxx + tmp0;
                tmp0 = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]) * v.vertex.zzzz + tmp0;
                tmp0 = tmp0 + float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
                tmp1 = tmp0.yyyy * float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
                tmp1 = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]) * tmp0.xxxx + tmp1;
                tmp1 = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]) * tmp0.zzzz + tmp1;
                o.position = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]) * tmp0.wwww + tmp1;
                o.texcoord1 = v.vertex;
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
                float4 tmp3;
                tmp0.xyz = inp.texcoord1.yyy * float3(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1]);
                tmp0.xyz = float3(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0]) * inp.texcoord1.xxx + tmp0.xyz;
                tmp0.xyz = float3(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2]) * inp.texcoord1.zzz + tmp0.xyz;
                tmp0.xyz = float3(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3]) * inp.texcoord1.www + tmp0.xyz;
                tmp0.xyz = _WorldSpaceCameraPos - tmp0.xyz;
                tmp0.x = dot(tmp0.xyz, tmp0.xyz);
                tmp0.x = tmp0.x - 100.0;
                tmp0.x = tmp0.x * 0.0025;
                tmp0.x = max(tmp0.x, 0.0);
                tmp0.x = min(tmp0.x, 0.5);
                tmp0.y = _Time.x * 0.2;
                tmp0.y = frac(tmp0.y);
                tmp0.zw = inp.texcoord.xy * float2(0.3424658, 0.3424658) + float2(8.09, 8.09);
                tmp1.xy = tmp0.zw;
                tmp1.z = 1.0;
                for (float i = tmp1.z; i < 10.0; i += 1) {
                    tmp1.w = i * 8.0;
                    tmp2.xy = tmp1.zz * float2(8.0, 8.0) + tmp1.xy;
                    tmp2.z = tmp1.y * i;
                    tmp3.x = tmp2.z * 9.0;
                    tmp3.y = tmp1.x * tmp1.w;
                    tmp2.zw = tmp0.yy * float2(6.28, 6.28) + tmp3.xy;
                    tmp3.x = sin(tmp2.z);
                    tmp3.y = cos(tmp2.w);
                    tmp1.xy = tmp3.xy * float2(0.0357552, 0.0119184) + tmp2.xy;
                }
                tmp0.yz = tmp1.xy * float2(0.825, 0.175);
                tmp0.y = tmp0.z + tmp0.y;
                tmp0.y = cos(tmp0.y);
                tmp0.y = tmp0.y * 10.74;
                tmp0.y = frac(tmp0.y);
                tmp1 = _MainTex_TexelSize * float4(0.015625, 0.015625, 0.0195313, 0.0195313);
                tmp0.zw = inp.texcoord.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp2.xy = log(abs(tmp0.zw));
                tmp1.xy = tmp1.xy * tmp2.xy;
                tmp1.xy = exp(tmp1.xy);
                tmp1.x = tmp1.x + tmp1.y;
                tmp1.x = min(tmp1.x, 1.0);
                tmp1.x = 1.0 - tmp1.x;
                tmp1.x = ceil(tmp1.x);
                tmp2.xy = float2(1.0, 1.25) - tmp0.xx;
                tmp0.xz = tmp0.zw * tmp2.yy;
                tmp0.xz = log(abs(tmp0.xz));
                tmp0.xz = tmp0.xz * tmp1.zw;
                tmp0.xz = exp(tmp0.xz);
                tmp0.x = tmp0.x + tmp0.z;
                tmp0.x = min(tmp0.x, 1.0);
                tmp0.x = 1.0 - tmp0.x;
                tmp0.x = ceil(tmp0.x);
                tmp0.z = round(tmp0.y);
                tmp0.y = tmp2.x < tmp0.y;
                tmp0.y = tmp0.y ? 1.0 : 0.0;
                tmp0.x = tmp1.x - tmp0.x;
                tmp2 = _Color * _SwirlControl.xxxx;
                tmp1 = tmp1.xxxx * tmp2;
                tmp0.w = 1.0 - tmp0.x;
                tmp0.x = tmp0.x * tmp0.z;
                tmp0.x = tmp0.y * tmp0.w + tmp0.x;
                o.sv_target = tmp0.xxxx * tmp1;
                return o;
			}
#endif
			ENDCG
		}
	}
}