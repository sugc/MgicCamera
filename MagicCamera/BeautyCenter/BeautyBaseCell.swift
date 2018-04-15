//
//  BeautyBaseCell.swift
//  MagicCamera
//
//  Created by sugc on 2018/3/21.
//  Copyright © 2018年 sugc. All rights reserved.
//

import Foundation

class BeautyBaseCell: UICollectionViewCell {
    
    var label : UILabel!
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        label = UILabel.init(frame: self.bounds)
        label.textAlignment = NSTextAlignment.center
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor.black
        self.contentView.addSubview(label)
    }
    
    
}
