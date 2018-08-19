Shader "Custom/Pick"
{
	Properties 
	{
		_Diffuse("Diffuse Color", Color) = (1,1,1,1)
		_Ramp("Ramp", 2D) = "white"{}
		_Intensity("Intensity", Range(0, 1)) = 0
		_Points("Points", Vector) = (0.2, 0.2, 0, 0)
	}

	SubShader
	{
		Tags { "Queue" = "Transparent" }
		Blend SrcAlpha OneMinusSrcAlpha // Alpha blend

		Pass 
		{
			Tags { "LightMode"="ForwardBase" }

			CGPROGRAM
			#include "Lighting.cginc"
			#pragma vertex vert
			#pragma fragment frag

			fixed3 _Diffuse;
			sampler2D _Ramp;
			fixed _Intensity;
			float4 _Points;
			
			struct a2v
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};
			
			struct v2f
			{
				float4 position : SV_POSITION;
				float3 worldPos : TEXCOORD0;
				float2 uv : TEXCOORD1;
			};

			v2f vert(a2v v)
			{
				v2f f;
				f.position = UnityObjectToClipPos(v.vertex);
				f.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				f.uv = v.uv;
				return f;
			}
			
			fixed4 frag(v2f f) : SV_Target
			{
				fixed4 diffuse = (1,1,1,1);

				//TODO:传入多个点坐标Points，遍历，分别赋值

                float dist = distance(f.uv, float2(_Points.x, _Points.y));
                if(dist < 0.1)
				{
					fixed2 _x = saturate(fixed2(_Intensity, 0.5));
					diffuse = fixed4(tex2D(_Ramp, _x).rgb, 1);
                }
				
                float dist1 = distance(f.uv, float2(0.7, 0.5));
                if(dist1 < 0.1)
				{
					fixed2 _x = saturate(fixed2(_Intensity + 0.4, 0.5));
					diffuse = fixed4(tex2D(_Ramp, _x).rgb, 1);
                }

				return diffuse;
			}

			ENDCG
		}
	}

	FallBack "Diffuse"
}
