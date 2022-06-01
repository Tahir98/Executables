#vertex shader
#version 330 core

layout(location = 0) in vec2 vPos;
layout(location = 1) in vec2 vTexCoord;
layout(location = 2) in float vIndex;

uniform float width;
uniform float height;

out vec2 texCoord;;
out float index;

void main() {
	vec2 pos = vPos;

	pos.x = -(width / 2.0f - pos.x) / (width / 2.0f);
	pos.y = -(height / 2.0f - pos.y) / (height / 2.0f);

	gl_Position = vec4(pos,0,1);
	texCoord = vTexCoord;
	index = vIndex;
}


#fragment shader
#version 330 core

in vec2 texCoord;
in float index;

out vec4 color;
uniform sampler2D tex[32];

void main() {
	int i = int(index);
	color = texture(tex[i],texCoord);
}