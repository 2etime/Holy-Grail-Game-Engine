//
//  Quad.swift
//  HolyGrailGameEngine
//
//  Created by Rick Twohy Jr on 6/30/19.
//  Copyright © 2019 Rick Twohy Jr. All rights reserved.
//

import Foundation

class Quad: GameObject {
    
    init() {
        super.init(name: "Quad", meshType: .Quad)
        setBaseTexture(.Sand_Base)
        
    }
    
}
