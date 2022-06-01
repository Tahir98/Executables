#vertex shader
#version 330 core

layout(location = 0) in vec3 vPos;
layout(location = 1) in vec4 vColor;
layout(location = 2) in vec2 vTexCoord;

out vec4 color;
out vec2 texCoord;


void main() {
	gl_Position = vec4(vPos, 1.0f);
	color = vColor;
	texCoord = vTexCoord;
}


#fragment shader
#version 330 core

in vec4 color;
in vec2 texCoord;
out vec4 outputColor;

uniform sampler2D tex;
uniform sampler2D tex2;

void main() {
	//outputColor = texture(tex, texCoord) + color;
	outputColor = texture(tex, texCoord) / 2.0f + texture(tex2, texCoord) / 2.0f;
}