//
//  CustomMeshes.swift
//  HolyGrailGameEngine
//
//  Created by Rick Twohy Jr on 6/14/19.
//  Copyright © 2019 Rick Twohy Jr. All rights reserved.
//

import MetalKit

class CustomMesh: Mesh {
    private var _vertices: [Vertex] = []
    private var _vertexBuffer: MTLBuffer!
    
    init() {
        createVertices()
        buildBuffers()
    }
    
    internal func addVertex(_ position: float3) {
        self._vertices.append(Vertex(position: position))
    }
    
    internal func createVertices() { } // Override in subclasses
    
    private func buildBuffers() {
        if(self._vertices.count > 0) {
            self._vertexBuffer = Engine.Device.makeBuffer(bytes: _vertices,
                                                          length: Vertex.size(_vertices.count),
                                                          options: .storageModeManaged)
        }
    }
    
    func draw(_ renderCommandEncoder: MTLRenderCommandEncoder) {
        renderCommandEncoder.setVertexBuffer(_vertexBuffer,
                                             offset: 0,
                                             index: 0)
        renderCommandEncoder.drawPrimitives(type: .triangle,
                                            vertexStart: 0,
                                            vertexCount: _vertices.count)
    }
}

class Triangle_CustomMesh: CustomMesh {
    override func createVertices() {
        addVertex(float3(0,1,0))
        addVertex(float3(-1,-1,0))
        addVertex(float3(1,-1,0))
    }
}
