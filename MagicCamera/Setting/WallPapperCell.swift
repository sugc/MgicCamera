//
//  WallPapperCell.swift
//  MagicCamera
//
//  Created by SuGuocai on 2017/12/26.
//  Copyright © 2017年 sugc. All rights reserved.
//

import Foundation

class WallPapperCell: UICollectionViewCell {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func layout() {
        let imageView = UIImageView.init(frame: self.bounds)
        let deleteBtn = UIButton.init(frame: CGRect.init(x: self.width - 15,
                                                         y: 0,
                                                         width: 15,
                                                         height: 15))
        
    }
    
    func delete() {
        
    }
}
