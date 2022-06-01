#vertex shader

#version 430 core
layout(location = 0) in vec3 vPos;
layout(location = 1) in vec3 vNormal;
layout(location = 2) in vec3 offset;
layout(location = 3) in float scale;
layout(location = 4) in vec3 ambient;
layout(location = 5) in vec3 diffuse;
layout(location = 6) in vec3 specular;
layout(location = 7) in float shininess;

layout(std140) uniform Matrices{
	mat4 view;
	mat4 projection;
};

out VS_OUT{
	vec3 pos;
	vec3 normal;
	vec3 ambient;
	vec3 diffuse;
	vec3 specular;
	float shininess;
} vs_out;


void main() {
	vec4 temp = vec4(vPos * scale + offset, 1.0f);
	vs_out.pos = temp.xyz;
	vs_out.normal = vNormal;
	vs_out.ambient = ambient;
	vs_out.diffuse = diffuse;
	vs_out.specular = specular;
	vs_out.shininess = shininess;
	
	gl_Position = temp * transpose(view) * transpose(projection);
}





#fragment shader
#version 430 core

in VS_OUT {
	vec3 pos;
	vec3 normal;
	vec3 ambient;
	vec3 diffuse;
	vec3 specular;
	float shininess;
} fs_in;

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

out vec4 color;

//uniform Material material;
uniform DirectionalLight light;
uniform vec3 viewPos;

void main() {
	//Ambient color
	vec3 ambient = fs_in.ambient * light.ambient;

	//Diffuse color
	vec3 normal = normalize(fs_in.normal);
	vec3 lightDir = light.direction;

	float diff = max(dot(-lightDir, normal), 0.0f);
	vec3 diffuse = diff * fs_in.diffuse * light.diffuse;

	//Specular color
	vec3 viewDir = normalize(viewPos - fs_in.pos);
	vec3 reflectDir = normalize(reflect(lightDir, normal));
	vec3 specular = fs_in.specular * pow(max(dot(viewDir, reflectDir), 0.0f), fs_in.shininess) * light.specular;

	//Output color
	color = vec4(vec3(ambient + diffuse + specular) * light.intensity, 1.0f);
}
