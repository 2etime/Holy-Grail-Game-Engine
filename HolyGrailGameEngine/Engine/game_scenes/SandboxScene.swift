//
//  SandboxScene.swift
//  HolyGrailGameEngine
//
//  Created by Rick Twohy Jr on 6/13/19.
//  Copyright © 2019 Rick Twohy Jr. All rights reserved.
//

class SandboxScene: GameScene {
    
    let triangle = Triangle()
    override func buildScene() {
        addChild(triangle)
    }

}
