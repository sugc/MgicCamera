//
//  JigsawModel.swift
//  Purika
//
//  Created by zj－db0548 on 2017/2/3.
//  Copyright © 2017年 魔方. All rights reserved.
//

import Foundation


class JigsawModel {

    var ID : String!   //模板ID
    var backRect : CGRect!
    var ratio : Float!
    //按照比率来设置0-1
    var rectArray : Array<CGRect>!
    
    //默认的文字位置
    var textArray : Array<Dictionary<String, Any>>!
    
}
