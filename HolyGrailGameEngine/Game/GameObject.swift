//
//  GameObject.swift
//  HolyGrailGameEngine
//
//  Created by Rick Twohy Jr on 6/13/19.
//  Copyright © 2019 Rick Twohy Jr. All rights reserved.
//

import MetalKit

class GameObject: Node {
    private var _materialConstants = MaterialConstants()
    private var _modelConstants = ModelConstants()
    
    private var _mesh: Mesh!
    private var _baseTextureType: TextureTypes! = .None
    private var _textureTileCounts: float2 = float2(1,1)
    
    private var _useTessellation: Bool = false
    private var _tessellationFactorsBuffer: MTLBuffer!
    
    private var edgeFactor: Float = 1.0
    private var insideFactor: Float = 1.0
 
    init(name: String, meshType: MeshTypes, useTessellation: Bool = false) {
        super.init(name: name)
        self._mesh = Entities.Meshes[meshType]
        createTesselationFactorsBuffer()
        setUseTessellation(useTessellation)
    
        if let _ = self as? Boundable {
            addChild(BoundingObject(self._mesh))
        }
    }
    
    private func createTesselationFactorsBuffer() {
        _tessellationFactorsBuffer = Engine.Device.makeBuffer(length: 256, options: [MTLResourceOptions.storageModeManaged])
        _tessellationFactorsBuffer.label = "Tessellation Factors"
    }
    
    override func update() {
        updateModelConstants()
        super.update()
    }
    
    private func updateModelConstants() {
        self._modelConstants.modelMatrix = self.modelMatrix
    }
    
    private func getTesselationFactors() {
        let commandBuffer = Engine.CommandQueue.makeCommandBuffer()
        let computeCommandEncoder = commandBuffer?.makeComputeCommandEncoder()
        computeCommandEncoder?.setComputePipelineState(Graphics.ComputePipelineStates[.QuadTessellation])

        computeCommandEncoder?.setBytes(&edgeFactor, length: Float.size, index: 0)
        computeCommandEncoder?.setBytes(&insideFactor, length: Float.size, index: 1)
        computeCommandEncoder?.setBuffer(self._tessellationFactorsBuffer, offset: 0, index: 2)
        computeCommandEncoder?.dispatchThreadgroups(MTLSize(width: 1, height: 1, depth: 1),
                                                    threadsPerThreadgroup: MTLSize(width: 1, height: 1, depth: 1))

        computeCommandEncoder?.endEncoding()
        commandBuffer?.commit()
    }
    
    override func setRenderPipelineValues(_ renderCommandEncoder: MTLRenderCommandEncoder) {
        if(_useTessellation){
            renderCommandEncoder.setRenderPipelineState(Graphics.RenderPipelineStates[.QuadTessellation])
            renderCommandEncoder.setTessellationFactorBuffer(_tessellationFactorsBuffer, offset: 0, instanceStride: 0)
        }else{
            renderCommandEncoder.setRenderPipelineState(Graphics.RenderPipelineStates[.Basic])
        }
        renderCommandEncoder.setDepthStencilState(Graphics.DepthStencilStates[.Less])
        
        renderCommandEncoder.setVertexBytes(&_modelConstants, length: ModelConstants.stride, index: 2)
        
        renderCommandEncoder.setFragmentBytes(&_materialConstants, length: MaterialConstants.stride, index: 0)
        renderCommandEncoder.setFragmentSamplerState(Graphics.SamplerStates[.Linear], index: 0)
        if(_materialConstants.useBaseTexture) {
            renderCommandEncoder.setFragmentTexture(Entities.Textures[_baseTextureType], index: 0)
        }
        
        renderCommandEncoder.setFragmentBytes(&_textureTileCounts, length: float2.stride, index: 3)
    }
}

extension GameObject: Renderable, Computable {
    func doCompute() {
        getTesselationFactors()
    }
    
    func doRender(_ renderCommandEncoder: MTLRenderCommandEncoder) {
        if(self._useTessellation) {
            _mesh.drawPatches(renderCommandEncoder)
        }else{
            _mesh.drawRender(renderCommandEncoder)            
        }
    }
}

