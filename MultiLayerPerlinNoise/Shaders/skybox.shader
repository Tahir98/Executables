#vertex shader
#version 330 core
layout(location = 0) in vec3 vPos;
layout(location = 1) in vec3 vTexCoord;

out vec2 texCoord;

uniform mat4 view;
uniform mat4 projection;

void main() {
	texCoord = vec2(vTexCoord.xy);
	vec4 result = vec4(vPos, 1.0f) * view * projection;
	result.z = result.w;
	gl_Position = result;
}

#fragment shader
#version 330 core
in vec2 texCoord;

out vec4 outColor;

uniform sampler2D tex;

void main() {
		
	vec4 color = texture(tex, texCoord);
	color.w = 1.0f;
	outColor = color;
}