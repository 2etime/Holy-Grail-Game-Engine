//
//  SceneManager.swift
//  HolyGrailGameEngine
//
//  Created by Rick Twohy Jr on 6/16/19.
//  Copyright © 2019 Rick Twohy Jr. All rights reserved.
//

import Metal

enum SceneTypes{
    case Sandbox
    case Quad
}

class SceneManager {
    private var _currentScene: GameScene!
    
    init(startingSceneType: SceneTypes) {
        setScene(startingSceneType)
    }
    
    public func setScene(_ sceneType: SceneTypes){
        switch sceneType {
        case .Sandbox:
            self._currentScene = SandboxScene(name: "Sandbox Scene")
        case .Quad:
            self._currentScene = QuadScene(name: "Quad Scene")
        }
    }
    
    public func update(deltaTime: Float) {
        GameTime.UpdateGameTime(deltaTime)

        self._currentScene.updateCameras()
        
        self._currentScene.doComputePass()
        
        self._currentScene.update()
    }
    
    public func mainRenderPass(renderCommandEncoder: MTLRenderCommandEncoder){
        _currentScene.render(renderCommandEncoder)
    }
    
    
}

