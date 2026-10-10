Shader "Unlit/DreamSwirlShader" {
	Properties {
		[Header(Colors)] _MainTex ("Color Ramp", 2D) = "white" {}
		_PaletteIndex ("Palette Offset", Range(0, 1)) = 0
		_ColorOffset ("Color Offset", Float) = 0
		[Header(UV)] [Toggle] _Rings ("Rings", Float) = 0
		[IntRange] _LineMultiplier ("Line multiplier", Range(1, 10)) = 3
		_Twist ("Twist", Float) = 0
		_Scalar5 ("Stretch Along Distortion", Range(-5, 5)) = 2
		_Scalar6 ("Distortion Scale", Range(0, 5)) = 1
		[Header(Animation)] _TimeScalar ("Speed", Range(0, 1)) = 0.5
		_DistortionSpeed ("Distortion Component", Float) = 0.844
		_DistortionFlow ("Distortion Flow", Float) = 1
		_RotationSpeed ("Rotation Component", Float) = 2
		_ColorRotation ("Color Component", Float) = 1
		[Header(Fade)] _BlackGradientApply ("BlackGradientAtBottom", Float) = 0
		_MovementAlpha ("MovementAlpha", Float) = 0
	}
	SubShader {
		Tags { "QUEUE" = "Transparent-1" "RenderType" = "Transparent" }
		Pass {
			Tags { "QUEUE" = "Transparent-1" "RenderType" = "Transparent" }
			Blend SrcAlpha OneMinusSrcAlpha, SrcAlpha OneMinusSrcAlpha
			Cull Front

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
				float3 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float _PaletteIndex;
			int _LineMultiplier;
			int _Rings;
			float _Twist;
			float _Scalar5;
			float _Scalar6;
			float _RotationSpeed;
			float _DistortionFlow;
			float _ColorRotation;
			float _ColorOffset;
			float _TimeScalar;
			float _DistortionSpeed;
			float _BlackGradientApply;
			float _MovementAlpha;
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
                tmp0 = v.vertex.yyyy * float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
                tmp0 = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]) * v.vertex.xxxx + tmp0;
                tmp0 = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]) * v.vertex.zzzz + tmp0;
                tmp0 = tmp0 + float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
                tmp1 = tmp0.yyyy * float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
                tmp1 = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]) * tmp0.xxxx + tmp1;
                tmp1 = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]) * tmp0.zzzz + tmp1;
                o.position = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]) * tmp0.wwww + tmp1;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord1.xyz = v.normal.xyz;
                o.texcoord2 = v.vertex;
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
                tmp0.x = _TimeScalar * _Time.x;
                tmp0.y = tmp0.x * _DistortionSpeed;
                tmp0.y = frac(tmp0.y);
                tmp0.y = tmp0.y * 6.283185;
                tmp0.z = dot(inp.texcoord1.xyz, inp.texcoord1.xyz);
                tmp0.z = rsqrt(tmp0.z);
                tmp1.xyz = tmp0.zzz * inp.texcoord1.zxy;
                tmp0.z = min(abs(tmp1.y), abs(tmp1.x));
                tmp0.w = max(abs(tmp1.y), abs(tmp1.x));
                tmp0.w = 1.0 / tmp0.w;
                tmp0.z = tmp0.w * tmp0.z;
                tmp0.w = tmp0.z * tmp0.z;
                tmp1.w = tmp0.w * 0.0208351 + -0.085133;
                tmp1.w = tmp0.w * tmp1.w + 0.180141;
                tmp1.w = tmp0.w * tmp1.w + -0.3302995;
                tmp0.w = tmp0.w * tmp1.w + 0.999866;
                tmp1.w = tmp0.w * tmp0.z;
                tmp2.x = abs(tmp1.y) < abs(tmp1.x);
                tmp1.w = tmp1.w * -2.0 + 1.570796;
                tmp1.w = tmp2.x ? tmp1.w : 0.0;
                tmp0.z = tmp0.z * tmp0.w + tmp1.w;
                tmp2.xy = tmp1.yz < -tmp1.yz;
                tmp0.w = tmp2.x ? -3.141593 : 0.0;
                tmp0.z = tmp0.w + tmp0.z;
                tmp0.w = min(tmp1.y, tmp1.x);
                tmp1.x = max(tmp1.y, tmp1.x);
                tmp0.w = tmp0.w < -tmp0.w;
                tmp1.x = tmp1.x >= -tmp1.x;
                tmp0.w = tmp0.w ? tmp1.x : 0.0;
                tmp0.z = tmp0.w ? -tmp0.z : tmp0.z;
                tmp0.z = -tmp0.z * 0.1591549 + _MainTex_ST.w;
                tmp0.w = 1.0 - abs(tmp1.z);
                tmp0.w = sqrt(tmp0.w);
                tmp1.x = abs(tmp1.z) * -0.0187293 + 0.074261;
                tmp1.x = tmp1.x * abs(tmp1.z) + -0.2121144;
                tmp1.x = tmp1.x * abs(tmp1.z) + 1.570729;
                tmp1.y = tmp0.w * tmp1.x;
                tmp1.y = tmp1.y * -2.0 + 3.141593;
                tmp1.y = tmp2.y ? tmp1.y : 0.0;
                tmp0.w = tmp1.x * tmp0.w + tmp1.y;
                tmp0.w = 1.570796 - tmp0.w;
                tmp0.w = tmp0.w * 0.3183099 + 0.5;
                tmp0.z = tmp0.z + 0.5;
                tmp1.xy = tmp0.xx * float2(_RotationSpeed.x, _DistortionFlow.x);
                tmp0.z = tmp1.x * 0.1 + tmp0.z;
                tmp0.w = tmp0.w * _Scalar6 + _MainTex_ST.z;
                tmp0.w = tmp1.y * 0.1 + tmp0.w;
                tmp1.x = _Scalar5 * 0.01108;
                tmp1.y = inp.texcoord2.z * _Scalar5;
                tmp1.y = tmp1.y * 0.0183;
                tmp2.xy = tmp0.zw;
                tmp1.z = 1.0;
                for (float i = tmp1.z; i < 19.0; i += 1) {
                    tmp1.w = i * 3.0;
                    tmp2.zw = tmp1.ww * tmp2.yx + tmp0.yy;
                    tmp1.w = sin(tmp2.z);
                    tmp1.w = tmp1.x * tmp1.w + tmp2.x;
                    tmp2.x = i * 4.0 + tmp1.w;
                    tmp1.w = cos(tmp2.w);
                    tmp1.w = tmp1.y * tmp1.w + tmp2.y;
                    tmp2.y = i * 4.0 + tmp1.w;
                }
                tmp0.yz = tmp2.xy * float2(6.283185, 6.283185);
                tmp0.w = 1 - _Rings;
                tmp1.y = floor(tmp0.w);
                tmp1.xz = floor(float2(_LineMultiplier.x, _Rings.x));
                tmp1.xy = tmp1.yz * tmp1.xx;
                tmp0.w = inp.texcoord2.y * _Twist;
                tmp0.yz = tmp0.yz * tmp1.xy + tmp0.ww;
                tmp0.y = tmp0.z + tmp0.y;
                tmp0.y = cos(tmp0.y);
                tmp0.y = tmp0.y + _ColorOffset;
                tmp0.x = tmp0.x * _ColorRotation + tmp0.y;
                tmp0.y = tmp0.x >= -tmp0.x;
                tmp0.x = frac(abs(tmp0.x));
                tmp0.x = tmp0.y ? tmp0.x : -tmp0.x;
                tmp0.y = _PaletteIndex;
                tmp0 = tex2D(_MainTex, tmp0.xy);
                tmp1.x = inp.texcoord2.x * 10.0;
                tmp1.xyz = saturate(tmp1.xxx);
                tmp2.xyz = tmp0.xyz;
                tmp2.w = _BlackGradientApply;
                tmp1.w = _BlackGradientApply;
                tmp1 = tmp1 * tmp2;
                tmp2.x = _BlackGradientApply;
                tmp2.w = tmp0.w;
                tmp2.y = 1.0 - _BlackGradientApply;
                tmp0 = tmp0 * tmp2.yyyy;
                tmp0 = tmp1 * tmp2.xxxw + tmp0;
                tmp1.x = trunc(tmp0.w);
                tmp0.w = -tmp1.x * _MovementAlpha + tmp0.w;
                o.sv_target.w = saturate(tmp0.w + _MovementAlpha);
                o.sv_target.xyz = tmp0.xyz;
                return o;
			}
#endif
			ENDCG
		}
	}
}