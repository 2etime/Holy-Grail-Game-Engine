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
    float2 texCoord = rd.textureCoordinate * 20;
    
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



struct PatchIn {
    patch_control_point<Vertex> controlPoints;
};

constexpr sampler heightSampler(compare_func::less, address::clamp_to_zero);

[[patch(quad, 16)]]
vertex RasterizerData quad_tessellation_vertex_shader(PatchIn patchIn [[stage_in]],
                                                      constant SceneConstants &sceneConstants [[ buffer(1) ]],
                                                      constant ModelConstants &modelConstants [[ buffer(2) ]],
                                                      texture2d<float> heightTexture [[ texture(0) ]],
                                                      float2 patch_coord [[ position_in_patch ]]) {
    // Parameter coordinates.
    float const u = patch_coord.x;
    float const v = patch_coord.y;
    
    float3 position =
    ((1 - u) * (1 - v) * patchIn.controlPoints[12].position +
     u * (1 - v) * patchIn.controlPoints[0].position +
     u * v * patchIn.controlPoints[3].position +
     (1 - u) * v * patchIn.controlPoints[15].position);
    
    
    float2 const upper_middle_textureCoordinates = mix(patchIn.controlPoints[0].textureCoordinate, patchIn.controlPoints[1].textureCoordinate, u);
    float2 const lower_middle_textureCoordinates = mix(patchIn.controlPoints[0].textureCoordinate, patchIn.controlPoints[1].textureCoordinate, 1-u);
    
    float2 texCoords = mix(upper_middle_textureCoordinates, lower_middle_textureCoordinates, v);
    float height = heightTexture.sample(heightSampler, texCoords).r;

    // Linear interpolation.
    float2 const upper_middle_position = mix(patchIn.controlPoints[0].position.xy, patchIn.controlPoints[1].position.xy, u);
    float2 const lower_middle_position = mix(patchIn.controlPoints[2].position.xy, patchIn.controlPoints[3].position.xy, 1-u);

    RasterizerData rd;
    
//    float2 uv = mix(upper_middle_position, lower_middle_position, v);
//    float4 position = float4(uv.x, uv.y, height * 2, 1.0);
    
    position.y = height;
    
    float4x4 modelViewMatrix = sceneConstants.viewMatrix * modelConstants.modelMatrix;
    float4 worldPosition = modelConstants.modelMatrix * float4(position, 1.0);
    rd.position = sceneConstants.projectionMatrix * sceneConstants.viewMatrix * worldPosition;
    rd.worldPosition = worldPosition.xyz;
    rd.toCameraVector = (sceneConstants.inverseViewMatrix * float4(0,0,0,1)).xyz - worldPosition.xyz;
    rd.textureCoordinate = float2(u,v);
    
    float3 normal = float3(0,0,1);
    
    float3 tangent = float3(0,1,0);
    float3 bitangent = float3(1,0,0);
    rd.surfaceNormal = (modelViewMatrix * float4(normal, 0.0)).xyz;
    rd.surfaceTangent = normalize(modelViewMatrix * float4(tangent, 1.0)).xyz;
    rd.surfaceBitangent = normalize(modelViewMatrix * float4(bitangent, 1.0)).xyz;
    
    return rd;
}

kernel void quad_tessellation(constant float &edgeFactor [[ buffer(0) ]],
                              constant float &insideFactor [[ buffer(1) ]],
                              device MTLQuadTessellationFactorsHalf *factors [[ buffer(2) ]],
                              uint tpig [[ thread_position_in_grid ]]) {
    
    const int AB = 2;
    const int BC = 3;
    const int CD = 0;
    const int DA = 1;
    
    factors[tpig].edgeTessellationFactor[AB] = edgeFactor;
    factors[tpig].edgeTessellationFactor[BC] = edgeFactor;
    factors[tpig].edgeTessellationFactor[CD] = edgeFactor;
    factors[tpig].edgeTessellationFactor[DA] = edgeFactor;
    
    factors[tpig].insideTessellationFactor[0] = insideFactor;
    factors[tpig].insideTessellationFactor[1] = insideFactor;
}
