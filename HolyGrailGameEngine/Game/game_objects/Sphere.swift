//
//  Sphere.swift
//  HolyGrailGameEngine
//
//  Created by Rick Twohy Jr on 6/17/19.
//  Copyright © 2019 Rick Twohy Jr. All rights reserved.
//

class Sphere: GameObject, Boundable {
    var boundingType: BoundingTypes {
        return .Sphere
    }
    
    init() {
        super.init(name: "Sphere", meshType: .Sphere)
        
        setMaterialAmbient(0.06)
        setMaterialShininess(35)
    }
}
