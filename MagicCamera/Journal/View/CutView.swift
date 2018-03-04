//
//  CutView.swift
//  Purika
//
//  Created by zj－db0548 on 2017/2/3.
//  Copyright © 2017年 魔方. All rights reserved.
//

import Foundation

class CutView: UIView , UIGestureRecognizerDelegate{
    
    private var panGesture: UIPanGestureRecognizer!
    private var pinchGesture : UIPinchGestureRecognizer!
    private var lastPoint : CGPoint!
    private var contentScale : CGFloat = 1.0
    private var imageViewSize : CGSize = CGSize.zero
    private var imageViewOrigin : CGPoint! = CGPoint.zero
    private var centerPoint : CGPoint! = CGPoint.zero
    
    var imageView : UIImageView!
    var image : UIImage! {
        didSet {
            setImageView()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.masksToBounds = true
        addGesture()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addGesture()  {
        panGesture = UIPanGestureRecognizer(target: self,
                                            action: #selector(pan(gesture:)))
        panGesture.delegate = self
        self.addGestureRecognizer(panGesture)
        
        pinchGesture = UIPinchGestureRecognizer.init(target: self, action: #selector(scale(gesture:)))
        pinchGesture.delegate = self
        self.addGestureRecognizer(pinchGesture)
    }
   
    
    func setImageView() {
        
        if imageView != nil && imageView.image != nil {
            let ratio = (imageView.image?.size.width)! / (imageView.image?.size.height)!
            let currentR = image.size.width / image.size.height
            
            if ratio == currentR {
                imageView.image = image
                return
            }
        }
        
        let rad = self.frame.size.height / self.frame.size.width
        let imageR = image.size.height / image.size.width
        
        var imageW : CGFloat = 0.0
        var imageH : CGFloat = 0.0
        
        if imageR > rad {
            imageW = self.frame.width
            imageH = self.frame.width * imageR
        }else {
            imageH = self.frame.height
            imageW = imageH / imageR
        }

        let imageViewFrame = CGRect(x: (self.width - imageW) / 2.0,
                                    y: (self.height - imageH) / 2.0,
                                    width: imageW,
                                    height: imageH)
        imageViewSize = imageViewFrame.size
        
        if imageView == nil {
            imageView = UIImageView(frame: imageViewFrame)
            imageView.contentMode = UIViewContentMode.scaleAspectFill
        }else {
            imageView.frame = imageViewFrame
        }
        
        imageView.image = image
        self.addSubview(imageView)
    }
    
    func pan(gesture:UIPanGestureRecognizer) {
        
        let p = gesture.location(in:self)
        
        if gesture.state == UIGestureRecognizerState.began {
            lastPoint = p
            return
        }
        
        imageView.frame = CGRect(x:imageView.frame.origin.x + (p.x - lastPoint.x) * 0.6,
                                 y:imageView.frame.origin.y + (p.y - lastPoint.y) * 0.6,
                                 width: imageView.width,
                                 height: imageView.height)
        lastPoint = p
        
        if gesture.state == UIGestureRecognizerState.ended {
            self.finallyAjust(duration: 0.3)
        }
    }
    
    func scale(gesture:UIPinchGestureRecognizer) {
        
        if gesture.state == UIGestureRecognizerState.began {
            centerPoint = gesture.location(in: imageView)
            imageViewOrigin = imageView.frame.origin
        }
        
        var currentScale = gesture.scale * contentScale

        if currentScale < 0.5 {
            currentScale = 0.5
        }
        
        if currentScale > 6 {
            currentScale = 6
        }
        
        self.ajust(scale: currentScale, centerPoint: centerPoint)
        if gesture.state == UIGestureRecognizerState.ended {
            contentScale = currentScale
            if contentScale < 1 {
                contentScale = 1
                UIView.animate(withDuration: 0.3, animations: {
                    self.ajust(scale: self.contentScale, centerPoint: self.centerPoint)
                    self.finallyAjust(duration: 0)
                })
            }else {
                self.finallyAjust(duration: 0.3)
            }
        }
    }
    
    //缩放调整
    func ajust(scale:CGFloat, centerPoint : CGPoint) {
        imageView.contentScaleFactor = scale
        let offSetX = centerPoint.x * (1 - scale / contentScale)
        let offSetY = centerPoint.y * (1 - scale / contentScale)
        
        let x = imageViewOrigin.x + offSetX
        let y = imageViewOrigin.y +  offSetY
        
        imageView.frame = CGRect.init(x: x,
                                      y: y,
                                      width: imageViewSize.width * scale,
                                      height: imageViewSize.height * scale)
    }
    
    func finallyAjust(duration:CGFloat)  {
        var x : CGFloat = imageView.frame.origin.x
        var y : CGFloat = imageView.frame.origin.y
        let width : CGFloat = imageView.frame.size.width
        let height : CGFloat = imageView.frame.size.height
        
        if x > 0 {
            x = 0
        }
        
        if y > 0 {
            y = 0
        }
        
        
        if imageView.right < self.width {
            x = self.width - width
        }
        
        if imageView.bottom < self.height {
            y = self.height - height
        }
        
        if duration == 0 {
            self.imageView.frame = CGRect(x: x,
                                          y: y,
                                          width: width,
                                          height: height)
        }else {
            UIView.animate(withDuration: 0.3,
                           animations: {
                            self.imageView.frame = CGRect(x: x,
                                                          y: y,
                                                          width: width,
                                                          height: height)
            })
        }
    }
    
    
    
    func getTextCoords() -> Array <GLfloat> {
        let imageFrame = imageView.frame
        
        let Ileft = (0 - imageFrame.origin.x) / imageFrame.width
        let Iright =  Ileft + frame.width / imageFrame.width
        let Ibottom =  (0 - imageFrame.origin.y) / imageFrame.height
        let Itop = Ibottom + frame.height / imageFrame.height
        
        
        let texCoords : Array <GLfloat> = [
            Float(Ileft.native), Float(Ibottom.native),
            Float(Iright.native), Float(Ibottom.native),
            Float(Ileft.native), Float(Itop.native),
            Float(Iright.native), Float(Itop.native)
        ]
        return texCoords
    }
}




