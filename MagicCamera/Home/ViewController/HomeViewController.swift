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
        self.requestCameraAuthority { (granted : Bool) in
            if granted {
                let storyboard = UIStoryboard.init(name: "CameraViewController", bundle: nil)
                let cameraVC = storyboard.instantiateViewController(withIdentifier: "CameraViewController")
                self.navigationController?.pushViewController(cameraVC, animated: true)
            }
        }
    }
    
    //相册页面
    @IBAction func goLibrary() {
        self.requestPhotoAuthority { (authorized : Bool) in
            if authorized {
                DispatchQueue.main.async {
                    let imagePick = UIImagePickerController.init()
                    imagePick.delegate = self
                    self.present(imagePick, animated: true) {
                        
                    };
                }
            }
        }
    }

    @IBAction func goJournalVC() {
        
        self.requestPhotoAuthority { (authorized : Bool) in
            if authorized {
                DispatchQueue.main.async {
                    let VC = JournalTemplateViewController()
                    self.navigationController?.pushViewController(VC,
                                                                  animated: true)
                }
            }
        }
    }
    
    @IBAction func goSetting() {
        let settingVC = SettingViewController()
        self.navigationController?.pushViewController(settingVC, animated: true)
    }
    
    func requestPhotoAuthority(completionHandler handler: @escaping (Bool) -> Swift.Void) {
        let authStatus = PHPhotoLibrary.authorizationStatus()
        if authStatus == .notDetermined {
            PHPhotoLibrary.requestAuthorization { (status:PHAuthorizationStatus) -> Void in
               handler(status == PHAuthorizationStatus.authorized)
            }
        }else {
            var isAuthorized = false
            if authStatus == .authorized {
                isAuthorized = true
            }else {
                UIApplication.shared.openURL(URL.init(string: UIApplicationOpenSettingsURLString)!)
            }
            handler(isAuthorized)
        }
    }
    
    func requestCameraAuthority(completionHandler handler: @escaping (Bool) -> Swift.Void) {
        var isAuthorized = false
        let authStatus = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
        
        if authStatus == .notDetermined {
            AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo, completionHandler: { (granted : Bool) in
                handler(granted)
            })
            return
        }
        
        if authStatus == .authorized {
            isAuthorized = true
        }
        
        if authStatus == .restricted || authStatus == .denied {
            //前往设置
            isAuthorized = false
        }
        handler(isAuthorized)
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
