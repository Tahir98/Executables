#vertex shader
#version 430 core
layout(location = 0) in vec3 vPos;
layout(location = 1) in vec3 vColor;

uniform mat3 projection;
out vec3 color;

void main() {
	gl_Position = vec4(vPos * projection, 1.0f);
	gl_Position.z = -0.5f;
	color = vColor;
}


#fragment shader
#version 430 core

in vec3 color;
out vec4 outputColor;

uniform int point;
void main() {
	if(point == 0)
		outputColor = vec4(color, 1.0f);
	else 
		outputColor = vec4(0,1,0, 1.0f);

}