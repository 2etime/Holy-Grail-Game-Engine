//
//  HGRenderer.swift
//  HolyGrailGameEngine
//
//  Created by Rick Twohy Jr on 6/13/19.
//  Copyright © 2019 Rick Twohy Jr. All rights reserved.
//

import MetalKit

class Renderer: NSObject {
    
    private var _vertices: [Vertex] = []
    private var _vertexBuffer: MTLBuffer!
    private var _vertexDescriptor: MTLVertexDescriptor!
    private var _renderPipelineState: MTLRenderPipelineState!
    
    override init() {
        super.init()
        createVertices()
        buildBuffers()
        createVertexDescriptor()
        createRenderPipelineState()
    }
    
    internal func addVertex(_ position: float3) {
        self._vertices.append(Vertex(position: position))
    }
    
    private func createVertices() {
        addVertex(float3(0,1,0))
        addVertex(float3(-1,-1,0))
        addVertex(float3(1,-1,0))
    }
    
    private func buildBuffers() {
        if(self._vertices.count > 0) {
            self._vertexBuffer = Engine.Device.makeBuffer(bytes: _vertices,
                                                          length: Vertex.size(_vertices.count),
                                                          options: .storageModeManaged)
        }
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
    
}

extension Renderer: MTKViewDelegate {
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        //TODO: Update when window is resized
    }
    
    func draw(in view: MTKView) {
        guard let drawable = view.currentDrawable, let renderPassDescriptor = view.currentRenderPassDescriptor else { return }
        let commandBuffer = Engine.CommandQueue.makeCommandBuffer()
        let renderCommandEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: renderPassDescriptor)
        
        renderCommandEncoder?.setRenderPipelineState(_renderPipelineState)
        renderCommandEncoder?.setVertexBuffer(_vertexBuffer, offset: 0, index: 0)
        renderCommandEncoder?.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: _vertices.count)
        
        renderCommandEncoder?.endEncoding()
        commandBuffer?.present(drawable)
        commandBuffer?.commit()
    }
    
}
