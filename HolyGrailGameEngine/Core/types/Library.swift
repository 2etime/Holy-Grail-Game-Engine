//
//  Library.swift
//  HolyGrailGameEngine
//
//  Created by Rick Twohy Jr on 6/14/19.
//  Copyright © 2019 Rick Twohy Jr. All rights reserved.
//

import MetalKit

class Library<T,K> {
    
    init() {
        fillLibrary()
    }
    
    func fillLibrary() {
        //Override this function when filling the library with default values
    }
    
    subscript(_ type: T)->K? {
        return nil
    }
    
}
