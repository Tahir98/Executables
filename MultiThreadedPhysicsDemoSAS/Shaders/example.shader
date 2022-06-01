#vertex shader
#version 330 core

layout(location = 0) in vec3 vPos;
layout(location = 1) in vec3 vNormal;
layout(location = 2) in vec2 vTexCoord;

out vec3 normal;
out vec3 fragPos;
out vec2 texCoord;

uniform mat4 model;
uniform mat4 view;
uniform mat4 projection;

void main() {
	gl_Position = vec4(vPos,1.0f) * model * view * projection;
	fragPos = vec3(vec4((vPos,1.0f) * model).xyz);
	normal =  vNormal  * mat3(model);
	vec2 texCoord = vec2(vTexCoord); 
}


#fragment shader
#version 330 core

in vec3 normal;
in vec3 fragPos;
in vec2 texCoord;

uniform vec3 lightColor;
uniform vec3 lightPos;
uniform vec3 viewPos;

out vec4 oColor;

uniform sampler2D tex;
void main() {
	float ambientStrength = 0.1f;
	float diffuseStrength = 0.3f;
	float specularStrength = 0.6f;

	//Ambient
	vec3 ambient = ambientStrength * lightColor;

	//Diffuse
	vec3 norm = normalize(normal);

	vec3 lightDir = normalize(lightPos - fragPos);
	float diff = dot(lightDir,norm);
	if (diff < 0.0f)
		diff = 0.0f;
	vec3 diffuse = diffuseStrength * diff * lightColor;

	//Specular
	vec3 viewDir = normalize(viewPos - fragPos);
	vec3 reflectDir = normalize(2.0f * dot(lightDir, norm) * norm - lightDir);
	float spec = dot(viewDir, reflectDir);
	if (spec > 0 && diff > 0) 
		spec = pow(spec, 200);
	else 
		spec = 0.0f;

	vec3 specular = specularStrength * spec * lightColor;
	oColor = vec4((ambient + diffuse + specular),1.0f)* 0.001 + texture(tex,texCoord);

}