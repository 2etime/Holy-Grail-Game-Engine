//
//  MetalTypes.metal
//  HolyGrailGameEngine
//
//  Created by Rick Twohy Jr on 6/16/19.
//  Copyright © 2019 Rick Twohy Jr. All rights reserved.
//
#ifndef METAL_TYPES_METAL
#define METAL_TYPES_METAL

#include <metal_stdlib>
using namespace metal;

struct Vertex {
    float3 position [[ attribute(0) ]];
    float2 textureCoordinate [[ attribute(1) ]];
    float3 normal [[ attribute(2) ]];
    float3 tangent [[ attribute(3) ]];
    float3 bitangent [[ attribute(4) ]];
};

struct RasterizerData{
    float4 position [[ position ]];
    float2 textureCoordinate;
    float3 worldPosition;
    float3 surfaceNormal;
    float3 surfaceTangent;
    float3 surfaceBitangent;
    float3 toCameraVector;
};

struct ModelConstants{
    float4x4 modelMatrix;
};

struct SceneConstants{
    float4x4 viewMatrix;
    float4x4 inverseViewMatrix;
    float4x4 projectionMatrix;
};

struct MaterialConstants {
    float4 color;
    bool useMaterialColor;
    bool useBaseTexture;
    bool useNormalMap;
    bool useSpecularMap;
    bool isLightable;
    float specularMapIntensity;
    
    float3 ambient;
    float3 diffuse;
    float3 specular;
    float shininess;
};

struct LightData {
    float3 position;
    float3 color;
    float brightness;
    
    float ambientIntensity;
    float diffuseIntensity;
    float specularIntensity;
};

#endif

