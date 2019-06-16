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
    private var _currentCamera: GameCamera!
    override init(name: String) {
        super.init(name: name)
        
        buildScene()
    }
    
    func setCamera(_ camera: GameCamera) {
        self._currentCamera = camera
    }
    
    func addGameObject(_ gameObject: GameObject) {
        self.addChild(gameObject)
    }
    
    internal func buildScene() { } // Override with inheriting classes
    
    override func update() {
        updateSceneConstants()
        super.update()
    }
    
    private func updateSceneConstants() {
        self._sceneConstants.viewMatrix = self._currentCamera.viewMatrix
        self._sceneConstants.projectionMatrix = self._currentCamera.projectionMatrix
    }
    
    override func setRenderPipelineValues(_ renderCommandEncoder: MTLRenderCommandEncoder) {
        renderCommandEncoder.setVertexBytes(&_sceneConstants, length: SceneConstants.size, index: 1)
    }
}
