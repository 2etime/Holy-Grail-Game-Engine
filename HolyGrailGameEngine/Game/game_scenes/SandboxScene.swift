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
    let lamp = Lamp()
    override func buildScene() {
        debugCamera.setPosition(0,1,6)
        addCamera(debugCamera)
        
        lamp.setPosition(0, 2, 2)
        lamp.setMaterialIsLightable(false)
        lamp.setLightAmbientIntensity(1.0)
        lamp.setLightDiffuseIntensity(1.0)
        lamp.setLightSpecularIntensity(1.0)
        addLight(lamp)
        
        sphere.setMaterialAmbient(0.03)
        sphere.setMaterialDiffuse(0.8)
        sphere.setMaterialSpecular(1)
        sphere.setMaterialShininess(0.8 * 128)
        sphere.setSpecularMapIntensity(15)
        
        sphere.setBaseTexture(.Sand_Base)
        sphere.setNormalMap(.Sand_Normal)
        sphere.setSpecularMap(.Sand_Specular)
        addGameObject(sphere)
    }
    
    override func onUpdate() {
        if(Mouse.IsMouseButtonPressed(button: .left)) {
            sphere.rotateX(Mouse.GetDY() * GameTime.DeltaTime)
            sphere.rotateY(Mouse.GetDX() * GameTime.DeltaTime)
        }
        if(Keyboard.IsKeyPressed(.space)){
            sphere.setSpecularMapIntensity(sphere.getSpecularMapIntensity() - Mouse.GetDWheel())
        }else{
            lamp.setLightBrightness(lamp.getLightBrightness() - Mouse.GetDWheel() * GameTime.DeltaTime)
        }
    }
}
