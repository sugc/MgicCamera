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
        let devices = AVCaptureDevice.devices(for: AVMediaType.video)
        
        for case let device as AVCaptureDevice in devices {
            if (device.position == AVCaptureDevice.Position.front) {
                return device
            }
        }
        
        return AVCaptureDevice.default(for: AVMediaType.video)!
    }
}
