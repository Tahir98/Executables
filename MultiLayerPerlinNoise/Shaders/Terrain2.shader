#vertex shader
#version 430 core

layout(location = 0) in vec3 vPos;
layout(location = 1) in vec3 vNormal;

uniform mat4 view;
uniform mat4 projection;

out vec3 pos;
out vec3 normal;

void main() {
	pos = vPos;
	normal = vNormal;
	gl_Position = vec4(vPos, 1.0f) * view * projection;
}


#fragment shader
#version 430 core

struct Material{
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

in vec3 pos;
in vec3 normal;

uniform Material material;
uniform DirectionalLight light;

uniform vec3 camPos;

uniform vec3 terrainColor;
uniform vec3 rockColor;
uniform vec3 snowColor;

out vec4 color;

void main() {
	//ambeint
	vec3 ambient = material.ambient * light.ambient;

	//Diffuse color
	vec3 Normal = normalize(normal);
	
	float diff = max(dot(-light.direction, normal), 0.0f);
	vec3 diffuse = diff * material.diffuse * light.diffuse;

	//Specular color
	vec3 viewDir = normalize(camPos - pos);
	vec3 reflectDir = normalize(reflect(light.direction, normal));
	vec3 specular = material.specular * pow(max(dot(viewDir, reflectDir), 0.0f), material.shininess) * light.specular;

	float n = dot(normal, vec3(0, 1, 0));

	if (pos.y < 40.0f) {
		if (n >= 0.90f) {
			color = vec4(terrainColor, 1);
		}
		else if (n < 0.90f && n >= 0.65f) {
			color = vec4(0, 0, 0, 0);
			color += vec4(rockColor * (0.90f - n) * 4.0f, 0.5f);
			color += vec4(terrainColor * (n - 0.65f) * 4.0f, 0.5f);
		}
		else {
			color = vec4(rockColor, 1);
		}


		if (pos.y >= 20) {
			vec4 c;
			c = color * ((40.0f - pos.y) / 20.0f);
			c += vec4(snowColor, 1) * ((pos.y - 20.0f) / 20.0f);

			color = c;
		}

		//Output color
		color.w = 1.0f;
		color = vec4(ambient + vec3(diffuse + specular) * light.intensity, 1.0f) * color;
	}
	else {
		color = vec4(snowColor, 1) * vec4(ambient + vec3(diffuse + specular) * light.intensity, 1.0f);
	}
}