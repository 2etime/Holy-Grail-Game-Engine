//
//  BoundingMesh.swift
//  HolyGrailGameEngine
//
//  Created by Rick Twohy Jr on 7/7/19.
//  Copyright © 2019 Rick Twohy Jr. All rights reserved.
//

import MetalKit

enum BoundingTypes {
    case None
    case Cube
}

fileprivate class BoundingMeshData {
    var boundingBox: BoundingBox! = nil
    var boundingType: BoundingTypes = .None
    var vertexBuffer: MTLBuffer! = nil
    var vertices: [BoundingVertex] = []
    var vertexCount: Int {
        return self.vertices.count
    }
    
    init(boundingBox: BoundingBox, boundingType: BoundingTypes) {
        self.boundingBox = boundingBox
        self.boundingType = boundingType
        
        calculateVertices()
        generateBuffers()
    }
    
    func addVertex(_ boundingVertex: BoundingVertex) {
        self.vertices.append(boundingVertex)
    }
    
    func generateBuffers() {
        if(vertexCount > 0) {
            self.vertexBuffer = Engine.Device.makeBuffer(bytes: self.vertices,
                                                         length: BoundingVertex.size(vertexCount),
                                                          options: .storageModeShared)
        }
    }
    
    func calculateVertices() {
        vertices = []
        let mins = boundingBox.mins
        let maxs = boundingBox.maxs
        
        switch boundingType {
        case .Cube:
            createCubeMesh(mins: mins, maxs: maxs)
        default:
            return
        }
    }
    
    private func createCubeMesh(mins: float3, maxs: float3) {
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

class BoundingMesh {
    private var _boundingMeshDatas: [BoundingMeshData] = []
    
    init(boundingBoxs: [BoundingBox]) {
        for boundingBox in boundingBoxs {
            _boundingMeshDatas.append(BoundingMeshData(boundingBox: boundingBox, boundingType: .Cube))
        }
    }
    
    func drawRender(_ renderCommandEncoder: MTLRenderCommandEncoder) {
        for meshData in _boundingMeshDatas {
            if(meshData.vertexCount > 0) {
                renderCommandEncoder.setVertexBuffer(meshData.vertexBuffer,
                                                     offset: 0,
                                                     index: 0)
                renderCommandEncoder.drawPrimitives(type: .lineStrip,
                                                    vertexStart: 0,
                                                    vertexCount: meshData.vertexCount)
            }
        }
    }
    
}
