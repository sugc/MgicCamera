//
//  StillCamera.swift
//  MagicCamera
//
//  Created by sugc on 2017/9/28.
//  Copyright © 2017年 sugc. All rights reserved.
//

import Foundation
import GPUImage
import AVFoundation
import UIKit

enum FlashType : Int {
    case Off    = 0 //闪光灯关
    case On     = 1     //闪光灯开
    case Auto   = 2     //闪光灯自动
    case TorOn  = 3    //闪光灯常亮
}

class StillCamera {
    
    var  flashType: FlashType!
    let camera : GPUImageStillCamera!
    var position : AVCaptureDevicePosition!
    var stillImageOutPut : AVCaptureStillImageOutput!
    var  lookupImageSource : GPUImagePicture!
    
    public init(sessionPreset:String!, cameraPosition:AVCaptureDevicePosition = AVCaptureDevicePosition.back) {
        camera = GPUImageStillCamera.init(sessionPreset: sessionPreset, cameraPosition: cameraPosition)
        camera.outputImageOrientation = UIInterfaceOrientation.portrait
        flashType = FlashType.Off
        position = cameraPosition
        
        if !GPUImageStillCamera.isBackFacingCameraPresent() {
             position = AVCaptureDevicePosition.front
        }
        
        let session = camera.captureSession!
        stillImageOutPut = AVCaptureStillImageOutput()
        if session.canAddOutput(stillImageOutPut) {
            session.addOutput(stillImageOutPut)
        }else {
            
            for outPut in session.outputs {
                if outPut is AVCaptureStillImageOutput {
                    session.removeOutput(outPut as! AVCaptureStillImageOutput)
                }
            }
            session.addOutput(stillImageOutPut)
        }
    }
    
    
    //返回前后置摄像机
    func device(position : AVCaptureDevicePosition) -> AVCaptureDevice {
        let devices = AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo)
        
        for case let device as AVCaptureDevice in devices! {
            if (device.position == position) {
                return device
            }
        }
        return AVCaptureDevice.defaultDevice(withMediaType:AVMediaTypeVideo)
    }
    
    //前后置切换
    func reverse() {
        let inputs = camera.captureSession.inputs
        camera.stopCapture()
        
        let newPosition : AVCaptureDevicePosition!
        let newDevice : AVCaptureDevice?
        if position == AVCaptureDevicePosition.front{
            newDevice = self.device(position: AVCaptureDevicePosition.back)
            newPosition = AVCaptureDevicePosition.back
        }else {
            newDevice = self.device(position: AVCaptureDevicePosition.front)
            newPosition = AVCaptureDevicePosition.front
            
        }
        
        let newInput : AVCaptureDeviceInput?
        do {
            newInput = try AVCaptureDeviceInput.init(device: newDevice)
        } catch  {
            fatalError("Could not initialize rendering pipeline: \(error)")
        }
        
        guard newInput != nil else {
            return
        }
        
        camera.captureSession.beginConfiguration()
        for case let input as AVCaptureDeviceInput in inputs! {
            let device = input.device
            if device?.position == position {
                camera.captureSession.removeInput(input)
            }
        }
       
        if camera.captureSession.canAddInput(newInput) {
            camera.captureSession.addInput(newInput)
            position = newPosition
        }
        camera.captureSession.commitConfiguration()
        
        if position == .front{
            let output = camera.captureSession.outputs[0] as! AVCaptureVideoDataOutput
            output.connection(withMediaType: AVMediaTypeVideo).videoOrientation = AVCaptureVideoOrientation.landscapeRight
            output.connection(withMediaType: AVMediaTypeVideo).isVideoMirrored = true
        }
        camera.startCapture()
    }
    
    //切换闪光灯模式
    func switchFlashMode() -> FlashType{
        
        if position == AVCaptureDevicePosition.front {
            return flashType
        }
        
        switch flashType! {
        case FlashType.On:
            applyFlasType(newFlashType: FlashType.TorOn)
            break
        case FlashType.Off:
            applyFlasType(newFlashType: FlashType.Auto)
            break
        case FlashType.Auto:
            applyFlasType(newFlashType: FlashType.On)
            break
        case FlashType.TorOn:
            applyFlasType(newFlashType: FlashType.Off)
            break
        default:
            break
        }
                
        return flashType
    }
    
    
    func applyFlasType(newFlashType:FlashType!)  {
        
        let currentDevice = device(position: position)
        do {
            try currentDevice.lockForConfiguration()
            if newFlashType.rawValue < 3 {
                if currentDevice.torchMode == AVCaptureTorchMode.on {
                    currentDevice.torchMode = AVCaptureTorchMode.off
                }
                if currentDevice.isFlashAvailable {
                    currentDevice.flashMode = AVCaptureFlashMode.init(rawValue: newFlashType.rawValue)!
                }else {
                    return
                }
            }else {
                if currentDevice.torchMode == AVCaptureTorchMode.off {
                    if currentDevice.isTorchAvailable {
                         currentDevice.torchMode = AVCaptureTorchMode.on
                    }else {
                        return;
                    }
                }
            }
            currentDevice.unlockForConfiguration()
        } catch {
            fatalError()
        }
        
        flashType = newFlashType
    }
    
    static func backCameraAvailbel() -> Bool {
       return UIImagePickerController.isCameraDeviceAvailable(UIImagePickerControllerCameraDevice.rear);
    }
    
    //切换滤镜
    func applyFiltersWith(filters:Array<GPUImageFilter>? = nil, renderView:GPUImageView) {
        //
//        camera.stopCapture()
        camera.removeAllTargets()
        
        if filters?.count == 0 {
            camera.addTarget(renderView)
        }else {
            var source : GPUImageOutput = camera
            if filters != nil {
                for operation in filters! {
                    source.addTarget(operation)
                    source = operation
                }
            }
            source.addTarget(renderView)
        }
    }

    //拍照接口
    func captureStillImageAsynchronously(completionHandler handler: ((UIImage?, Error?) -> Swift.Void)!){
        
        let connection = stillImageOutPut.connection(withMediaType: AVMediaTypeVideo)
        connection?.videoScaleAndCropFactor = 1.0
        
        stillImageOutPut.captureStillImageAsynchronously(from: connection) { (sampleBuffer, error) in
            if error != nil {
                handler(nil,error)
                return;
            }

            let data = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer)
            let image = UIImage.init(data: data!)
            handler(image,error)
        }
    
    }
}



