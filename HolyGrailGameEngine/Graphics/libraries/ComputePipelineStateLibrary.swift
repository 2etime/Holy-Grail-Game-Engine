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
    case QuadTessellation
}

class ComputePipelineStateLibrary {
    
    private var _library: [ComputePipelineStateTypes:ComputePipelineState] = [:]
    
    init() {
        createLibrary()
    }
    
    private func createLibrary() {
        _library.updateValue(QuadTessellation_ComputePipelineState(), forKey: .QuadTessellation)
    }
    
    subscript(_ type: ComputePipelineStateTypes)->MTLComputePipelineState{
        return self._library[type]!.computePipelineState
    }
    
}

protocol ComputePipelineState {
    var computePipelineState: MTLComputePipelineState! { get }
}

public struct QuadTessellation_ComputePipelineState: ComputePipelineState {
    var computePipelineState: MTLComputePipelineState!
    init(){
        let function = Engine.DefaultLibrary.makeFunction(name: "quad_tessellation")
        do{
            computePipelineState = try Engine.Device.makeComputePipelineState(function: function!)
        } catch let error as NSError {
            print("ERROR::CREATE::COMPUTE_PIPELINE_STATE::\(error)")
        }
    }
}


