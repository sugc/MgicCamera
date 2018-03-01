//
//  ClipView.swift
//  MagicCamera
//
//  Created by SuGuocai on 2018/2/25.
//  Copyright © 2018年 sugc. All rights reserved.
//

import Foundation
import UIKit


class ClipView : UIView {
    
    
    var imageView : UIImageView!
    var clipRatio : CGFloat = 1 {
        didSet {
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
