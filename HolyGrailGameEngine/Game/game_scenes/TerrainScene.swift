//
//  SandboxScene.swift
//  HolyGrailGameEngine
//
//  Created by Rick Twohy Jr on 6/13/19.
//  Copyright © 2019 Rick Twohy Jr. All rights reserved.
//

import MetalKit

class TerrainScene: GameScene {
    let debugCamera = DebugCamera()
    let sphere = Cruiser()
    let light = LightObject(name: "Light")
    override func buildScene() {
        debugCamera.setPosition(0,0,5)
        addCamera(debugCamera)
        
        light.setPosition(30,30,30)
        light.setLightBrightness(0.5)
        addLight(light)
        
        sphere.setMaterialAmbient(0.2)
        addGameObject(sphere)
    }
    
    override func onUpdate() {
        if(Mouse.IsMouseButtonPressed(button: .left)){
            sphere.rotateX(Mouse.GetDY() * GameTime.DeltaTime)
            sphere.rotateY(Mouse.GetDX() * GameTime.DeltaTime)
        }
    }
}
