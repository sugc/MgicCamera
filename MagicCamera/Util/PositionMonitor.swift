//
//  PositionMonitor.swift
//  MagicCamera
//
//  Created by sugc on 2017/9/27.
//  Copyright © 2017年 sugc. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import  CoreMotion

class PositionMonitor  {
    var monitionManager : CMMotionManager!
    var orientation : UIDeviceOrientation!
    var lastValidOrientation : UIDeviceOrientation!
    var willOrientation : UIDeviceOrientation!
    
    init() {
        monitionManager = CMMotionManager.init()
        orientation = UIDeviceOrientation.portrait
        starTrack()
    }
    
    func starTrack() {
        monitionManager.accelerometerUpdateInterval = 1.0 / 30
        monitionManager.startAccelerometerUpdates(to: OperationQueue.main) { (data, error) in
            if error != nil {
                return
            }
            if data != nil {
                self.trackPosition(accelerometerData: data!)
            }
        }
    }
    
    func trackPosition(accelerometerData:CMAccelerometerData) {
        //追踪位置
        var tmpOrientation = UIDeviceOrientation.portrait
        
        let vector : Vector3 = Vector3(x: accelerometerData.acceleration.x,
                                       y: accelerometerData.acceleration.y,
                                       z: accelerometerData.acceleration.z)
        let radio : Double = Double.pi / 180 * 30
        
        if vectorAngle(vec1: vector, vec2: Vector3(x: 0, y: -1, z: 0)) < radio {
            tmpOrientation = UIDeviceOrientation.portrait
        }
        else if vectorAngle(vec1: vector, vec2: Vector3(x: 0, y: 1, z: 0)) < radio {
            tmpOrientation = UIDeviceOrientation.portraitUpsideDown
        }
        else if vectorAngle(vec1: vector, vec2: Vector3(x: -1, y: 0, z: 0)) < radio {
            tmpOrientation = UIDeviceOrientation.landscapeLeft
        }
        else if vectorAngle(vec1: vector, vec2: Vector3(x: 1, y: 0, z: 0)) < radio {
            tmpOrientation = UIDeviceOrientation.landscapeRight
        }
        else if vectorAngle(vec1: vector, vec2: Vector3(x: 0, y: 0, z: -1)) < radio {
//            tmpOrientation = UIDeviceOrientation.faceUp
        }
        else if vectorAngle(vec1: vector, vec2: Vector3(x: 0, y: 0, z: 1)) < radio {
//            tmpOrientation = UIDeviceOrientation.faceDown
        }else {
            tmpOrientation = UIDeviceOrientation.unknown
            
        }
        
        if tmpOrientation != willOrientation && tmpOrientation != UIDeviceOrientation.unknown {
            willOrientation = tmpOrientation;
            changeOrientation(orientation: tmpOrientation)
        }
        
//        let vector =
    }
    
    func changeOrientation(orientation : UIDeviceOrientation) -> Void {
        self.orientation = orientation
    }
    
    
    func imageOrientationWithCameraPosition(position:AVCaptureDevicePosition) -> UIImageOrientation {
        return self.imageOrientationFromUIDeviceOrientation(orientation: orientation, isFront: position == AVCaptureDevicePosition.front ? true : false)
    }
    func imageOrientationFromUIDeviceOrientation(orientation:UIDeviceOrientation, isFront:Bool) ->UIImageOrientation {
        
        var imageOrient = UIImageOrientation.leftMirrored
        switch orientation {
        case UIDeviceOrientation.portrait:
            if isFront {
                imageOrient = UIImageOrientation.leftMirrored
            }else {
                imageOrient = UIImageOrientation.right
            }
            break
        case UIDeviceOrientation.landscapeRight:
            if isFront {
                imageOrient = UIImageOrientation.upMirrored
            }else {
                imageOrient = UIImageOrientation.down
            }
            break
        case UIDeviceOrientation.landscapeLeft:
            if isFront {
                imageOrient = UIImageOrientation.downMirrored
            }else {
                imageOrient = UIImageOrientation.up
            }
            break
        case UIDeviceOrientation.portraitUpsideDown:
            if isFront {
                imageOrient = UIImageOrientation.rightMirrored
            }else {
                imageOrient = UIImageOrientation.left
            }
            break
        default:
            break
        }
        
        return imageOrient
    }
}
