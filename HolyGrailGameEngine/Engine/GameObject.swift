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
        createVertexDescriptor()
        createRenderPipelineState()
        self._mesh = Entities.Meshes[meshKey]
    }
    
    private func createVertexDescriptor() {
        self._vertexDescriptor = MTLVertexDescriptor()
        
        //Position
        self._vertexDescriptor.attributes[0].format = .float3
        self._vertexDescriptor.attributes[0].bufferIndex = 0
        self._vertexDescriptor.attributes[0].offset = 0
        
        self._vertexDescriptor.layouts[0].stride = Vertex.stride
    }
    
    private func createRenderPipelineState() {
        let vertexFunction = Engine.DefaultLibrary.makeFunction(name: "vertex_shader")
        let fragmentFunction = Engine.DefaultLibrary.makeFunction(name: "fragment_shader")
        
        let name = "Basic"
        let renderPipelineDescriptor = MTLRenderPipelineDescriptor()
        renderPipelineDescriptor.colorAttachments[0].pixelFormat = EngineSettings.MainPixelFormat
        renderPipelineDescriptor.vertexDescriptor = self._vertexDescriptor
        renderPipelineDescriptor.vertexFunction = vertexFunction
        renderPipelineDescriptor.fragmentFunction = fragmentFunction
        renderPipelineDescriptor.label = "\(name) Render Pipeline State"
        
        do {
            _renderPipelineState = try Engine.Device.makeRenderPipelineState(descriptor: renderPipelineDescriptor)
        } catch {
            print("ERROR::CREATING::RENDER_PIPELINE_STATE::\(name) Render Pipeline State::\(error)")
        }
    }
    
    override func setRenderPipelineValues(_ renderCommandEncoder: MTLRenderCommandEncoder) {
        renderCommandEncoder.setRenderPipelineState(_renderPipelineState)
    }
    
}

extension GameObject: Renderable {
    func doRender(_ renderCommandEncoder: MTLRenderCommandEncoder) {
        _mesh.draw(renderCommandEncoder)
    }
}
