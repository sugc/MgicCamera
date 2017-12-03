//
//  NSString+Utils.swift
//  Purika
//
//  Created by zj－db0548 on 2017/4/9.
//  Copyright © 2017年 魔方. All rights reserved.
//

import Foundation

extension NSString {

    func verticalString() -> NSString {
        
        if self.length == 0 {
            return NSString(string: "")
        }
        var str = NSString(string: "")
        
        for i in 0...(self.length - 1) {
            let range = NSMakeRange(i, 1)
            
            let subStr = self.substring(with: range) + "\n"
            str = NSString(string: str.appending(subStr))
            
        }
        return str;
    }


}
