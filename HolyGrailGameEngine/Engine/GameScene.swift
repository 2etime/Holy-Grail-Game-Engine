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
    override init(name: String) {
        super.init(name: name)
        
        buildScene()
    }
    
    internal func buildScene() {
        // Override with inheriting classes
    }
    
    override func setRenderPipelineValues(_ renderCommandEncoder: MTLRenderCommandEncoder) {
        renderCommandEncoder.setVertexBytes(&_sceneConstants, length: SceneConstants.size, index: 1)
    }
}
