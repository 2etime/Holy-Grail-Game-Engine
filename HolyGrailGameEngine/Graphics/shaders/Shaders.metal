//
//  Shaders.metal
//  HolyGrailGameEngine
//
//  Created by Rick Twohy Jr on 6/13/19.
//  Copyright © 2019 Rick Twohy Jr. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

struct Vertex {
    float3 position [[ attribute(0) ]];
};

struct RasterizerData {
    float4 position [[ position ]];
};

vertex RasterizerData vertex_shader(const Vertex vIn [[ stage_in ]]) {
    RasterizerData rd;
    
    rd.position = float4(vIn.position, 1.0);
    
    return rd;
}

fragment half4 fragment_shader(RasterizerData rd [[ stage_in ]]) {
    float4 color = float4(1,0,0,1);
    
    return half4(color);
}


