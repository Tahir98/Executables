#vertex shader
#version 330 core
layout(location = 0) in vec3 vPos;
layout(location = 1) in vec3 vNormal;
layout(location = 2) in vec3 vtexCoord;


out vec3 normal;
out vec3 texCoord;
uniform mat4 projection;
uniform mat4 view;

uniform mat4 rotX;
uniform mat4 rotY;
uniform mat4 rotZ;

void main() {
	//color = vColor;

	normal = vNormal;
	texCoord = vtexCoord;
	vec4 pos = vec4(vPos,-1);

	pos = pos * rotX * rotY * rotZ;
	pos.z -= 100;

	pos = pos * view;

	gl_Position = vec4((pos * projection));
}

#fragment shader
#version 330 core
//in vec4 color;
out vec4 outColor;
in vec3 normal;
in vec3 texCoord;

uniform sampler2D tex;
void main() {
	

	//outColor = color;

	vec2 a = vec2(texCoord.xy);
	a.x = a.x * 2.0 - 1.0;
	a.y = a.y * 2.0 - 1.0;

	outColor = texture(tex,a);
}









