//
//  FilterListViewHeader.swift
//  MagicCamera
//
//  Created by sugc on 2017/9/15.
//  Copyright © 2017年 sugc. All rights reserved.
//

import Foundation
import UIKit

protocol FilterListViewHeaderDelegate : NSObjectProtocol {
    
    func FilterListViewHeader(_ hederView: FilterListViewHeader?, didSelectItemAt section: NSInteger)
}

class FilterListViewHeader : UICollectionReusableView {

    @IBOutlet var imageView : UIImageView!
    @IBOutlet var titleLabel : UILabel!
    weak open var delegate : FilterListViewHeaderDelegate?
    var section : NSInteger!
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
        
    }
    
    @IBAction func clickButton() {
        delegate?.FilterListViewHeader(self, didSelectItemAt: section)
    }
}
