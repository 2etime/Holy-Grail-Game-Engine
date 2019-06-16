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
}

class SceneManager {
    private var _currentScene: GameScene!
    private var _currentBufferIndex: Int = 0
    
    init(startingSceneType: SceneTypes) {
        setScene(startingSceneType)
    }
    
    public func setScene(_ sceneType: SceneTypes){
        switch sceneType {
        case .Sandbox:
            self._currentScene = SandboxScene(name: "Sandbox Scene")
        }
    }
    
    public func update(deltaTime: Float) {
        GameTime.UpdateGameTime(deltaTime)
        
        self._currentBufferIndex = (self._currentBufferIndex + 1) % EngineSettings.MaxBuffersInFlight
        
        self._currentScene.updateCameras()
        
        self._currentScene.update(currentBufferIndex: self._currentBufferIndex)
    }
    
    public func mainRenderPass(renderCommandEncoder: MTLRenderCommandEncoder){
        _currentScene.render(renderCommandEncoder)
    }
    
    
}

