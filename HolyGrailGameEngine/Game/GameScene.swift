//
//  Scene.swift
//  HolyGrailGameEngine
//
//  Created by Rick Twohy Jr on 6/13/19.
//  Copyright © 2019 Rick Twohy Jr. All rights reserved.
//

import MetalKit


class GameScene: GameNode {
    private var _sceneConstants = SceneConstants()
    private var _lightManager = LightManager()

    override init(name: String) {
        super.init(name: name)
        
        buildScene()
    }
    
    func addCamera(_ camera: GameCamera) {
        Entities.Cameras.addCamera(camera: camera)
    }
    
    func addGameObject(_ gameObject: GameObject) {
        self.addChild(gameObject)
    }
    
    func addLight(_ lightObject: LightObject) {
        self.addChild(lightObject)
        _lightManager.addLightObject(lightObject)
    }
    
    internal func buildScene() { } // Override with inheriting classes
    
    override func update() {
        updateSceneConstants()
        super.update()
    }
    
    private func updateSceneConstants() {
        if(Entities.Cameras.currentCamera != nil) {
            self._sceneConstants.viewMatrix = Entities.Cameras.currentCamera.viewMatrix
            self._sceneConstants.inverseViewMatrix = self._sceneConstants.viewMatrix
            self._sceneConstants.projectionMatrix = Entities.Cameras.currentCamera.projectionMatrix            
        }
    }
    
    override func setRenderPipelineValues(_ renderCommandEncoder: MTLRenderCommandEncoder) {
        renderCommandEncoder.setVertexBytes(&_sceneConstants, length: SceneConstants.size, index: 1)
        self._lightManager.setLightData(renderCommandEncoder)
    }
}
