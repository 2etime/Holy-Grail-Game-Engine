//
//  MetalTypes.swift
//  HolyGrailGameEngine
//
//  Created by Rick Twohy Jr on 6/13/19.
//  Copyright © 2019 Rick Twohy Jr. All rights reserved.
//

import MetalKit

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

extension uint32: sizeable { }
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

struct BoundingVertex: sizeable {
    var position: float3
}

struct ModelConstants: sizeable{
    var modelMatrix = matrix_identity_float4x4
}

struct SceneConstants: sizeable {
    var viewMatrix = matrix_identity_float4x4
    var inverseViewMatrix = matrix_identity_float4x4
    var projectionMatrix = matrix_identity_float4x4
}

struct MaterialConstants: sizeable {
    var color = float4(0.8, 0.8, 0.8, 1.0)
    var useMaterialColor: Bool = false
    var useBaseTexture: Bool = false
    var useNormalMap: Bool = false
    var useSpecularMap: Bool = false
    var useAmbientMap: Bool = false
    var useHeightMap: Bool = false
    var isLightable: Bool = true
    
    
    var ambient: float3 = float3(1,1,1)
    var diffuse: float3 = float3(1,1,1)
    var specular: float3 = float3(1,1,1)
    var shininess: Float = 0.1 * 128
    
    var ambientMapIntensity: Float = 1.0
    var specularMapIntensity: Float = 1.0
}

struct LightData: sizeable {
    var position: float3 = float3(0,0,0)
    var color: float3 = float3(1,1,1)
    var brightness: Float = 1.0
    
    var ambientIntesity: Float = 1.0
    var diffuseIntensity: Float = 1.0
    var specularIntensity: Float = 1.0
}
