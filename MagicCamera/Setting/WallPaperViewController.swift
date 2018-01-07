//
//  WallPaperViewController.swift
//  MagicCamera
//
//  Created by SuGuocai on 2017/12/21.
//  Copyright © 2017年 sugc. All rights reserved.
//

import Foundation

class WallPaperViewController: UIViewController {
    //
    @IBOutlet var scrollView : UIScrollView!
    @IBOutlet var collectionView : UICollectionView!
    @IBOutlet var flowLayout : UICollectionViewFlowLayout!
    
    var manager : WallPapperManager!
    
    var imageArray : Array<Any>!
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
    }
    
    func layout() {
        //
        //计算
        let containerHeight = ScreenHeight - iPhoneXSafeDistance - 35 - 10 - 50 - 60
        let cellHeight = containerHeight - 40
        let ratio = ScreenHeight / ScreenWidth
        let imageheight = cellHeight - 35
        let imageWidth = imageheight / ratio
        let cellWidth = imageWidth + 35
        
        manager = WallPapperManager.init()
        flowLayout.itemSize = CGSize.init(width: cellWidth,
                                         height: cellHeight)
        collectionView.delegate = manager
        collectionView.dataSource = manager
        manager.collectionView = collectionView
    }
    
    //获取设置的图片
    func getData() {
        //
        let fileManager = FileManager.init()
    }
    
}
