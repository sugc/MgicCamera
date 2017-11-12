//
//  UIImage+CGRect.swift
//  MagicCamera
//
//  Created by sugc on 2017/10/23.
//  Copyright © 2017年 sugc. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    
    func imageInRect(rect:CGRect) -> UIImage {
        
        let cgImg = self.cgImage?.cropping(to: rect)
        return UIImage.init(cgImage: cgImg!)
    }
    
    
    func imageWithRatio(ratio:CGFloat) -> UIImage {
        var imgW = self.size.width
        var imgH = self.size.height
        
        let curretRatio = imgW / imgH
        var drawRect : CGRect!
        
        if ratio > curretRatio{
            imgH = imgW / ratio
            
        }
        
        if ratio < curretRatio {
            imgW = imgH * ratio
        }
        drawRect = CGRect.init(x: (self.size.width - imgW) / 2,
                               y: (self.size.height - imgH) / 2,
                               width: imgW,
                               height: imgH)
        return self.imageInRect(rect: drawRect)
    }
    
}

