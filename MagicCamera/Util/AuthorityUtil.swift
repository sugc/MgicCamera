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
        showSettingAlertView(title: "'蜜柚相机' 需要访问您的相机权限", message: "请前往 设置->隐私->相机 打开权限", settingUrlStr: settingUrl)
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
            showSettingAlertView(title: "'蜜柚相机' 需要访问您的相册权限", message: "请前往 设置->隐私->照片 打开权限", settingUrlStr: settingUrl)
        }
        DispatchQueue.main.async {
            handler(isAuthorized)
        }
    }
}

func showSettingAlertView(title:String!, message : String!, settingUrlStr : String!) {
    let alert = UIAlertController.init(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
    let cancelAction = UIAlertAction.init(title: "好的", style: UIAlertActionStyle.cancel) { (action : UIAlertAction) in
        
    }
    
    let settingAction = UIAlertAction.init(title: "去设置", style: UIAlertActionStyle.default) { (action : UIAlertAction) in
        UIApplication.shared.openURL(URL.init(string: UIApplicationOpenSettingsURLString)!)
    }
    
    alert.addAction(cancelAction)
    alert.addAction(settingAction)
    
    UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
}




