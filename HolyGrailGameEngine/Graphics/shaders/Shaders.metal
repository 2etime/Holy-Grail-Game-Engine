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
    
    float4 worldPosition = modelConstants.modelMatrix * float4(vIn.position, 1.0);
    rd.position = sceneConstants.projectionMatrix * sceneConstants.viewMatrix * worldPosition;
    
    return rd;
}

fragment half4 fragment_shader(RasterizerData rd [[ stage_in ]]) {
    float4 color = float4(1,0,0,1);
    return half4(color);
}


