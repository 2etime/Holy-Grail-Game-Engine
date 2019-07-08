//
//  Bounds.metal
//  HolyGrailGameEngine
//
//  Created by Rick Twohy Jr on 7/6/19.
//  Copyright © 2019 Rick Twohy Jr. All rights reserved.
//
#include "MetalTypes.metal"
#include <metal_stdlib>
using namespace metal;

struct BoundsVertex {
    float3 position [[ attribute(0) ]];
};

vertex float4 bounds_vertex_shader(const BoundsVertex vIn [[ stage_in ]],
                                   constant SceneConstants &sceneConstants [[ buffer(1) ]],
                                   constant ModelConstants &modelConstants [[ buffer(2) ]]) {
    float4 worldPosition = modelConstants.modelMatrix * float4(vIn.position, 1);
    float4 position = sceneConstants.projectionMatrix * sceneConstants.viewMatrix * worldPosition;
    return position;
}

fragment half4 bounds_fragment_shader() {
    float4 color = float4(0,1,0,1);
    return half4(color.r, color.g, color.b, color.a);
}
