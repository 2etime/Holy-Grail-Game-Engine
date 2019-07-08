//
//  SandboxScene.swift
//  HolyGrailGameEngine
//
//  Created by Rick Twohy Jr on 6/13/19.
//  Copyright © 2019 Rick Twohy Jr. All rights reserved.
//

import MetalKit


class TerrainScene: Scene {
    let Green: float4 = float4(0.1, 0.7, 0.1, 1.0)
    let White: float4 = float4(1,1,1,1)

    let debugCamera = DebugCamera()
    let sphereRed = Sphere()
    let sphereWhite = Sphere()
    let lamp = Lamp()
    override func buildScene() {
        debugCamera.setPosition(0,0,5)
        addCamera(debugCamera)
        
        lamp.setPosition(0,1,0)
        addLight(lamp)
        
        sphereRed.setPosition(-1,0,0)
        sphereRed.setMaterialColor(float4(0.9,0.2,0.1,1))
        addGameObject(sphereRed)
        
        sphereWhite.setPosition(1,0,0)
        addGameObject(sphereWhite)
    }
    
    override func onUpdate() {
        if(Mouse.IsMouseButtonPressed(button: .left)){
            sphereRed.moveX(Mouse.GetDX() * GameTime.DeltaTime)
        }
        
        if(sphereRed.intersects(sphereWhite)) {
            sphereWhite.setMaterialColor(Green)
        }else{
            sphereWhite.setMaterialColor(White)
        }
    }
}
