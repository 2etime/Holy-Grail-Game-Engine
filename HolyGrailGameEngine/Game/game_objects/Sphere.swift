//
//  Sphere.swift
//  HolyGrailGameEngine
//
//  Created by Rick Twohy Jr on 6/17/19.
//  Copyright © 2019 Rick Twohy Jr. All rights reserved.
//

class Sphere: GameObject, Boundable {
    
    var boundingTypes: [BoundingTypes] = [.Sphere]
    
    init() {
        super.init(name: "Sphere", meshType: .Sphere)
        
        setMaterialAmbient(0.2)
        setMaterialShininess(35)
    }
}
