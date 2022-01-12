#vertex shader
#version 430 core

layout(location = 0) in vec3 vPos;
layout(location = 1) in vec3 vNormal;

uniform vec3 camPos;

uniform mat4 view;
uniform mat4 projection;

void main() {
	gl_Position = vec4(vPos, 1) * view * projection;
	float distance = length(camPos - vPos);
	if (distance > 200)
		gl_Position.z = gl_Position.w + 1;
}





#fragment shader
#version 430 core

out vec4 color;

void main() {
	color = vec4(0, 0, 0, 1);	
}