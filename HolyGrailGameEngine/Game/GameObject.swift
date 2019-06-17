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
    private var _baseTextureType: TextureTypes!
    
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
        renderCommandEncoder.setVertexBytes(&_modelConstants,
                                            length: ModelConstants.stride,
                                            index: 2)
        renderCommandEncoder.setFragmentBytes(&_materialConstants,
                                              length: MaterialConstants.stride,
                                              index: 0)
        renderCommandEncoder.setFragmentSamplerState(Graphics.SamplerStates[.Linear],
                                                     index: 0)
        if(_materialConstants.useBaseTexture) {
            renderCommandEncoder.setFragmentTexture(Entities.Textures[_baseTextureType],
                                                    index: 0)
        }
    }
}

extension GameObject: Renderable {
    func doRender(_ renderCommandEncoder: MTLRenderCommandEncoder) {
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
        self._materialConstants.useBaseTexture = true
        self._materialConstants.useMaterialColor = false
    }
}
