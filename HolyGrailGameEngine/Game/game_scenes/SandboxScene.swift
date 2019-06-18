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
    let lampRight = Lamp()
    let lampMiddle = Lamp()
    let lampLeft = Lamp()
    override func buildScene() {
        debugCamera.setPosition(0,1,6)
        addCamera(debugCamera)
        
        let midColor = float3(1,1,1)
        lampMiddle.setPosition(0, 2, 2)
        lampMiddle.setLightColor(midColor)
        lampMiddle.setMaterialColor(midColor.x, midColor.y, midColor.z, 1.0)
        lampMiddle.setMaterialIsLightable(false)
        lampMiddle.setLightAmbientIntensity(1.0)
        lampMiddle.setLightDiffuseIntensity(1.0)
        lampMiddle.setLightSpecularIntensity(1.0)
        addLight(lampMiddle)
        
        let rightColor = float3(1,0,0)
        lampRight.setPosition(2, 2, 2)
        lampRight.setLightColor(rightColor)
        lampRight.setMaterialColor(rightColor.x, rightColor.y, rightColor.z, 1.0)
        lampRight.setMaterialIsLightable(false)
        lampRight.setLightAmbientIntensity(1.0)
        lampRight.setLightDiffuseIntensity(1.0)
        lampRight.setLightSpecularIntensity(1.0)
        addLight(lampRight)
        
        let leftColor = float3(0,0,1)
        lampLeft.setPosition(-2, 2, 2)
        lampLeft.setLightColor(leftColor)
        lampLeft.setMaterialColor(leftColor.x, leftColor.y, leftColor.z, 1.0)
        lampLeft.setMaterialIsLightable(false)
        lampLeft.setLightAmbientIntensity(1.0)
        lampLeft.setLightDiffuseIntensity(1.0)
        lampLeft.setLightSpecularIntensity(1.0)
        addLight(lampLeft)
        
        sphere.setMaterialAmbient(0.03)
        sphere.setMaterialDiffuse(0.8)
        sphere.setMaterialSpecular(1)
        sphere.setMaterialShininess(0.8 * 128)
        sphere.setMaterialSpecularMapIntensity(15)
        
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
    
    var selectedLight: [Bool] = [false, true, false]
    func setSelectedLight(_ code: KeyCodes) {
        switch code {
        case .one:
            selectedLight[0] = true
            selectedLight[1] = false
            selectedLight[2] = false
        case .two:
            selectedLight[0] = false
            selectedLight[1] = true
            selectedLight[2] = false
        case .three:
            selectedLight[0] = false
            selectedLight[1] = false
            selectedLight[2] = true
        default:
            break;
        }
    }
    
    private var timePassed: Int = 0
    override func onUpdate() {
        timePassed += 1
        if(timePassed > 10){
            if(Keyboard.IsKeyPressed(.a)){
                timePassed = 0
                toggleBaseTexture()
            }
            if(Keyboard.IsKeyPressed(.s)){
                timePassed = 0
                toggleAmbientTexture()
            }
            if(Keyboard.IsKeyPressed(.d)){
                timePassed = 0
                toggleNormalTexture()
            }
            if(Keyboard.IsKeyPressed(.f)){
                timePassed = 0
                toggleSpecularTexture()
            }
        }
        
        sphere.rotateY(GameTime.DeltaTime)
        
        if(Mouse.IsMouseButtonPressed(button: .left)){
            if(selectedLight[0]) {
                lampLeft.moveX(Mouse.GetDX() * GameTime.DeltaTime * 0.3)
                lampLeft.moveY(-Mouse.GetDY() * GameTime.DeltaTime * 0.3)
            } else if(selectedLight[1]) {
                lampMiddle.moveX(Mouse.GetDX() * GameTime.DeltaTime * 0.3)
                lampMiddle.moveY(-Mouse.GetDY() * GameTime.DeltaTime * 0.3)
            } else if(selectedLight[2]) {
                lampRight.moveX(Mouse.GetDX() * GameTime.DeltaTime * 0.3)
                lampRight.moveY(-Mouse.GetDY() * GameTime.DeltaTime * 0.3)
            }
        }
        
        if(selectedLight[0]) {
            lampLeft.addLightBrightness(Mouse.GetDWheel() * GameTime.DeltaTime)
        } else if(selectedLight[1]) {
            lampMiddle.addLightBrightness(Mouse.GetDWheel() * GameTime.DeltaTime)
        } else if(selectedLight[2]) {
            lampRight.addLightBrightness(Mouse.GetDWheel() * GameTime.DeltaTime)
        }
        
        if(Keyboard.IsKeyPressed(.one)) {
            setSelectedLight(.one)
        }else if(Keyboard.IsKeyPressed(.two)) {
            setSelectedLight(.two)
        }else if(Keyboard.IsKeyPressed(.three)) {
            setSelectedLight(.three)
        }

    }
}
