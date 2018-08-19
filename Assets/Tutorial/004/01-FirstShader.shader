Shader "Tutorial/01-FirstShader" 
{
	//属性
	Properties
	{
		//_变量名(Inspector中显示的名字, 类型)=赋值
		//_是命名习惯
		_Color ("Color", Color) = (1,1,1,1) //_Color变量名与VertexLit中耦合了，所以可以影响效果
		_Colour ("Colour", Color) = (1,1,1,1) //float4
		_Vector("Vector", Vector) = (1,2,3,4) //float4
		_Int("Int", Int)=234 //float
		_Float("Float", Float)=4.5 //float
		_Range("Range", Range(1,11))=6 //float
		_2D("Texture2D", 2D)= "red"{} //sampler2D //当不指定图片时，默认为是纯红色贴图
		_3D("Texture3D", 3D)= "red"{} //sampler3D
		_Cube("Cube", Cube)= "white"{} //samplerCube
	}
	
	//SubShader可以有很多个，增加支持适应性。
	//显卡运行时，优先执行前面的。
	//第一个SubShader的效果都支持，就使用第一个。
	//某些效果实现不了，就自动运行下一个SubShader。
	SubShader
	{
		//可以有多个Pass块，至少有一个
		//类似C#的function（方法）
		//Pass中编写实际的Shader代码
		Pass 
		{
			CGPROGRAM
			//使用CG语言编写Shader

			//如何使用Properties
			//对Properties中的属性重新定义一下
			//名字一致，不用赋值，会自动取到Properties中的值
			float4 _Color;
			float4 _Vector;
			float3 t3;
			float2 t2;
			float _Int; //float half fixed内存大小不同
			float _Float;
			float _Range;
			sampler2D _2D;
			sampler3D _3D;
			samplerCube _Cube;
			//float 二进制，32位存储，3.4E-38 ~3.4E+38
			//half 二进制，16位存储，-60000 ~60000
			//fixed 二进制，11位存储，-2 ~2，颜色0~1，比较合适使用fixed存储



			ENDCG
		}
	}
	
	Fallback "VertexLit" //当所有SubShader都不支持时的后备方案
}
