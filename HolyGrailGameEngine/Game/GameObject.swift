//
//  GameObject.swift
//  HolyGrailGameEngine
//
//  Created by Rick Twohy Jr on 6/13/19.
//  Copyright © 2019 Rick Twohy Jr. All rights reserved.
//

import MetalKit

class GameObject: GameNode {
    private var _modelBufferConstants: BufferManager<ModelConstants>!
    private var _currentBufferIndex: Int = 0
    
    private var _mesh: Mesh!

    init(name: String, meshKey: String) {
        super.init(name: name)
        self._modelBufferConstants = BufferManager(proto: ModelConstants(),
                                                   bufferCount: EngineSettings.MaxBuffersInFlight)
        self._mesh = Entities.Meshes[meshKey]
    }
    
    override func update(currentBufferIndex: Int) {
        self._currentBufferIndex = currentBufferIndex
        updateModelConstants(currentBufferIndex: currentBufferIndex)
        super.update(currentBufferIndex: currentBufferIndex)
    }
    
    private func updateModelConstants(currentBufferIndex: Int) {
        var modelConstants = self._modelBufferConstants.getBuffer(index: _currentBufferIndex)
        modelConstants.modelMatrix = self.modelMatrix
        self._modelBufferConstants.setBuffer(index: _currentBufferIndex, modelConstants)
    }
    
    override func setRenderPipelineValues(_ renderCommandEncoder: MTLRenderCommandEncoder) {
        var modelConstants = self._modelBufferConstants.getBuffer(index: _currentBufferIndex)
        renderCommandEncoder.setRenderPipelineState(Graphics.RenderPipelineStates[.Basic])
        renderCommandEncoder.setVertexBytes(&modelConstants,
                                            length: ModelConstants.stride,
                                            index: 2)
    }
}

extension GameObject: Renderable {
    func doRender(_ renderCommandEncoder: MTLRenderCommandEncoder) {
        _mesh.draw(renderCommandEncoder)
    }
}
