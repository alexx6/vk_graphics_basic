#version 450

layout (triangles) in;
layout (triangle_strip, max_vertices = 12) out;

layout(push_constant) uniform params_t
{
    mat4 mProjView;
    mat4 mModel;
    float time;
} params;

layout(location = 0) in GS_IN
{
    vec3 wPos;
    vec3 wNorm;
    vec3 wTangent;
    vec2 texCoord;
} gIn[];

layout(location = 0) out GS_OUT
{
    vec3 wPos;
    vec3 wNorm;
    vec3 wTangent;
    vec2 texCoord;
} gOut;

void drawTriangle (vec3 p1, vec3 p2, vec3 p3)
{
    
    vec3 n = normalize(cross(p1 - p2, p1 - p3));

    gOut.wPos     = p1;
    gOut.wNorm    = n;
    gl_Position = params.mProjView * vec4(p1, 1.0);
    EmitVertex();

    gOut.wPos     = p2;
    gOut.wNorm    = n;
    gl_Position = params.mProjView * vec4(p2, 1.0);
    EmitVertex();

    gOut.wPos     = p3;
    gOut.wNorm    = n;
    gl_Position = params.mProjView * vec4(p3, 1.0);
    EmitVertex();

    EndPrimitive();

}

void main()
{
  float fs = 10.0;
  float es = 5.0; 

  vec3 fNorm = normalize(cross(gIn[0].wPos - gIn[1].wPos, gIn[0].wPos - gIn[2].wPos));
  drawTriangle(gIn[0].wPos, gIn[1].wPos, gIn[2].wPos);

  drawTriangle(gIn[0].wPos, gIn[1].wPos, (gIn[0].wPos + gIn[1].wPos + gIn[2].wPos) / 3.0 + fNorm * (es + abs(sin(params.time + gIn[0].wPos.x * 5.0)) * 5) / 100.0);
  drawTriangle(gIn[0].wPos, (gIn[0].wPos + gIn[1].wPos + gIn[2].wPos) / 3.0 + fNorm * (es + abs(sin(params.time + gIn[0].wPos.x * 5.0)) * 5) / 100.0, gIn[2].wPos);
  drawTriangle((gIn[0].wPos + gIn[1].wPos + gIn[2].wPos) / 3.0 + fNorm * (es + abs(sin(params.time + gIn[0].wPos.x * 5.0)) * 5) / 100.0, gIn[1].wPos, gIn[2].wPos);
}