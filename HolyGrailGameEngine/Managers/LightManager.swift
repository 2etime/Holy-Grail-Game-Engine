import MetalKit

class LightManager {
    private var _lightObjects: [LightObject] = []
    
    func addLightObject(_ lightObject: LightObject) {
        self._lightObjects.append(lightObject)
    }
    
    private func gatherLightData()->[LightData] {
        var result: [LightData] = []
        for lightObject in _lightObjects {
            result.append(lightObject.lightData)
        }
        return result
    }
    
    func setLightData(_ renderCommandEncoder: MTLRenderCommandEncoder) {
        var lightDatas = gatherLightData()
        var lightCount = lightDatas.count
        renderCommandEncoder.setFragmentBytes(&lightCount,
                                              length: Int32.stride,
                                              index: 1)
        renderCommandEncoder.setFragmentBytes(&lightDatas,
                                              length: LightData.size(lightDatas.count),
                                              index: 2)
    }
}
