//
//  SaveAndShareViewController.swift
//  MagicCamera
//
//  Created by sugc on 2017/9/11.
//  Copyright © 2017年 sugc. All rights reserved.
//

import Foundation
import UIKit
import GoogleMobileAds

enum shareFromMudule : NSInteger {
    case camera = 0
    case album = 1
    case pintu = 2
}

class SaveAndShareViewController : UIViewController {

    var fromType : shareFromMudule!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        adView()
    }
    
    func adView() {
        let adRect = CGRect(x: 0,
                            y:UIScreen.main.bounds.height - 50 ,
                            width: UIScreen.main.bounds.width,
                            height: 50)
        
        let adView = GADBannerView(frame: adRect)
        adView.adUnitID = "ca-app-pub-9435427819697575/5920935041"
        let request = GADRequest()
        adView.rootViewController = self
        adView.load(request)
        self.view.addSubview(adView)
    }
    
    @IBAction func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func goHome() {
        let nav = self.navigationController!
        let vcs = nav.viewControllers
        var homeVC : UIViewController = vcs.first!
        for vc in vcs {
            if vc.isKind(of: HomeViewController.classForCoder()) {
                homeVC = vc
                break
            }
        }
        
        nav.setViewControllers([homeVC], animated: true)
    }
    
    @IBAction func goOn() {
        
        let nav = self.navigationController!
        
        if fromType == shareFromMudule.pintu {
            nav.popViewController(animated: false)
            nav.popViewController(animated: false)
            nav.popViewController(animated: true)
            return;
        }
        
      
        let vcs = nav.viewControllers
        var cameraVC : UIViewController = vcs.first!
        for vc in vcs {
            if vc.isKind(of: CameraViewController.classForCoder()) {
                cameraVC = vc
                break
            }
        }
        
        nav.popToViewController(cameraVC, animated: true)
        
        if cameraVC.isKind(of: HomeViewController.classForCoder()) {
            let homeVC = cameraVC as! HomeViewController
            homeVC.goLibrary()
        }
    }
}
