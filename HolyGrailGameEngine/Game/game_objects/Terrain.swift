//
//  Quad.swift
//  HolyGrailGameEngine
//
//  Created by Rick Twohy Jr on 6/20/19.
//  Copyright © 2019 Rick Twohy Jr. All rights reserved.
//

class Terrain: GameObject {
    init() {
        super.init(name: "Terrain", meshType: .Quad_Tessellated)
    }
}
