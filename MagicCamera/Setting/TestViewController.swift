//
//  TestVC.swift
//  MagicCamera
//
//  Created by sugc on 2018/3/12.
//  Copyright © 2018年 sugc. All rights reserved.
//

import Foundation

class TestViewController : UIViewController {
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        let frame = CGRect.init(x: 100,
                                y: 100, width: 100,
                                height: 100)
        let rotateView = RotateScaleView.init(frame: frame)
        rotateView.backgroundColor = UIColor.green
        self.view.addSubview(rotateView)
    }
}
