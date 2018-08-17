Shader "Tutorial/08-SpecularFragment" {

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
				float3 worldNormal:TEXCOORD0; //作存储介质，没意义
				float3 worldVertex:TEXCOORD1;
			};

			v2f vert(a2v v) {
				v2f f;
				f.position = UnityObjectToClipPos(v.vertex);
				f.worldNormal = mul(v.normal, (float3x3)unity_WorldToObject);
				f.worldVertex = mul(v.vertex, unity_WorldToObject).xyz;
				return f;
			}
			
			fixed4 frag(v2f f):SV_Target {
			
				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.rgb;

				fixed3 normalDir = normalize(f.worldNormal);

				fixed3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
				
				fixed3 diffuse = _LightColor0.rgb * max( dot(lightDir, normalDir), 0)* _Diffuse.rgb;

				//反射光方向，凡是方向，都要单位化
				fixed3 reflectDir = normalize(reflect(-lightDir, normalDir));
				//视野方向 = 相机方向 - 点的方向
				fixed3 viewDir = normalize(_WorldSpaceCameraPos.xyz - f.worldVertex);
				
				fixed3 specular = _LightColor0.rgb * _Specular.rgb * pow( max( dot(reflectDir,viewDir), 0), _Gloss);

				fixed3 tempColor = diffuse + ambient + specular; //Add/Multiply

				fixed4 col = fixed4(tempColor.rgb, 1);

				return col;
			}

			ENDCG
		}
	}
	FallBack "Diffuse"
}