// Tessellation
extension GameObject {
    public func setUseTessellation(_ useTessellation: Bool) {
        self._useTessellation = useTessellation
    }
    
    public func setEdgeFactor(_ edgeFactor: Float) { self.edgeFactor = edgeFactor }
    public func addEdgeFactor(_ value: Float) { self.edgeFactor = min(max(edgeFactor + value, 1), 64) }
    
    public func setInsideFactor(_ insideFactor: Float) { self.insideFactor = insideFactor }
    public func addInsideFactor(_ value: Float) { self.insideFactor = min(max(insideFactor + value, 1), 64) }
}

//MATERIALS
extension GameObject {
    public func getMaterialColor()->float4 { return self._materialConstants.color }
    public func setMaterialColor(_ r: Float, _ g: Float, _ b: Float,_ a: Float) { self.setMaterialColor(float4(r,g,b,a)) }
    public func setMaterialColor(_ color: float4) {
        self._materialConstants.color = color
        self._materialConstants.useMaterialColor = true
        self._materialConstants.useBaseTexture = false
    }
    
    public func setBaseTexture(_ textureType: TextureTypes) {
        self._baseTextureType = textureType
        self._materialConstants.useBaseTexture = textureType != .None
        self._materialConstants.useMaterialColor = textureType == .None
    }
    
    public func setTextureTileCount(_ wide: Float, _ high: Float) { self._textureTileCounts = float2(wide, high) }
    public func setTextureTileCountWide(_ count: Float) { self._textureTileCounts.x = count }
    public func setTextureTileCountHigh(_ count: Float) { self._textureTileCounts.y = count }
    
    public func setMaterialIsLightable(_ isLightable: Bool) { self._materialConstants.isLightable = isLightable }
    
    public func setMaterialAmbient(_ ambient: float3) { self._materialConstants.ambient = ambient }
    public func setMaterialAmbient(_ ambient: Float) { self._materialConstants.ambient = float3(ambient, ambient, ambient) }
    public func addMaterialAmbient(_ value: float3 ) { self._materialConstants.ambient += value}
    public func addMaterialAmbient(_ value: Float ) { self._materialConstants.ambient += value}
    public func getMaterialAmbient()->float3 { return self._materialConstants.ambient }
    
    public func setMaterialDiffuse(_ diffuse: float3) { self._materialConstants.diffuse = diffuse }
    public func setMaterialDiffuse(_ diffuse: Float) { self._materialConstants.diffuse = float3(diffuse, diffuse, diffuse) }
    public func addMaterialDiffuse(_ value: float3 ) { self._materialConstants.diffuse += value}
    public func addMaterialDiffuse(_ value: Float ) { self._materialConstants.diffuse += value}
    public func getMaterialDiffuse()->float3 { return self._materialConstants.diffuse }
    
    public func setMaterialSpecular(_ specular: float3) { self._materialConstants.specular = specular }
    public func setMaterialSpecular(_ specular: Float) { self._materialConstants.specular = float3(specular, specular, specular) }
    public func addMaterialSpecular(_ value: float3 ) { self._materialConstants.specular += value}
    public func addMaterialSpecular(_ value: Float ) { self._materialConstants.specular += value}
    public func getMaterialSpecular()->float3 { return self._materialConstants.specular }

    public func setMaterialShininess(_ shininess: Float) { self._materialConstants.shininess = shininess }
    public func addMaterialShininess(_ value: Float) { self._materialConstants.shininess += value}
    public func getMaterialShininess()->Float { return self._materialConstants.shininess }
    
    public func setMaterialSpecularMapIntensity(_ intensity: Float) { self._materialConstants.specularMapIntensity = intensity }
    public func addMaterialSpecularMapIntensity(_ value: Float ) { self._materialConstants.specularMapIntensity += value}
    public func getMaterialSpecularMapIntensity()->Float { return self._materialConstants.specularMapIntensity }
    
    public func setMaterialAmbientMapIntensity(_ intensity: Float) { self._materialConstants.ambientMapIntensity = intensity }
    public func addMaterialAmbientMapIntensity(_ value: Float ) { self._materialConstants.specularMapIntensity += value}
    public func getMaterialAmbientMapIntensity()->Float { return self._materialConstants.ambientMapIntensity }
}
