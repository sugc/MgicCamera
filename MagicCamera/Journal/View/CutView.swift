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
            
            var x : CGFloat = imageView.frame.origin.x
            var y : CGFloat = imageView.frame.origin.y
            
            if imageView.width == self.width {
                x = 0
                if imageView.frame.origin.y < (self.height - imageView.height) {
                    y = self.height - imageView.height
                }
                
                if imageView.frame.origin.y > 0 {
                    y = 0
                }
                
            }else{
                y = 0
                if imageView.frame.origin.x < (self.width - imageView.width) {
                    x = self.width - imageView.width
                }
                
                if imageView.frame.origin.x > 0 {
                    x = 0
                }
            
            }
            
            UIView.animate(withDuration: 0.3,
                           animations: {
                    self.imageView.frame = CGRect(x: x,
                                             y: y,
                                             width: self.imageView.width,
                                             height: self.imageView.height)
            })
        
        }
        
    }
    
    func scale(gesture:UIPinchGestureRecognizer) {
        //
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




