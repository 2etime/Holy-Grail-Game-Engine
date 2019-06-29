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
        debugCamera.setPosition(0,0,15)
//        debugCamera.setRotationX(0.4)
        addCamera(debugCamera)
        
        light.setPosition(0, 100, 20)
        light.setLightBrightness(0.5)
        addLight(light)
        
        quad.setMaterialColor(float4(0.0, 0.5, 0.0, 1.0))
        quad.rotateX(Float(90).toRadians)
        quad.setUseTessellation(true)
        addGameObject(quad)
    }
    
    override func onUpdate() {
        if(Mouse.IsMouseButtonPressed(button: .left)){
            quad.rotateX(Mouse.GetDY() * GameTime.DeltaTime)
            quad.rotateY(Mouse.GetDX() * GameTime.DeltaTime)
        }
        
        if(Keyboard.IsKeyPressed(.space)){
            light.moveX(Mouse.GetDX() * GameTime.DeltaTime * 5)
            light.moveY(-Mouse.GetDY() * GameTime.DeltaTime * 5)
        }
        
        let change = Mouse.GetDWheel()
        quad.addEdgeFactor(-change)
        quad.addInsideFactor(-change)
        
        let speed: Float = 5
        if(Keyboard.IsKeyPressed(.upArrow)) {
            debugCamera.moveZ(-GameTime.DeltaTime * speed)
        }
        
        if(Keyboard.IsKeyPressed(.downArrow)) {
            debugCamera.moveZ(GameTime.DeltaTime * speed)
        }
        
        if(Keyboard.IsKeyPressed(.leftArrow)) {
            debugCamera.moveX(-GameTime.DeltaTime * speed)
        }
        
        if(Keyboard.IsKeyPressed(.rightArrow)) {
            debugCamera.moveX(GameTime.DeltaTime * speed)
        }
    }
}
