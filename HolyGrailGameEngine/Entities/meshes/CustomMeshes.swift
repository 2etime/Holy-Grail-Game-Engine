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
    
    private var _instanceCount: Int = 1
    private var _patchCount: Int = 0
    private var _patchControlPointCount: Int = 0
    
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
    
    func drawRender(_ renderCommandEncoder: MTLRenderCommandEncoder) {
        if(self._vertexCount > 0) {
            renderCommandEncoder.setVertexBuffer(self._vertexBuffer,
                                                 offset: 0,
                                                 index: 0)
            if(self._indexCount > 0) {
                renderCommandEncoder.drawIndexedPrimitives(type: .triangle,
                                                           indexCount: self._indexCount,
                                                           indexType: .uint32,
                                                           indexBuffer: self._indexBuffer,
                                                           indexBufferOffset: 0,
                                                           instanceCount: self._instanceCount)
            }else{
                renderCommandEncoder.drawPrimitives(type: .triangle,
                                                    vertexStart: 0,
                                                    vertexCount: self._vertexCount,
                                                    instanceCount: self._instanceCount)
            }
        }
    }
    
    func drawPatches(_ renderCommandEncoder: MTLRenderCommandEncoder) {
        if(self._vertexCount > 0) {
            renderCommandEncoder.setVertexBuffer(self._vertexBuffer,
                                                 offset: 0,
                                                 index: 0)
            
            renderCommandEncoder.drawPatches(numberOfPatchControlPoints: self._patchControlPointCount,
                                             patchStart: 0,
                                             patchCount: self._patchCount,
                                             patchIndexBuffer: _indexBuffer,
                                             patchIndexBufferOffset: 0,
                                             instanceCount: self._instanceCount,
                                             baseInstance: 0)
        }
    }
    
}

extension CustomMesh {
    func setInstanceCount(_ count: Int) { self._instanceCount = count }
    func setPatchCount(_ count: Int) { self._patchCount = count }
    func setPatchControlPointCount(_ count: Int) { self._patchControlPointCount = count }
}

class Triangle_CustomMesh: CustomMesh {
    override func createVertices() {
        addVertex(float3(0,1,0))
        addVertex(float3(-1,-1,0))
        addVertex(float3(1,-1,0))
        
        addIndices([0,1,2])
    }
}

class Quad_CustomMesh: CustomMesh {
    override func createVertices() {
        let rightVec = float3(1,0,0)
        let normal = float3(0,0,1)
        let tangent = cross(rightVec, normal)
        let bitangent = cross(tangent, normal)

        addVertex(float3( 0.5, 0.5, 0), textureCoordinates: float2(1,0), normal: normal, tangent: tangent, bitangent: bitangent) // Top Right
        addVertex(float3(-0.5, 0.5, 0), textureCoordinates: float2(0,0), normal: normal, tangent: tangent, bitangent: bitangent) // Top Left
        addVertex(float3(-0.5,-0.5, 0), textureCoordinates: float2(0,1), normal: normal, tangent: tangent, bitangent: bitangent) // Bottom Left
        addVertex(float3( 0.5,-0.5, 0), textureCoordinates: float2(1,1), normal: normal, tangent: tangent, bitangent: bitangent) // Bottom Right
        
        addIndices([
            0,1,2,
            0,2,3
        ])
    }
}

class QuadTessellated_CustomMesh: CustomMesh {
    
    override func createVertices() {
        let normal = float3(0,1,0)
        
        addVertex(float3(-0.5,   0.0,-0.5), textureCoordinates: float2(0,    0), normal: normal)
        addVertex(float3(-0.167, 0.0,-0.5), textureCoordinates: float2(0.333,0), normal: normal)
        addVertex(float3( 0.166, 0.0,-0.5), textureCoordinates: float2(0.666,0), normal: normal)
        addVertex(float3( 0.5,   0.0,-0.5), textureCoordinates: float2(1.00, 0), normal: normal)
     
        addVertex(float3(-0.5,   0.0,-0.167), textureCoordinates: float2(0,    0.333), normal: normal)
        addVertex(float3(-0.167, 0.0,-0.167), textureCoordinates: float2(0.333,0.333), normal: normal)
        addVertex(float3( 0.166, 0.0,-0.167), textureCoordinates: float2(0.666,0.333), normal: normal)
        addVertex(float3( 0.5,   0.0,-0.167), textureCoordinates: float2(1.00, 0.333), normal: normal)

        addVertex(float3(-0.5,   0.0, 0.166), textureCoordinates:  float2(0,    0.666), normal: normal)
        addVertex(float3(-0.167, 0.0, 0.166), textureCoordinates:  float2(0.333,0.666), normal: normal)
        addVertex(float3( 0.166, 0.0, 0.166), textureCoordinates:  float2(0.666,0.666), normal: normal)
        addVertex(float3( 0.5,   0.0, 0.166), textureCoordinates:  float2(1.00, 0.666), normal: normal)

        addVertex(float3(-0.5,   0.0, 0.5), textureCoordinates: float2(0,    1.0), normal: normal)
        addVertex(float3(-0.167, 0.0, 0.5), textureCoordinates: float2(0.333,1.0), normal: normal)
        addVertex(float3( 0.166, 0.0, 0.5), textureCoordinates: float2(0.666,1.0), normal: normal)
        addVertex(float3( 0.5,   0.0, 0.5), textureCoordinates: float2(1.00, 1.0), normal: normal)
        
        setPatchControlPointCount(16)
        setPatchCount(16)
    }
}
