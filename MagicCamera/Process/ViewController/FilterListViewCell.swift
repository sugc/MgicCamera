//
//  FilterListViewCell.swift
//  MagicCamera
//
//  Created by sugc on 2017/9/15.
//  Copyright © 2017年 sugc. All rights reserved.
//

import Foundation
import UIKit

class FilterListViewCell : UICollectionViewCell {
    
    @IBOutlet var imageView : UIImageView!
    @IBOutlet var titleLabel : UILabel!
    @IBOutlet var maskImageView : UIImageView!
    var isSelect : Bool = false {
        didSet {
            maskImageView.isHidden = !isSelect
        }
    }
    
    var imageName : String? {
        didSet {
            imageView.image = UIImage.init(contentsOfFile: imageName!)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.isHidden = false
    }
}
