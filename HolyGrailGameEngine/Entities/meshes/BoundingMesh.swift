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
    case Sphere
}

fileprivate class BoundingMeshData {
    var boundingBox: BoundingBox! = nil
    var boundingType: BoundingTypes = .None
    var vertexBuffer: MTLBuffer! = nil
    var indexBuffer: MTLBuffer! = nil
    var vertices: [BoundingVertex] = []
    var indices: [UInt32] = []
    var vertexCount: Int {
        return self.vertices.count
    }
    var indexCount: Int {
        return self.indices.count
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
        
        if(indexCount > 0) {
            self.indexBuffer = Engine.Device.makeBuffer(bytes: self.indices,
                                                         length: uint32.size(indexCount),
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
        case .Sphere:
            createSphereMesh(mins: mins, maxs: maxs)
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
    
    private func createSphereMesh(mins: float3, maxs: float3) {
        let numSegments: Int = 100
        let twopi = Float.pi * 2
        let radius = max(maxs.x - mins.x, maxs.y - mins.y, maxs.z - mins.z) / 2.0
        var indexCount: UInt32 = 0
        
        let centerX = (maxs.x + mins.x) / 2
        let centerY = (maxs.y + mins.y) / 2
        let centerZ = (maxs.z + mins.z) / 2
        for i in 0..<numSegments {
            let posX = cos(Float(i) / Float(numSegments) * 360.0 / 360.0 * twopi) * radius + centerX
            let posY = sin(Float(i) / Float(numSegments) * 360.0 / 360.0 * twopi) * radius + centerY
            addVertex(BoundingVertex(position: float3(posX, posY, centerZ)))
            indices.append(indexCount)
            indexCount += 1
        }
        indices.append(0)
        for i in 0..<numSegments {
            let posX = cos(Float(i) / Float(numSegments) * 360.0 / 360.0 * twopi) * radius + centerX
            let posZ = sin(Float(i) / Float(numSegments) * 360.0 / 360.0 * twopi) * radius + centerZ
            addVertex(BoundingVertex(position: float3(posX, centerY, posZ)))
            indices.append(UInt32(i * 2))
            indexCount += 1
        }
        indices.append(0)
        for i in 0..<Int(numSegments / 4) {
            indices.append(UInt32(i))
        }
        for i in 0..<numSegments {
            let posY = cos(Float(i) / Float(numSegments) * 360.0 / 360.0 * twopi) * radius + centerY
            let posZ = sin(Float(i) / Float(numSegments) * 360.0 / 360.0 * twopi) * radius + centerZ
            addVertex(BoundingVertex(position: float3(centerX, posY, posZ)))
            indices.append(UInt32(indexCount) + UInt32(i))
        }
        indices.append(UInt32(numSegments / 4))
    }
}

class BoundingMesh {
    private var _boundingMeshDatas: [BoundingMeshData] = []
    
    init(boundingBoxs: [BoundingBox]) {
        for boundingBox in boundingBoxs {
            _boundingMeshDatas.append(BoundingMeshData(boundingBox: boundingBox, boundingType: .Sphere))
        }
    }
    
    func drawRender(_ renderCommandEncoder: MTLRenderCommandEncoder) {
        for meshData in _boundingMeshDatas {
            if(meshData.vertexCount > 0) {
                renderCommandEncoder.setVertexBuffer(meshData.vertexBuffer,
                                                     offset: 0,
                                                     index: 0)
                
                if(meshData.indexCount > 0) {
                    renderCommandEncoder.drawIndexedPrimitives(type: .lineStrip,
                                                               indexCount: meshData.indexCount,
                                                               indexType: .uint32,
                                                               indexBuffer: meshData.indexBuffer,
                                                               indexBufferOffset: 0)
                }else  {
                    renderCommandEncoder.drawPrimitives(type: .lineStrip,
                                                        vertexStart: 0,
                                                        vertexCount: meshData.vertexCount)
                }
            }
        }
    }
    
}
