//
//  Bounds.swift
//  HolyGrailGameEngine
//
//  Created by Rick Twohy Jr on 7/6/19.
//  Copyright © 2019 Rick Twohy Jr. All rights reserved.
//

import simd

class BoundingBox {
    private var _mins: float3 = float3(0,0,0)
    private var _maxs: float3 = float3(0,0,0)
    
    private var _boundingType: BoundingTypes = .None
    
    init(mins: float3, maxs: float3, boundingType: BoundingTypes) {
        self._boundingType = boundingType
        self._mins = mins
        self._maxs = maxs
    }
    
    public func setMins(_ mins: float3) { self._mins = mins }
    public func setMaxs(_ maxs: float3) { self._maxs = maxs }
    public func getBoundingType()->BoundingTypes { return self._boundingType }
    
    public var mins: float3 { return self._mins }
    public var minX: Float { return self._mins.x }
    public var minY: Float { return self._mins.y }
    public var minZ: Float { return self._mins.z }
    
    public var maxs: float3 { return self._maxs }
    public var maxX: Float { return self._maxs.x }
    public var maxY: Float { return self._maxs.y }
    public var maxZ: Float { return self._maxs.z }
}
