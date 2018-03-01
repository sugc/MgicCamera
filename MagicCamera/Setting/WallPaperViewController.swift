//
//  WallPaperViewController.swift
//  MagicCamera
//
//  Created by SuGuocai on 2017/12/21.
//  Copyright © 2017年 sugc. All rights reserved.
//

import Foundation

class WallPaperViewController: UIViewController{
    //
    @IBOutlet var scrollView : UIScrollView!
    @IBOutlet var collectionView : UICollectionView!
    @IBOutlet var flowLayout : UICollectionViewFlowLayout!
    @IBOutlet var switcher : UISwitch!
    
    var manager : WallPapperManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        switcher.isOn = checkIsNeedShowWallPaper()
        layout()
    }
    
    func layout() {
        //
        //计算
        let containerHeight = ScreenHeight - iPhoneXSafeDistance - 35 - 10 - 50 - 60 - 100
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
    
    
    @IBAction func switchValueChange(_ sender: UISwitch) {
        setIsNeedShowWallPaper(isNeedShow: sender.isOn)
    }
    
    @IBAction func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
}
