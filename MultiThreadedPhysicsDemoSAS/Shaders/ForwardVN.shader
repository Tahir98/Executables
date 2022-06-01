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
	vec4 temp = vec4(vPos,1.0f) * model;
	pos = temp.xyz;
	normal = vNormal * mat3(model);

	gl_Position = temp * view * projection;
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
	int use;
};

struct PointLight {
	vec3 pos;
	vec3 ambient;
	vec3 diffuse;
	vec3 specular;

	float intensity;
	float constant, linear, quadrantic;
	int use;
};

struct SpotLight {
	vec3 pos;
	vec3 direction;
	vec3 ambient;
	vec3 diffuse;
	vec3 specular;

	float intensity;
	float innerCut, outerCut;
	float constant, linear, quadrantic;
	int use;
};

#define NUM_P_L 50
#define NUM_S_L 10

in vec3 pos;
in vec3 normal;
out vec4 oColor;

uniform vec3 viewerPos;
uniform Material material;

uniform DirectionalLight dLight;
uniform PointLight pLight[NUM_P_L];
uniform SpotLight sLight[NUM_S_L];

vec3 calculateDirectionalLight(DirectionalLight light, Material mat, vec3 position, vec3 normal, vec3 viewDir);
vec3 calculatePointLight(PointLight light, Material mat, vec3 position, vec3 normal, vec3 viewDir);
vec3 calculateSpotLight(SpotLight light, Material mat, vec3 position, vec3 normal, vec3 viewDir);

void main() {	
	vec3 norm = normalize(normal);
	vec3 viewDir = normalize(viewerPos - pos);
	
	vec3 color = vec3(0.0f, 0.0f, 0.0f);

	if (bool(dLight.use)) {
		color += calculateDirectionalLight(dLight, material, pos, norm, viewDir);
	}

	for (int i = 0; i < NUM_P_L; i++) {
		if (bool(pLight[i].use)) {
			color += calculatePointLight(pLight[i], material, pos, norm, viewDir);
		}
		else {
			break;
		}
	}

	for (int i = 0; i < NUM_S_L; i++) {
		if (bool(sLight[i].use)) {
			color += calculateSpotLight(sLight[i], material, pos, norm, viewDir);
		}
		else {
			break;
		}
	}

	oColor = vec4(color, 1.0f);
}


vec3 calculateDirectionalLight(DirectionalLight light, Material mat, vec3 position, vec3 normal, vec3 viewDir) {
	//Ambient
	vec3 ambient = mat.ambient * light.ambient;

	//Diffuse
	float angle = max(dot(-light.direction, normal), 0.0);
	vec3 diffuse = angle * mat.diffuse * light.diffuse;

	//Specular
	vec3 reflectionDirection = normalize(reflect(normalize(light.direction), normal));
	vec3 specular = mat.specular * pow(max(dot(viewDir, reflectionDirection), 0.0), mat.shininess) * light.specular;

	return (ambient + diffuse + specular) * light.intensity;
}

vec3 calculatePointLight(PointLight light, Material mat, vec3 position, vec3 normal, vec3 viewDir) {
	//Ambient
	//vec3 ambient = mat.ambient * light.ambient;
	vec3 ambient = vec3(0.0f);

	//Diffuse
	vec3 lightDir = normalize(light.pos - position);
	float angle = max(dot(lightDir, normal), 0.0f);
	vec3 diffuse = angle * mat.diffuse * light.diffuse;

	//Specular
	vec3 reflectionDirection = normalize(reflect(-lightDir, normal));
	vec3 specular = mat.specular * pow(max(dot(viewDir, reflectionDirection), 0.0f), mat.shininess) * light.specular;

	float distance = length(position - light.pos);
	float att = light.intensity / (light.constant + distance * light.linear + distance * distance * light.quadrantic);
	return vec3(ambient + diffuse + specular) * att;
}

vec3 calculateSpotLight(SpotLight light, Material mat, vec3 position, vec3 normal, vec3 viewDir) {
	vec3 ambient = vec3(0,0,0);
	vec3 diffuse = vec3(0, 0, 0);
	vec3 specular = vec3(0, 0, 0);
	float intensity = 0.0f;

	//Diffuse
	vec3 lightDir = normalize(position - light.pos);
	float theta = dot(normalize(light.direction),lightDir);
	if (theta >= cos(light.outerCut)) {
		
		float angle = max(dot(-lightDir, normal), 0.0f);
		diffuse = angle * mat.diffuse * light.diffuse;


		//Specular
		vec3 reflectionDirection = normalize(reflect(lightDir, normal));
		specular = mat.specular * pow(max(dot(viewDir, reflectionDirection), 0.0f), mat.shininess) * light.specular;

		intensity = clamp((cos(light.outerCut) - theta) / (cos(light.outerCut) - cos(light.innerCut)), 0.0f, 1.0f);
	}

	float distance = length(position - light.pos);
	float att = (light.intensity * intensity) / (light.constant + distance * light.linear + distance * distance * light.quadrantic);

	return (ambient + diffuse + specular) * att;
}