#vertex shader
#version 330 core
layout(location = 0) in vec4 vPos; 

out vec2 texCoord;
uniform mat4 projection;

void main(){
	gl_Position = vec4(vPos.xy, 0.0, 1.0) * projection;
	texCoord = vPos.zw;
}



#fragment shader
#version 330 core

in vec2 texCoord;
out vec4 color;

uniform sampler2D text;
uniform vec3 textColor;

void main() {

	vec4 sampled = vec4(1.0, 1.0, 1.0, texture(text, texCoord).r);
	color = vec4(textColor, 1.0) * sampled;
}
