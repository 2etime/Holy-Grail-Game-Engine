//
//  Quad.swift
//  HolyGrailGameEngine
//
//  Created by Rick Twohy Jr on 6/20/19.
//  Copyright © 2019 Rick Twohy Jr. All rights reserved.
//
import simd

class Terrain: GameObject {

    init() {
        super.init(name: "Terrain", meshType: .Quad_Tessellated, useTessellation: true)
//        setTriangleFillMode(.lines)
        
    }
    
    override func onUpdate() {
        let distance: Float = length(Entities.Cameras.currentCamera.getPosition() - self.getPosition())
        print(10 - distance)
        self.setEdgeFactor((10 - distance) * 8)
        self.setInsideFactor((10 - distance) * 8)
    }
}
