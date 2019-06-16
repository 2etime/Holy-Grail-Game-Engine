//
//  Shader.swift
//  HolyGrailGameEngine
//
//  Created by Rick Twohy Jr on 6/15/19.
//  Copyright © 2019 Rick Twohy Jr. All rights reserved.
//

import MetalKit

class Shader {
    var function: MTLFunction!
    init(functionName: String) {
        self.function = Engine.DefaultLibrary.makeFunction(name: functionName)
        self.function.label = functionName
    }
}
