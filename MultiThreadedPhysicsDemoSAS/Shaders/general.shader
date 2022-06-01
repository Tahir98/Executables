#vertex shader
#version 330 core

layout(location = 0) in vec3 vPos;
layout(location = 1) in vec4 vColor;

uniform mat4 model;
uniform mat4 view;
uniform mat4 projection;

out vec4 color;

void main() {
	color = vColor;

	vec4 pos = vec4(vPos,1.0);	
	gl_Position = pos * model * view * projection;
}


#fragment shader
#version 330 core

in vec4 color;
out vec4 fragColor;
void main() {
	fragColor = color;
}