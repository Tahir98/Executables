#vertex shader
#version 430 core

layout(location = 0) in vec3 vPos;
layout(location = 0) in vec3 vTex;

out vec3 texCoord;

void main() {
	gl_Position = vec4(vPos, 1);
	texCoord = vTex;
}





#fragment shader
#version 430 core

in vec3 texCoord;

uniform sampler2D tex;
out vec4 color;

void main() {
	color = texture(tex,texCoord.xy);
}