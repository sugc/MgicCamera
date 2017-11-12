//
//  UIImage+Save.swift
//  Purika
//
//  Created by zj－db0548 on 2017/2/26.
//  Copyright © 2017年 魔方. All rights reserved.
//

import Foundation

import Photos
import AssetsLibrary

extension UIImage {


    func save(completion:@escaping (_ url : URL?, _ error:Error?)->Void)  {
        
        let lib = ALAssetsLibrary()
        
        lib.writeImage(toSavedPhotosAlbum: self.cgImage, metadata: nil) { (url, error) in
            completion(url, error)
        }
        
    }

    
}
