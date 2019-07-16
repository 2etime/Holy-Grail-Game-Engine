//
//  Helmet.swift
//  HolyGrailGameEngine
//
//  Created by Rick Twohy Jr on 7/15/19.
//  Copyright © 2019 Rick Twohy Jr. All rights reserved.
//

class Helmet: GameObject {
//    var boundingType: BoundingTypes {
//        return .Sphere
//    }
    
    init() {
        super.init(name: "Helmet", meshType: .Helmet)
        
        setBaseTexture(.Helmet_Albedo)
        setMaterialAmbient(0.3)
    }
    
    override func onUpdate() {
        if(Mouse.IsMouseButtonPressed(button: .left)) {
            self.rotateX(Mouse.GetDY() * GameTime.DeltaTime)
            self.rotateY(Mouse.GetDX() * GameTime.DeltaTime)
        }
    }
}
