#vertex shader
#version 330 core

layout(location = 0) in vec3 vPos;
layout(location = 1) in vec3 vNormal;
layout(location = 2) in vec3 vtexCoord;

uniform mat4 model;
uniform mat4 view;
uniform mat4 projection;

out vec3 texCoord;
out vec3 Normal;
out vec3 FragPos;

void main() {
	texCoord = vtexCoord;

	vec4 pos = vec4(vPos, 1.0);
	pos.y /= 5.0;
	pos.x /= 5.0;
	pos.z /= 5.0;

	gl_Position = pos * model * view * projection;
    FragPos = vec3(pos.xyz);
	Normal = vNormal;
}


#fragment shader
#version 330 core

uniform vec3 lightPos;
uniform vec3 viewPos;

in vec3 texCoord;
in vec3 FragPos;
in vec3 Normal;

out vec4 fragColor;

uniform sampler2D tex;
void main() {
    vec3 lightColor = vec3(1,1,1);

    // Ambient
    float ambientStrength = 0.1f;
    vec3 ambient = ambientStrength * lightColor;

    // Diffuse 
    float diffuseStrenght = 0.3f;
    float diff;
    vec3 norm = normalize(Normal);
    vec3 lightDir = normalize(vec3(lightPos - FragPos));
    if (dot(norm, lightDir) > 0) {
        diff = diffuseStrenght * dot(norm, lightDir);
    }
    else {
        diff = 0.0f;
    }
    vec3 diffuse = diff * lightColor;

    // Specular
    float specularStrength = 0.8f;
    float spec;
    vec3 viewDir = normalize(viewPos - FragPos);
    vec3 reflectDir = normalize(normalize(2.0f * dot(lightDir, norm) * norm) - lightDir);
    
    if (dot(norm, lightDir) > 0 && dot(viewDir, reflectDir) > 0) {
        spec = pow(dot(viewDir, reflectDir), 200);
    }
    else {
        spec = 0.0f;
    }

    vec3 specular = specularStrength * spec * lightColor;

    vec3 result = (ambient + diffuse + specular);
    fragColor = vec4(result, 1.0f) + texture(tex,texCoord.xy);
    //fragColor =  vec4(result,1.0);
    
}




