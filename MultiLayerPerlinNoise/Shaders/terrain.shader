#vertex shader
#version 430 core

layout(location = 0) in vec3 vPos;
layout(location = 1) in vec3 vNormal;
layout(location = 2) in vec3 vTexCoord;

//uniform mat4 model;
uniform mat4 view;
uniform mat4 projection;

out VS_OUT{
	vec3 pos;
	vec3 normal;
	vec3 texCoord;
} vs_out;

uniform vec3 camPos;
uniform int wireframe;

void main() {
	vec3 temp = vNormal;
	//temp = temp * mat3(model);

	vs_out.pos = vPos;//vec4(vec4(vPos, 1.0f) * model).xyz;
	vs_out.normal = temp;
	vs_out.texCoord = vTexCoord;

	gl_Position = vec4(vPos, 1.0f) * view * projection;

	if (wireframe == 1) {
		float distance = length(camPos - vPos);

		gl_Position.z -= 0.0001f;

		if (distance > 50)
			gl_Position.z = gl_Position.w + 1;
	}
}




#fragment shader
#version 430 core

in VS_OUT{
	vec3 pos;
	vec3 normal;
	vec3 texCoord;
} fs_in;

struct Light {
	vec3 direction;
	vec3 ambient;
	vec3 diffuse;
	vec3 specular;
	float intensity;
};

struct Material { 
	vec3 ambient;
	vec3 diffuse;
	vec3 specular;
	float shininess;
};


uniform Light light;
uniform Material material;

uniform vec3 camPos;

uniform sampler2D tex;
uniform int includeTexture;

uniform int wireframe;

out vec4 color;

void main() {
	if (wireframe == 0) {
		//Ambient color
		vec3 ambient = material.ambient * light.ambient;

		//Diffuse color
		vec3 norm = normalize(fs_in.normal);
		vec3 lightDir = normalize(-light.direction);

		float diff = max(dot(lightDir, norm), 0.0f);
		vec3 diffuse = diff * material.diffuse * light.diffuse;

		//Specular color
		vec3 viewDir = normalize(camPos - fs_in.pos);
		vec3 reflectDir = normalize(reflect(-lightDir, norm));
		vec3 specular = material.specular * pow(max(dot(viewDir, reflectDir), 0.0f), material.shininess) * light.specular;

		float att = light.intensity;

		//Output color
		if (includeTexture == 0)
			color = vec4(ambient + vec3(diffuse + specular) * att, 1.0f);
		else {
			vec4 texColor = texture2D(tex, fs_in.texCoord.xy);
			color = vec4(ambient + vec3(diffuse + specular) * att, 1.0f) * texColor;
		}
	}
	else {
		color = vec4(0, 0, 0, 1);
	}
}
