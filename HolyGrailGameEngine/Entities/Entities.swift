//
//  Entities.swift
//  HolyGrailGameEngine
//
//  Created by Rick Twohy Jr on 6/14/19.
//  Copyright © 2019 Rick Twohy Jr. All rights reserved.
//

import simd

class Entities {
    private static var _meshLibrary: MeshLibrary!
    public static var Meshes: MeshLibrary { return self._meshLibrary }
    
    public static func Initialize() {
        self._meshLibrary = MeshLibrary()
    }
}
