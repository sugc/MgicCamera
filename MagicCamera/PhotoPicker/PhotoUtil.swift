//
//  PhotoUtil.swift
//  Purika
//
//  Created by zj－db0548 on 2017/1/6.
//  Copyright © 2017年 魔方. All rights reserved.
//

import Foundation
import AssetsLibrary
import Photos

class PhotoUtil: NSObject {
    
    
    static func getAllPhoto() -> PHFetchResult<PHAsset> {
    
        let option = PHFetchOptions()
        option.includeHiddenAssets = true
        option.sortDescriptors = [NSSortDescriptor(key:"creationDate", ascending: true)]
        let result = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: option)
        return result
    }
    
}
