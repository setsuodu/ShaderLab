﻿// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/CutPixelByDistance"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white"{}
	}

	SubShader
	{
		Tags { "Queue" = "Transparent" "RenderType" = "Opaque" }
		
		LOD 100
		Blend SrcAlpha OneMinusSrcAlpha
		
		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_fog // make fog work
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				UNITY_FOG_COORDS(1)
				float4 vertex : SV_POSITION;
				float lengthInCamera : TEXCOORD1;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;

			v2f vert(appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);

				//计算顶点和camera之间的距离  
				o.lengthInCamera = length(_WorldSpaceCameraPos - v.vertex.xyz);
				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				// sample the texture  
				fixed4 col = tex2D(_MainTex, i.uv);
				col.a = 1;

				float Start = 3;//设定开始值  
				float End = 2.5;//设定结束值  
							//如果像素和camera直接的距离小于Start则给alpha赋值  
				if (i.lengthInCamera < Start)
				{
					col.a = i.lengthInCamera / (Start - End) - End / (Start - End);
				}
				return col;
			}

			ENDCG
		}
	}
}
