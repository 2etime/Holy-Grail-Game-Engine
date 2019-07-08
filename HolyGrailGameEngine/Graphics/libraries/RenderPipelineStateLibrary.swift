//
//  RenderPipelineStateLibrary.swift
//  HolyGrailGameEngine
//
//  Created by Rick Twohy Jr on 6/15/19.
//  Copyright © 2019 Rick Twohy Jr. All rights reserved.
//

import MetalKit

enum RenderPipelineStateTypes {
    case None
    case Basic
    case Bounds
    case QuadTessellation
}

class RenderPipelineStateLibrary {
    
    private var _library: [RenderPipelineStateTypes:RenderPipelineState] = [:]

    init() {
        createLibrary()
    }
    
    private func createLibrary() {
        _library.updateValue(Basic_RenderPipelineState(), forKey: .Basic)
        _library.updateValue(Bounds_RenderPipelineState(), forKey: .Bounds)
        _library.updateValue(QuadTessellation_RenderPipelineState(), forKey: .QuadTessellation)
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
        
        //Texture Coordinates
        vertexDescriptor.attributes[1].format = .float2
        vertexDescriptor.attributes[1].bufferIndex = 0
        vertexDescriptor.attributes[1].offset = float3.size
        
        //Normal
        vertexDescriptor.attributes[2].format = .float3
        vertexDescriptor.attributes[2].bufferIndex = 0
        vertexDescriptor.attributes[2].offset = float3.size + float3.size
        
        //Tangent
        vertexDescriptor.attributes[3].format = .float3
        vertexDescriptor.attributes[3].bufferIndex = 0
        vertexDescriptor.attributes[3].offset = float3.size + float3.size + float3.size
        
        //Bitangent
        vertexDescriptor.attributes[4].format = .float3
        vertexDescriptor.attributes[4].bufferIndex = 0
        vertexDescriptor.attributes[4].offset = float3.size + float3.size + float3.size + float3.size
        
        vertexDescriptor.layouts[0].stride = Vertex.stride
        
        let renderPipelineDescriptor = MTLRenderPipelineDescriptor()
        renderPipelineDescriptor.colorAttachments[0].pixelFormat = EngineSettings.MainPixelFormat
        renderPipelineDescriptor.depthAttachmentPixelFormat = EngineSettings.MainDepthPixelFormat
        renderPipelineDescriptor.sampleCount = EngineSettings.SampleCount
        renderPipelineDescriptor.vertexFunction = vertexFunction
        renderPipelineDescriptor.fragmentFunction = fragmentFunction
        renderPipelineDescriptor.vertexDescriptor = vertexDescriptor
        
        super.init(renderPipelineDescriptor: renderPipelineDescriptor)
    }
}


private class Bounds_RenderPipelineState: RenderPipelineState {
    init() {
        let vertexFunction = Engine.DefaultLibrary.makeFunction(name: "bounds_vertex_shader")
        let fragmentFunction = Engine.DefaultLibrary.makeFunction(name: "bounds_fragment_shader")
        
        let vertexDescriptor = MTLVertexDescriptor()
        
        //Position
        vertexDescriptor.attributes[0].format = .float3
        vertexDescriptor.attributes[0].bufferIndex = 0
        vertexDescriptor.attributes[0].offset = 0

        vertexDescriptor.layouts[0].stride = BoundingVertex.stride
        
        let renderPipelineDescriptor = MTLRenderPipelineDescriptor()
        renderPipelineDescriptor.colorAttachments[0].pixelFormat = EngineSettings.MainPixelFormat
        renderPipelineDescriptor.depthAttachmentPixelFormat = EngineSettings.MainDepthPixelFormat
        renderPipelineDescriptor.sampleCount = EngineSettings.SampleCount
        renderPipelineDescriptor.vertexFunction = vertexFunction
        renderPipelineDescriptor.fragmentFunction = fragmentFunction
        renderPipelineDescriptor.vertexDescriptor = vertexDescriptor
        
        super.init(renderPipelineDescriptor: renderPipelineDescriptor)
    }
}


private class QuadTessellation_RenderPipelineState: RenderPipelineState {
    init() {
        let vertexFunction = Engine.DefaultLibrary.makeFunction(name: "quad_tessellation_vertex_shader")
        let fragmentFunction = Engine.DefaultLibrary.makeFunction(name: "fragment_shader")
        
        let vertexDescriptor = MTLVertexDescriptor()
        
        //Position
        vertexDescriptor.attributes[0].format = .float3
        vertexDescriptor.attributes[0].bufferIndex = 0
        vertexDescriptor.attributes[0].offset = 0
        
        //Texture Coordinates
        vertexDescriptor.attributes[1].format = .float2
        vertexDescriptor.attributes[1].bufferIndex = 0
        vertexDescriptor.attributes[1].offset = float3.size
        
        //Normal
        vertexDescriptor.attributes[2].format = .float3
        vertexDescriptor.attributes[2].bufferIndex = 0
        vertexDescriptor.attributes[2].offset = float3.size + float3.size
        
        //Tangent
        vertexDescriptor.attributes[3].format = .float3
        vertexDescriptor.attributes[3].bufferIndex = 0
        vertexDescriptor.attributes[3].offset = float3.size + float3.size + float3.size
        
        //Bitangent
        vertexDescriptor.attributes[4].format = .float3
        vertexDescriptor.attributes[4].bufferIndex = 0
        vertexDescriptor.attributes[4].offset = float3.size + float3.size + float3.size + float3.size
        
        //Tessellation Stuff
        vertexDescriptor.layouts[0].stepFunction = .perPatchControlPoint
        vertexDescriptor.layouts[0].stepRate = 1
        vertexDescriptor.layouts[0].stride = Vertex.stride
        
        let renderPipelineDescriptor = MTLRenderPipelineDescriptor()
        renderPipelineDescriptor.colorAttachments[0].pixelFormat = EngineSettings.MainPixelFormat
        renderPipelineDescriptor.depthAttachmentPixelFormat = EngineSettings.MainDepthPixelFormat
        renderPipelineDescriptor.sampleCount = EngineSettings.SampleCount
        renderPipelineDescriptor.vertexFunction = vertexFunction
        renderPipelineDescriptor.fragmentFunction = fragmentFunction
        renderPipelineDescriptor.vertexDescriptor = vertexDescriptor
        
        //Tessellation Stuff
        renderPipelineDescriptor.isTessellationFactorScaleEnabled = false
        renderPipelineDescriptor.tessellationFactorFormat = .half
        renderPipelineDescriptor.tessellationControlPointIndexType = .none
        renderPipelineDescriptor.tessellationFactorStepFunction = .constant
        renderPipelineDescriptor.tessellationOutputWindingOrder = .clockwise
        renderPipelineDescriptor.tessellationPartitionMode = .fractionalEven
        renderPipelineDescriptor.maxTessellationFactor = 64
        
        super.init(renderPipelineDescriptor: renderPipelineDescriptor)
    }
}


