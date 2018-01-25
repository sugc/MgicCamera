//
//  HomeCollectionViewManager.swift
//  MagicCamera
//
//  Created by SuGuocai on 2018/1/14.
//  Copyright © 2018年 sugc. All rights reserved.
//

import Foundation

class HomeCollectionViewManager :
    NSObject,
    UICollectionViewDataSource,
    WaterFlowLayoutDelegate
{
   
    weak var weakCollectionView : UICollectionView!
    var waterLayout : WaterFlowLayout!
    
    
    
    init(collectionView:UICollectionView) {
        super.init()
        collectionView.dataSource = self
        weakCollectionView = collectionView
        waterLayout = WaterFlowLayout()
        waterLayout.scrollDirection = UICollectionViewScrollDirection.horizontal
        waterLayout.numOfRow = 2
        waterLayout.delegate = self
        weakCollectionView.collectionViewLayout = waterLayout
    }
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath) as! HomeCollectionViewCell
        
        let param = self.param()[indexPath.row]
        cell.cellLabel.text = param["title"] as? String
        cell.cellImageView.image = UIImage.init(named: param["imageName"] as! String)
        cell.backgroundColor = param["color"] as? UIColor
        return cell
    }
    
    func param() -> Array<Dictionary<String,Any>> {
        let param = [
            ["color":UIColor.color(hex: 0x68D4DC, alpha: 1),
             "title":"美化图片",
             "imageName":"icon_home_filter"],
            ["color":UIColor.color(hex: 0x4677FE, alpha: 1),
             "title":"拼图",
             "imageName":"icon_home_pintu"]
        ]
        return param
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func size(in indexPath: IndexPath) -> CGSize {
        let width = (ScreenWidth - 30) / 2
        let height : CGFloat  = 100.0
        return CGSize.init(width: width, height: height)
    }
}
