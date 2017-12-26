//
//  WallPapperManager.swift
//  MagicCamera
//
//  Created by SuGuocai on 2017/12/26.
//  Copyright © 2017年 sugc. All rights reserved.
//

import Foundation

class WallPapperManager: NSObject, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var imageArray : Array<UIImage>!
    override init() {
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return  imageArray.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row < imageArray.count {
            //带有图片的cell
        }
        
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //最后一个可以添加图片
        
    }
}


