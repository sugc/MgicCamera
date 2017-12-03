//
//  UIView+Utils.swift
//  BeautyPlus
//
//  Created by zj－db0548 on 2016/12/15.
//  Copyright © 2016年 美图网. All rights reserved.
//

import Foundation


extension UIView {

    var left : CGFloat {
    
        get{
            return self.frame.origin.x
        }
        
        set(newVal){
            self.frame = CGRect(x: newVal,
                                y: self.frame.origin.y,
                                width: self.frame.width,
                                height: self.frame.height)
        }
    }
    
    
    var right : CGFloat {
        
        get{
            return self.frame.origin.x + self.frame.width
        }
        
        set(newVal){
            self.frame = CGRect(x: newVal - self.frame.width,
                                y: self.frame.origin.y,
                                width: self.frame.width,
                                height: self.frame.height)
        }
    }

    
    var top : CGFloat {
        
        get{
            return self.frame.origin.y
        }
        
        set(newVal){
            self.frame = CGRect(x: self.frame.origin.x,
                                y: newVal,
                                width: self.frame.width,
                                height: self.frame.height)
        }
    }
    

    var bottom : CGFloat {
        
        get{
            return self.frame.origin.y + self.frame.height
        }
        
        set(newVal){
            self.frame = CGRect(x: self.frame.origin.x,
                                y: newVal - self.frame.height,
                                width: self.frame.width,
                                height: self.frame.height)
        }
    }

    var width : CGFloat {
        
        get{
            return self.frame.width
        }
        
        set(newVal){
            self.frame = CGRect(x: self.frame.origin.x,
                                y: self.frame.origin.y,
                                width: width,
                                height: self.frame.height)
        }
    }

    var height : CGFloat {
        
        get{
            return self.frame.height
        }
        
        set(newVal){
            self.frame = CGRect(x: self.frame.origin.x,
                                y: self.frame.origin.y,
                                width: self.frame.width,
                                height: newVal)
        }
    }
    
    
    func isPositionInView(position:CGPoint) -> Bool {
        
        if self.left <= position.x
        && self.right >= position.x
        && self.top <= position.y
        && self.bottom >= position.y{
            return true
        }
        
        return false
    }
    
    func renderImage(finalSize:CGSize) -> UIImage? {
        let size = self.layer.frame.size
        UIGraphicsBeginImageContext(finalSize)
        let contexts = UIGraphicsGetCurrentContext()!
        contexts.scaleBy(x: finalSize.width / size.width, y: finalSize.height / size.height)
        self.layer.render(in: contexts)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        return image;
    }
}






















