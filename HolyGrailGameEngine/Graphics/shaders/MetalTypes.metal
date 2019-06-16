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

struct RasterizerData {
    float4 position [[ position ]];
};

struct SceneConstants {
    float4x4 viewMatrix;
    float4x4 projectionMatrix;
};

struct ModelConstants {
    float4x4 modelMatrix;
};

#endif

