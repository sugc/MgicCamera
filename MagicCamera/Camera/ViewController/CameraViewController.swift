//
//  CameraViewController.swift
//  MagicCamera
//
//  Created by sugc on 2017/9/11.
//  Copyright © 2017年 sugc. All rights reserved.
//

import Foundation
import UIKit
import GPUImage
import AVFoundation
import MBProgressHUD


enum ImageRatio : Int {
    case Type4v3  = 0       //4:3
    case Type1v1  = 1       //1:1
}


class CameraViewController : UIViewController,
                        FilterListViewProtocol,
                        UIImagePickerControllerDelegate,
UINavigationControllerDelegate{
    
    // 
    var camera : StillCamera!
    var filter : BasicOperation!
    var stillImageOutPut : AVCaptureStillImageOutput!
    var originImage : UIImage?
    var preViewType : ImageRatio!
    var positionMonitor : PositionMonitor?
    
    @IBOutlet var preViewHeight : NSLayoutConstraint!
    @IBOutlet var renderBackView : UIView!
    @IBOutlet var rationBtn : UIButton!
    @IBOutlet var flashBtn : UIButton!
    @IBOutlet var filterListView : FilterListView?
    @IBOutlet var renderView : RenderView!
    @IBOutlet var bottomMaskView : UIView!
    @IBOutlet var topMaskView : UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        filterListView?.filterDelegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        positionMonitor = PositionMonitor()
        filterListView?.filterDelegate = self
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(change(notification:)),
                                               name: NSNotification.Name.UIDeviceOrientationDidChange,
                                               object: nil)
        renderView.fillMode = GPUImage.FillMode.stretch
        if !DEVICE_IS_SUMILATE {
            camera = StillCamera.init(sessionPreset: AVCaptureSessionPresetPhoto)
            camera.camera --> renderView
        }
        
        preViewType = ImageRatio.Type1v1
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !DEVICE_IS_SUMILATE {
            camera.camera.startCapture()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if !DEVICE_IS_SUMILATE {
            camera.camera.stopCapture()
        }
    }
    
    //切换预览尺寸
    func applyLayout(preViewType:ImageRatio) ->Void {
        self.preViewType = preViewType
       
        switch preViewType {
            case ImageRatio.Type1v1:
                topMaskView.isHidden = false
                bottomMaskView.isHidden = false
                rationBtn.setTitle("1:1", for: UIControlState.normal)
                break
            case ImageRatio.Type4v3:
                //
                topMaskView.isHidden = true
                bottomMaskView.isHidden = true
                rationBtn.setTitle("4:3", for: UIControlState.normal)
                break
        }
        //
    }
    
    //拍照
    @IBAction func capturePhoto() {
        camera.captureStillImageAsynchronously { (catureImage, error) in
            if error != nil {
                return
            }
            if catureImage == nil {
                return
            }
            
//            DispatchQueue.main.async {
//                MBProgressHUD.showAdded(to: self.view, animated: true)
//            }
            
            let deviceOrientation = self.positionMonitor?.orientation
            let finalImage = catureImage?.fixWithDeviceOrientation(orientation: deviceOrientation!, isFront: true)
            self.goNext(image: finalImage)
        }
    }
    
    @IBAction func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    //摄像头前后置
    @IBAction func reverse() {
        
        if camera.position == AVCaptureDevicePosition.front {
            self.flashBtn.isHidden = false
        }else {
            self.flashBtn.isHidden = true
        }
        
        camera.reverse()
        
        
    }
    
    @IBAction func actionAlbum() {
        //
        let imagePick = UIImagePickerController.init()
        imagePick.delegate = self
        self.present(imagePick, animated: true) {
            
        };
        
    }
    
    func refreshFlashStatus() {
        switch camera.flashType! {
        case FlashType.On:
            flashBtn.setImage(UIImage.init(named: "icon_flash_on"),
                              for: UIControlState.normal)
            break
        case FlashType.Off:
            flashBtn.setImage(UIImage.init(named: "icon_flash_off"),
                              for: UIControlState.normal)
            break
        case FlashType.Auto:
            flashBtn.setImage(UIImage.init(named: "icon_flash_auto"),
                              for: UIControlState.normal)
            break
        case FlashType.TorOn:
            flashBtn.setImage(UIImage.init(named: "icon_flash_torch") ,
                              for: UIControlState.normal)
            break
        }
    }
    
    //闪光灯模式
    @IBAction func flash (){
        //
        _ = camera.switchFlashMode()
        refreshFlashStatus()
    
    }
    
    @IBAction func changeImageRatio() {
        //
        switch preViewType! {
            case ImageRatio.Type1v1:
                applyLayout(preViewType: ImageRatio.Type4v3)
            case ImageRatio.Type4v3:
                applyLayout(preViewType: ImageRatio.Type1v1)
        }
    }
    
    func change(notification : NSNotification)  {
        
    }
    
    func goNext(image : UIImage!) {
        var originImage = image
        if self.preViewType == ImageRatio.Type1v1 {
            originImage = image.imageWithRatio(ratio: 1)
        }
        
        var processImage = originImage
        let selectFilters = filterListView!.getCurrentFilters()!
        if selectFilters.count > 0 {
            let toonFilter  = selectFilters.first!
            toonFilter.removeSourceAtIndex(0)
            toonFilter.removeAllTargets()
            let pictureInput = PictureInput(image: originImage!)
            let pictureOutput = PictureOutput()
            pictureInput --> toonFilter --> pictureOutput
            pictureOutput.imageAvailableCallback = {image in
                processImage = image
                self.goNextWith(originImage: originImage, processImage: processImage)
            }
            pictureInput.processImage(synchronously:true)
        }else {
            self.goNextWith(originImage: originImage, processImage: processImage)
        }
    }

    func goNextWith(originImage : UIImage!, processImage : UIImage!) {
        let storyboard = UIStoryboard.init(name: "ProcessViewController", bundle: nil)
        let processVC = storyboard.instantiateViewController(withIdentifier: "ProcessViewController") as! ProcessViewController
        processVC.originImage = originImage
        processVC.processImage = processImage
        
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: self.view, animated: true)
            self.navigationController?.pushViewController(processVC, animated: true)
        }
    }
    
    func didbeganApplyFilter() {
        //
    }
    
    //**************应用滤镜/
    func applyFilter(filters: Array<BasicOperation>) {
        camera.applyFiltersWith(filters: filters, renderView: renderView)
    }
    
    func applyLookUpImage(lookUpImage: UIImage?) {
        
    }
    
    //UIImagePickerControllerDelegate
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





