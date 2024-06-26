#version 450
#extension GL_ARB_separate_shader_objects : enable
#extension GL_GOOGLE_include_directive : require

#include "unpack_attributes.h"
#include "common.h"

layout (quads) in;

layout(push_constant) uniform params_t
{
    mat4 mProjView;
    vec4 frequencyAndHeights;
} params;


layout (location = 0 ) out VS_OUT
{
    vec3 wPos;
    vec3 wNorm;
    vec3 wTangent;
    vec2 texCoord;
} vOut;


float rand(vec2 n) { 
	return fract(sin(dot(n, vec2(12.9898, 4.1414))) * 43758.5453);
}

float noise(vec2 p){
    p*= params.frequencyAndHeights[0];
	vec2 ip = floor(p);
	vec2 u = fract(p);
	u = u*u*(3.0-2.0*u);
	
	float res = mix(
		mix(rand(ip),rand(ip+vec2(1.0,0.0)),u.x),
		mix(rand(ip+vec2(0.0,1.0)),rand(ip+vec2(1.0,1.0)),u.x),u.y);
    
    float range = params.frequencyAndHeights[2] - params.frequencyAndHeights[1];

	return res * range + params.frequencyAndHeights[1];
}

void main(void)
{
    vec3 point = vec3(gl_TessCoord.x * 3.0, 0, gl_TessCoord.y * 3.0);
    point.y = noise(point.xz);

    vOut.wPos     = point;
    vOut.wNorm    = normalize(vec3((noise(point.xz - vec2(0.05, 0)) - noise(point.xz + vec2(0.05, 0))) / 0.1, 1, (noise(point.xz - vec2(0, 0.05)) - noise(point.xz + vec2(0, 0.05))) / 0.1));
    gl_Position   = params.mProjView * vec4(point, 1.0);
}
