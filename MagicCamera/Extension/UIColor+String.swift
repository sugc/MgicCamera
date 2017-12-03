//
//  UIColor+String.swift
//  Purika
//
//  Created by zj－db0548 on 2017/3/30.
//  Copyright © 2017年 魔方. All rights reserved.
//

import Foundation

extension UIColor {
    static func color(hex:NSInteger, alpha:CGFloat)->UIColor {
        
        return  UIColor(red: CGFloat((hex & 0xFF0000) >> 16) / 255.0,
                        green: CGFloat((hex & 0x00FF00) >> 8) / 255.0,
                        blue: CGFloat((hex & 0x0000FF) ) / 255.0,
                        alpha: alpha)
    }

}
