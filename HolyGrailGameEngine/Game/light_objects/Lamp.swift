//
//  Lamp.swift
//  HolyGrailGameEngine
//
//  Created by Rick Twohy Jr on 6/17/19.
//  Copyright © 2019 Rick Twohy Jr. All rights reserved.
//

import simd

class Lamp: LightObject {
    init() {
        super.init(name: "Lamp", meshType: .Sphere)
        self.setMaterialColor(float4(1,1,1,1))
        self.setScale(0.6)
    }
}
