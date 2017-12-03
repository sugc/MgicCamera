//
//  PhotoPickerHandler.swift
//  Purika
//
//  Created by zj－db0548 on 2017/1/6.
//  Copyright © 2017年 魔方. All rights reserved.
//

import Foundation
import Photos


protocol selectViewDelegate : NSObjectProtocol{
    func updateImageNum(num:NSInteger)
}

class SelectViewHandler: NSObject, UICollectionViewDelegate, UICollectionViewDataSource {

    var data : Array<UIImage>! = []
    var imageManager = PHImageManager()
    weak var delegate : selectViewDelegate!
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "selectCell", for: indexPath) as! PhotoPickerCell
        cell.backgroundColor = UIColor.red
        cell.image = data[indexPath.row]
        cell.setCellType()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //移除当前的图片
        data.remove(at: indexPath.row)
        collectionView.reloadData()
        delegate.updateImageNum(num: data.count)
    }
    
    deinit {
        print("release selectHandler")
    }
}
