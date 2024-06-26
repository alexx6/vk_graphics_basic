#version 450
#extension GL_ARB_separate_shader_objects : enable
#extension GL_GOOGLE_include_directive : require

#include "unpack_attributes.h"
#include "common.h"

layout(vertices = 4) out;


void main(void)
{
   int t = 64;
   if (gl_InvocationID == 0) {
    gl_TessLevelInner[0] = t;
    gl_TessLevelInner[1] = t;

    gl_TessLevelOuter[0] = t;
    gl_TessLevelOuter[1] = t;
    gl_TessLevelOuter[2] = t;
    gl_TessLevelOuter[3] = t;
   }
}
