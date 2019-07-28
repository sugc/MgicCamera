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
    var filter : GPUImageFilter!
    var stillImageOutPut : AVCaptureStillImageOutput!
    var originImage : UIImage?
    var preViewType : ImageRatio!
    var positionMonitor : PositionMonitor?
    
    @IBOutlet var albumBtn : UIButton!
    @IBOutlet var renderBackView : UIView!
    @IBOutlet var rationBtn : UIButton!
    @IBOutlet var flashBtn : UIButton!
    @IBOutlet weak var reveseBtn: UIButton!
    @IBOutlet var filterListView : FilterListView?
    @IBOutlet var renderView : GPUImageView!
    @IBOutlet var bottomMaskView : UIView!
    @IBOutlet var topMaskView : UIView!
    @IBOutlet var topMaskViewHeight : NSLayoutConstraint!
    @IBOutlet var bottomMaskViewheight : NSLayoutConstraint!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        filterListView?.filterDelegate = self
        albumBtn.setTitle(NSLocalizedString("相册", comment:""), for: UIControl.State.normal)
        positionMonitor = PositionMonitor()
        filterListView?.filterDelegate = self
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(change(notification:)),
                                               name:UIDevice.orientationDidChangeNotification,
                                               object: nil)
        if !DEVICE_IS_SUMILATE {
            camera = StillCamera.init(sessionPreset: AVCaptureSession.Preset.photo.rawValue)
            camera.camera.addTarget(renderView)
        }
        
        preViewType = ImageRatio.Type1v1
        refreshFlashStatus()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !StillCamera.backCameraAvailbel() {
            reveseBtn.isHidden = true
        }
        
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

        let preViewHeight = self.view.width / 3.0 * 4.0
        let ajustY = -preViewHeight * 0.125
        
        UIView.animate(withDuration: 0.2) {
            switch preViewType {
            case ImageRatio.Type1v1:
                
                self.topMaskViewHeight.constant = 0
                self.bottomMaskViewheight.constant = 0
                self.rationBtn.setTitle("1:1", for: UIControl.State.normal)
                break
            case ImageRatio.Type4v3:
                //
                self.topMaskViewHeight.constant = ajustY
                self.bottomMaskViewheight.constant = ajustY
                self.rationBtn.setTitle("4:3", for: UIControl.State.normal)
                break
            }
            self.renderBackView.layoutIfNeeded()
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
            let finalImage = catureImage?.fixWithDeviceOrientation(orientation: deviceOrientation!, isFront: self.camera.position == AVCaptureDevice.Position.front)
            self.goNext(image: finalImage)
        }
    }
    
    @IBAction func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    //摄像头前后置
    @IBAction func reverse() {
        
        if camera.position == AVCaptureDevice.Position.front {
            self.flashBtn.isHidden = false
        }else {
            self.flashBtn.isHidden = true
        }
        
        camera.reverse()
        
        
    }
    
    @IBAction func actionAlbum() {
        //
        requestPhotoAuthority { (isAuthority:Bool) in
            if isAuthority {
                let imagePick = UIImagePickerController.init()
                imagePick.delegate = self
                self.present(imagePick, animated: true) {
                    
                };
            }
        }
    }
    
    func refreshFlashStatus() {
        switch camera.flashType! {
        case FlashType.On:
            flashBtn.setImage(UIImage.init(named: "icon_flash_on"),
                              for: UIControl.State.normal)
            break
        case FlashType.Off:
            flashBtn.setImage(UIImage.init(named: "icon_flash_off"),
                              for: UIControl.State.normal)
            break
        case FlashType.Auto:
            flashBtn.setImage(UIImage.init(named: "icon_flash_auto"),
                              for: UIControl.State.normal)
            break
        case FlashType.TorOn:
            flashBtn.setImage(UIImage.init(named: "icon_flash_torch") ,
                              for: UIControl.State.normal)
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
    
    @objc func change(notification : NSNotification)  {
        
    }
    
    func goNext(image : UIImage!) {
        var originImage = image
        if self.preViewType == ImageRatio.Type1v1 {
            originImage = image.imageWithRatio(ratio: 1)
        }
        
        var processImage = originImage
        let selectFilters = filterListView!.getCurrentFilters()!
        if selectFilters.count > 0 {
            let toonFilter  = selectFilters.first as! GPUImageFilter
            toonFilter.removeAllTargets()
            let pictureInput = GPUImagePicture.init(image: originImage)
            pictureInput?.addTarget(toonFilter)
            toonFilter.useNextFrameForImageCapture()
            pictureInput?.processImage()
            processImage = toonFilter.imageFromCurrentFramebuffer()
        }
        
        self.goNextWith(originImage: originImage, processImage: processImage)
    }

    func goNextWith(originImage : UIImage!, processImage : UIImage!) {
        let storyboard = UIStoryboard.init(name: "ProcessViewController", bundle: nil)
        let processVC = storyboard.instantiateViewController(withIdentifier: "ProcessViewController") as! ProcessViewController
        processVC.originImage = originImage
        processVC.processImage = processImage
        processVC.lastSelectIndex = self.filterListView?.lastSelectIndex
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: self.view, animated: true)
            self.navigationController?.pushViewController(processVC, animated: true)
        }
    }
    
    func didbeganApplyFilter() {
        //
    }
    
    //**************应用滤镜/
    func applyFilter(filters: Array<GPUImageFilter>) {
        camera.applyFiltersWith(filters: filters, renderView: renderView)
    }
    
    func applyLookUpImage(lookUpImage: UIImage?) {
        
    }
    
    func shoulApplyHeaderAction() -> Bool {
        return true
    }
    
    //UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [AnyHashable : Any]) {
        //
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
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





