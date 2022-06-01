#vertex shader
#version 430 core

layout(location = 0) in vec3 vPos;
layout(location = 1) in vec3 vNormal;
layout(location = 2) in vec3 vOffset;
layout(location = 3) in vec3 vScale;

uniform mat4 view;
uniform mat4 projection;

out vec3 pos;
out vec3 normal;

void main() {
	gl_Position = vec4(vPos * vScale + vOffset,1) * view * projection;
	pos = vPos * vScale + vOffset;
	normal = vNormal;
}


#fragment shader
#version 430 core

struct Material {
	vec3 ambient;
	vec3 diffuse;
	vec3 specular;
	float shininess;
};

struct PointLight {
	vec3 pos;
	vec3 ambient;
	vec3 diffuse;
	vec3 specular;

	float intensity;

	float constant;
	float linear;
	float quadrantic;
};

uniform Material material;
uniform PointLight light;
uniform vec3 viewPos;
uniform vec4 oColor;

in vec3 pos;
in vec3 normal;
out vec4 color;


void main() {
	//Ambient color
	vec3 ambient = material.ambient * light.ambient;

	//Diffuse color
	vec3 norm = normalize(normal);
	vec3 lightDir = normalize(light.pos - pos);

	float diff = max(dot(lightDir, norm), 0.0f);
	vec3 diffuse = diff * material.diffuse * light.diffuse;

	//Specular color
	vec3 viewDir = normalize(viewPos - pos);
	vec3 reflectDir = normalize(reflect(-lightDir, norm));
	vec3 specular = material.specular * pow(max(dot(viewDir, reflectDir), 0.0f), material.shininess) * light.specular;

	float distance = length(pos - light.pos);
	float att = light.intensity / (light.constant + distance * light.linear + distance * distance * light.quadrantic);

	//Output color
	color = vec4(vec3(diffuse + specular) * att + ambient, 1.0f) * oColor;
	color.w = 1.0f;
}