//
//  RotateScaleView.swift
//  MagicCamera
//
//  Created by SuGuocai on 2018/3/7.
//  Copyright © 2018年 sugc. All rights reserved.
//

import Foundation

class RotateScaleView : UIView {
    
    private var contentView : UIImageView!
    private var rotateBtn : UIButton!
    private var angle : CGFloat!
    private var isRotate : Bool!
    
//    private var panGesture: UIPanGestureRecognizer!
//    private var pinchGesture : UIPinchGestureRecognizer!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    //UI布局
    func layout()  {
        self.backgroundColor = UIColor.clear
        
        let contentFrame = CGRect.init(x: 10,
                                       y: 10,
                                       width: self.width - 20,
                                       height: self.height - 20)
        contentView = UIImageView.init(frame: contentFrame)
        self.addSubview(contentView)
        
        let frame = CGRect.init(x: self.width - 20,
                                y: 0,
                                width: 20,
                                height: 20)
        let rotateBtn = UIButton.init(frame: frame)
        self.addSubview(rotateBtn)
    }
    
    func addGesture() {
        let panGesture = UIPanGestureRecognizer(target: self,
                                            action: #selector(pan(gesture:)))
        self.addGestureRecognizer(panGesture)
        
//        let pinchGesture = UIPinchGestureRecognizer.init(target: self, action: #selector(scale(gesture:)))
//        self.addGestureRecognizer(pinchGesture)
    }
    
    func pan(gesture:UIPanGestureRecognizer) {
        if gesture.state == UIGestureRecognizerState.began {
            //判断落点
           let point = gesture.location(in: rotateBtn)
            
        }
        
    }
    
    
    func scale(gesture:UIPinchGestureRecognizer) {
        
    }
}
