Shader "Unlit/MarkerShineShader" {
	Properties {
		_Color ("Color", Color) = (0,0,0,1)
		_Size ("Size", Float) = 4
	}
	SubShader {
		Pass {
			Tags { "LIGHTMODE" = "FordwardBase" "QUEUE" = "Geometry" }

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
			float _Size;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _Color;
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
                tmp0.x = frac(_Time.x);
                tmp0.yzw = tmp0.xxx * float3(20.0, 1000.0, 500.0);
                tmp0.x = tmp0.x * 40.0 + -0.1;
                tmp0.xyz = sin(tmp0.xyz);
                tmp0.xy = tmp0.xy + float2(0.98, 0.5);
                tmp0.xy = ceil(tmp0.xy);
                tmp0.x = min(tmp0.x, 1.0);
                tmp0.w = cos(tmp0.w);
                tmp0.z = tmp0.w * 2.6 + tmp0.z;
                tmp0.xy = float2(1.0, 1.0) - tmp0.xy;
                tmp0.z = saturate(tmp0.z + 0.3);
                tmp0.y = tmp0.z * tmp0.y;
                tmp0.y = max(tmp0.y, 0.0);
                tmp0.x = tmp0.x * tmp0.y;
                tmp0.x = tmp0.x * _Size;
                tmp0.xy = tmp0.xx * v.vertex.xy;
                tmp1 = float4(unity_ObjectToWorld[1][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[1][3]) * float4(unity_MatrixV[0][1], unity_MatrixV[1][1], unity_MatrixV[2][1], unity_MatrixV[3][1]);
                tmp1 = float4(unity_MatrixV[0][0], unity_MatrixV[1][0], unity_MatrixV[2][0], unity_MatrixV[3][0]) * float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[0][3], unity_ObjectToWorld[0][3], unity_ObjectToWorld[0][3]) + tmp1;
                tmp1 = float4(unity_MatrixV[0][2], unity_MatrixV[1][2], unity_MatrixV[2][2], unity_MatrixV[3][2]) * float4(unity_ObjectToWorld[2][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[2][3]) + tmp1;
                tmp1 = float4(unity_MatrixV[0][3], unity_MatrixV[1][3], unity_MatrixV[2][3], unity_MatrixV[3][3]) * float4(unity_ObjectToWorld[3][3], unity_ObjectToWorld[3][3], unity_ObjectToWorld[3][3], unity_ObjectToWorld[3][3]) + tmp1;
                tmp0.zw = float2(0.0, 0.0);
                tmp0 = tmp0 + tmp1;
                tmp1 = tmp0.yyyy * float4(glstate_matrix_projection[0][1], glstate_matrix_projection[1][1], glstate_matrix_projection[2][1], glstate_matrix_projection[3][1]);
                tmp1 = float4(glstate_matrix_projection[0][0], glstate_matrix_projection[1][0], glstate_matrix_projection[2][0], glstate_matrix_projection[3][0]) * tmp0.xxxx + tmp1;
                tmp1 = float4(glstate_matrix_projection[0][2], glstate_matrix_projection[1][2], glstate_matrix_projection[2][2], glstate_matrix_projection[3][2]) * tmp0.zzzz + tmp1;
                o.position = float4(glstate_matrix_projection[0][3], glstate_matrix_projection[1][3], glstate_matrix_projection[2][3], glstate_matrix_projection[3][3]) * tmp0.wwww + tmp1;
                o.texcoord.xy = v.texcoord.xy;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
 UNITY_SETUP_INSTANCE_ID(inp);
                fout o;
                float4 tmp0;
                tmp0.xy = inp.texcoord.xy - float2(0.5, 0.5);
                tmp0.xy = tmp0.xy * float2(0.5, 0.5);
                tmp0.xy = log(abs(tmp0.xy));
                tmp0.xy = tmp0.xy * float2(0.2, 0.2);
                tmp0.xy = exp(tmp0.xy);
                tmp0.x = tmp0.x + tmp0.y;
                tmp0.x = min(tmp0.x, 1.0);
                tmp0.x = 1.0 - tmp0.x;
                tmp0.x = ceil(tmp0.x);
                tmp0.y = tmp0.x - 0.5;
                o.sv_target.w = tmp0.x;
                tmp0.x = tmp0.y < 0.0;
                if (tmp0.x) {
                    discard;
                }
                o.sv_target.xyz = _Color.xyz;
                return o;
			}
#endif
			ENDCG
		}
	}
}