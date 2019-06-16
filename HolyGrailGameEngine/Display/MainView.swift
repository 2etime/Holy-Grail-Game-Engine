//
//  ViewController.swift
//  HolyGrailGameEngine
//
//  Created by Rick Twohy Jr on 6/13/19.
//  Copyright © 2019 Rick Twohy Jr. All rights reserved.
//

import MetalKit

class MainView: MTKView {
    public static var ScreenSize = float2(0,0)
    public static var AspectRatio: Float {
        return ScreenSize.x / ScreenSize.y
    }
    
    private var _renderer: Renderer!
    required init(coder: NSCoder) {
        super.init(coder: coder)
        
        self.device = MTLCreateSystemDefaultDevice()
        
        Engine.Ignite(self.device!)
        
        self._renderer = Renderer(mtkView: self)
        
        self.clearColor = EngineSettings.ClearColor
        
        self.colorPixelFormat = EngineSettings.MainPixelFormat
        
        self.depthStencilPixelFormat = EngineSettings.MainDepthPixelFormat
        
        self.delegate = _renderer
    }
    
}

