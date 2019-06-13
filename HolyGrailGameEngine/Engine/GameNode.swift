//
//  Node.swift
//  HolyGrailGameEngine
//
//  Created by Rick Twohy Jr on 6/13/19.
//  Copyright © 2019 Rick Twohy Jr. All rights reserved.
//

import MetalKit

class GameNode {
    private var _name: String = "Node"
    private var _children: [GameNode] = []
    
    init(name: String) {
        self._name = name
    }
    
    internal func addChild(_ node: GameNode) {
        self._children.append(node)
    }
    
    public func update() {
        for child in self._children {
            child.update()
        }
    }
    
    
    internal func setRenderPipelineValues(_ renderCommandEncoder: MTLRenderCommandEncoder) {
        // Override with inheriting classes
    }

    public func render(_ renderCommandEncoder: MTLRenderCommandEncoder) {
        setRenderPipelineValues(renderCommandEncoder)
        if let renderable = self as? Renderable {
            renderable.doRender(renderCommandEncoder)
        }
        for child in self._children {
            child.render(renderCommandEncoder)
        }
    }
}

extension GameNode {
    public var Name: String { return self._name }
}
