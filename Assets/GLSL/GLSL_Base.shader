Shader "GLSL/GLSL_Base"
{
	Properties
	{
		//添加任何变量
	}

	SubShader
	{
		Tags { "Queue" = "Geometry" }

		Pass
		{
			GLSLPROGRAM

			#ifdef VERTEX
			//在这里添加顶点着色器代码
			main()
			{
				gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
			}
			#endif

			#ifdef FRAGMENT
			//在这里添加片段着色器代码
			main()
			{
				gl_FragColor = vec4 (1.0, 1.0, 1.0, 1.0);
			}
			#endif

			ENDGLSL   
		}
	}
	
	FallBack "VertexLit"
}
