//
//  MeshLibrary.swift
//  HolyGrailGameEngine
//
//  Created by Rick Twohy Jr on 6/14/19.
//  Copyright © 2019 Rick Twohy Jr. All rights reserved.
//

import Metal

struct MeshKeys {
    public static let Triangle = "Triangle"
}

class MeshLibrary: Library<Mesh> {
    override func createDefaultLibraryItems() {
        addItem(key: MeshKeys.Triangle, value: Triangle_CustomMesh())
    }
}

protocol Mesh {
    func draw(_ renderCommandEncoder: MTLRenderCommandEncoder)
}
