//
//  Graphics.swift
//  HolyGrailGameEngine
//
//  Created by Rick Twohy Jr on 6/15/19.
//  Copyright © 2019 Rick Twohy Jr. All rights reserved.
//

class Graphics {
    
    private static var _renderPipelineStateLibrary: RenderPipelineStateLibrary!
    public static var RenderPipelineStates: RenderPipelineStateLibrary { return self._renderPipelineStateLibrary }
    
    public static func Initialize() {
        self._renderPipelineStateLibrary = RenderPipelineStateLibrary()
    }
    
}
