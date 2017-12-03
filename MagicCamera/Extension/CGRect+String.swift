//
//  CGRect+String.swift
//  Purika
//
//  Created by zj－db0548 on 2017/2/11.
//  Copyright © 2017年 魔方. All rights reserved.
//

import Foundation


extension CGRect {

    
    public static func getRect(array:Array<NSNumber>)->CGRect {
        
        //格式不对
        if array.count != 4 {
            return CGRect.zero
        }
    
        let rect = CGRect(x:  CGFloat.init(array[0]),
                          y: CGFloat.init(array[1]),
                          width: CGFloat.init(array[2]),
                          height: CGFloat.init(array[3]))
        return rect
    }

    
    public static func getRect(string:String)->CGRect {
        
        let array : Array<String> =  string.components(separatedBy: ",")
        
        //格式不对
        if array.count != 4 {
            return CGRect.zero
        }
        
        let rect = CGRect(x: CGFloat(Double(array[0])!),
                          y: CGFloat(Double(array[1])!),
                          width: CGFloat(Double(array[2])!),
                          height: CGFloat(Double(array[3])!))
        return rect
    }
    
}
