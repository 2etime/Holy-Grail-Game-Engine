//  Pikachu.swift
//  HolyGrailGameEngine
//
//  Created by Rick Twohy Jr on 6/30/19.
//  Copyright © 2019 Rick Twohy Jr. All rights reserved.
//

class RocketShip: GameObject {
    
    init() {
        super.init(name: "RocketShip", meshType: .RocketShip)
        setScale(0.01)
        setRotationZ(Float(180).toRadians)
        setRotationY(Float(90).toRadians)
        moveX(-1)
    }
    
}
