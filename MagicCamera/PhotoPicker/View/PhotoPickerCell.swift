//
//  PhotoPickerCell.swift
//  Purika
//
//  Created by zj－db0548 on 2017/1/6.
//  Copyright © 2017年 魔方. All rights reserved.
//

import Foundation


class PhotoPickerCell: UICollectionViewCell {
    
    private var imageView : UIImageView!
    private var shutDownImageView : UIImageView!
    private var selectView : UIImageView!
    
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
        shutDownImageView = UIImageView(frame: CGRect(x: frame.width - 15,
                                                          y: -5,
                                                          width: 20,
                                                          height: 20))
        
        imageView = UIImageView(frame: self.bounds)
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        self.contentView.addSubview(imageView)
        self.contentView.addSubview(shutDownImageView)
    }
    
    func setCellType()  {
        shutDownImageView.image = UIImage(named:"icon_shutDown")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
