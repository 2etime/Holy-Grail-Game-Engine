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
    rd.textureCoordinate = vIn.textureCoordinate;
    
    return rd;
}

fragment half4 fragment_shader(RasterizerData rd [[ stage_in ]],
                               constant MaterialConstants &material    [[ buffer(0)  ]],
                               const    sampler           sampler2d    [[ sampler(0) ]],
                               const    texture2d<float>  baseTexture [[ texture(0) ]]) {
    float4 color;
    if(material.useBaseTexture){
        color = baseTexture.sample(sampler2d, rd.textureCoordinate);
    }else if(material.useMaterialColor) {
        color = material.color;
    }else{
        color = float4(0.5,0.5,0.5, 1.0);
    }
    
    return half4(color);
}


