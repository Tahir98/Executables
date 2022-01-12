#vertex shader
#version 430 core

layout(location = 0) in vec3 vPos;
layout(location = 1) in vec3 vNormal;

uniform mat4 view;
uniform mat4 projection;

out vec3 pos;
out vec3 normal;

void main() {
	gl_Position = vec4(vPos, 1) * view * projection;
	pos = vPos;
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

struct Light {
	vec3 direction;
	vec3 ambient;
	vec3 diffuse;
	vec3 specular;
	float intensity;
};

uniform vec3 camPos;

uniform Material material;
uniform Light light;

in vec3 pos;
in vec3 normal;
out vec4 oColor;

void main() {
	//Ambient color
	vec3 ambient = material.ambient * light.ambient;

	//Diffuse color
	vec3 norm = normalize(normal);
	vec3 lightDir = normalize(-light.direction);

	float diff = max(dot(lightDir, norm), 0.0f);
	vec3 diffuse = diff * material.diffuse * light.diffuse;

	//Specular color
	vec3 viewDir = normalize(camPos - pos);
	vec3 reflectDir = normalize(reflect(-lightDir, norm));
	vec3 specular = material.specular * pow(max(dot(viewDir, reflectDir), 0.0f), material.shininess) * light.specular;

	float att = light.intensity;

	//Output color
	oColor = vec4(ambient + vec3(diffuse + specular) * att, 1.0f);
}