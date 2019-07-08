//
//  MeshLibrary.swift
//  HolyGrailGameEngine
//
//  Created by Rick Twohy Jr on 6/14/19.
//  Copyright © 2019 Rick Twohy Jr. All rights reserved.
//

import Metal

enum MeshTypes {
    case None
    case Triangle
    case Quad
    
    case Cruiser
    case Sphere
    
    case Quad_Tessellated
}

class MeshLibrary: Library<MeshTypes, Mesh> {
    
    private var _library: [MeshTypes:Mesh] = [:]
    
    override func fillLibrary() {
        _library.updateValue(NoMesh(), forKey: .None)
        
        _library.updateValue(Triangle_CustomMesh(), forKey: .Triangle)
        _library.updateValue(Quad_CustomMesh(), forKey: .Quad)
        
        _library.updateValue(ModelMesh(modelName: "cruiser"), forKey: .Cruiser)
        _library.updateValue(ModelMesh(modelName: "sphere"), forKey: .Sphere)
        
        _library.updateValue(QuadTessellated_CustomMesh(), forKey: .Quad_Tessellated)
    }
    
    override subscript(_ type: MeshTypes)->Mesh {
        return _library[type]!
    }
    
}

class NoMesh: Mesh {
    var bounds: [BoundingBox] = []
    func setInstanceCount(_ count: Int) { }
    func drawRender(_ renderCommandEncoder: MTLRenderCommandEncoder) {}
    func drawPatches(_ renderCommandEncoder: MTLRenderCommandEncoder) {}
}

protocol Mesh {
    var bounds: [BoundingBox] { get }
    func setInstanceCount(_ count: Int)
    func drawRender(_ renderCommandEncoder: MTLRenderCommandEncoder)
    func drawPatches(_ renderCommandEncoder: MTLRenderCommandEncoder)
}
