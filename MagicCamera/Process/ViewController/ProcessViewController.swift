//
//  ProcessViewController.swift
//  MagicCamera
//
//  Created by sugc on 2017/9/15.
//  Copyright © 2017年 sugc. All rights reserved.
//

import Foundation
import UIKit
import GPUImage
import MBProgressHUD


class ProcessViewController: UIViewController,FilterListViewProtocol, newFilterListViewProtocol {
    
    @IBOutlet weak var showImageView: UIImageView!
    @IBOutlet weak var toolView : UIView!
    
    
    var filterListView : NewFilterListView!
    var originImage : UIImage!
    var processImage : UIImage!
    var lastSelectIndex : IndexPath! = IndexPath.init(row: -1, section: -1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let height = ScreenHeight * 0.25 - iPhoneXSafeDistance - 70
        filterListView = NewFilterListView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: height) )
        filterListView.filterDelegate = self
        toolView.addSubview(filterListView)
        showImageView.image = processImage
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        filterListView.selectItemAtIndexPath(path: lastSelectIndex)
    }
    
    func didbeganApplyFilter() {
        //
        MBProgressHUD.showAdded(to: self.showImageView, animated: true)
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    
    func applyFilter(filters: Array<GPUImageFilter>) {
        if filters.count == 0 {
            self.processImage = originImage
            self.showImageView.image = originImage
            return;
        }
        
        //
        let toonFilter = filters.first!
        let pictureInput = GPUImagePicture.init(image: originImage)
        pictureInput?.addTarget(toonFilter)
        toonFilter.useNextFrameForImageCapture()
        pictureInput?.processImage()
        processImage = toonFilter.imageFromCurrentFramebuffer();
        self.showImageView.image = processImage
        MBProgressHUD.hide(for: self.showImageView, animated: true)
        UIApplication.shared.endIgnoringInteractionEvents()
    }
    
    func applyLookUpImage(lookUpImage: UIImage?) {
        
    }
    
    func shoulApplyHeaderAction() -> Bool {
        return true
    }
    
   @IBAction func goBack() -> Void {
        //
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func save() ->Void {
        let storyBoard = UIStoryboard.init(name: "SaveAndShareViewController", bundle: nil)
        let saveVC = storyBoard.instantiateViewController(withIdentifier: "SaveAndShareViewController") as! SaveAndShareViewController
        saveVC.fromType = shareFromMudule.camera
        MBProgressHUD.showAdded(to: self.view, animated: true)
        processImage.save { (url, error) in
            MBProgressHUD.hide(for: self.view, animated: true)
            self.navigationController?.pushViewController(saveVC, animated: true)
        }
    }
}
