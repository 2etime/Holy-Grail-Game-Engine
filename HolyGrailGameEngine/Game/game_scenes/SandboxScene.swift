//
//  SandboxScene.swift
//  HolyGrailGameEngine
//
//  Created by Rick Twohy Jr on 6/13/19.
//  Copyright © 2019 Rick Twohy Jr. All rights reserved.
//

import MetalKit

class SandboxScene: GameScene {
    let sphere = Sphere()
    let debugCamera = DebugCamera()
    let lamp = Lamp()
    override func buildScene() {
        debugCamera.setPosition(0,1,6)
        addCamera(debugCamera)
        
        lamp.setPosition(0, 2, 2)
        lamp.setMaterialIsLightable(false)
        lamp.setLightAmbientIntensity(1.0)
        lamp.setLightDiffuseIntensity(1.0)
        lamp.setLightSpecularIntensity(1.0)
        addLight(lamp)
        
        sphere.setMaterialAmbient(0.03)
        sphere.setMaterialDiffuse(0.8)
        sphere.setMaterialSpecular(1)
        sphere.setMaterialShininess(0.8 * 128)
        sphere.setSpecularMapIntensity(15)
        
//        sphere.setBaseTexture(.Sand_Base)
//        sphere.setNormalMap(.Sand_Normal)
//        sphere.setSpecularMap(.Sand_Specular)
//        sphere.setAmbientMap(.Sand_Ambient)
        addGameObject(sphere)
    }
    
    private var _currentAmbient: TextureTypes = .None
    func toggleAmbientTexture() {
        if(_currentAmbient == .None){
            _currentAmbient = .Sand_Ambient
            sphere.setAmbientMap(.Sand_Ambient)
        }else{
            _currentAmbient = .None
            sphere.setAmbientMap(.None)
        }
    }
    
    private var _currentNormal: TextureTypes = .None
    func toggleNormalTexture() {
        if(_currentNormal == .None){
            _currentNormal = .Sand_Normal
            sphere.setNormalMap(.Sand_Normal)
        }else{
            _currentNormal = .None
            sphere.setNormalMap(.None)
        }
    }
    
    private var _currentSpecular: TextureTypes = .None
    func toggleSpecularTexture() {
        if(_currentSpecular == .None){
            _currentSpecular = .Sand_Specular
            sphere.setSpecularMap(.Sand_Specular)
        }else{
            _currentSpecular = .None
            sphere.setSpecularMap(.None)
        }
    }
    
    private var _currentBase: TextureTypes = .None
    func toggleBaseTexture() {
        if(_currentBase == .None){
            _currentBase = .Sand_Base
            sphere.setBaseTexture(.Sand_Base)
        }else{
            _currentBase = .None
            sphere.setBaseTexture(.None)
        }
    }
    
    private var timePassed: Int = 0
    override func onUpdate() {
        timePassed += 1
        if(timePassed > 10){
            if(Keyboard.IsKeyPressed(.one)){
                timePassed = 0
                toggleBaseTexture()
            }
            if(Keyboard.IsKeyPressed(.two)){
                timePassed = 0
                toggleAmbientTexture()
            }
            if(Keyboard.IsKeyPressed(.three)){
                timePassed = 0
                toggleNormalTexture()
            }
            if(Keyboard.IsKeyPressed(.four)){
                timePassed = 0
                toggleSpecularTexture()
            }
        }
        if(Mouse.IsMouseButtonPressed(button: .left)) {
            sphere.rotateX(Mouse.GetDY() * GameTime.DeltaTime)
            sphere.rotateY(Mouse.GetDX() * GameTime.DeltaTime)
        }
        
        if(Keyboard.IsKeyPressed(.b)){
            lamp.setLightBrightness(lamp.getLightBrightness() - Mouse.GetDWheel() * GameTime.DeltaTime)
        }
        
        if(Keyboard.IsKeyPressed(.s)){
            sphere.setSpecularMapIntensity(sphere.getSpecularMapIntensity() - Mouse.GetDWheel())
        }
        
        if(Keyboard.IsKeyPressed(.a)){
            sphere.setAmbientMapIntensity(sphere.getAmbientMapIntensity() - Mouse.GetDWheel())
        }
        
        
    }
}
