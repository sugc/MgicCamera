//
//  DesignedTextView.swift
//  Purika
//
//  Created by sugc on 2017/9/9.
//  Copyright © 2017年 魔方. All rights reserved.
//

import Foundation

protocol DesignedTextViewDelegate {
    func beginEdit()
}

class DesignedTextView: UIView {
    
    var backImageView : UIImageView!
    var label : UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func commonInit()  {
        //初始化
        
        //添加手势
    }
    
}
