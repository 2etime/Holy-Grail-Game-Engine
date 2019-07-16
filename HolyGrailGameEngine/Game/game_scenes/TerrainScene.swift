//
//  SandboxScene.swift
//  HolyGrailGameEngine
//
//  Created by Rick Twohy Jr on 6/13/19.
//  Copyright © 2019 Rick Twohy Jr. All rights reserved.
//

import MetalKit

class TerrainScene: Scene {
    let debugCamera = DebugCamera()
    let helmet = Helmet()
    let lamp = Lamp()
    override func buildScene() {
        debugCamera.setPosition(0,0,5)
        addCamera(debugCamera)
        
        lamp.setPosition(1.5,1.5,1.5)
        addLight(lamp)
        

        helmet.setMaterialAmbient(0.03)
        addGameObject(helmet)
    }
    
    override func onUpdate() {
        if(Mouse.IsMouseButtonPressed(button: .left)) {
            lamp.moveX(Mouse.GetDX() * GameTime.DeltaTime)
            lamp.moveY(-Mouse.GetDY() * GameTime.DeltaTime)
        }
    }
}
