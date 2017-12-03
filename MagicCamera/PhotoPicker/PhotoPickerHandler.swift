//
//  PhotoPickerHandler.swift
//  Purika
//
//  Created by zj－db0548 on 2017/1/6.
//  Copyright © 2017年 魔方. All rights reserved.
//

import Foundation
import Photos


@objc protocol photoPickerProtocol: NSObjectProtocol {
    @objc optional  func addImage(image:UIImage)
    @objc optional  func addImageAnotation(starRect:CGRect)
    @objc optional func removeImage(image:UIImage)
    
    
}

class PhotoPickerHandler: NSObject, UICollectionViewDelegate, UICollectionViewDataSource {
    
    weak var delegate : photoPickerProtocol!
    var data : PHFetchResult<PHAsset>?
    var imageManager = PHImageManager.default()
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (data?.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! PhotoPickerCell
        imageManager.requestImage(for: data![indexPath.row],
                                  targetSize: cell.bounds.size,
                                  contentMode: PHImageContentMode.aspectFill,
                                  options: nil,
                                  resultHandler: {(image, dic)in
                     cell.image = image
        })
       
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if (delegate != nil) {
            let option = PHImageRequestOptions.init();
            option.deliveryMode = PHImageRequestOptionsDeliveryMode.highQualityFormat
            imageManager.requestImage(for: data![indexPath.row],
                                      targetSize: PHImageManagerMaximumSize,
                                      contentMode: PHImageContentMode.aspectFill,
                                      options: option,
                                      resultHandler: {(image, dic)in
                                        
                                        if self.delegate.responds(to: #selector(photoPickerProtocol.addImage(image:))) {
                                            self.delegate.addImage!(image: image!)

                                        }
                                        
                                        if self.delegate.responds(to: #selector(photoPickerProtocol.addImageAnotation(starRect:))){
                                            let cell = collectionView.cellForItem(at: indexPath)
                                            let rect = CGRect(x: (cell?.left)! - collectionView.contentOffset.x ,
                                                              y: (cell?.top)! - collectionView.contentOffset.y,
                                                              width: (cell?.width)!,
                                                              height: (cell?.height)!)
                                            self.delegate.addImageAnotation!(starRect: rect)
                                        }
            })
        }
    }
    
    deinit {
        print("release photoPickerHandler")
    }
}
