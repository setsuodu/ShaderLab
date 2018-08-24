Shader "GLSL/GLSL_Diffuse" {
	Properties {
		_MainTex("MainTex", 2D) = "white"{}
		_Color ("Diffuse Material Color", Color) = (1,1,1,1) 
	}
	
	SubShader {
		Pass {
			Tags { "LightMode" = "ForwardBase" }
			// make sure that all uniforms are correctly set
			
			GLSLPROGRAM
			uniform vec4 _Color; // shader property specified by users
			// The following built-in uniforms (except _LightColor0)
			// are also defined in "UnityCG.glslinc",
			// i.e. one could #include "UnityCG.glslinc"
			uniform mat4 _Object2World; // model matrix
			uniform mat4 _World2Object; // inverse model matrix
			uniform vec4 _WorldSpaceLightPos0;
			// direction to or position of light source
			uniform vec4 _LightColor0;
			// color of light source (from "Lighting.cginc")
			
			#ifdef VERTEX
			
			out vec4 color;
			
			void main()
			{
				//world 转到 model
				mat4 modelMatrix = _Object2World;

				//model 转到 world
				mat4 modelMatrixInverse = _World2Object;
			
				//normal从model转到world
				//和下面那行代码功能一样，注意乘的顺序
				//vec3 normalDirection = normalize(vec3(vec4(gl_Normal, 0.0) * modelMatrixInverse));

				//normal从model转到world
				//和上面那行代码功能一样，注意乘的顺序
				//可以把这行代码注释掉，把上面那行取消注释,效果一样
				vec3 normalDirection = normalize(vec3(modelMatrix * vec4(gl_Normal, 0.0)));
			
				//light direction
				vec3 lightDirection = normalize(vec3(_WorldSpaceLightPos0));
			
				//diffuse color计算
				//opengl中：两向量这样相乘：v1 * v2为各分部相乘为一个新向量v3
				vec3 diffuseReflection = vec3(_LightColor0) * vec3(_Color) * max(0.0, dot(normalDirection, lightDirection));

				//把color传到fragment shader中去
				color = vec4(diffuseReflection, 1.0);

				//顶点坐标变换
				gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
			}
		
			#endif
		
			#ifdef FRAGMENT
		
			in vec4 color;
		
			void main()
			{
				gl_FragColor = color;
			}
		
			#endif
		
			ENDGLSL
		}
	}

	// The definition of a fallback shader should be commented out 
	// during development:
	Fallback "Diffuse"
}
