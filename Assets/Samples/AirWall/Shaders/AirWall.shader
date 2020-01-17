// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'
Shader "SetsuOdu/AirWall"
{
	Properties
	{
		_FieldTex ("Field Texture" ,2D) = "" {}
		_Color ("Mask Color", Color) = (1.0, 0.0, 0.0, 0.2)
		_Offset("Mask Offset", Float) = 3.0
		_Pow("Mask Feather", Float) = 3.0
	}

	Category
	{
		Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" }
		Blend One One
		Cull Off Lighting Off ZWrite Off Fog { Mode Off }

		SubShader
		{
			Pass
			{
				CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag
				#pragma glsl

				#include "UnityCG.cginc"

				fixed4 _Pos_0;
				fixed4 _Pos_1;
				fixed4 _Pos_2;
				fixed4 _Pos_3;
				fixed4 _Pos_4;
				fixed4 _Pos_5;
				fixed4 _Pos_6;
				fixed4 _Pos_7;
				fixed4 _Pos_8;
				fixed4 _Pos_9;
				fixed4 _Pos_10;
				fixed4 _Pos_11;
				fixed4 _Pos_12;
				fixed4 _Pos_13;
				fixed4 _Pos_14;
				fixed4 _Pos_15;
				fixed4 _Pos_16;
				fixed4 _Pos_17;
				fixed4 _Pos_18;
				fixed4 _Pos_19;
				fixed4 _Pos_20;
				fixed4 _Pos_21;
				fixed4 _Pos_22;
				fixed4 _Pos_23;

				sampler2D _FieldTex;
				fixed4 _FieldTex_ST;
			
				fixed4 _Color;

				fixed _Offset;
				fixed _Pow;

				struct a2v {		
					fixed4 vertex : POSITION;				
					fixed4 texcoord : TEXCOORD0;
					fixed4 normal : NORMAL;
				};

				struct v2f {
					fixed4 vertex : SV_POSITION;
					fixed2 uv : TEXCOORD0;
					fixed4 oPos : TEXCOORD2;
					fixed4 normal: TEXCOORD3;
				};

				fixed2 uvPanner(fixed2 uv, fixed x, fixed y)
				{
					fixed t = _Time;
					return fixed2(uv.x + x * t, uv.y + y * t);
				}

				/// VERTEX
				v2f vert (a2v v)
				{
					v2f o;

					v.vertex.xyz += v.normal * 0;
					o.vertex = UnityObjectToClipPos(v.vertex);
					o.oPos = v.vertex;
					o.normal = v.normal;
					o.uv = TRANSFORM_TEX ( v.texcoord, _FieldTex );

					return o;
				}

				/// FRAGMENT
				fixed4 frag (v2f i) : COLOR
				{
					int interpolators = 24;
					fixed4 pos[24];
				
					fixed3 field_Mask = 0.0;

					pos[0] = _Pos_0;
					pos[1] = _Pos_1;
					pos[2] = _Pos_2;
					pos[3] = _Pos_3;
					pos[4] = _Pos_4;
					pos[5] = _Pos_5;
					pos[6] = _Pos_6;
					pos[7] = _Pos_7;
					pos[8] = _Pos_8;
					pos[9] = _Pos_9;
					pos[10] = _Pos_10;
					pos[11] = _Pos_11;
					pos[12] = _Pos_12;
					pos[13] = _Pos_13;
					pos[14] = _Pos_14;
					pos[15] = _Pos_15;
					pos[16] = _Pos_16;
					pos[17] = _Pos_17;
					pos[18] = _Pos_18;
					pos[19] = _Pos_19;
					pos[20] = _Pos_20;
					pos[21] = _Pos_21;
					pos[22] = _Pos_22;
					pos[23] = _Pos_23;

					for(int x = 0; x < interpolators; x++)
					{
						fixed dist = distance(pos[x].xyz, i.oPos.xyz);
						field_Mask += saturate((1 - dist * _Offset)) * pos[x].w;
					}
					
					fixed field_Tex = pow(tex2D(_FieldTex, uvPanner(i.uv, 0, 0)), 2.2).r;
					
					field_Mask = saturate(field_Mask * _Color.rgb);
					
					fixed3 final = field_Tex * field_Mask + field_Mask * _Color.a;
					
					return fixed4(final, 1.0);
				}
				ENDCG
			}
		}
	}
}
