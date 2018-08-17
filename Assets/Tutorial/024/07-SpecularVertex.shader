// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

Shader "Tutorial/07-SpecularVertex" {

	Properties {
		_Diffuse("Diffuse Color", Color)=(0.5,0.7,0.6,1)
		_Specular("Specular Color", Color)=(1,1,1,1)
		_Gloss("Gloss",Range(8,200))=10
	}

	SubShader {
		Pass {
			Tags {
				"LightMode"="ForwardBase"
			}

			CGPROGRAM
		#include "Lighting.cginc"
		#pragma vertex vert
		#pragma fragment frag

			fixed4 _Diffuse;
			fixed4 _Specular;
			half _Gloss;
			
			struct a2v {
				float4 vertex:POSITION;
				float3 normal:NORMAL;
			};
			
			struct v2f {
				float4 position:SV_POSITION;
				fixed3 color:COLOR;
			};

			v2f vert(a2v v) {
				v2f f;
				f.position = UnityObjectToClipPos(v.vertex);
				
				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.rgb;

				fixed3 normalDir = normalize(mul(v.normal, (float3x3)unity_WorldToObject));

				fixed3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
				
				fixed3 diffuse = _LightColor0.rgb * max( dot(lightDir, normalDir), 0)* _Diffuse.rgb;

				//反射光方向，凡是方向，都要单位化
				fixed3 reflectDir = normalize(reflect(-lightDir, normalDir));
				//视野方向 = 相机方向 - 点的方向
				fixed3 viewDir = normalize(_WorldSpaceCameraPos.xyz - mul(v.vertex, unity_WorldToObject).xyz);
				
				fixed3 specular = _LightColor0.rgb * _Specular.rgb * pow( max( dot(reflectDir,viewDir), 0), _Gloss);

				f.color = diffuse + ambient + specular; //Add/Multiply

				return f;
			}
			
			fixed4 frag(v2f f):SV_Target {
			
				fixed4 col = fixed4(f.color, 1);
				return col;
			}

			ENDCG
		}
	}
	FallBack "Diffuse"
}
