#vertex shader
#version 430 core

layout(location = 0) in vec3 vPos;
layout(location = 1) in vec3 vColor;

uniform vec3 position;
uniform mat4 view;
uniform mat4 projection;

out vec3 color;

void main() {
	color = vColor;

	gl_Position = vec4(vPos + position, 1.0f) * view * projection;
}


#fragment shader
#version 430 core

in vec3 color;

uniform vec3 u_color;

out vec4 o_color;

void main() {
	o_color = vec4(color * u_color, 1.0f);
}