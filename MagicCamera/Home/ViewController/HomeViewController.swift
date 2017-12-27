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

class HomeViewController : UIViewController,
                            UIImagePickerControllerDelegate,
                            UINavigationControllerDelegate{

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.setStatusBarHidden(true, with: UIStatusBarAnimation.none)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
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
    @IBAction func goLibrary() {
        requestPhotoAuthority { (authorized : Bool) in
            if authorized {
                let imagePick = UIImagePickerController.init()
                imagePick.delegate = self
                self.present(imagePick, animated: true) {}
            }
        }
    }

    @IBAction func goJournalVC() {
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
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        let storyboard = UIStoryboard.init(name: "ProcessViewController", bundle: nil)
        let processVC = storyboard.instantiateViewController(withIdentifier: "ProcessViewController") as! ProcessViewController
        processVC.originImage = image
        processVC.processImage = image
        self.navigationController?.pushViewController(processVC, animated: true)
        print("")
        picker.dismiss(animated: true) { 
            
        }
    }
}
