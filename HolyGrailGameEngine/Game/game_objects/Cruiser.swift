//
//  Cruiser.swift
//  HolyGrailGameEngine
//
//  Created by Rick Twohy Jr on 6/16/19.
//  Copyright © 2019 Rick Twohy Jr. All rights reserved.
//

class Cruiser: GameObject, Boundable {
    init() {
        super.init(name: "Cruiser", meshType: .Cruiser)
        setBaseTexture(.Cruiser_Base)
    }
}
