#vertex shader
#version 430 core

layout(location = 0) in vec3 vPos;
layout(location = 1) in vec3 vNormal;

uniform mat4 model;
uniform mat4 view;
uniform mat4 projection;

out vec3 pos;
out vec3 normal;
 
void main() {
	vec4 coord = vec4(vPos, 1.0f) * model;
	pos = coord.xyz;
	normal = vNormal * mat3(model);

	gl_Position = coord * view * projection;
}


#fragment shader
#version 430 core

struct Material {
	vec3 ambient;
	vec3 diffuse;
	vec3 specular;
	float shininess;
};

struct DirectionalLight {
	vec3 direction;
	vec3 ambient;
	vec3 diffuse;
	vec3 specular;
	float intensity;
};


uniform vec3 camPos;
uniform Material material;
uniform DirectionalLight light;

in vec3 pos;
in vec3 normal;
out vec4 color;

void main() {
	//Ambient color
	vec3 ambient = material.ambient * light.ambient;

	//Diffuse color
	vec3 Normal = normalize(normal);
	vec3 lightDir = light.direction;

	float diff = max(dot(-lightDir, Normal), 0.0f);
	vec3 diffuse = diff * material.diffuse * light.diffuse;

	//Specular color
	vec3 viewDir = normalize(camPos - pos);
	vec3 reflectDir = normalize(reflect(lightDir, Normal));
	vec3 specular = material.specular * pow(max(dot(viewDir, reflectDir), 0.0f), material.shininess) * light.specular;

	//Output color
	color = vec4(vec3(ambient + diffuse + specular) * light.intensity, 1.0f);
}