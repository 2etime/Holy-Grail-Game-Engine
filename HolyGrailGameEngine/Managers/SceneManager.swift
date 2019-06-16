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
    
    private static var _currentScene: GameScene!
    
    public static func Initialize(_ sceneType: SceneTypes){
        SetScene(sceneType)
    }
    
    public static func SetScene(_ sceneType: SceneTypes){
        switch sceneType {
        case .Sandbox:
            self._currentScene = SandboxScene(name: "Sandbox Scene")
        }
    }
    
    public static func Update(deltaTime: Float) {
        GameTime.UpdateGameTime(deltaTime)
        
        _currentScene.updateCameras()
        
        _currentScene.update()
    }
    
    public static func MainRenderPass(renderCommandEncoder: MTLRenderCommandEncoder){
        _currentScene.render(renderCommandEncoder)
    }
    
    
}

