// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

Shader "Tutorial/04-DiffuseVertex" {

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

			struct a2v {
				float4 vertex:POSITION;
				float3 normal:NORMAL; //模型空间
			};
			
			struct v2f {
				float4 position:SV_POSITION;
				fixed3 color:COLOR;
			};

			v2f vert(a2v v) {
				v2f f;
				f.position = UnityObjectToClipPos(v.vertex);

				//cos(x) = 光的方向·法线方向
				//normalize用来把一个向量单位化（方向不变，长度变为1，用fixed保存）
				fixed3 lightDir = normalize(_WorldSpaceLightPos0.xyz); //第一个直射光的位置（对直射光而言，位置就是方向）世界空间
				
				//mul(_World2Object,向量) 是从模型空间转换到世界空间
				//mul(向量,_World2Object) 可以让语义实现反向的效果
				fixed3 normalDir = mul(v.normal, (float3x3)unity_WorldToObject); //mul的参数，位数要一致

				 //暂不处理透明度a
				fixed3 diffuse = _LightColor0.rgb * max(0, dot(lightDir, normalDir)); //空间要相同，统一到世界空间
				fixed3 mul_light = diffuse * _Diffuse.rgb; //两个颜色相乘叠加，Multipy，亮度变暗，红*绿=黑。

				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.rgb;
				fixed3 add_env = mul_light + ambient;

				//通过结构体的中间变量，传递到片元函数中显示
				f.color = add_env;

				return f;
			}
			
			fixed4 frag(v2f f):SV_Target {
				//fixed4 col = fixed4(1,1,1,1);
				fixed4 col = fixed4(f.color,1);
				return col;
			}

			ENDCG
		}
	}
	FallBack "Diffuse"
}
