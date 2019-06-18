//
//  GameLightObject.swift
//  HolyGrailGameEngine
//
//  Created by Rick Twohy Jr on 6/17/19.
//  Copyright © 2019 Rick Twohy Jr. All rights reserved.
//

import MetalKit

class LightObject: GameObject {
    
    var lightData = LightData()
    
    init(name: String) {
        super.init(name: name, meshType: .None)
    }
    
    override init(name: String, meshType: MeshTypes) {
        super.init(name: name,  meshType: meshType)
    }
    
    override func update() {
        self.lightData.position = self.getPosition()
        super.update()
    }
}

extension LightObject {
    public func setLightColor(_ lightColor: float3) { self.lightData.color = lightColor }
    public func setLightColor(_ r: Float,_ g: Float,_ b: Float) { self.lightData.color = float3(r,g,b) }
    
    public func setLightAmbientIntensity(_ ambientIntensiy: Float){ self.lightData.ambientIntesity = ambientIntensiy }
    public func addLightAmbientIntensity(_ value: Float) { self.lightData.ambientIntesity += value }
    public func getLightAmbientIntensity()->Float { return self.lightData.ambientIntesity }
    
    public func setLightDiffuseIntensity(_ diffuseIntensiy: Float){ self.lightData.diffuseIntensity = diffuseIntensiy }
    public func addLightDiffuseIntensity(_ value: Float) { self.lightData.diffuseIntensity += value }
    public func getLightDiffuseIntensity()->Float { return self.lightData.diffuseIntensity }
    
    public func setLightSpecularIntensity(_ specularIntensiy: Float){ self.lightData.specularIntensity = specularIntensiy }
    public func addLightSpecularIntensity(_ value: Float) { self.lightData.specularIntensity += value }
    public func getLightSpecularIntensity()->Float { return self.lightData.specularIntensity }
    
    public func setLightBrightness(_ brightness: Float){ self.lightData.brightness = brightness }
    public func addLightBrightness(_ value: Float) { self.lightData.brightness += value }
    public func getLightBrightness()->Float{ return self.lightData.brightness }
}
