#vertex shader
#version 430 core

layout(location = 0) in vec2 vPos;

uniform mat4 projection;

void main() {
	gl_Position = vec4(vPos, -3.0f, 1.0f) * projection;

	gl_Position.z = 0.0f;
}



#fragment shader
#version 430 core

uniform vec3 cursorColor;
out vec4 color;

void main() {
	color = vec4(cursorColor,1.0f);
}