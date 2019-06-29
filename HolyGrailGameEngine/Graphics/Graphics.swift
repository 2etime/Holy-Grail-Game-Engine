//
//  Graphics.swift
//  HolyGrailGameEngine
//
//  Created by Rick Twohy Jr on 6/15/19.
//  Copyright © 2019 Rick Twohy Jr. All rights reserved.
//

class Graphics {
    
    private static var _computePipelineStateLibrary: ComputePipelineStateLibrary!
    public static var ComputePipelineStates: ComputePipelineStateLibrary { return self._computePipelineStateLibrary }
    
    private static var _renderPipelineStateLibrary: RenderPipelineStateLibrary!
    public static var RenderPipelineStates: RenderPipelineStateLibrary { return self._renderPipelineStateLibrary }
    
    private static var _samplerStateLibrary: SamplerStateLibrary!
    public static var SamplerStates: SamplerStateLibrary { return self._samplerStateLibrary }
    
    private static var _depthStencilStateLibrary: DepthStencilStateLibrary!
    public static var DepthStencilStates: DepthStencilStateLibrary { return _depthStencilStateLibrary }
    
    public static func Initialize() {
        self._computePipelineStateLibrary = ComputePipelineStateLibrary()
        self._samplerStateLibrary = SamplerStateLibrary()
        self._depthStencilStateLibrary = DepthStencilStateLibrary()
        self._renderPipelineStateLibrary = RenderPipelineStateLibrary()
    }
    
}
