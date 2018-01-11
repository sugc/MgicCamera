//
//  AuthorityUtil.swift
//  MagicCamera
//
//  Created by SuGuocai on 2017/12/27.
//  Copyright © 2017年 sugc. All rights reserved.
//

import Foundation
import AVFoundation
import Photos


//相机权限请求
func requestCameraAuthority(completionHandler handler: @escaping (Bool) -> Swift.Void) {
    var isAuthorized = false
    let authStatus = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
    
    if authStatus == .notDetermined {
        AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo, completionHandler: { (granted : Bool) in
            DispatchQueue.main.async {
                handler(granted)
            }
        })
        return
    }
    
    if authStatus == .authorized {
        isAuthorized = true
    }
    
    if authStatus == .restricted || authStatus == .denied {
        //前往设置
        let settingUrl = "App-Prefs:root=Privacy&path=camera"
        let title = NSLocalizedString("无法访问相机", comment: "")
        let message = NSLocalizedString("请打开设置-蜜柚相机-相机-开启", comment: "")
        showSettingAlertView(title: title, message: message, settingUrlStr: settingUrl)
        isAuthorized = false
    }
    DispatchQueue.main.async {
        handler(isAuthorized)
    }
}

//相册权限请求
func requestPhotoAuthority(completionHandler handler: @escaping (Bool) -> Swift.Void) {
    let authStatus = PHPhotoLibrary.authorizationStatus()
    if authStatus == .notDetermined {
        PHPhotoLibrary.requestAuthorization { (status:PHAuthorizationStatus) -> Void in
            DispatchQueue.main.async {
                handler(status == PHAuthorizationStatus.authorized)
            }
        }
    }else {
        var isAuthorized = false
        if authStatus == .authorized {
            isAuthorized = true
        }else {
            let settingUrl = "App-Prefs:root=Privacy&path=photos"
            let title = NSLocalizedString("无法访问相册", comment: "")
            let message = NSLocalizedString("请打开设置-蜜柚相机-照片-开启", comment:"")
            showSettingAlertView(title:title, message:message, settingUrlStr: settingUrl)
        }
        DispatchQueue.main.async {
            handler(isAuthorized)
        }
    }
}

func showSettingAlertView(title:String!, message : String!, settingUrlStr : String!) {
    let alert = UIAlertController.init(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
    let cancelAction = UIAlertAction.init(title: NSLocalizedString("好的", comment: ""), style: UIAlertActionStyle.cancel) { (action : UIAlertAction) in
        
    }
    
    let settingAction = UIAlertAction.init(title: NSLocalizedString("去设置", comment: ""), style: UIAlertActionStyle.default) { (action : UIAlertAction) in
        UIApplication.shared.openURL(URL.init(string: UIApplicationOpenSettingsURLString)!)
    }
    
    alert.addAction(cancelAction)
    alert.addAction(settingAction)
    
    UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
}




