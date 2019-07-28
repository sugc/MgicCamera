//
//  BeautyBaseView.swift
//  MagicCamera
//
//  Created by sugc on 2018/3/16.
//  Copyright © 2018年 sugc. All rights reserved.
//

import Foundation

class BeautyBaseViewController: UIViewController {
    
    private var backBtn : UIButton!
    private var saveBtn : UIButton!
    var operationView : UIView!
    var toolView : UIView!
    var bottomView : UICollectionView!
    
    private var bottomManager : BeautyBottomViewManager = BeautyBottomViewManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
    }
    
    func layout() {
        let operationFrame = CGRect.init(x: 0,
                                         y: iPhoneXSafeDistanceTop,
                                         width: ScreenWidth,
                                         height: ScreenWidth / 3 * 4)
        operationView = UIView.init(frame: operationFrame)
        
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = UICollectionView.ScrollDirection.horizontal
        let bottomViewFrame = CGRect.init(x: 0,
                                          y: ScreenHeight - iPhoneXSafeDistanceBottom - 50,
                                          width: ScreenWidth,
                                          height: 50)
        bottomView = UICollectionView.init(frame: bottomViewFrame, collectionViewLayout: layout)
        bottomView.register(BeautyBaseCell.classForCoder(), forCellWithReuseIdentifier: "BeautyBaseCell")
        bottomView.dataSource = bottomManager
        bottomView.delegate = bottomManager
        bottomView.backgroundColor = UIColor.white
        
        
        let toolViewHeight = ScreenHeight - operationView.height - bottomView.height - iPhoneXSafeDistance
        let toolViewFrame = CGRect.init(x: 0,
                                        y: bottomView.top - toolViewHeight,
                                        width: ScreenWidth,
                                        height: toolViewHeight)
        toolView = UIView.init(frame: toolViewFrame)
        
        self.view.addSubview(operationView)
        self.view.addSubview(toolView)
        self.view.addSubview(bottomView)
        self.view.backgroundColor = UIColor.white
    }
    
    
    
}


