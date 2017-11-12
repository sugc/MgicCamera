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


class ProcessViewController: UIViewController,FilterListViewProtocol {
    
    @IBOutlet var showImageView: UIImageView!
    @IBOutlet var filterListView : FilterListView!
    var originImage : UIImage!
    var processImage : UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        filterListView.filterDelegate = self
        showImageView.image = processImage
    }
    
    func didbeganApplyFilter() {
        //
        MBProgressHUD.showAdded(to: self.showImageView, animated: true)
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    
    func applyFilter(filters: Array<BasicOperation>) {
        
        if filters.count == 0 {
            self.processImage = originImage
            self.showImageView.image = originImage
            return;
        }
        
        //
        let toonFilter = filters.first!
        let orient = originImage.imageOrientation.rawValue % 4
        var imgOrient : ImageOrientation
        switch orient {
        case 0:
            imgOrient = ImageOrientation.portrait
            break
        case 1:
            imgOrient = ImageOrientation.portraitUpsideDown
            break
        case 2:
            imgOrient = ImageOrientation.landscapeLeft
            break
        case 3:
            imgOrient = ImageOrientation.landscapeRight
            break
        default:
            imgOrient = ImageOrientation.portrait
            break
        }

        let pictureInput = PictureInput.init(image: originImage, smoothlyScaleOutput: false, orientation: imgOrient)
        
        let pictureOutput = PictureOutput()
        pictureInput --> toonFilter --> pictureOutput
        pictureOutput.imageAvailableCallback = {image in
            // Do something with image
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.processImage = image
                self.showImageView.image = image
                MBProgressHUD.hide(for: self.showImageView, animated: true)
                UIApplication.shared.endIgnoringInteractionEvents()
            }
        }
        
        pictureInput.processImage(synchronously:true)
        
//        let prImage : UIImage = originImage.copy() as! UIImage
//
//        let processImage =  prImage.filterWithPipeline { (input, output) in
//            let baseOperation : BasicOperation = filters.first!
//            input --> baseOperation --> output
//        }
        
       
    }
    
   @IBAction func goBack() -> Void {
        //
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func save() ->Void {
        let storyBoard = UIStoryboard.init(name: "SaveAndShareViewController", bundle: nil)
        let saveVC = storyBoard.instantiateViewController(withIdentifier: "SaveAndShareViewController")
        MBProgressHUD.showAdded(to: self.view, animated: true)
        processImage.save { (url, error) in
            MBProgressHUD.hide(for: self.view, animated: true)
            self.navigationController?.pushViewController(saveVC, animated: true)
        }
    }
}
