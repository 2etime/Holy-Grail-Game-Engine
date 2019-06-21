//
//  Shaders.metal
//  HolyGrailGameEngine
//
//  Created by Rick Twohy Jr on 6/13/19.
//  Copyright © 2019 Rick Twohy Jr. All rights reserved.
//

#include <metal_stdlib>
#include "MetalTypes.metal"
using namespace metal;

vertex RasterizerData vertex_shader(const Vertex vIn [[ stage_in ]],
                                    constant SceneConstants &sceneConstants [[ buffer(1) ]],
                                    constant ModelConstants &modelConstants [[ buffer(2) ]]) {
    RasterizerData rd;
    
    float4x4 modelViewMatrix = sceneConstants.viewMatrix * modelConstants.modelMatrix;
    float4 worldPosition = modelConstants.modelMatrix * float4(vIn.position, 1);
    rd.position = sceneConstants.projectionMatrix * sceneConstants.viewMatrix * worldPosition;
    rd.worldPosition = worldPosition.xyz;
    rd.toCameraVector = (sceneConstants.inverseViewMatrix * float4(0,0,0,1)).xyz - worldPosition.xyz;
    rd.textureCoordinate = vIn.textureCoordinate;
    
    rd.surfaceNormal = (modelViewMatrix * float4(vIn.normal, 0.0)).xyz;
    rd.surfaceTangent = normalize(modelViewMatrix * float4(vIn.tangent, 1.0)).xyz;
    rd.surfaceBitangent = normalize(modelViewMatrix * float4(vIn.bitangent, 1.0)).xyz;
    
    return rd;
}

fragment half4 fragment_shader(RasterizerData rd [[ stage_in ]],
                               constant MaterialConstants &material [[ buffer(0) ]],
                               constant int &lightCount [[ buffer(1) ]],
                               constant LightData *lightDatas [[ buffer(2) ]],
                               sampler sampler2d [[ sampler(0) ]],
                               texture2d<float> baseTexture [[ texture(0) ]],
                               texture2d<float> normalsTexture [[ texture(1) ]],
                               texture2d<float> specularTexture [[ texture(2) ]],
                               texture2d<float> ambientTexture [[ texture(3) ]]) {
    float2 texCoord = rd.textureCoordinate;
    
    float4 color;
    if(material.useBaseTexture){
        color = baseTexture.sample(sampler2d, texCoord);
    }else if(material.useMaterialColor) {
        color = material.color;
    }else{
        color = float4(1,1,1,1);
    }
    
    if(material.isLightable){
        float3 unitNormal = normalize(rd.surfaceNormal);
        // Start with the identity matrix
        float3x3 TBN = { float3(1,0,0), float3(0,1,0), float3(0,0,1) };
        if(material.useNormalMap){
            float4 normalsColor = normalsTexture.sample(sampler2d, texCoord);
            float3 T = normalize(rd.surfaceTangent);
            float3 B = normalize(rd.surfaceBitangent);
            float3 N = normalize(rd.surfaceNormal);
            TBN = {
                float3(T.x, B.x, N.x),
                float3(T.y, B.y, N.y),
                float3(T.z, B.z, N.z)
            };
            unitNormal = normalsColor.rgb * 2.0 - 1.0;
        }
        
        float3 specularMapValue = 1.0;
        if(material.useSpecularMap){
            specularMapValue = specularTexture.sample(sampler2d, texCoord).r;
        }
        
        float3 ambientMapValue = 1.0;
        if(material.useAmbientMap){
            ambientMapValue = ambientTexture.sample(sampler2d, texCoord).r;
        }
        
        float3 unitToCameraVector = normalize(TBN * rd.toCameraVector);
        float3 totalAmbient = float3(0);
        float3 totalDiffuse = float3(0);
        float3 totalSpecular = float3(0);
        for(int i = 0; i < lightCount; i++) {
            LightData lightData = lightDatas[i];
            
            float3 unitToLightVector = normalize(TBN * (lightData.position - rd.worldPosition));
            float3 unitLightReflection = normalize(reflect(unitToLightVector, unitNormal));
            
            float3 ambientess = material.ambient * lightData.ambientIntensity;
            float3 ambientColor = clamp(ambientess * lightData.color * lightData.brightness, 0.0, 1.0);
            float3 ambientFactor = ambientColor * ambientMapValue;
            totalAmbient += max(ambientFactor * material.ambientMapIntensity, ambientFactor);
            
            float3 diffuseness = material.diffuse * lightData.diffuseIntensity;
            float diffuseFactor = max(dot(unitNormal, unitToLightVector), 0.0);
            float3 diffuseColor = clamp(diffuseness * diffuseFactor * lightData.color * lightData.brightness, 0.0, 1.0);
            totalDiffuse += diffuseColor;
            
            float3 specularness = material.specular * lightData.specularIntensity;
            float specularFactor = pow(max(dot(unitLightReflection, unitToCameraVector), 0.0), material.shininess);
            specularFactor = max(specularFactor * material.specularMapIntensity, specularFactor);
            float3 specularColor = clamp(specularness * specularFactor * lightData.color * lightData.brightness, 0.0, 1.0);
            totalSpecular += specularColor * specularMapValue;
        }
        
        float3 phongIntensity = totalAmbient + totalDiffuse + totalSpecular;
        color *= float4(phongIntensity, 1.0);
    }

    return half4(color.r, color.g, color.b, color.a);
}


