//
//  BufferManager.swift
//  HolyGrailGameEngine
//
//  Created by Rick Twohy Jr on 6/16/19.
//  Copyright © 2019 Rick Twohy Jr. All rights reserved.
//

class BufferManager<T> {
    private var _buffers: [T]
    
    init(proto:T, bufferCount: Int) {
        self._buffers = [T].init(repeating: proto, count: bufferCount)
    }
    
    subscript(_ index: Int)->T{
        return _buffers[index]
    }
    
    func setBuffer(index: Int, _ value: T){
        self._buffers[index] = value
    }
}
