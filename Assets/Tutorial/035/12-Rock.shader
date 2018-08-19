// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Tutorial/12-Rock" {

	Properties {
		_Color("Color", Color) = (1,1,1,1)
		_MainTex("MainTex",2D) = "white"{}
		_NormalMap("NormalMap",2D) = "bump"{}
		_BumpScale("Bump Scale", Float) = 1 //法线力度
	}

	SubShader {
		Pass {
			Tags{"LightMode"="ForwardBase"}
			
			CGPROGRAM
#include "Lighting.cginc"
#pragma vertex vert
#pragma fragment frag
			
			fixed4 _Color;
			sampler2D _MainTex;
			float4 _MainTex_ST;
			sampler2D _NormalMap;
			float4 _NormalMap_ST;
			float _BumpScale;
			
			struct a2v
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
				//通过语义取得切线。切线与法线是垂直的，切线空间是通过(模型中的)法线和(模型中的)切线确定的
				float4 tangent : TANGENT; //tangent.w用来确定切线空间方向。
				fixed4 texcoord : TEXCOORD0;
			};
			
			struct v2f {
				float4 position:SV_POSITION;
				float3 lightDir:TEXCOORD0; //顶点函数中计算出光照方向，传递到片元函数
				float3 worldVertex:TEXCOORD1;
				float4 uv:TEXCOORD2; //xy用来存MainTex纹理坐标,zw用来存法线纹理坐标
			};
			
			v2f vert(a2v v) {
				v2f f;
				f.position = UnityObjectToClipPos(v.vertex);

				f.worldVertex = mul(v.vertex, unity_WorldToObject).xyz;
				f.uv.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw; //贴图的纹理坐标
				f.uv.zw = v.texcoord.xy * _NormalMap_ST.xy + _NormalMap_ST.zw; //法线贴图的纹理坐标
				
                TANGENT_SPACE_ROTATION; // 调用这个宏会得到一个矩阵rotation，该矩阵用来把模型空间下的方向转换为切线空间下

                f.lightDir = mul(rotation, ObjSpaceLightDir(v.vertex)); // 切线空间下，平行光的方向

				return f;
			}
			
			// 统一空间，与法线空间有关的都放在切线空间下，因为法线贴图中取得的法线方向是在切线空间下的
			fixed4 frag(v2f f):SV_Target {
				
				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.rgb;

				fixed4 normalColor = tex2D(_NormalMap, f.uv.zw); //获取法线贴图颜色
                //fixed3 tangentNormal = normalize(normalColor.xyz * 2 - 1); // 切线空间下的法线方向，发现计算得到的法线不正确！
				fixed3 tangentNormal = UnpackNormal(normalColor); // 使用Unity内置的方法，从颜色值得到法线在切线空间的方向
				
				tangentNormal.xy = tangentNormal.xy * _BumpScale; // 控制凹凸程度
				tangentNormal = normalize(tangentNormal); // 再次单位化

				fixed3 lightDir = normalize(f.lightDir);

				//用像素映射的纹理坐标对应的颜色 代替 _Diffuse.rgb 
				fixed3 texColor = tex2D(_MainTex, f.uv.xy) * _Color.rgb;
				fixed3 diffuse = _LightColor0.rgb * texColor * max( dot( tangentNormal, lightDir), 0);
				
				fixed3 tempColor = diffuse + ambient * texColor; //Add/Multiply
				return fixed4(tempColor, 1);
			}

			ENDCG
		}
	}
	FallBack "Diffuse"
}
