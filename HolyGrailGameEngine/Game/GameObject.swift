//
//  GameObject.swift
//  HolyGrailGameEngine
//
//  Created by Rick Twohy Jr on 6/13/19.
//  Copyright © 2019 Rick Twohy Jr. All rights reserved.
//

import MetalKit

class GameObject: GameNode {
    private var _modelConstants: [ModelConstants]!
    private var _currentBufferIndex: Int = 0
    
    private var _mesh: Mesh!

    init(name: String, meshKey: String) {
        super.init(name: name)
        self._modelConstants = [ModelConstants].init(repeating: ModelConstants(), count: EngineSettings.MaxBuffersInFlight)
        self._mesh = Entities.Meshes[meshKey]
    }
    
    override func update(currentBufferIndex: Int) {
        self._currentBufferIndex = currentBufferIndex
        
        updateModelConstants()
        super.update(currentBufferIndex: currentBufferIndex)
    }
    
    private func updateModelConstants() {
        self._modelConstants[self._currentBufferIndex].modelMatrix = self.modelMatrix
    }
    
    override func setRenderPipelineValues(_ renderCommandEncoder: MTLRenderCommandEncoder) {
        renderCommandEncoder.setRenderPipelineState(Graphics.RenderPipelineStates[.Basic])
        renderCommandEncoder.setVertexBytes(&self._modelConstants[self._currentBufferIndex],
                                            length: ModelConstants.stride,
                                            index: 2)
    }
}

extension GameObject: Renderable {
    func doRender(_ renderCommandEncoder: MTLRenderCommandEncoder) {
        _mesh.draw(renderCommandEncoder)
    }
}
