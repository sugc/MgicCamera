//
//  BeautyBottomViewManager.swift
//  MagicCamera
//
//  Created by sugc on 2018/3/18.
//  Copyright © 2018年 sugc. All rights reserved.
//

import Foundation

class BeautyBottomViewManager : NSObject, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var data : Array<Dictionary<String, Any>> = [["title":"滤镜",
                                                  "action":0],
                                                 ["title":"美化",
                                                  "action":1]]
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BeautyBaseCell", for: indexPath) as! BeautyBaseCell
        cell.label.text = data[indexPath.row]["title"] as? String
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //选中某个cell, 代理回调——>或者消息
        let dic = data[indexPath.row]
        let actionType = dic["action"] as! NSInteger
        
    }
    
    
}
