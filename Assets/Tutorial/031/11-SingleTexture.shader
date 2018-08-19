Shader "Tutorial/11-SingleTexture" {

	Properties {
		_MainTex("MainTex",2D)="white"{}
		_Color("Color", Color) = (1,1,1,1)
		_Specular("Specular", Color) = (1,1,1,1)
		_Gloss("Gloss", Range(10,200)) = 20
	}

	SubShader {
		Pass {
			Tags{"LightMode"="ForwardBase"}
			
			CGPROGRAM
			#include "Lighting.cginc"
			#pragma vertex vert
			#pragma fragment frag

			sampler2D _MainTex;
			float4 _MainTex_ST;
			fixed4 _Color;
			fixed4 _Specular;
			half _Gloss;

			struct a2v {
				float4 vertex:POSITION;
				float4 normal:NORMAL;
				fixed4 texcoord:TEXCOORD0;
			};
			
			struct v2f {
				float4 pos : SV_POSITION; //屏幕空间
				float3 worldNormal : TEXCOORD0;
				float3 worldVertex : TEXCOORD1;
				float2 uv : TEXCOORD2;
			};

			v2f vert(a2v v) {
				v2f f;
				f.pos = UnityObjectToClipPos(v.vertex);
				f.worldNormal = UnityObjectToWorldNormal(v.normal);
				f.worldVertex = mul(v.vertex, unity_WorldToObject);
				f.uv = v.texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
				return f;
			}
			
			fixed4 frag(v2f f):SV_Target {
				
				fixed3 normalDir = normalize(f.worldNormal);
				fixed3 lightDir = normalize(UnityWorldSpaceLightDir(f.worldVertex)); //mul计算 或 使用内置方法取得

				//用像素映射的纹理坐标对应的颜色 代替 _Diffuse.rgb 
				//fixed3 diffuse = _LightColor0.rgb * _Diffuse.rgb * max( dot(normalDir, lightDir), 0); //计算漫反射
				fixed3 texColor = tex2D(_MainTex, f.uv) * _Color;
				fixed3 diffuse = _LightColor0.rgb * texColor * max( dot(normalDir, lightDir), 0); //tex2D(),通过uv坐标取颜色
				
				//环境光对纹理作用，需要融合处理，避免贴图变得不清晰
				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.rgb * texColor;

				fixed3 viewDir = normalize(UnityWorldSpaceViewDir(f.worldVertex));
				fixed3 halfDir = normalize((lightDir + viewDir)/2);
				fixed3 specular = _LightColor0.rgb * _Specular.rgb * pow( max( dot(normalDir,halfDir), 0), _Gloss); //计算高光
				
				fixed3 tempColor = diffuse + ambient + specular; //Add/Multiply
				return fixed4(tempColor, 1);
			}

			ENDCG
		}
	}
	FallBack "Specular"
}
