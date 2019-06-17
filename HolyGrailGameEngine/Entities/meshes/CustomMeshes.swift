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
    private var _vertexCount: Int { return _vertices.count }
    
    private var _indices: [uint32] = []
    private var _indexBuffer: MTLBuffer!
    private var _indexCount: Int { return _indices.count }
    
    
    init() {
        createVertices()
        buildBuffers()
    }
    
    internal func addVertex(_ position: float3,
                            textureCoordinates: float2 = float2(0,0),
                            normal: float3 = float3(0,1,0),
                            tangent: float3 = float3(1,0,0),
                            bitangent: float3 = float3(0,0,1)) {
        self._vertices.append(Vertex(position: position,
                                     textureCoordinates: textureCoordinates,
                                     normal: normal,
                                     tangent: tangent,
                                     bitangent: bitangent))
    }
    
    func createVertices() { } // Override in subclasses
    
    func addIndex(_ index: uint32) {
        self._indices.append(index)
    }
    
    func addIndices(_ indices: [uint32]){
        self._indices.append(contentsOf: indices)
    }
    
    private func buildBuffers() {
        if(self._vertexCount > 0) {
            self._vertexBuffer = Engine.Device.makeBuffer(bytes: self._vertices,
                                                          length: Vertex.size(self._vertexCount),
                                                          options: .storageModeManaged)
        }
        
        if(self._indexCount > 0){
            self._indexBuffer = Engine.Device.makeBuffer(bytes: self._indices,
                                                         length: uint32.size(self._indexCount),
                                                         options: .storageModeManaged)
        }
    }
    
    func draw(_ renderCommandEncoder: MTLRenderCommandEncoder) {
        if(self._vertexCount > 0) {
            renderCommandEncoder.setVertexBuffer(self._vertexBuffer,
                                                 offset: 0,
                                                 index: 0)
            if(self._indexCount > 0) {
                renderCommandEncoder.drawIndexedPrimitives(type: .triangle,
                                                           indexCount: self._indexCount,
                                                           indexType: .uint32,
                                                           indexBuffer: self._indexBuffer,
                                                           indexBufferOffset: 0)
            }else{
                renderCommandEncoder.drawPrimitives(type: .triangle,
                                                    vertexStart: 0,
                                                    vertexCount: self._vertexCount)
            }
        }
    }
}

class Triangle_CustomMesh: CustomMesh {
    override func createVertices() {
        addVertex(float3(0,1,0))
        addVertex(float3(-1,-1,0))
        addVertex(float3(1,-1,0))
        
        addIndices([0,1,2])
    }
}
