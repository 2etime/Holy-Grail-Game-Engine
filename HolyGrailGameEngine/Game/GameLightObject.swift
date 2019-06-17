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
    public func setLightAmbientIntensity(_ ambientIntensiy: Float){ self.lightData.ambientIntesity = ambientIntensiy }
    public func setLightDiffuseIntensity(_ diffuseIntensiy: Float){ self.lightData.diffuseIntensity = diffuseIntensiy }
    public func setLightSpecularIntensity(_ specularIntensiy: Float){ self.lightData.specularIntensity = specularIntensiy }
    public func setLightBrightness(_ brightness: Float){ self.lightData.brightness = brightness }
    public func getLightBrightness()->Float{ return self.lightData.brightness }
}
