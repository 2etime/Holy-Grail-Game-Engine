//
//  Pikachu.swift
//  HolyGrailGameEngine
//
//  Created by Rick Twohy Jr on 6/30/19.
//  Copyright © 2019 Rick Twohy Jr. All rights reserved.
//

class Pikachu: GameObject {
    
    init() {
        super.init(name: "Pikachu", meshType: .Pikachu)
        setScale(0.3)
        moveY(-1)
    }
    
}
