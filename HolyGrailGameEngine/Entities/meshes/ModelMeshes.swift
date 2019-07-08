//
//  ModelMeshes.swift
//  HolyGrailGameEngine
//
//  Created by Rick Twohy Jr on 6/16/19.
//  Copyright © 2019 Rick Twohy Jr. All rights reserved.
//

import MetalKit

class ModelMesh: Mesh {
    private var _meshes: [Any]! = []
    private var _instanceCount: Int = 1
    var boundingBoxes: [BoundingBox] = []
    
    init(modelName: String) {
        loadModel(modelName: modelName)
    }
    
    func addBoundingBox(_ box: MDLAxisAlignedBoundingBox){
        boundingBoxes.append(BoundingBox(mins: box.minBounds, maxs: box.maxBounds))
    }
    
    func loadModel(modelName: String) {
        guard let assetURL = Bundle.main.url(forResource: modelName, withExtension: "obj") else {
            fatalError("Asset \(modelName) does not exist.")
        }
        
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
        
        let descriptor = MTKModelIOVertexDescriptorFromMetal(vertexDescriptor)
        (descriptor.attributes[0] as! MDLVertexAttribute).name = MDLVertexAttributePosition
        (descriptor.attributes[1] as! MDLVertexAttribute).name = MDLVertexAttributeTextureCoordinate
        (descriptor.attributes[2] as! MDLVertexAttribute).name = MDLVertexAttributeNormal
        (descriptor.attributes[3] as! MDLVertexAttribute).name = MDLVertexAttributeTangent
        (descriptor.attributes[4] as! MDLVertexAttribute).name = MDLVertexAttributeBitangent
        
        let bufferAllocator = MTKMeshBufferAllocator(device: Engine.Device)
        let asset: MDLAsset = MDLAsset(url: assetURL,
                                       vertexDescriptor: descriptor,
                                       bufferAllocator: bufferAllocator)
        var modelIOMeshes: [MDLMesh]!
        do{
            modelIOMeshes = try MTKMesh.newMeshes(asset: asset,
                                                  device: Engine.Device).modelIOMeshes
        } catch {
            print("ERROR::LOADING_MESH::__\(modelName)__::\(error)")
        }
        
        for mesh in modelIOMeshes {
            mesh.addTangentBasis(forTextureCoordinateAttributeNamed: MDLVertexAttributeTextureCoordinate,
                                 normalAttributeNamed: MDLVertexAttributeNormal,
                                 tangentAttributeNamed: MDLVertexAttributeTangent)
            mesh.addTangentBasis(forTextureCoordinateAttributeNamed: MDLVertexAttributeTextureCoordinate,
                                 tangentAttributeNamed: MDLVertexAttributeTangent,
                                 bitangentAttributeNamed: MDLVertexAttributeBitangent)
            mesh.vertexDescriptor = descriptor
            
            addBoundingBox(mesh.boundingBox)
            
            var mtkMesh: MTKMesh!
            do {
                mtkMesh = try MTKMesh(mesh: mesh, device: Engine.Device)
            } catch {
                print("mesh error")
            }
            self._meshes.append(mtkMesh!)
        }
        
//        let bb = MDLAxisAlignedBoundingBox(maxBounds: float3(1,1,1), minBounds: float3(-1,-1,-1))
//        addBoundingBox(bb)
    }
    
    func setInstanceCount(_ count: Int) {
        self._instanceCount = count
    }
    
    func drawRender(_ renderCommandEncoder: MTLRenderCommandEncoder) {
        guard let meshes = self._meshes as? [MTKMesh] else { return }
        for mesh in meshes {
            for vertexBuffer in mesh.vertexBuffers {
                renderCommandEncoder.setVertexBuffer(vertexBuffer.buffer, offset: vertexBuffer.offset, index: 0)
                for submesh in mesh.submeshes {
                    renderCommandEncoder.drawIndexedPrimitives(type: submesh.primitiveType,
                                                               indexCount: submesh.indexCount,
                                                               indexType: submesh.indexType,
                                                               indexBuffer: submesh.indexBuffer.buffer,
                                                               indexBufferOffset: submesh.indexBuffer.offset,
                                                               instanceCount: self._instanceCount)
                }
            }
        }
    }
    
    func drawPatches(_ renderCommandEncoder: MTLRenderCommandEncoder) { }
}
