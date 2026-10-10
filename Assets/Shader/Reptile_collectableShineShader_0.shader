Shader "Reptile/collectableShineShader" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_AnimateSpeed (" Animate Speed", Float) = 1
	}
	SubShader {
		Pass {

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
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float _AnimateSpeed;
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
                tmp0.x = _AnimateSpeed * _Time.w;
                tmp0.x = sin(tmp0.x);
                tmp0.x = tmp0.x * 0.5 + -0.4;
                tmp0.x = saturate(tmp0.x * 10.0);
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
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
 UNITY_SETUP_INSTANCE_ID(inp);
                fout o;
                o.sv_target = _Color;
                return o;
			}
#endif
			ENDCG
		}
	}
}