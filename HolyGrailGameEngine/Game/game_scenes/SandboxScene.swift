//
//  SandboxScene.swift
//  HolyGrailGameEngine
//
//  Created by Rick Twohy Jr on 6/13/19.
//  Copyright © 2019 Rick Twohy Jr. All rights reserved.
//

class SandboxScene: GameScene {
    let cruiser = Cruiser()
    let debugCamera = DebugCamera()
    override func buildScene() {
        debugCamera.setPosition(0,0,5)
        addCamera(debugCamera)
        
        addGameObject(cruiser)
    }
    
    override func onUpdate() {
        if(Mouse.IsMouseButtonPressed(button: .left)) {
            cruiser.rotateX(Mouse.GetDY() * GameTime.DeltaTime)
            cruiser.rotateY(Mouse.GetDX() * GameTime.DeltaTime)
        }
    }
}
