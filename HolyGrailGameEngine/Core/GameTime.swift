//
//  GameTime.swift
//  HolyGrailGameEngine
//
//  Created by Rick Twohy Jr on 6/13/19.
//  Copyright © 2019 Rick Twohy Jr. All rights reserved.
//
import simd

class GameTime {
    private static var _deltaTime: Float = 0.0
    private static var _totalTime: Float = 0.0
    
    public static var DeltaTime: Float { return self._deltaTime }
    public static var TotalTime: Float { return self._totalTime }
    
    public static func UpdateGameTime(_ deltaTime: Float) {
        self._deltaTime = deltaTime
        self._totalTime += deltaTime
    }
}
