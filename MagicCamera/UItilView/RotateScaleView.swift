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
    private var rotateBtn : UIImageView!
    private var deleteBtn : UIButton!
    private var angle : CGFloat! = 0
    private var isRotate : Bool!
    private var ratio : CGFloat!  //对角线和宽的比
    private var originSize : CGSize!
    
//    private var panGesture: UIPanGestureRecognizer!
//    private var pinchGesture : UIPinchGestureRecognizer!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        ratio = pow(pow(frame.size.width, 2) + pow(frame.size.height, 2), 0.5) / frame.size.width
        originSize = frame.size
        layout()
        addGesture()
    }
    
    //UI布局
    func layout()  {
        contentView = UIImageView.init(frame: CGRect.zero)
        self.addSubview(contentView)
        
        rotateBtn = UIImageView.init(frame: CGRect.zero)
        rotateBtn.isUserInteractionEnabled = true
        rotateBtn.backgroundColor = UIColor.yellow
        self.addSubview(rotateBtn)
        
        deleteBtn = UIButton.init(frame: CGRect.zero)
        deleteBtn.backgroundColor = UIColor.red
        deleteBtn.addTarget(self, action: #selector(remove), for: UIControlEvents.touchUpInside)
        self.addSubview(deleteBtn)
        
        ajustUI()
    }
    
    func ajustUI()  {
        let contentFrame = CGRect.init(x: 10,
                                       y: 10,
                                       width: self.width - 20,
                                       height: self.height - 20)
        contentView.frame = contentFrame
        
        let rotateFrame = CGRect.init(x: self.width - 20,
                                      y: 0,
                                      width: 20,
                                      height: 20)
        rotateBtn.frame = rotateFrame
        
        let deleteFrame = CGRect.init(x: 0,
                                      y: 0,
                                      width: 20,
                                      height: 20)
        deleteBtn.frame = deleteFrame
    }
    
    func addGesture() {
        let rotatePanGesture = UIPanGestureRecognizer(target: self,
                                            action: #selector(roteteAndScale(gesture:)))
        rotateBtn.addGestureRecognizer(rotatePanGesture)
        
        let movePanGesture = UIPanGestureRecognizer(target: self,
                                                      action: #selector(move(gesture:)))
        self.addGestureRecognizer(movePanGesture)
    }
    
    //旋转
    func roteteAndScale(gesture:UIPanGestureRecognizer) {
        
        self.transform = CGAffineTransform.init(rotationAngle: 0)
        
        let point = gesture.location(in: self.superview)
        let center = self.center
        let length = pow(pow(point.x - center.x, 2) + pow(point.y - center.y, 2), 0.5)
        
        let width = length / ratio
//        let scaleRatio = width / originSize.width
        let height = width * self.height / self.width
        
        self.frame = CGRect.init(x: center.x - 0.5 * width,
                                 y: center.y - 0.5 * height,
                                 width: width,
                                 height: height)
        
        ajustUI()
        
        //旋转角度 计算和（1,0）向量夹角
        let b = length
        let add = point.x - center.x
        let currentAngle = acos(add / b)
        
        //判断在对角线的上方还是下方
        
        angle = currentAngle
        self.transform = CGAffineTransform.init(rotationAngle: angle)
    
    }
    
    //移动
    func move(gesture:UIPanGestureRecognizer) {
//        if gesture.state == UIGestureRecognizerState.began {
//            //判断落点
//            let point = gesture.location(in: self)
//            if rotateBtn.frame.contains(point) {
//                isRotate = true
//            }
//        }
//
//        let movePoint = gesture.location(in: self.superview)
//        if isRotate {
//            //开始计算选择角度
//
//        }else {
//            //计算位移
//        }
        
    }
    
    func remove() {
//        self.removeFromSuperview()
    }
}
