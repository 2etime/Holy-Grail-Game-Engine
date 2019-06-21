//
//  SandboxScene.swift
//  HolyGrailGameEngine
//
//  Created by Rick Twohy Jr on 6/13/19.
//  Copyright © 2019 Rick Twohy Jr. All rights reserved.
//

import MetalKit

class SandboxScene: GameScene {
    let sphere = Sphere()
    let debugCamera = DebugCamera()
    let light = Lamp()
    override func buildScene() {
        debugCamera.setPosition(0,0,6)
        addCamera(debugCamera)
        
        let midColor = float3(1,1,1)
        light.setPosition(20, 20, 20)
        light.setLightColor(midColor)
        light.setMaterialColor(midColor.x, midColor.y, midColor.z, 1.0)
        light.setMaterialIsLightable(false)
        light.setLightAmbientIntensity(1.0)
        light.setLightDiffuseIntensity(1.0)
        light.setLightSpecularIntensity(1.0)
        addLight(light)
        
        sphere.setMaterialAmbient(0.03)
        sphere.setMaterialDiffuse(0.8)
        sphere.setMaterialSpecular(0.5)
        sphere.setMaterialShininess(0.1 * 128)
        sphere.setBaseTexture(.Sand_Base)
        
        addGameObject(sphere)
    }
    
    override func onUpdate() {
        if(Mouse.IsMouseButtonPressed(button: .left)){
            sphere.rotateX(Mouse.GetDY() * GameTime.DeltaTime)
            sphere.rotateY(Mouse.GetDX() * GameTime.DeltaTime)
        }
    }
}
