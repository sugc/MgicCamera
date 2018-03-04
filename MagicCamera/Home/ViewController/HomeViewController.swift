//
//  HomeViewController.swift
//  MagicCamera
//
//  Created by sugc on 2017/9/11.
//  Copyright © 2017年 sugc. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import Photos

class HomeViewController :
    UIViewController,
    UIImagePickerControllerDelegate,
    UINavigationControllerDelegate,
    UICollectionViewDelegate
{

    var wallPaperView : UIImageView?
    var homeManager : HomeCollectionViewManager!
    @IBOutlet var collectionView : UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        homeManager = HomeCollectionViewManager.init(collectionView: collectionView)
        self.showWallPaper()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.setStatusBarHidden(true, with: UIStatusBarAnimation.none)
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.hideWallPaperAnimate()
   
    }
    
    func showWallPaper() {
        let isNeedShow = checkIsNeedShowWallPaper()
        if !isNeedShow {
          return
        }
        
        wallPaperView = UIImageView.init(frame: self.view.bounds)
        wallPaperView?.contentMode = UIViewContentMode.scaleAspectFill
        self.view.addSubview(wallPaperView!)
        let dbManager = WallPapperDBMananer.init()
        let allImage = dbManager.getAllImage()
        if allImage.count > 0 {
            let num  = Int(arc4random_uniform(UInt32(allImage.count)))
            wallPaperView?.image = allImage[num]
        }
    }
    
    
    func hideWallPaperAnimate() {
        if wallPaperView == nil {
            return
        }
        
        //加载图片, 默认图？
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            UIView.animate(withDuration: 0.8, animations: {
                self.wallPaperView?.alpha = 0
            }, completion: { (isComplete : Bool) in
                self.wallPaperView?.removeFromSuperview()
                self.wallPaperView = nil;
            })
        }
    }
    
    
    //相机页面
    @IBAction func goCamera() {
        requestCameraAuthority { (granted : Bool) in
            if granted {
                let storyboard = UIStoryboard.init(name: "CameraViewController", bundle: nil)
                let cameraVC = storyboard.instantiateViewController(withIdentifier: "CameraViewController")
                self.navigationController?.pushViewController(cameraVC, animated: true)
            }
        }
    }
    
    //相册页面
    func goLibrary() {
        requestPhotoAuthority { (authorized : Bool) in
            if authorized {
                let imagePick = UIImagePickerController.init()
                imagePick.allowsEditing = false;
                imagePick.delegate = self
                self.present(imagePick, animated: true) {}
            }
        }
    }

    func goJournalVC() {
        requestPhotoAuthority { (authorized : Bool) in
            if authorized {
                let VC = JournalTemplateViewController()
                self.navigationController?.pushViewController(VC,
                                                              animated: true)
            }
        }
    }
    
    @IBAction func goSetting() {
        let settingVC = SettingViewController()
        self.navigationController?.pushViewController(settingVC, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //
        
        let tempImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        let image = tempImage.fixOrientation()
//        let image = tempImage
        
        let storyboard = UIStoryboard.init(name: "ProcessViewController", bundle: nil)
        let processVC = storyboard.instantiateViewController(withIdentifier: "ProcessViewController") as! ProcessViewController
        processVC.originImage = image
        processVC.processImage = image
        self.navigationController?.pushViewController(processVC, animated: true)
        print("")
        picker.dismiss(animated: true) { 
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            self.goLibrary()
        }
        
        if indexPath.row == 1 {
            self.goJournalVC()
        }
    }
}
