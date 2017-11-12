//
//  UIImage+UItil.swift
//  MagicCamera
//
//  Created by sugc on 2017/10/16.
//  Copyright © 2017年 sugc. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    
    
    func fixWithDeviceOrientation (orientation:UIDeviceOrientation, isFront:Bool) -> UIImage {
        
        if orientation == UIDeviceOrientation.unknown ||
            orientation == UIDeviceOrientation.faceUp ||
            orientation == UIDeviceOrientation.faceDown{
            return self
        }
        
        let size = self.size
        var transform = CGAffineTransform.identity
        
        if isFront {
            if orientation == UIDeviceOrientation.landscapeRight ||
                orientation == UIDeviceOrientation.landscapeLeft{
                transform = transform.scaledBy(x: size.height, y: 0)
            }else {
                transform = transform.translatedBy(x: size.width, y: 0.0)
            }
            transform = transform.scaledBy(x: -1, y: 1)
        }
        
        switch orientation {
        case .landscapeLeft:
            transform = transform.translatedBy(x: size.height, y: 0)
            transform = transform.rotated(by: CGFloat(Double.pi / 2))
            break
        case .landscapeRight:
            transform = transform.translatedBy(x: 0, y: size.width)
            transform = transform.rotated(by: CGFloat(-Double.pi / 2))
            break
        case .portraitUpsideDown:
            transform = transform.translatedBy(x: size.width, y: size.height)
            transform = transform.rotated(by: CGFloat(Double.pi))
            break
        default:
            break
        }
        
        switch self.imageOrientation {
        case .down:
            break
        case .downMirrored:
            break
        case .left:
            transform = transform.translatedBy(x: 0, y: size.height)
            transform = transform.rotated(by: CGFloat(-Double.pi / 2))
            break
        case .leftMirrored:
            transform = transform.translatedBy(x: 0, y: size.height)
            transform = transform.rotated(by: CGFloat(-Double.pi / 2))
            break
        case .right:
            transform = transform.translatedBy(x: 0, y: size.height)
            transform = transform.rotated(by: CGFloat(-Double.pi / 2))
            break
        case .rightMirrored:
            transform = transform.translatedBy(x: 0, y: size.height)
            transform = transform.rotated(by: CGFloat(-Double.pi / 2))
            break
        default:
            break
        }
            
        if isFront {
            let imgOrient = self.imageOrientation
            if imgOrient == .rightMirrored ||
                imgOrient == .right ||
                imgOrient == .leftMirrored ||
                imgOrient == .left {
                transform = transform.translatedBy(x: 0, y: size.width)
                transform = transform.scaledBy(x: 1, y: -1)
            }
        }
        
        var width = size.width
        var height = size.height
        
        if orientation == .landscapeLeft ||
            orientation == .landscapeRight {
            width = size.height
            height = size.width
        }
       
        
        var bounds = CGRect.init(x: 0, y: 0, width: width, height: height)
        
        let context = CGContext.init(data: nil,
                                     width: Int(width),
                                     height: Int(height),
                                     bitsPerComponent: (self.cgImage?.bitsPerComponent)!,
                                     bytesPerRow: 0,
                                     space: (self.cgImage?.colorSpace)!,
                                     bitmapInfo: (self.cgImage?.bitmapInfo)!.rawValue)
        
//        UIGraphicsBeginImageContext(bounds.size);
//        let context = UIGraphicsGetCurrentContext()
        
        context?.setFillColor(UIColor.white.cgColor)
        context?.fill(bounds)
        context?.concatenate(transform)
        context?.interpolationQuality = CGInterpolationQuality.low
        
        if self.imageOrientation == .left ||
            self.imageOrientation == .leftMirrored ||
            self.imageOrientation == .right ||
            self.imageOrientation == .rightMirrored {
            bounds = CGRect.init(x: 0,
                                 y: 0,
                                 width: height,
                                 height: width)
        }
        

        context?.draw(self.cgImage!, in: bounds)
        let imageCopy = context?.makeImage()
        let returnImage = UIImage.init(cgImage: imageCopy!)
        
        return returnImage
    }
    
    
    func fixOrientation(orientation:UIImageOrientation, isFront:Bool)-> UIImage {
        
        let imageRef = self.cgImage
        let width = imageRef!.width
        let height = imageRef!.height
        var transform = CGAffineTransform.identity
        var bounds = CGRect.init(x: 0,
                               y: 0,
                               width: width,
                               height: height)
        
        switch orientation {
        case UIImageOrientation.up:
            transform = CGAffineTransform.identity
            break
        case UIImageOrientation.upMirrored:
            transform = CGAffineTransform.init(translationX: CGFloat(width), y: 0.0)
            transform = transform.scaledBy(x: -1.0, y: 1.0)
            break
        case UIImageOrientation.down:
            transform = CGAffineTransform.init(translationX: CGFloat(width), y: CGFloat(height))
            transform = transform.rotated(by: CGFloat(Double.pi))
            break
        case UIImageOrientation.downMirrored:
            transform = CGAffineTransform.init(translationX: 0.0, y: CGFloat(height))
            transform = transform.scaledBy(x: 1.0, y: -1.0)
            
            break
        case UIImageOrientation.left:
            bounds.size.height = CGFloat(width)
            bounds.size.width = CGFloat(height)
            transform = CGAffineTransform.init(translationX: 0.0, y: CGFloat(width))
            transform = transform.rotated(by: CGFloat(1.5 * Double.pi))
            break
        case UIImageOrientation.leftMirrored:
            bounds.size.height = CGFloat(width)
            bounds.size.width = CGFloat(height)
            transform = CGAffineTransform.init(translationX: CGFloat(height), y: CGFloat(width))
            if isFront {
                transform = transform.scaledBy(x: -1.0, y: 1.0)
            }
            transform = transform.rotated(by: CGFloat(1.5 * Double.pi))
            
            break
        case UIImageOrientation.right:
            bounds.size.height = CGFloat(width)
            bounds.size.width = CGFloat(height)
            transform = CGAffineTransform.init(scaleX: CGFloat(height), y: 0.0)
            transform = transform.rotated(by: CGFloat(0.5 * Double.pi))
            break
        case UIImageOrientation.rightMirrored:
            
            bounds.size.height = CGFloat(width)
            bounds.size.width = CGFloat(height)
            transform = CGAffineTransform.init(scaleX: -1.0, y: 1.0)
            transform = transform.rotated(by: CGFloat(0.5 * Double.pi))
            break
        }
        
        

        UIGraphicsBeginImageContext(bounds.size);
        
        let context = UIGraphicsGetCurrentContext()
        
        
        context?.setFillColor(UIColor.white.cgColor)
        context?.fill(bounds)
        context?.concatenate(transform)
        context?.interpolationQuality = CGInterpolationQuality.low
        context?.draw(imageRef!, in: bounds)
        let imageCopy = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return imageCopy!
        
    }
    
}
