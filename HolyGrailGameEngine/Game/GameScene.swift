//
//  Scene.swift
//  HolyGrailGameEngine
//
//  Created by Rick Twohy Jr on 6/13/19.
//  Copyright © 2019 Rick Twohy Jr. All rights reserved.
//

import MetalKit

class GameScene: GameNode {
    private var _sceneConstants: [SceneConstants]!
    private var _cameraManager = CameraManager()
    private var _currentBufferIndex: Int = 0

    override init(name: String) {
        super.init(name: name)
        self._sceneConstants = [SceneConstants].init(repeating: SceneConstants(), count: EngineSettings.MaxBuffersInFlight)
        buildScene()
    }
    
    func addCamera(_ camera: GameCamera) {
        self._cameraManager.registerCamera(camera: camera)
    }
    
    func addGameObject(_ gameObject: GameObject) {
        self.addChild(gameObject)
    }
    
    internal func buildScene() { } // Override with inheriting classes
    
    override func update(currentBufferIndex: Int) {
        self._currentBufferIndex = currentBufferIndex
        
        updateSceneConstants()
        super.update(currentBufferIndex: currentBufferIndex)
    }
    
    func updateCameras(){
        _cameraManager.update(currentBufferIndex: self._currentBufferIndex)
    }
    
    private func updateSceneConstants() {
        self._sceneConstants[self._currentBufferIndex].viewMatrix = self._cameraManager.currentCamera.viewMatrix
        self._sceneConstants[self._currentBufferIndex].projectionMatrix = self._cameraManager.currentCamera.projectionMatrix
    }
    
    override func setRenderPipelineValues(_ renderCommandEncoder: MTLRenderCommandEncoder) {
        renderCommandEncoder.setVertexBytes(&self._sceneConstants[self._currentBufferIndex], length: SceneConstants.size, index: 1)
    }
}
