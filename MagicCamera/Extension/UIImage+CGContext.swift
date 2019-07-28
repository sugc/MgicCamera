//
//  UIImage+CGContext.swift
//  Purika
//
//  Created by zj－db0548 on 2017/2/1.
//  Copyright © 2017年 魔方. All rights reserved.
//

import Foundation


extension UIImage {


//获取添加文字后的图片
    
    
    func getNewImage(string: NSString, attribute: Dictionary<NSAttributedString.Key, Any>, rect : CGRect ) -> UIImage{
    
        
        UIGraphicsBeginImageContext(self.size)
        
        let context = UIGraphicsGetCurrentContext()
        
        context!.translateBy(x: 0.0, y: self.size.height)
        context!.scaleBy(x: 1.0, y: -1.0)
        
        
        context?.draw(self.cgImage!, in: CGRect(x: 0,
                                               y: 0,
                                               width: self.size.width,
                                               height: self.size.height))
        
        context!.translateBy(x: 0.0, y: self.size.height)
        context!.scaleBy(x: 1.0, y: -1.0)
//        string.draw(in: rect,
//                    withAttributes: attribute)
        string.draw(at: rect.origin, withAttributes: attribute)
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        return image
    }
    
    
    static func getImage(size:CGSize, color:UIColor) ->UIImage{
        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()
        
        context?.setFillColor(color.cgColor)
        context?.fill(CGRect(x: 0,
                             y: 0,
                             width: size.width,
                             height: size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    

}
