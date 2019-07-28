//
//  RotateScaleView.swift
//  MagicCamera
//
//  Created by SuGuocai on 2018/3/7.
//  Copyright © 2018年 sugc. All rights reserved.
//

import Foundation

class RotateScaleView : UIView {
    
    var contentView : UIImageView!
    private var rotateBtn : UIImageView!
    private var deleteBtn : UIButton!
    private var angle : CGFloat! = 0
    private var isRotate : Bool!
    private var ratio : CGFloat!  //对角线和宽的比
    private var originSize : CGSize!
    private var beginPoint : CGPoint!
    private var originPoint : CGPoint!
    private var btnSize : CGFloat! = 25;
    
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
        deleteBtn.addTarget(self, action: #selector(remove), for: UIControl.Event.touchUpInside)
        self.addSubview(deleteBtn)
        
        ajustUI()
    }
    
    func ajustUI()  {
        let contentFrame = CGRect.init(x: btnSize / 2.0,
                                       y: btnSize / 2.0,
                                       width: self.width - btnSize,
                                       height: self.height - btnSize)
        contentView.frame = contentFrame
        
        let rotateFrame = CGRect.init(x: self.width - btnSize,
                                      y: 0,
                                      width: btnSize,
                                      height: btnSize)
        rotateBtn.frame = rotateFrame
        
        let deleteFrame = CGRect.init(x: 0,
                                      y: 0,
                                      width: btnSize,
                                      height: btnSize)
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
    @objc func roteteAndScale(gesture:UIPanGestureRecognizer) {
        
        self.transform = CGAffineTransform.init(rotationAngle: 0)
        
        let point = gesture.location(in: self.superview)
        let center = self.center
        
        let transX = point.x - center.x
        let transY = point.y - center.y
        
        let length = pow(pow(transX, 2) + pow(transY, 2), 0.5) * 2
        
        let width = length / ratio
//        let scaleRatio = width / originSize.width
        let height = width * self.height / self.width
        
        self.frame = CGRect.init(x: center.x - 0.5 * width,
                                 y: center.y - 0.5 * height,
                                 width: width,
                                 height: height)
        
        ajustUI()
        
        //和对角线（width, -height）的夹角
        
        let b = length * 0.5 * length
        let add = transX * width - transY * height
        let result = add / b
        
        var currentAngle = acos(result)
        
        //判断在对角线的上方还是下方
        let supposeY = -(transX * height / width);
        if (supposeY + center.y) > point.y {
            currentAngle = -currentAngle
        }
        
        angle = currentAngle
        self.transform = CGAffineTransform.init(rotationAngle: angle)
        print("current angle is %ld",angle)
    }
    
    //移动
    @objc func move(gesture:UIPanGestureRecognizer) {
        self.transform = CGAffineTransform.init(rotationAngle: 0)
        if gesture.state == UIGestureRecognizer.State.began {
            //判断落点
            beginPoint = gesture.location(in: self.superview)
            originPoint = self.frame.origin;
        }

        let movePoint = gesture.location(in: self.superview)
        let transX = movePoint.x - beginPoint.x
        let transY = movePoint.y - beginPoint.y
        
        self.frame = CGRect.init(x: originPoint.x + transX,
                                 y: originPoint.y + transY,
                                 width: self.width,
                                 height: self.height)
        self.transform = CGAffineTransform.init(rotationAngle: angle)
        
    }
    
    @objc func remove() {
        self.removeFromSuperview()
    }
}
