//
//  Library.swift
//  HolyGrailGameEngine
//
//  Created by Rick Twohy Jr on 6/14/19.
//  Copyright © 2019 Rick Twohy Jr. All rights reserved.
//

import MetalKit

class Library<T> {
    private var _library: [String: T] = [:]
    
    init() {
        createDefaultLibraryItems()
    }
    
    internal func createDefaultLibraryItems() {
        //TODO: Override with sub classes
    }
    
    internal func addItem(key: String, value: T) {
        self._library.updateValue(value, forKey: key)
    }
    
    subscript(_ key: String)->T {
        return _library[key]!
    }
}
