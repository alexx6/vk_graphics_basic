#version 450
#extension GL_ARB_separate_shader_objects : enable
#extension GL_GOOGLE_include_directive : require

#include "common.h"

layout(location = 0) out vec4 out_sceneColor;

layout(binding = 0) uniform AppData
{
  UniformParams Params;
};
layout (binding = 1) uniform sampler2D hdrImage;

layout (location = 1) in VS_OUT
{
  vec2 texCoord;
} surf;

vec3 uncharted2_tonemap_partial(vec3 x)
{
    float A = 0.15f;
    float B = 0.50f;
    float C = 0.10f;
    float D = 0.20f;
    float E = 0.02f;
    float F = 0.30f;
    return ((x*(A*x+C*B)+D*E)/(x*(A*x+B)+D*F))-E/F;
}

vec3 uncharted2_filmic(vec3 v)
{
    float exposure_bias = 2.0f;
    vec3 curr = uncharted2_tonemap_partial(v * exposure_bias);

    vec3 W = vec3(11.2f);
    vec3 white_scale = vec3(1.0f) / uncharted2_tonemap_partial(W);
    return curr * white_scale;
}

void main()
{
    vec4 color = textureLod(hdrImage, surf.texCoord, 0);
    if (Params.tmEnabled)
    {
        color = vec4(uncharted2_filmic(color.rgb), 1.0);
    }
    out_sceneColor = color;
}