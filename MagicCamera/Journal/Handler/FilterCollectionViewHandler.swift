//
//  FilterCollectionViewHandler.swift
//  Purika
//
//  Created by sugc on 2017/4/23.
//  Copyright © 2017年 魔方. All rights reserved.
//

import Foundation


@objc protocol filterSelectDelegate: NSObjectProtocol {
    func selectFilterWithLookupImage(image:UIImage?, index:Int)
}

class FilterCollectionViewHandler : NSObject, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var selectIndex : Int! = -1
    var data : Array<Dictionary<String,String>>!
    weak var delegate : filterSelectDelegate!
    override init() {
        super.init()
        let filePath = Bundle.main.path(forResource: "filter", ofType: "plist")
        let array = NSArray(contentsOfFile: filePath!)
        data = Array(array!) as! Array<Dictionary<String,String>>
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "filterCell", for: indexPath) as! FilterViewCell
        
        if indexPath.row == selectIndex {
            cell.isSelected = true
        }else {
            cell.isSelected = false
        }
       
        let dic = data[indexPath.row]
        cell.image =  UIImage(named: dic["sampleImageName"]!)
        
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let dic = data[indexPath.row]
        let lookupImage = UIImage(named: dic["lookupImage"]!)
        
        if selectIndex == indexPath.row {
            return
        }
        
        if selectIndex >= 0 && selectIndex < data.count{
            let path = IndexPath(row: selectIndex, section: 0)
            let lastCell = collectionView.cellForItem(at: path)
            lastCell?.isSelected = false
        }
        
        let currentCell = collectionView.cellForItem(at: indexPath)
        currentCell?.isSelected = true
        
        if delegate.responds(to: #selector(filterSelectDelegate.selectFilterWithLookupImage(image:index:))) {
            delegate.selectFilterWithLookupImage(image: lookupImage, index: indexPath.row)
        }
        
    }
    
}
