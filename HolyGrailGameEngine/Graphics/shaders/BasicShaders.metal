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
    
    float4 worldPosition = modelConstants.modelMatrix * float4(vIn.position, 1);
    rd.position = sceneConstants.projectionMatrix * sceneConstants.viewMatrix * worldPosition;
    rd.worldPosition = worldPosition.xyz;
    rd.toCameraVector = (sceneConstants.inverseViewMatrix * float4(0,0,0,1)).xyz - worldPosition.xyz;
    rd.textureCoordinate = vIn.textureCoordinate;
    
    float4x4 modelViewMatrix = sceneConstants.viewMatrix * modelConstants.modelMatrix;
    rd.surfaceNormal = (modelConstants.modelMatrix * float4(vIn.normal, 0.0)).xyz;
    rd.surfaceTangent = normalize(modelViewMatrix * float4(vIn.tangent, 1.0)).xyz;
    rd.surfaceBitangent = normalize(modelViewMatrix * float4(vIn.bitangent, 1.0)).xyz;
    
    return rd;
}

float3 getPhongIntensity(constant MaterialConstants &material,
                         constant LightData *lightDatas,
                         int lightCount,
                         float3 worldPosition,
                         float3 toCameraVector,
                         float3 surfaceNormal) {
    float3 unitToCameraVector = normalize(toCameraVector);
    float3 totalAmbient = float3(0);
    float3 totalDiffuse = float3(0);
    float3 totalSpecular = float3(0);
    for(int i = 0; i < lightCount; i++) {
        LightData lightData = lightDatas[i];
        
        float3 unitToLightVector = normalize(lightData.position - worldPosition);
        float3 unitLightReflection = normalize(reflect(-unitToLightVector, surfaceNormal));
        
        float3 ambientess = material.ambient * lightData.ambientIntensity;
        float3 ambientColor = clamp(ambientess * lightData.color * lightData.brightness, 0.0, 1.0);
        float3 ambientFactor = ambientColor;
        totalAmbient += max(ambientFactor * material.ambientMapIntensity, ambientFactor);
        
        float3 diffuseness = material.diffuse * lightData.diffuseIntensity;
        float diffuseFactor = max(dot(surfaceNormal, unitToLightVector), 0.0);
        float3 diffuseColor = clamp(diffuseness * diffuseFactor * lightData.color * lightData.brightness, 0.0, 1.0);
        totalDiffuse += diffuseColor;
        
        float3 specularness = material.specular * lightData.specularIntensity;
        float specularFactor = pow(max(dot(unitLightReflection, unitToCameraVector), 0.0), material.shininess);
        specularFactor = max(specularFactor * material.specularMapIntensity, specularFactor);
        float3 specularColor = clamp(specularness * specularFactor * lightData.color * lightData.brightness, 0.0, 1.0);
        totalSpecular += specularColor;
    }
    
    return totalAmbient + totalDiffuse + totalSpecular;
}

fragment half4 fragment_shader(RasterizerData rd [[ stage_in ]],
                               constant MaterialConstants &material [[ buffer(0) ]],
                               constant int &lightCount [[ buffer(1) ]],
                               constant LightData *lightDatas [[ buffer(2) ]],
                               constant float2 &textureTileCounts [[ buffer(3) ]],
                               sampler sampler2d [[ sampler(0) ]],
                               texture2d<float> baseTexture [[ texture(0) ]]) {
    float2 texCoord = rd.textureCoordinate * textureTileCounts;

    float4 color;
    if(material.useBaseTexture){
        color = baseTexture.sample(sampler2d, texCoord);
    }else if(material.useMaterialColor) {
        color = material.color;
    }else{
        color = float4(0.5,0.5,0.5,1);
    }

    if(material.isLightable){
        float3 unitNormal = normalize(rd.surfaceNormal);
        float3 unitToCameraVector = normalize(rd.toCameraVector);
        float3 phongIntensity = getPhongIntensity(material,
                                                  lightDatas,
                                                  lightCount,
                                                  rd.worldPosition,
                                                  unitToCameraVector,
                                                  unitNormal);
        color *= float4(phongIntensity, 1.0);
    }
    

    return half4(color.r, color.g, color.b, color.a);
}
