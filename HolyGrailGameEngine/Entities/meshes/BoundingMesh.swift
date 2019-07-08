//
//  BoundingMesh.swift
//  HolyGrailGameEngine
//
//  Created by Rick Twohy Jr on 7/7/19.
//  Copyright © 2019 Rick Twohy Jr. All rights reserved.
//

import MetalKit

class BoundingMesh {
    private var _instanceCount: Int = 1
    private var _vertexBuffer: MTLBuffer!
    private var _vertices: [BoundingVertex] = []
    private var _vertexCount: Int {
        return _vertices.count
    }

    init(boundingBoxs: [BoundingBox]) {
        self.calculateVertices(boundingBoxs)
        self.createBuffers()
    }
    
    func addVertex(_ boundingVertex: BoundingVertex) {
        self._vertices.append(boundingVertex)
    }
    
    func calculateVertices(_ boundingBoxs: [BoundingBox]) { }
    
    private func createBuffers() {
        if(_vertexCount > 0) {
            self._vertexBuffer = Engine.Device.makeBuffer(bytes: self._vertices,
                                                          length: BoundingVertex.size(_vertexCount),
                                                          options: .storageModeShared)
        }
    }
    
    func setInstanceCount(_ count: Int) {
        self._instanceCount = count
    }
    
    func drawPatches(_ renderCommandEncoder: MTLRenderCommandEncoder) { }

    func drawRender(_ renderCommandEncoder: MTLRenderCommandEncoder) {
        if(_vertexCount > 0) {
            renderCommandEncoder.setVertexBuffer(_vertexBuffer,
                                                 offset: 0,
                                                 index: 0)
            renderCommandEncoder.drawPrimitives(type: .lineStrip,
                                                vertexStart: 0,
                                                vertexCount: _vertexCount)
        }
    }
    
}

class Cube_BoundingMesh: BoundingMesh {
    
    override func calculateVertices(_ boundingBoxs: [BoundingBox]) {
        for boundingBox in boundingBoxs {
            let mins = boundingBox.mins
            let maxs = boundingBox.maxs
            
            //Front
            addVertex(BoundingVertex(position: float3(maxs.x, maxs.y, maxs.z))) // Right Top Front
            addVertex(BoundingVertex(position: float3(maxs.x, mins.y, maxs.z))) // Right Bottom Front
            addVertex(BoundingVertex(position: float3(mins.x, mins.y, maxs.z))) // Left Bottom Front
            addVertex(BoundingVertex(position: float3(mins.x, maxs.y, maxs.z))) // Left Top Front
            addVertex(BoundingVertex(position: float3(maxs.x, maxs.y, maxs.z))) // Right Top Front
            
            //Left
            addVertex(BoundingVertex(position: float3(mins.x, maxs.y, maxs.z)))  // Left Top Front
            addVertex(BoundingVertex(position: float3(mins.x, mins.y, maxs.z)))  // Left Bottom Front
            addVertex(BoundingVertex(position: float3(mins.x, mins.y, mins.z)))  // Left Bottom Back
            addVertex(BoundingVertex(position: float3(mins.x, maxs.y, mins.z)))  // Left Top Back
            addVertex(BoundingVertex(position: float3(mins.x, maxs.y, maxs.z)))  // Left Top Front
            
            //Right
            addVertex(BoundingVertex(position: float3(maxs.x, maxs.y, maxs.z)))  // Right Top Front
            addVertex(BoundingVertex(position: float3(maxs.x, mins.y, maxs.z)))  // Right Bottom Front
            addVertex(BoundingVertex(position: float3(maxs.x, mins.y, mins.z)))  // Right Bottom Back
            addVertex(BoundingVertex(position: float3(maxs.x, maxs.y, mins.z)))  // Right Top Back
            addVertex(BoundingVertex(position: float3(maxs.x, maxs.y, maxs.z)))  // Right Top Front
            
            //Back
            addVertex(BoundingVertex(position: float3(maxs.x, maxs.y, mins.z))) // Right Top Back
            addVertex(BoundingVertex(position: float3(maxs.x, mins.y, mins.z))) // Right Bottom Back
            addVertex(BoundingVertex(position: float3(mins.x, mins.y, mins.z))) // Left Bottom Back
            addVertex(BoundingVertex(position: float3(mins.x, maxs.y, mins.z))) // Left Top Back
            addVertex(BoundingVertex(position: float3(maxs.x, maxs.y, mins.z))) // Right Top Back
            
        }
    }
    
}
