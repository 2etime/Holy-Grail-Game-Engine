////
////  Tessellation.metal
////  HolyGrailGameEngine
////
////  Created by Rick Twohy Jr on 7/6/19.
////  Copyright © 2019 Rick Twohy Jr. All rights reserved.
////
//#include "MetalTypes.metal"
//#include <metal_stdlib>
//using namespace metal;
//
//
//struct PatchIn {
//    patch_control_point<Vertex> controlPoints;
//};
//
//constexpr sampler heightSampler(compare_func::less);
//
//[[patch(quad, 16)]]
//vertex RasterizerData quad_tessellation_vertex_shader(PatchIn patchIn [[stage_in]],
//                                                      constant SceneConstants &sceneConstants [[ buffer(1) ]],
//                                                      constant ModelConstants &modelConstants [[ buffer(2) ]],
//                                                      texture2d<float> heightTexture [[ texture(0) ]],
//                                                      float2 patch_coord [[ position_in_patch ]]) {
//    // Parameter coordinates.
//    float const u = patch_coord.x;
//    float const v = patch_coord.y;
//    
//    float3 position =
//    ((1 - u) * (1 - v) * patchIn.controlPoints[12].position +
//     u * (1 - v) * patchIn.controlPoints[0].position +
//     u * v * patchIn.controlPoints[3].position +
//     (1 - u) * v * patchIn.controlPoints[15].position);
//    
//    float2 texCoords =
//    ((1 - u) * (1 - v) * patchIn.controlPoints[12].textureCoordinate +
//     u * (1 - v) * patchIn.controlPoints[0].textureCoordinate +
//     u * v * patchIn.controlPoints[3].textureCoordinate +
//     (1 - u) * v * patchIn.controlPoints[15].textureCoordinate);
//    
//    float3 normal =
//    ((1 - u) * (1 - v) * patchIn.controlPoints[12].normal +
//     u * (1 - v) * patchIn.controlPoints[0].normal +
//     u * v * patchIn.controlPoints[3].normal +
//     (1 - u) * v * patchIn.controlPoints[15].normal);
//    
//    float height = heightTexture.sample(heightSampler, texCoords).r;
//    position.y += height / 10;
//    
//    RasterizerData rd;
//    
//    float4 worldPosition = modelConstants.modelMatrix * float4(position, 1.0);
//    rd.position = sceneConstants.projectionMatrix * sceneConstants.viewMatrix * worldPosition;
//    rd.worldPosition = worldPosition.xyz;
//    rd.toCameraVector = (sceneConstants.inverseViewMatrix * float4(0,0,0,1)).xyz - worldPosition.xyz;
//    rd.textureCoordinate = texCoords;
//    
//    float3 surfaceNormal = (modelConstants.modelMatrix * float4(normal, 0.0)).xyz;
//    float3 norm = normalize(surfaceNormal);
//    rd.surfaceNormal = norm;
//    
//    return rd;
//}
//
//kernel void quad_tessellation(constant float &edgeFactor [[ buffer(0) ]],
//                              constant float &insideFactor [[ buffer(1) ]],
//                              device MTLQuadTessellationFactorsHalf *factors [[ buffer(2) ]],
//                              uint tpig [[ thread_position_in_grid ]]) {
//    
//    const int AB = 2;
//    const int BC = 3;
//    const int CD = 0;
//    const int DA = 1;
//    
//    factors[tpig].edgeTessellationFactor[AB] = edgeFactor;
//    factors[tpig].edgeTessellationFactor[BC] = edgeFactor;
//    factors[tpig].edgeTessellationFactor[CD] = edgeFactor;
//    factors[tpig].edgeTessellationFactor[DA] = edgeFactor;
//    
//    factors[tpig].insideTessellationFactor[0] = insideFactor;
//    factors[tpig].insideTessellationFactor[1] = insideFactor;
//}
