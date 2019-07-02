//
//  SandboxScene.swift
//  HolyGrailGameEngine
//
//  Created by Rick Twohy Jr on 6/13/19.
//  Copyright © 2019 Rick Twohy Jr. All rights reserved.
//

import MetalKit

class TerrainScene: GameScene {
    let terrain = Terrain()
    let debugCamera = DebugCamera()
    let light = Lamp()
    override func buildScene() {
        debugCamera.setPosition(0,0,1)
        debugCamera.rotateX(0.3)
        addCamera(debugCamera)
        
        light.setPosition(0, 0, 0)
        light.setLightBrightness(0.5)
        addLight(light)
        
        terrain.setMaterialColor(float4(0.0, 0.5, 0.0, 1.0))
        terrain.setMaterialShininess(128)
        terrain.setPosition(0,-0.5,0)
//        terrain.setTriangleFillMode(.lines)
        terrain.setHeightMap(.Sand_Height)
        terrain.setBaseTexture(.Sand_Base)
        terrain.setNormalMap(.Sand_Normal)
        terrain.setMaterialAmbient(0.03)
        addGameObject(terrain)
    }
    
    override func onUpdate() {
        if(Mouse.IsMouseButtonPressed(button: .left)){
            terrain.rotateX(Mouse.GetDY() * GameTime.DeltaTime)
            terrain.rotateY(Mouse.GetDX() * GameTime.DeltaTime)
        }
        
        if(Keyboard.IsKeyPressed(.space)){
            light.moveX(Mouse.GetDX() * GameTime.DeltaTime * 5)
            light.moveY(-Mouse.GetDY() * GameTime.DeltaTime * 5)
        }
        
        let change = Mouse.GetDWheel()
        terrain.addEdgeFactor(-change)
        terrain.addInsideFactor(-change)
        
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
