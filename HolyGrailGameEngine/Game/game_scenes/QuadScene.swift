//
//  SandboxScene.swift
//  HolyGrailGameEngine
//
//  Created by Rick Twohy Jr on 6/13/19.
//  Copyright © 2019 Rick Twohy Jr. All rights reserved.
//

import MetalKit

class QuadScene: GameScene {
    let quad = Quad()
    let debugCamera = DebugCamera()
    let light = Lamp()
    override func buildScene() {
        debugCamera.setPosition(0,0,8)
        addCamera(debugCamera)
        
        light.setPosition(0, 2, 2)
        light.setLightBrightness(0.5)
        addLight(light)
        
        quad.setMaterialColor(float4(0.5, 0.5, 0.5, 1.0))
        quad.setMaterialShininess(128)
        quad.setBaseTexture(.Sand_Base)
        quad.setMaterialAmbient(0.03)
        addGameObject(quad)
    }
    
    override func onUpdate() {
        if(Mouse.IsMouseButtonPressed(button: .left)){
            quad.rotateX(Mouse.GetDY() * GameTime.DeltaTime)
            quad.rotateY(Mouse.GetDX() * GameTime.DeltaTime)
        }
        
        if(Keyboard.IsKeyPressed(.space)){
            light.moveX(Mouse.GetDX() * GameTime.DeltaTime * 5)
            light.moveY(Mouse.GetDY() * GameTime.DeltaTime * 5)
        }
        
        
    }
}
