//
//  CommonFilter.swift
//  Purika
//
//  Created by zj－db0548 on 2017/1/20.
//  Copyright © 2017年 魔方. All rights reserved.
//

import Foundation

import Foundation

let tmpVertices : Array <GLfloat> = [
    -1, -1, 0,   //左下
    1,  -1, 0,   //右下
    -1, 1,  0,   //左上
    1,  1,  0,   //右上
]

let tmpTexCoords : Array <GLfloat> = [
    0, 0,//左下
    1, 0,//右下
    0, 1,//左上
    1, 1,//右上
]

class CommonFiler : BaseFilter {
    
    
    required init() {
        super.init()
        
    }
    
    required init(vString : String, fString : String ){
        super.init(vString: vString, fString: fString)
        textureScale = tmpTexCoords
        textPosition = tmpVertices
    }
    
    
    override func render(){
        
        super.render()
    }



}
