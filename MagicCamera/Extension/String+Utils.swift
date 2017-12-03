//
//  String+Utils.swift
//  Purika
//
//  Created by zj－db0548 on 2017/4/9.
//  Copyright © 2017年 魔方. All rights reserved.
//

import Foundation


extension String {


    func verticalString() -> String {
        
        var str = ""
        let testStr = NSString(string: self)
        
        for i in 0...(testStr.length - 1) {
            let range = NSMakeRange(i, 1)
            str = str + testStr.substring(with: range) + "\n"
            
        }
        return str;
    }

}
