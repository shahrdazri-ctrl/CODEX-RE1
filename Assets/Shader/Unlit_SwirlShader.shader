Shader "Unlit/SwirlShader" {
	Properties {
		[PerRendererData] _MainTex ("Sprite Texture", 2D) = "white" {}
		[Header(Colors)] _ColorTex ("Color Ramp", 2D) = "white" {}
		_PaletteIndex ("Palette Offset", Range(0, 1)) = 0
		_ColorOffset ("Color Offset", Float) = 0
		[Header(UV)] _LineRotation ("Line Rotation", Range(0, 1)) = 0.5
		[Header(Distortion)] _Scalar5 ("Stretch Along Distortion", Float) = 0.01
		_Scalar6 ("Scale", Float) = 0.01
	}
	SubShader {
		Tags { "QUEUE" = "Transparent" "RenderType" = "Transparent" }
		Pass {
			Tags { "QUEUE" = "Transparent" "RenderType" = "Transparent" }
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
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float _PaletteIndex;
			float _LineRotation;
			float _Scalar5;
			float _Scalar6;
			float _ColorOffset;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _ColorTex;
			sampler2D _MainTex;
			
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
                o.position = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]) * tmp0.wwww + tmp1;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
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
                tmp0.x = 1.0 / _Scalar6;
                tmp0.x = tmp0.x * _ScreenParams.x;
                tmp0.y = _ScreenParams.y * 0.005;
                tmp0.z = _Time.x * 0.244;
                tmp0.z = frac(tmp0.z);
                tmp0.z = tmp0.z * 6.28;
                tmp0.x = max(tmp0.y, tmp0.x);
                tmp0.xy = inp.position.xy / tmp0.xx;
                tmp1.xy = float2(11.08, 18.3) / _Scalar5.xx;
                tmp1.zw = tmp0.xy;
                tmp0.w = 1.0;
                for (float i = tmp0.w; i < 19.0; i += 1) {
                    tmp2.x = i * 3.0;
                    tmp2.xy = tmp2.xx * tmp1.wz + tmp0.zz;
                    tmp2.x = sin(tmp2.x);
                    tmp2.x = tmp1.x * tmp2.x + tmp1.z;
                    tmp1.z = i * 4.0 + tmp2.x;
                    tmp2.x = cos(tmp2.y);
                    tmp2.x = tmp1.y * tmp2.x + tmp1.w;
                    tmp1.w = i * 4.0 + tmp2.x;
                }
                tmp0.xy = _LineRotation.xx * float2(1.0, -1.0) + float2(0.0, 1.0);
                tmp0.xy = tmp0.xy * tmp1.zw;
                tmp0.x = tmp0.y + tmp0.x;
                tmp0.x = cos(tmp0.x);
                tmp0.x = tmp0.x * 10.97 + _ColorOffset;
                tmp0.y = tmp0.x >= -tmp0.x;
                tmp0.x = frac(abs(tmp0.x));
                tmp0.x = tmp0.y ? tmp0.x : -tmp0.x;
                tmp0.y = _PaletteIndex;
                tmp0 = tex2D(_ColorTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord.xy);
                o.sv_target.xyz = tmp0.xyz;
                o.sv_target.w = tmp1.w;
                return o;
			}
#endif
			ENDCG
		}
	}
}