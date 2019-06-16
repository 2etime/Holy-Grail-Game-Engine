//
//  SandboxScene.swift
//  HolyGrailGameEngine
//
//  Created by Rick Twohy Jr on 6/13/19.
//  Copyright © 2019 Rick Twohy Jr. All rights reserved.
//

class SandboxScene: GameScene {
    let triangle = Triangle()
    let debugCamera = DebugCamera()
    
    override func buildScene() {
        debugCamera.setPosition(0,0,8)
        setCamera(debugCamera)
        
        triangle.setScale(0.5)
        addGameObject(triangle)
    }
    
    override func onUpdate() {
        
    }
}
