#vertex shader
#version 430 core

layout(location = 0) in vec3 vPos;
layout(location = 0) in vec2 vTexCoord;

out vec2 texCoord;

void main() {
	gl_Position = vec4(vPos, 1);
	texCoord = vTexCoord;
}


#fragment shader
#version 430 core

in vec2 texCoord;

uniform sampler2D tex;

out vec4 color;

void main() {
	color = texture(tex,texCoord);
}