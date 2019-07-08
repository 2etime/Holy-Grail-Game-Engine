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
    let cruiser = Cruiser()
    let lamp = Lamp()
    override func buildScene() {
        debugCamera.setPosition(0,0,5)
        addCamera(debugCamera)
        
        lamp.setPosition(0,1,0)
        addLight(lamp)
        
        cruiser.setMaterialAmbient(0.2)
        cruiser.setMaterialShininess(20)
        cruiser.setMaterialSpecular(2)
        addGameObject(cruiser)
    }
    
    override func onUpdate() {
        if(Mouse.IsMouseButtonPressed(button: .left)){
            cruiser.rotateX(Mouse.GetDY() * GameTime.DeltaTime)
            cruiser.rotateY(Mouse.GetDX() * GameTime.DeltaTime)
        }
    }
}
