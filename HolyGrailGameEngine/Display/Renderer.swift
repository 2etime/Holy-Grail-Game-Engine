//
//  HGRenderer.swift
//  HolyGrailGameEngine
//
//  Created by Rick Twohy Jr on 6/13/19.
//  Copyright © 2019 Rick Twohy Jr. All rights reserved.
//

import MetalKit

class Renderer: NSObject {
    public static var ScreenSize = float2(0,0)
    public static var AspectRatio: Float { return ScreenSize.x / ScreenSize.y }
    
    private var _sceneManager: SceneManager!
    private var _inFlightSemaphore: DispatchSemaphore!

    init(mtkView: MTKView) {
        super.init()
        updateScreenSize(view: mtkView)
        self._sceneManager = SceneManager(startingSceneType: EngineSettings.StartingSceneType)
        self._inFlightSemaphore = DispatchSemaphore.init(value: EngineSettings.MaxBuffersInFlight)
    }
    
    public func updateScreenSize(view: MTKView){
        Renderer.ScreenSize = float2(Float(view.bounds.width), Float(view.bounds.height))
    }
}

extension Renderer: MTKViewDelegate {
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        updateScreenSize(view: view)
    }
    
    func draw(in view: MTKView) {
        _ = _inFlightSemaphore.wait(timeout: .distantFuture)
        
        guard let drawable = view.currentDrawable, let renderPassDescriptor = view.currentRenderPassDescriptor else { return }
        let commandBuffer = Engine.CommandQueue.makeCommandBuffer()
        
        let blockSemaphore = _inFlightSemaphore
        commandBuffer?.addCompletedHandler({ _  in
            blockSemaphore!.signal()
        })
        
        self._sceneManager.update(deltaTime: 1.0 / Float(view.preferredFramesPerSecond ))
                
        let renderCommandEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: renderPassDescriptor)

        self._sceneManager.mainRenderPass(renderCommandEncoder: renderCommandEncoder!)
        
        renderCommandEncoder?.endEncoding()
        commandBuffer?.present(drawable)
        commandBuffer?.commit()
    }
    
}
