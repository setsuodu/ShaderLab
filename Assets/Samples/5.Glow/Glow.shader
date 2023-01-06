Shader "Outline/Glow" 
{
	Properties
	{
		_Color("Color", Color) = (1, 0.6, 0, 1)
		_GlowColor("Glow Color", Color) = (1,1,0,1)
		_Strength("Glow Strength", Range(5.0, 1.0)) = 2.0
		_GlowRange("Glow Range", Range(0.1,1)) = 0.6
	}

	SubShader
	{
		Pass 
		{
			Tags { "LightMode" = "ForwardBase" }

			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag

			float4 _Color;

			float4 vert(float4 vertexPos : POSITION) : SV_POSITION 
			{
				return UnityObjectToClipPos(vertexPos);
			}

			float4 frag(void) : COLOR 
			{
				return _Color;
			}

			ENDCG
		}

		Pass 
		{
			Tags { "LightMode" = "ForwardBase" "Queue" = "Transparent" "RenderType" = "Transparent" }
			// Cull Front
			ZWrite Off
			Blend SrcAlpha OneMinusSrcAlpha

			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			float4 _GlowColor;
			float _Strength;
			float _GlowRange;

			struct a2v 
			{
				float4 vertex : POSITION;
				float4 normal : NORMAL;
			};

			struct v2f 
			{
				float4 position : SV_POSITION;
				float4 col : COLOR;
			};

			v2f vert(a2v a)
			{
				v2f o;

				float3 normalDirection = normalize(UnityObjectToWorldNormal(a.normal));

				float3 worldPos = mul(unity_ObjectToWorld, a.vertex).xyz;
				float3 viewDirection = normalize(UnityWorldSpaceViewDir(worldPos));

				float4 pos = a.vertex + (a.normal * _GlowRange);
				o.position = UnityObjectToClipPos(pos);
				float strength = abs(dot(viewDirection, normalDirection));
				float opacity = pow(strength, _Strength);
				float4 col = float4(_GlowColor.xyz, opacity);
				o.col = col;
				return o;
			}

			float4 frag(v2f i) : COLOR 
			{
				return i.col;
			}

			ENDCG
		}
	}
	FallBack "Diffuse"
}