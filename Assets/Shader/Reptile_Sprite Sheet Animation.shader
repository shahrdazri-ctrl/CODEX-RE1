Shader "Reptile/Sprite Sheet Animation" {
	Properties {
		[NoScaleOffset] _MainTex ("Texture", 2D) = "black" {}
		_Max ("Max. Frames", Float) = 4
		_Speed ("Speed", Float) = 1
	}
	SubShader {
		Tags { "RenderType" = "Opaque" }
		Pass {
			Tags { "RenderType" = "Opaque" }

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
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float _Max;
			float _Speed;
			// $Globals ConstantBuffers for Fragment Shader
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
                tmp0.x = v.color.x + _Time.y;
                tmp0.x = tmp0.x * _Speed;
                tmp0.y = floor(_Max);
                tmp0.x = tmp0.x / tmp0.y;
                tmp0.z = tmp0.x >= -tmp0.x;
                tmp0.x = frac(abs(tmp0.x));
                tmp0.x = tmp0.z ? tmp0.x : -tmp0.x;
                tmp0.x = tmp0.y * tmp0.x;
                tmp0.x = trunc(tmp0.x);
                tmp0.x = tmp0.x / _Max;
                tmp0.y = tmp0.x >= -tmp0.x;
                tmp0.x = frac(abs(tmp0.x));
                tmp0.x = tmp0.y ? tmp0.x : -tmp0.x;
                tmp0.x = tmp0.x * _Max;
                tmp0.y = 1.0 / _Max;
                o.texcoord.x = tmp0.x * tmp0.y + v.texcoord.x;
                o.texcoord.y = v.texcoord.y;
                tmp0 = v.vertex.yyyy * float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
                tmp0 = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]) * v.vertex.xxxx + tmp0;
                tmp0 = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]) * v.vertex.zzzz + tmp0;
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
                o.sv_target = tex2D(_MainTex, inp.texcoord.xy);
                return o;
			}
#endif
			ENDCG
		}
	}
}