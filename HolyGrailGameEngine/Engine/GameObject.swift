//
//  GameObject.swift
//  HolyGrailGameEngine
//
//  Created by Rick Twohy Jr on 6/13/19.
//  Copyright © 2019 Rick Twohy Jr. All rights reserved.
//

import MetalKit

class GameObject: GameNode {
    private var _vertexDescriptor: MTLVertexDescriptor!
    private var _renderPipelineState: MTLRenderPipelineState!
    
    private var _mesh: Mesh!
    
    init(name: String, meshKey: String) {
        super.init(name: name)
        self._mesh = Entities.Meshes[meshKey]
    }
    
    override func setRenderPipelineValues(_ renderCommandEncoder: MTLRenderCommandEncoder) {
        renderCommandEncoder.setRenderPipelineState(Graphics.RenderPipelineStates[.Basic])
    }
    
}

extension GameObject: Renderable {
    func doRender(_ renderCommandEncoder: MTLRenderCommandEncoder) {
        _mesh.draw(renderCommandEncoder)
    }
}
