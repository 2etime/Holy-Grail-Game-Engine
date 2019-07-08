//
//  GameBounds.swift
//  HolyGrailGameEngine
//
//  Created by Rick Twohy Jr on 7/7/19.
//  Copyright © 2019 Rick Twohy Jr. All rights reserved.
//

import MetalKit

class BoundingObject: Node {
    private var _boundingMesh: BoundingMesh!
    private var _modelConstants = ModelConstants()
    
    init(_ mesh: Mesh, boundingType: BoundingTypes) {
        super.init(name: "Bounding Mesh")
        self._boundingMesh = BoundingMesh(boundingBoxes: mesh.boundingBoxes, boundingType: boundingType)
    }
    
    func intersects(object: BoundingObject) {
//        let myBoundingBoxes = _boundingMesh.boundingBoxes[0]
//        let objectBoundingBoxes = object._boundingMesh.boundingBoxes
//
    }
    
    override func update() {
        updateModelConstants()
        super.update()
    }
    
    private func updateModelConstants() {
        self._modelConstants.modelMatrix = self.modelMatrix
    }

    override func setRenderPipelineValues(_ renderCommandEncoder: MTLRenderCommandEncoder) {
        renderCommandEncoder.setRenderPipelineState(Graphics.RenderPipelineStates[.Bounds])
        renderCommandEncoder.setVertexBytes(&_modelConstants,
                                            length: ModelConstants.stride,
                                            index: 2)
    }
}

extension BoundingObject: Renderable {
    func doRender(_ renderCommandEncoder: MTLRenderCommandEncoder) {
        _boundingMesh.drawRender(renderCommandEncoder)
    }
}
