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
    let light = LightObject(name: "Light")
    override func buildScene() {
        debugCamera.setPosition(0,0,5)
        addCamera(debugCamera)
        
        light.setPosition(30,30,30)
        light.setLightBrightness(0.5)
        addLight(light)
        
        cruiser.setMaterialAmbient(0.2)
        addGameObject(cruiser)
    }
    
    override func onUpdate() {
        if(Mouse.IsMouseButtonPressed(button: .left)){
            cruiser.rotateX(Mouse.GetDY() * GameTime.DeltaTime)
            cruiser.rotateY(Mouse.GetDX() * GameTime.DeltaTime)
        }
    }
}
