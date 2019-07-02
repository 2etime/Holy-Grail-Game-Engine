//
//  SandboxScene.swift
//  HolyGrailGameEngine
//
//  Created by Rick Twohy Jr on 6/13/19.
//  Copyright © 2019 Rick Twohy Jr. All rights reserved.
//

import MetalKit

class SandboxScene: GameScene {
    let sphere = RocketShip()
    let debugCamera = DebugCamera()
    var lampRight = Lamp()
    var lampMiddle = Lamp()
    var lampLeft = Lamp()
    override func buildScene() {
        debugCamera.setPosition(0,1,6)
        addCamera(debugCamera)
        
        sphere.setMaterialAmbient(0.03)
        sphere.setMaterialDiffuse(0.8)
        sphere.setMaterialSpecular(1)
        sphere.setMaterialShininess(0.8 * 128)
        sphere.setMaterialSpecularMapIntensity(15)
        addGameObject(sphere)
        
        let background = Quad()
//        background.setScale(10)
//        background.moveZ(-10)
        addGameObject(background)
    }
    
    
    var selectedLight: [Bool] = [false, true, false]
    func setSelectedLight(_ code: KeyCodes) {
        switch code {
        case .one:
            Console.LightColor = lampLeft.getLightColor()
            Console.LightAmbientIntensity = lampLeft.getLightAmbientIntensity()
            Console.LightDiffuseIntensity = lampLeft.getLightDiffuseIntensity()
            Console.LightSpecularItensity = lampLeft.getLightSpecularIntensity()
            selectedLight[0] = true
            selectedLight[1] = false
            selectedLight[2] = false
        case .two:
            Console.LightColor = lampMiddle.getLightColor()
            Console.LightAmbientIntensity = lampMiddle.getLightAmbientIntensity()
            Console.LightDiffuseIntensity = lampMiddle.getLightDiffuseIntensity()
            Console.LightSpecularItensity = lampMiddle.getLightSpecularIntensity()
            selectedLight[0] = false
            selectedLight[1] = true
            selectedLight[2] = false
        case .three:
            Console.LightColor = lampRight.getLightColor()
            Console.LightAmbientIntensity = lampRight.getLightAmbientIntensity()
            Console.LightDiffuseIntensity = lampRight.getLightDiffuseIntensity()
            Console.LightSpecularItensity = lampRight.getLightSpecularIntensity()
            selectedLight[0] = false
            selectedLight[1] = false
            selectedLight[2] = true
        default:
            break;
        }
    }
    
    private func setUseBaseTexture(_ useIt: Bool) { sphere.setBaseTexture(useIt ? TextureTypes.RocketShip : TextureTypes.None)}
    private func setUseAmbientMap(_ useIt: Bool) { sphere.setAmbientMap(useIt ? TextureTypes.Sand_Ambient : TextureTypes.None)}
    private func setUseNormalMap(_ useIt: Bool) { sphere.setNormalMap(useIt ? TextureTypes.Sand_Normal : TextureTypes.None)}
    private func setUseSpecularMap(_ useIt: Bool) { sphere.setSpecularMap(useIt ? TextureTypes.Sand_Specular : TextureTypes.None)}
    
    private func setMaterialValues(){
        sphere.setMaterialAmbient(Console.MaterialAmbient)
        sphere.setMaterialDiffuse(Console.MaterialDiffuse)
        sphere.setMaterialSpecular(Console.MaterialSpecular)
        sphere.setMaterialShininess(Console.MaterialShininess)
        sphere.setMaterialAmbientMapIntensity(Console.MaterialAmbientMapIntensity)
        sphere.setMaterialSpecularMapIntensity(Console.MaterialSpecularMapIntensity)
    }
    
    private func setLightIntensities(light: inout Lamp) {
        light.setLightBrightness(Console.LightBrightness)
//        light.setLightAmbientIntensity(Console.LightAmbientIntensity)
//        light.setLightDiffuseIntensity(Console.LightDiffuseIntensity)
//        light.setLightSpecularIntensity(Console.LightSpecularItensity)
    }
    
    private func setLightColor(light: inout Lamp){
        let color = Console.LightColor
        light.setLightColor(color)
//        light.setMaterialColor(color.x, color.y, color.z, 1.0)
    }
    
    override func onUpdate() {
        if(Keyboard.IsKeyPressed(.one)) {
            setSelectedLight(.one)
        }else if(Keyboard.IsKeyPressed(.two)) {
            setSelectedLight(.two)
        }else if(Keyboard.IsKeyPressed(.three)) {
            setSelectedLight(.three)
        }
        
        if(Mouse.IsMouseButtonPressed(button: .left)){
            if(selectedLight[0]) {
                lampLeft.moveX(Mouse.GetDX() * GameTime.DeltaTime)
                lampLeft.moveY(-Mouse.GetDY() * GameTime.DeltaTime)
            } else if(selectedLight[1]) {
                lampMiddle.moveX(Mouse.GetDX() * GameTime.DeltaTime)
                lampMiddle.moveY(-Mouse.GetDY() * GameTime.DeltaTime)
            } else if(selectedLight[2]) {
                lampRight.moveX(Mouse.GetDX() * GameTime.DeltaTime)
                lampRight.moveY(-Mouse.GetDY() * GameTime.DeltaTime)
            }
        }
        
        if(selectedLight[0]) {
            setLightIntensities(light: &lampLeft)
            setLightColor(light: &lampLeft)
        } else if(selectedLight[1]) {
            setLightIntensities(light: &lampMiddle)
            setLightColor(light: &lampMiddle)
        } else if(selectedLight[2]) {
            setLightIntensities(light: &lampRight)
            setLightColor(light: &lampRight)
        }
        
        setUseBaseTexture(Console.UseBaseTexture)
        setUseNormalMap(Console.UseNormalMap)
        setUseSpecularMap(Console.UseSpecularMap)
        setUseAmbientMap(Console.UseAmbientMap)
        setMaterialValues()
        
        if(Keyboard.IsKeyPressed(.space)){
            sphere.rotateX(Mouse.GetDY() * GameTime.DeltaTime)
            sphere.rotateY(Mouse.GetDX() * GameTime.DeltaTime)
        }
        
                                           
        
    }
}
