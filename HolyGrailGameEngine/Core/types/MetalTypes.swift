//
//  MetalTypes.swift
//  HolyGrailGameEngine
//
//  Created by Rick Twohy Jr on 6/13/19.
//  Copyright © 2019 Rick Twohy Jr. All rights reserved.
//

import simd

protocol sizeable{ }
extension sizeable{
    static var size: Int{
        return MemoryLayout<Self>.size
    }
    
    static var stride: Int{
        return MemoryLayout<Self>.stride
    }
    
    static func size(_ count: Int)->Int{
        return MemoryLayout<Self>.size * count
    }
    
    static func stride(_ count: Int)->Int{
        return MemoryLayout<Self>.stride * count
    }
}

extension Int32: sizeable { }
extension Float: sizeable { }
extension float2: sizeable { }
extension float3: sizeable { }
extension float4: sizeable { }

struct Vertex: sizeable {
    var position: float3
    var textureCoordinates: float2
    var normal: float3
    var tangent: float3
    var bitangent: float3
}

struct SceneConstants: sizeable {
    var viewMatrix = matrix_identity_float4x4
    var projectionMatrix = matrix_identity_float4x4
}

struct ModelConstants: sizeable {
    var modelMatrix = matrix_identity_float4x4
}
