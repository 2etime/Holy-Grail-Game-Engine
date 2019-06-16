//
//  Scene.swift
//  HolyGrailGameEngine
//
//  Created by Rick Twohy Jr on 6/13/19.
//  Copyright © 2019 Rick Twohy Jr. All rights reserved.
//

import MetalKit

class GameScene: GameNode {
    private var _cameraManager = CameraManager()
    private var _sceneBuffers: BufferManager<SceneConstants>!
    private var _currentBufferIndex: Int = 0

    override init(name: String) {
        super.init(name: name)
        self._sceneBuffers = BufferManager(proto: SceneConstants(),
                                           bufferCount: EngineSettings.MaxBuffersInFlight)
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
        var sceneConstants = self._sceneBuffers.getBuffer(index: _currentBufferIndex)
        sceneConstants.viewMatrix = self._cameraManager.currentCamera.viewMatrix
        sceneConstants.projectionMatrix = self._cameraManager.currentCamera.projectionMatrix
        self._sceneBuffers.setBuffer(index: _currentBufferIndex, sceneConstants)
    }
    
    override func setRenderPipelineValues(_ renderCommandEncoder: MTLRenderCommandEncoder) {
        var sceneConstants = self._sceneBuffers.getBuffer(index: _currentBufferIndex)
        renderCommandEncoder.setVertexBytes(&sceneConstants, length: SceneConstants.size, index: 1)
    }
}
