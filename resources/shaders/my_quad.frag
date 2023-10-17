#version 450
#extension GL_ARB_separate_shader_objects : enable

layout(location = 0) out vec4 color;

layout (binding = 0) uniform sampler2D colorTex;


layout (location = 0 ) in VS_OUT
{
  vec2 texCoord;
} surf;

//physiological luminance coefficients from stackoverflow
const vec3 LC = vec3(0.2126, 0.7152, 0.0722); 

//results with windowSize = 2n+1 are the same as windowSize = 2n
const int windowSize = 3; 

vec3 findLuminanceMedian(in vec3 colors[windowSize * windowSize])
{
	//sorting by luminance
	bool flag = true;
	while (flag)
	{
		flag = false;
		for(int i = 0; i < windowSize * windowSize - 1; ++i)
		{
			if (dot(colors[i], LC) > dot(colors[i + 1], LC))
			{
				vec3 tmp = colors[i];
				colors[i] = colors[i + 1];
				colors[i + 1] = tmp;
				flag = true;
			}
		}
	}

	//returning middle color in sorted array
	return colors[windowSize * windowSize / 2];
}

void main()
{
	vec3 colors[windowSize * windowSize];
	ivec2 ts = textureSize(colorTex, 0);
	float texelX = 1.0 / ts.x;
	float texelY = 1.0 / ts.y;

	for (int i = -windowSize / 2; i <= windowSize / 2; ++i)
	{
		for (int j = -windowSize / 2; j <= windowSize / 2; ++j)
		{
			colors[(i + windowSize / 2) * windowSize + j + windowSize / 2] = texture(colorTex, surf.texCoord + vec2(i * texelX, j * texelY)).rgb;
		}
	}
	color = vec4(findLuminanceMedian(colors), 1.0);
}


//got ~2300 fps with windowSize = 3
//got ~340 fps with windowSize = 7
//got ~20 fps with windowSize = 11
//this is very unoptimal because of bubble sort O(windowSize^4)