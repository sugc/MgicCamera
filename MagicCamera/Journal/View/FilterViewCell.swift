//
//  FilterViewCell.swift
//  Purika
//
//  Created by sugc on 2017/4/27.
//  Copyright © 2017年 魔方. All rights reserved.
//

import Foundation


class FilterViewCell : UICollectionViewCell {
    
    private var imageView : UIImageView!
    private var shutDownImageView : UIImageView!
    private var selectView : UIImageView!
    override var isSelected : Bool {
        didSet {
            if isSelected {
                selectView.isHidden = false
            }else {
                selectView.isHidden = true
            }
        }
    }
    public var image : UIImage?{
        set(newImage){
            self.imageView.image = newImage
        }
        get{
            return self.imageView.image
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        selectView = UIImageView(frame: self.bounds)
        selectView.backgroundColor = UIColor.color(hex: 0x123456, alpha: 0.7)
        
        imageView = UIImageView(frame: self.bounds)
        imageView.backgroundColor = UIColor.gray
        imageView.contentMode = UIViewContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        self.contentView.addSubview(imageView)
        self.contentView.addSubview(selectView)
    }
    
    func setCellType()  {
//        shutDownImageView.image = UIImage(named:"icon_shutDown")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
