// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'
Shader "Tutorial/03-UseStruct" {

	SubShader {
		Pass {
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			// 结构体作参数，封装属性
			// application to vertex
			struct a2v {
				float4 vertex:POSITION; //坐标，旋转用float4。必须用语言，让操作系统给参数传值。模型空间的坐标传给vertex
				float3 normal:NORMAL; //方向是向量float3表示。模型空间的法线方向传给normal
				float4 texcoord:TEXCOORD0; //第0套uv，0~1是有效范围。让os把第0套纹理坐标传给texcoord
			};
			
			// 顶点函数的返回值，返回值必须有语义，不然系统不知道如何处理
			// vertex to fragment
			struct v2f {
				float4 position:SV_POSITION; //os会把position作为顶点在剪裁空间的坐标。
				//传递法线，定义一个float3
				float3 temp:COLOR0; //NORMAL在片元函数中取不到，所以转存到COLOR0中，传递给片元函数
			};

			v2f vert(a2v v) {
				v2f f;
				f.position = UnityObjectToClipPos(v.vertex);
				f.temp = v.normal; //把法线信息，存储到结构体中
				return f;
			}
			
			// 014 顶点、片元函数间的数据传递
			// 有些语义只能在顶点函数中使用，有些语义只能在片元函数中使用，取不到会报错
			// 类型 函数名(传入的参数的类型 传入的值):返回值语义
			fixed4 frag(v2f f):SV_Target {
				//fixed4 col = fixed4(0.5,0.5,1,1);
				fixed4 col = fixed4(f.temp,1); //顶点函数中只给模型顶点赋了颜色值，相邻顶点间的像素是os通过差值计算出来的
				return col;
			}

			ENDCG
		}
	}
	FallBack "VertexLit"
}
