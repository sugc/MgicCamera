//
//  WaterFlowLayout.swift
//  Purika
//
//  Created by zj－db0548 on 2017/2/9.
//  Copyright © 2017年 魔方. All rights reserved.
//

import Foundation


protocol WaterFlowLayoutDelegate : NSObjectProtocol{
    func size(in indexPath:IndexPath) -> CGSize
}

class WaterFlowLayout: UICollectionViewLayout {
    
    var scrollDirection  = UICollectionView.ScrollDirection.vertical
    var offSetC : CGFloat = 5.0
    var offSetR : CGFloat = 5.0
    
    var contentInsects : UIEdgeInsets = UIEdgeInsets.init(top: 0,
                                                          left: 10,
                                                          bottom: 0,
                                                          right: 10)
    
    var bottomArray : Array<CGFloat> = [0,0,0]  //存储最每一列的高度
    var numOfRow : Int = 3
    
    weak var delegate : WaterFlowLayoutDelegate!

   
    let width : CGFloat = (UIScreen.main.bounds.size.width - 10) / 3.0
    
    private var attrArray : Array<UICollectionViewLayoutAttributes> = []
    
    override func prepare() {
        super.prepare()
        if scrollDirection == UICollectionView.ScrollDirection.vertical {
            self.calculateVertical()
        }else {
            self.calculateHorizontal()
        }
    }

    func calculateHorizontal() {
        let count = self.collectionView?.numberOfItems(inSection: 0)
        if count! <= 0 {
            return
        }
        
        offSetC = 10;
        
        for i in 0...count! - 1 {
            let indexPath = IndexPath(item: i, section: 0)
            let attr = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            let size = delegate.size(in: indexPath);
            
            var num : CGFloat = 0.0;
            var countN = 0;
            num = bottomArray[0]
            for i in 0...(numOfRow - 1) {
                if num > bottomArray[i] {
                    countN = i;
                    num = bottomArray[i];
                }
            }
            
            attr.frame = CGRect(x: contentInsects.left + (offSetC + size.width) * CGFloat(countN),
                                y: bottomArray[countN],
                                width: size.width,
                                height: size.height);
            bottomArray[countN] = num + size.height + offSetR
            attrArray.append(attr)
        }
        
    }
    
    func calculateVertical() {
        let count = self.collectionView?.numberOfItems(inSection: 0)
        if count! <= 0 {
            return
        }
        
        
        for i in 0...count! - 1 {
            let indexPath = IndexPath(item: i, section: 0)
            let attr = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            let size = delegate.size(in: indexPath);
            
            var num : CGFloat = 0.0;
            var countN = 0;
            num = bottomArray[0]
            for i in 0...(numOfRow - 1) {
                
                if num > bottomArray[i] {
                    countN = i;
                    num = bottomArray[i];
                }
                
            }
            
            attr.frame = CGRect(x: (offSetC + size.width) * CGFloat(countN),
                                y: bottomArray[countN],
                                width: size.width,
                                height: size.height);
            bottomArray[countN] = num + size.height + offSetR
            attrArray.append(attr)
        }
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return attrArray[indexPath.row]
        
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attrArray
    }
    
    override var collectionViewContentSize: CGSize {
        let frame = attrArray.last?.frame
        
        if (frame != nil) {
            return CGSize(width: (self.collectionView?.width)!, height: (frame?.origin.y)! + (frame?.height)!)
        }
        
        return CGSize.zero
    }
}




