//
//  WallPapperManager.swift
//  MagicCamera
//
//  Created by SuGuocai on 2017/12/26.
//  Copyright © 2017年 sugc. All rights reserved.
//

import Foundation

class WallPapperManager:
    NSObject,
    UICollectionViewDataSource,
    UICollectionViewDelegate,
    WallPapperCellProtocol,
    CutViewControllerProtocol,
    UIImagePickerControllerDelegate,
    UINavigationControllerDelegate  {
   
    weak var collectionView : UICollectionView?
    var imageArray : Array<UIImage>! = []
    var dbManager : WallPapperDBMananer!
    
    override init() {
        super.init()
        //设置图片
        dbManager = WallPapperDBMananer.init()
        imageArray =  dbManager.getAllImage()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return  imageArray.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WallPapperCell", for: indexPath) as! WallPapperCell
        cell.delegate = self
        cell.index = indexPath.row
        
        if indexPath.row >= (imageArray.count) {
            cell.deleteBtn.isHidden = true
            cell.imageView.isHidden = true
            cell.addView.isHidden = false
        }else {
            cell.addView.isHidden = true
            cell.imageView.isHidden = false
            cell.image = imageArray[indexPath.row]
            cell.deleteBtn.isHidden = false
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //最后一个可以添加图片
        
        if indexPath.row >= (imageArray.count) {
            //添加图片
            actionAddImage()
        }
    }
    
    func deleteImageAtIndex(index: NSInteger) {
        //删除图片
        
        //删除数据源
    
        let isSuccess = dbManager.deleteImageAtIndex(index: index)
        
        if !isSuccess {
            return
        }
    
        imageArray.remove(at: index)
        let indexPath = IndexPath.init(row: index, section: 0)
        
        collectionView?.performBatchUpdates({
            self.collectionView?.deleteItems(at: [indexPath])
        }, completion: { (isComplete) in
            self.collectionView?.reloadData()
        })
        
        //删除cell
    }
    
    //开始显示图片添加页面
    func actionAddImage() {
        //检查权限
        requestPhotoAuthority { (isAuth) in
            if isAuth {
                let imagePick = UIImagePickerController.init()
                imagePick.delegate = self
//                imagePick.allowsEditing = true
                
                let delegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
                let nav = delegate.window!.rootViewController as! UINavigationController
                nav.topViewController?.present(imagePick, animated: true, completion: {
                    
                })
            }
        }
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        print("")
        
//        self.addImage(image: image)
        picker.dismiss(animated: false) {
            let storyboard = UIStoryboard.init(name: "WallPapperCutViewController", bundle: nil)
            let cutVC = storyboard.instantiateViewController(withIdentifier: "WallPapperCutViewController") as! WallPapperCutViewController
            cutVC.image = image
            cutVC.delegate = self
            let delegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
            let nav = delegate.window!.rootViewController as! UINavigationController
            nav.topViewController?.present(cutVC, animated: true, completion: nil)
        }
    }
    
    func selectImage(image: UIImage?) {
        if image != nil {
            let isSuccess = self.dbManager.inserImage(image: image!)
            if  isSuccess {
                self.imageArray.append(image!)
                self.collectionView?.reloadData()
            }
        }
    }
    
}


