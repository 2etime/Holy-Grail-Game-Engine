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
    case Cruiser
    case Sphere
}

class MeshLibrary: Library<MeshTypes, Mesh> {
    
    private var _library: [MeshTypes:Mesh] = [:]
    
    override func fillLibrary() {
        _library.updateValue(NoMesh(), forKey: .None)
        
        _library.updateValue(Triangle_CustomMesh(), forKey: .Triangle)
        _library.updateValue(ModelMesh(modelName: "cruiser"), forKey: .Cruiser)
        _library.updateValue(ModelMesh(modelName: "sphere"), forKey: .Sphere)
    }
    
    override subscript(_ type: MeshTypes)->Mesh {
        return _library[type]!
    }
    
}

class NoMesh: Mesh {
    func setInstanceCount(_ count: Int) { }
    func draw(_ renderCommandEncoder: MTLRenderCommandEncoder) {}
}

protocol Mesh {
    func draw(_ renderCommandEncoder: MTLRenderCommandEncoder)
}
