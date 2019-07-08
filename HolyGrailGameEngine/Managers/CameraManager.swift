//
//  CameraManager.swift
//  HolyGrailGameEngine
//
//  Created by Rick Twohy Jr on 6/16/19.
//  Copyright © 2019 Rick Twohy Jr. All rights reserved.
//

enum CameraTypes {
    case Debug
}

class CameraManager {
    private var _cameras: [CameraTypes : Camera] = [:]
    public var currentCamera: Camera!
    
    public func addCamera(camera: Camera) {
        self.registerCamera(camera: camera)
    }
    
    private func registerCamera(camera: Camera){
        self._cameras.updateValue(camera, forKey: camera.cameraType)
        
        // Always register the first camera
        if(currentCamera == nil){
            self.currentCamera = camera
        }
    }
    
    func setCamera(_ cameraType: CameraTypes){
        self.currentCamera = _cameras[cameraType]
    }
    
    func update(){
        for camera in _cameras.values {
            camera.update()
        }
    }
    
}
