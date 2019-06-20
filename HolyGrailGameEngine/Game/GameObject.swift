//
//  GameObject.swift
//  HolyGrailGameEngine
//
//  Created by Rick Twohy Jr on 6/13/19.
//  Copyright © 2019 Rick Twohy Jr. All rights reserved.
//

import MetalKit

class GameObject: GameNode {
    private var _materialConstants = MaterialConstants()
    private var _modelConstants = ModelConstants()
    
    private var _mesh: Mesh!
    private var _baseTextureType: TextureTypes! = .None
    private var _normalTextureType: TextureTypes! = .None
    private var _specularTextureType: TextureTypes! = .None
    private var _ambientTextureType: TextureTypes! = .None
    private var _heightMapTextureType: TextureTypes! = .None
 
    init(name: String, meshType: MeshTypes) {
        super.init(name: name)
        self._mesh = Entities.Meshes[meshType]
    }
    
    override func update() {
        updateModelConstants()
        super.update()
    }
    
    private func updateModelConstants() {
        self._modelConstants.modelMatrix = self.modelMatrix
    }
    
    override func setRenderPipelineValues(_ renderCommandEncoder: MTLRenderCommandEncoder) {
        renderCommandEncoder.setRenderPipelineState(Graphics.RenderPipelineStates[.Basic])
        renderCommandEncoder.setDepthStencilState(Graphics.DepthStencilStates[.Less])
        
        renderCommandEncoder.setVertexBytes(&_modelConstants, length: ModelConstants.stride, index: 2)
        
        renderCommandEncoder.setFragmentBytes(&_materialConstants, length: MaterialConstants.stride, index: 0)
        renderCommandEncoder.setFragmentSamplerState(Graphics.SamplerStates[.Linear], index: 0)
        
        if(_materialConstants.useHeightMap) {
            renderCommandEncoder.setVertexTexture(Entities.Textures[_heightMapTextureType], index: 0)
        }
        if(_materialConstants.useBaseTexture) {
            renderCommandEncoder.setFragmentTexture(Entities.Textures[_baseTextureType], index: 0)
        }
        if(_materialConstants.useNormalMap) {
            renderCommandEncoder.setFragmentTexture(Entities.Textures[_normalTextureType], index: 1)
        }
        if(_materialConstants.useSpecularMap) {
            renderCommandEncoder.setFragmentTexture(Entities.Textures[_specularTextureType], index: 2)
        }
        if(_materialConstants.useAmbientMap) {
            renderCommandEncoder.setFragmentTexture(Entities.Textures[_ambientTextureType], index: 3)
        }
        
    }
}

extension GameObject: Renderable {
    func doRender(_ renderCommandEncoder: MTLRenderCommandEncoder) {
        renderCommandEncoder.setFrontFacing(.counterClockwise)
        renderCommandEncoder.setCullMode(.back)
        _mesh.draw(renderCommandEncoder)
    }
}

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
    
    public func setNormalMap(_ textureType: TextureTypes) {
        self._normalTextureType = textureType
        self._materialConstants.useNormalMap = textureType != .None
    }
    
    public func setSpecularMap(_ textureType: TextureTypes) {
        self._specularTextureType = textureType
        self._materialConstants.useSpecularMap = textureType != .None
    }
    
    public func setAmbientMap(_ textureType: TextureTypes) {
        self._ambientTextureType = textureType
        self._materialConstants.useAmbientMap = textureType != .None
    }
    
    public func setHeightMap(_ textureType: TextureTypes) {
        self._heightMapTextureType = textureType
        self._materialConstants.useHeightMap = textureType != .None
    }
    
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
