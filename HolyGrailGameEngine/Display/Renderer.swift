//
//  HGRenderer.swift
//  HolyGrailGameEngine
//
//  Created by Rick Twohy Jr on 6/13/19.
//  Copyright © 2019 Rick Twohy Jr. All rights reserved.
//

import MetalKit

class Renderer: NSObject {
    
}

extension Renderer: MTKViewDelegate {
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        //TODO: Update when window is resized
    }
    
    func draw(in view: MTKView) {
        guard let drawable = view.currentDrawable, let renderPassDescriptor = view.currentRenderPassDescriptor else { return }
        let commandBuffer = Engine.CommandQueue.makeCommandBuffer()
        let renderCommandEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: renderPassDescriptor)
        
        // Draw Here
        
        renderCommandEncoder?.endEncoding()
        commandBuffer?.present(drawable)
        commandBuffer?.commit()
    }
    
}
