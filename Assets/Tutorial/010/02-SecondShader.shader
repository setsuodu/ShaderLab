// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Tutorial/02-SecondShader" {

	SubShader {
		Pass {
			CGPROGRAM

			//shaderlab的内置函数
			//类似C#的Start，Update等内置方法

			//顶点函数，完成模型空间到剪裁空间的转换。
			//模型上的所有顶点的坐标，是相对与建模时指定的pivot。
			//顶点函数自动使模型空间的顶点坐标，转换到剪裁坐标（摄像机剪裁）。
			//也可以自定义使对顶点做一些变换，使顶点坐标发生改变。
			//#pragma vertex是固定的，表示顶点函数。vert是函数名。
			#pragma vertex vert

			//片元函数
			//返回模型在应屏幕上的每一个像素的颜色值。
			#pragma fragment frag


			//返回值 函数名(参数:语义):语义 { }
			float4 vert(float4 v:POSITION):SV_POSITION //float4对矩阵转换提供方便
			{
				//参数的语义，告诉系统要什么（让系统把模型的顶点坐标传递给v）
				//返回值的语义，告诉系统返回值是什么（返回值是剪裁空间下的顶点坐标）
				//每个顶点都经过这个函数，有了剪裁空间的坐标

				//坐标系转换，矩阵
				//mul，用来完成矩阵和position的乘法运算，使模型空间的坐标，转换到剪裁空间
				//UNITY_MATRIX_MVP，用宏代替这个矩阵
				float4 pos = UnityObjectToClipPos(v); 
				//或写成 float4 pos = mul(UNITY_MATRIX_MVP, v);
				return pos;

				//UnityCG.cginc中一些常用的函数
				//摄像机方向（视角方向）
				//float3 WorldSpaceViewDir(float4 v); //根据模型空间中的顶点坐标，得到世界空间从这个点到摄像机的观察方向
				//float3 UnityWorldSpaceViewDir(float4 v); //世界空间中的顶点坐标 ==>> 世界空间从这个点到摄像机的观察方向
				//float3 ObjSpaceViewDir(float4 v);  //模型空间中的顶点坐标 ==>> 模型空间从这个点到摄像机的观察方向

				//光源方向
				//float3 WorldSpaceLightDir(float4 v); //模型空间顶点坐标 ==>> 世界空间从这个点到光源的方向
				//float3 UnityWorldSpaceLightDir(float4 v); //世界空间顶点坐标 ==>> 世界空间从这个点到光源的方向
				//float3 ObjSpaceLightDir(float4 v); //模型空间顶点坐标 ==>> 模型空间中从这个点到光源的方向

				//方向转换
				//float3 UnityObjectToWorldNormal(float3 norm); //把法线从 模型空间->世界空间
				//float3 UnityObjectToWorldDir(float3 dir); //把方向从 模型空间->世界空间
				//float3 UnityWorldToObjectDir(float3 dir); //把方向从 世界空间->模型空间
			}

			
			fixed4 frag():SV_Target {
				//SV_Target语义，对应盘面上的颜色
				fixed4 col = fixed4(0.5,0.5,1,1);
				return col;

				//return _Color;
			}


			ENDCG
		}
	}

	FallBack "Diffuse"
}
