#version 450

layout(location = 0) out vec4 fragColor;

layout (location = 0 ) in VS_OUT
{
  vec3 wPos;
  vec3 wNorm;
  vec3 wTangent;
  vec2 texCoord;
} surf;

void main()
{
	fragColor = vec4(gl_FragCoord.z, gl_FragCoord.z * gl_FragCoord.z, gl_FragCoord.z, 1.0);
}