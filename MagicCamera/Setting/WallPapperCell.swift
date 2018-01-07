//
//  WallPapperCell.swift
//  MagicCamera
//
//  Created by SuGuocai on 2017/12/26.
//  Copyright © 2017年 sugc. All rights reserved.
//

import Foundation

protocol WallPapperCellProtocol : NSObjectProtocol {
    func deleteImageAtIndex(index : NSInteger);
}

class WallPapperCell: UICollectionViewCell {
    
    @IBOutlet var deleteBtn : UIButton!
    @IBOutlet var imageView : UIImageView!
    
    weak var delegate : WallPapperCellProtocol!
    var index : NSInteger = 0
    
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
    
    
    @IBAction func deleteImage() {
        //调用代理方法，删除数据源
        delegate.deleteImageAtIndex(index: index) 
    }
}
