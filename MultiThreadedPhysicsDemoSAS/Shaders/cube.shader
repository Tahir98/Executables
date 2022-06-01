#vertex shader
#version 330 core

layout(location = 0) in vec3 vPos;
layout(location = 2) in vec3 vNormal;
layout(location = 1) in vec4 vColor;

uniform mat4 model;
uniform mat4 view;
uniform mat4 projection;

out vec3 normal;
out vec4 color;

void main() {
	gl_Position = vec4(vPos, 1.0f) * model * view * projection;
	normal = vNormal * mat3(model);
	color = vColor;
}


#fragment shader
#version 330 core

in vec3 normal;
in vec4 color;
out vec4 outputColor;

void main() {
	outputColor = vec4(color);
}