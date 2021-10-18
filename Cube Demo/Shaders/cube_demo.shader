#vertex shader

#version 430 core
layout(location = 0) in vec3 vPos;
layout(location = 1) in vec3 vNormal;
layout(location = 2) in vec3 vTexCoord;
layout(location = 3) in vec3 vOffset;

layout(std140) uniform Matrices{
	mat4 view;
	mat4 projection;
};

//uniform mat4 model;
uniform vec3 scale;

out VS_OUT{
	vec3 pos;
	vec3 normal;
	vec2 texCoord;
} vs_out;


void main() {
	vec4 temp = vec4((vPos * scale) + vOffset, 1.0f);
	vs_out.pos = temp.xyz;
	vs_out.normal = vNormal;
	vs_out.texCoord = vTexCoord.xy;

	gl_Position = temp * transpose(view) * transpose(projection);
}





#fragment shader
#version 430 core

in VS_OUT{
	vec3 pos;
	vec3 normal;
	vec2 texCoord;
} fs_in;

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
	float constant, linear, quadrantic;
};

out vec4 color;

uniform Material material;
uniform PointLight light;
uniform vec3 viewPos;

uniform sampler2D texture1;

void main() {
	//Ambient color
	vec3 ambient = material.ambient * light.ambient;

	//Diffuse color
	vec3 normal = normalize(fs_in.normal);
	vec3 lightDir = normalize(light.pos - fs_in.pos);

	float diff = max(dot(lightDir, normal), 0.0f);
	vec3 diffuse = diff * material.diffuse * light.diffuse;

	//Specular color
	vec3 viewDir = normalize(viewPos - fs_in.pos);
	vec3 reflectDir = normalize(reflect(-lightDir, normal));
	vec3 specular = material.specular * pow(max(dot(viewDir, reflectDir), 0.0f), material.shininess) * light.specular;

	float distance = length(fs_in.pos - light.pos);
	float att = light.intensity / (light.constant + distance * light.linear + distance * distance * light.quadrantic);

	//Output color
	color = vec4(vec3(diffuse + specular) * att + ambient, 1.0f) * texture(texture1,fs_in.texCoord);
	color.w = 1.0f;
}
