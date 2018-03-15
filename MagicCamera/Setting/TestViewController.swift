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
        let image = UIImage.init(named: "2.jpg")!
        
        let rotateWidth : CGFloat = 100
        let rotateHeight = rotateWidth / image.size.width * image.size.height
        let frame = CGRect.init(x: (self.view.width - rotateWidth) / 2,
                                y: (self.view.height - rotateHeight) / 2,
                                width: rotateWidth,
                                height: rotateHeight)
        let rotateView = RotateScaleView.init(frame: frame)
        rotateView.contentView.image = image
//        rotateView.backgroundColor = UIColor.green
        self.view.addSubview(rotateView)
    }
}
