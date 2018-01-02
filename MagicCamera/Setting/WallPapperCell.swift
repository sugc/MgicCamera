//
//  WallPapperCell.swift
//  MagicCamera
//
//  Created by SuGuocai on 2017/12/26.
//  Copyright © 2017年 sugc. All rights reserved.
//

import Foundation

class WallPapperCell: UICollectionViewCell {
    
    private var deleteBtn : UIButton!
    private var imageView : UIImageView!
    var isDeleteBtnHidden : Bool = false {
        didSet {
            deleteBtn.isHidden = isDeleteBtnHidden
        }
    }
    
    var image : UIImage? {
        didSet {
            imageView.image = image
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func layout() {
        imageView = UIImageView.init(frame: self.bounds)
        deleteBtn = UIButton.init(frame: CGRect.zero)
        deleteBtn.addTarget(self, action: #selector(deleteImage), for: UIControlEvents.touchUpInside)
        
    }
    
    func deleteImage() {
        //调用代理方法，删除数据源
    }
    
    func ajustWithSize(size : CGSize) {
        imageView.frame = CGRect.init(x: 10,
                                      y: 10,
                                      width: size.width - 20,
                                      height: size.height - 20)
        let deleteBtnWidth : CGFloat = 15.0
        deleteBtn.frame = CGRect.init(x: imageView.right - deleteBtnWidth / 2.0,
                                      y: imageView.top - deleteBtnWidth / 2.0,
                                      width: deleteBtnWidth,
                                      height: deleteBtnWidth);
    }
}
