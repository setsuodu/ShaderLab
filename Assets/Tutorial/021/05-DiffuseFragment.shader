// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

Shader "Tutorial/05-DiffuseFragment" {

	Properties {
		_Diffuse("Diffuse Color", Color)=(0.5,0.7,0.6,1)
	}

	SubShader {
		Pass {
			Tags {
				"LightMode"="ForwardBase"
			}

			CGPROGRAM
		#include "Lighting.cginc" //取得第一个直射光的颜色（多个光时另外处理） _LightColor0
		#pragma vertex vert
		#pragma fragment frag

			fixed3 _Diffuse; //
			
			//应用到顶点
			struct a2v {
				float4 vertex:POSITION;
				float3 normal:NORMAL; //模型空间
			};
			
			//顶点到片元
			struct v2f {
				float4 position:SV_POSITION;
				//fixed3 color:COLOR;
				fixed3 worldNormalDir:COLOR; //语义只能取一次
			};

			v2f vert(a2v v) {
				v2f f;
				f.position = UnityObjectToClipPos(v.vertex);
				//f.worldNormalDir = v.normal;
				f.worldNormalDir = mul(v.normal, (float3x3)unity_WorldToObject);
				return f;
			}
			
			//逐片元计算，效果比逐顶点细腻，减少一楞一楞的效果，耗费性能多
			fixed4 frag(v2f f):SV_Target {
			
				fixed3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
				
				//片元不能调用NORMAL语义，需要从顶点函数中传递过来
				fixed3 normalDir = normalize(f.worldNormalDir);

				fixed3 diffuse = _LightColor0.rgb * max(0, dot(lightDir, normalDir));
				fixed3 mul_light = diffuse * _Diffuse.rgb;

				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.rgb;
				fixed3 add_env = mul_light + ambient;

				fixed4 col = fixed4(add_env,1);
				return col;
			}

			ENDCG
		}
	}
	FallBack "Diffuse"
}
