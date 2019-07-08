//
//  RenderPipelineStateLibrary.swift
//  HolyGrailGameEngine
//
//  Created by Rick Twohy Jr on 6/15/19.
//  Copyright © 2019 Rick Twohy Jr. All rights reserved.
//

import MetalKit

enum ComputePipelineStateTypes {
    case None
}

class ComputePipelineStateLibrary {
    
    private var _library: [ComputePipelineStateTypes:ComputePipelineState] = [:]
    
    init() {
        createLibrary()
    }
    
    private func createLibrary() {

    }
    
    subscript(_ type: ComputePipelineStateTypes)->MTLComputePipelineState{
        return self._library[type]!.computePipelineState
    }
    
}

protocol ComputePipelineState {
    var computePipelineState: MTLComputePipelineState! { get }
}



