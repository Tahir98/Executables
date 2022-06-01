#vertex shader
#version 330 core

layout(location = 0) in vec2 pos;
layout(location = 1) in vec4 bufferColor;

out vec4 color;

uniform float width;
uniform float height;


void main() {
	gl_Position = vec4(-2.0 * (width - pos.x) / (width) + 1.0, -2.0 * (height - pos.y) / (height) + 1.0, 0.0, 1.0);
	color = bufferColor;
}


#fragment shader
#version 330 core

in vec4 color;
out vec4 oColor;

void main() {
	oColor = color;
}