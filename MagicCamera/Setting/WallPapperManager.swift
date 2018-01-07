//
//  WallPapperManager.swift
//  MagicCamera
//
//  Created by SuGuocai on 2017/12/26.
//  Copyright © 2017年 sugc. All rights reserved.
//

import Foundation

class WallPapperManager: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, WallPapperCellProtocol {
   
    weak var collectionView : UICollectionView?
    var imageArray : Array<UIImage>! = []
    
    override init() {
        super.init()
        
        imageArray = [UIImage.init(named: "M1.JPG")!,
                      UIImage.init(named: "M2.JPG")!,
                      UIImage.init(named: "M3.JPG")!,
                      UIImage.init(named: "M4.JPG")!,
                      UIImage.init(named: "M5.JPG")!,
                      UIImage.init(named: "icon_close_normal")!,]
        //设置图片
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return  imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WallPapperCell", for: indexPath) as! WallPapperCell
        cell.backgroundColor = UIColor.red
        cell.delegate = self
        cell.image = imageArray[indexPath.row]
        cell.index = indexPath.row
        if indexPath.row == (imageArray.count - 1) {
            cell.deleteBtn.isHidden = true
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //最后一个可以添加图片
        
        if indexPath.row == (imageArray.count - 1) {
            
        }
    }
    
    func deleteImageAtIndex(index: NSInteger) {
        //删除图片
        
        //删除数据源
        imageArray.remove(at: index)
        let indexPath = IndexPath.init(row: index, section: 0)
        
        collectionView?.performBatchUpdates({
            self.collectionView?.deleteItems(at: [indexPath])
        }, completion: { (isComplete) in
            self.collectionView?.reloadData()
        })
        
        //删除cell
    }
}


