//
//  RenderPipelineStateLibrary.swift
//  HolyGrailGameEngine
//
//  Created by Rick Twohy Jr on 6/15/19.
//  Copyright © 2019 Rick Twohy Jr. All rights reserved.
//

import Metal

enum RenderPipelineStateTypes {
    case Basic
}

class RenderPipelineStateLibrary {
    
    private var _library: [RenderPipelineStateTypes:RenderPipelineState] = [:]

    init() {
        createLibrary()
    }
    
    private func createLibrary() {
        _library.updateValue(Basic_RenderPipelineState(), forKey: .Basic)
    }
    
    subscript(_ type: RenderPipelineStateTypes)->MTLRenderPipelineState{
        return self._library[type]!.renderPipelineState
    }
    
}

private class RenderPipelineState {
    var renderPipelineState: MTLRenderPipelineState!
    init(renderPipelineDescriptor: MTLRenderPipelineDescriptor) {
        do{
            renderPipelineState = try Engine.Device.makeRenderPipelineState(descriptor: renderPipelineDescriptor)
        }catch let error as NSError {
            print("ERROR::CREATE::RENDER_PIPELINE_STATE::__::\(error)")
        }
    }
}

private class Basic_RenderPipelineState: RenderPipelineState {
    init() {
        let vertexFunction = Engine.DefaultLibrary.makeFunction(name: "vertex_shader")
        let fragmentFunction = Engine.DefaultLibrary.makeFunction(name: "fragment_shader")
        
        let vertexDescriptor = MTLVertexDescriptor()
        
        //Position
        vertexDescriptor.attributes[0].format = .float3
        vertexDescriptor.attributes[0].bufferIndex = 0
        vertexDescriptor.attributes[0].offset = 0
        
        vertexDescriptor.layouts[0].stride = Vertex.stride
        
        let renderPipelineDescriptor = MTLRenderPipelineDescriptor()
        renderPipelineDescriptor.colorAttachments[0].pixelFormat = EngineSettings.MainPixelFormat
        renderPipelineDescriptor.vertexFunction = vertexFunction
        renderPipelineDescriptor.fragmentFunction = fragmentFunction
        renderPipelineDescriptor.vertexDescriptor = vertexDescriptor
        
        super.init(renderPipelineDescriptor: renderPipelineDescriptor)
    }
}


