//
//  Vector3.swift
//  MagicCamera
//
//  Created by sugc on 2017/10/15.
//  Copyright © 2017年 sugc. All rights reserved.
//

import Foundation

struct Vector3 {
    var x : Double
    var y : Double
    var z : Double
}

func vectorDot(vec1:Vector3!, vec2:Vector3!) -> Double {
    return vec1.x * vec2.x + vec1.y * vec2.y + vec1.z * vec2.z
}

func vectorAngle(vec1:Vector3!, vec2:Vector3!) -> Double {
    var dot = vectorDot(vec1: vec1, vec2: vec2)
    dot = dot > 1.0 ? 1.0 : dot;
    dot = dot < -1.0 ? -1.0 :dot;
    return Double(acosf(Float(dot)))
}




