//
//  DebugCamera.swift
//  HolyGrailGameEngine
//
//  Created by Rick Twohy Jr on 6/16/19.
//  Copyright © 2019 Rick Twohy Jr. All rights reserved.
//

import MetalKit

class DebugCamera: GameCamera {
    private var _zoom: Float = 45.0
    
    override var projectionMatrix: matrix_float4x4 {
        return matrix_float4x4.perspective(degreesFov: self._zoom,
                                           aspectRatio: Renderer.AspectRatio,
                                           near: 0.1,
                                           far: 1000)
    }
    
    init() {
        super.init(name: "Debug Camera", cameraType: .Debug)
    }
    
    override func onUpdate() {
        self._zoom -= Mouse.GetDWheel()
        
        if(Keyboard.IsKeyPressed(.upArrow)) {
            self.moveY(GameTime.DeltaTime)
        }
        if(Keyboard.IsKeyPressed(.downArrow)) {
            self.moveY(-GameTime.DeltaTime)
        }
        if(Keyboard.IsKeyPressed(.leftArrow)) {
            self.moveX(-GameTime.DeltaTime)
        }
        if(Keyboard.IsKeyPressed(.rightArrow)) {
            self.moveX(GameTime.DeltaTime)
        }
    }

}
