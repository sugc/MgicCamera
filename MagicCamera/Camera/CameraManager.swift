//
//  CameraManager.swift
//  MagicCamera
//
//  Created by sugc on 2017/9/28.
//  Copyright © 2017年 sugc. All rights reserved.
//

import Foundation
import AVFoundation

class CameraManager  {



    func reverse() {
        let device = self.device()
        
//        if device. {
//            <#code#>
//        }
    }
    
    func device() -> AVCaptureDevice {
        let devices = AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo)
        
        for case let device as AVCaptureDevice in devices! {
            if (device.position == AVCaptureDevicePosition.front) {
                return device
            }
        }
        
        return AVCaptureDevice.defaultDevice(withMediaType:AVMediaTypeVideo)
    }
}
