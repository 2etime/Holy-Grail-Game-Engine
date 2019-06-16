//
//  GameCamera.swift
//  HolyGrailGameEngine
//
//  Created by Rick Twohy Jr on 6/16/19.
//  Copyright © 2019 Rick Twohy Jr. All rights reserved.
//

import simd

class GameCamera: GameNode {
    var cameraType: CameraTypes!
    
    var viewMatrix: matrix_float4x4 {
        var viewMatrix = matrix_identity_float4x4
        viewMatrix.rotate(angle: self.getRotationX(), axis: X_AXIS)
        viewMatrix.rotate(angle: self.getRotationY(), axis: Y_AXIS)
        viewMatrix.rotate(angle: self.getRotationZ(), axis: Z_AXIS)
        viewMatrix.translate(direction: -getPosition())
        return viewMatrix
    }
    
    var projectionMatrix: matrix_float4x4 {
        return matrix_identity_float4x4
    }
    
    init(name: String, cameraType: CameraTypes){
        super.init(name: "Camera")
        self.cameraType = cameraType
    }
}
