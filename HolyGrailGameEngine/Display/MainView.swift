//
//  ViewController.swift
//  HolyGrailGameEngine
//
//  Created by Rick Twohy Jr on 6/13/19.
//  Copyright © 2019 Rick Twohy Jr. All rights reserved.
//

import MetalKit

class MainView: MTKView {

    private var _renderer: Renderer!
    required init(coder: NSCoder) {
        super.init(coder: coder)
        
        self.device = MTLCreateSystemDefaultDevice()
        
        Engine.Ignite(self.device!)
        
        self._renderer = Renderer()
        
        self.clearColor = EngineSettings.ClearColor
        
        self.colorPixelFormat = .bgra8Unorm_srgb
        
        self.delegate = _renderer
    }
    
}

