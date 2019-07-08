//
//  Boundable.swift
//  HolyGrailGameEngine
//
//  Created by Rick Twohy Jr on 7/8/19.
//  Copyright © 2019 Rick Twohy Jr. All rights reserved.
//

protocol Boundable {
    var boundingType: BoundingTypes { get }
}

extension Boundable {
    func intersects(_ boundable: Boundable)->Bool {
        
        return true
    }
    
    private func checkSphereOnSphere(boundable: Boundable) {
        
    }
}
