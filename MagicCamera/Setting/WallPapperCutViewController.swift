//
//  WallPapperCutViewController.swift
//  MagicCamera
//
//  Created by SuGuocai on 2018/3/4.
//  Copyright © 2018年 sugc. All rights reserved.
//

import Foundation

@objc protocol CutViewControllerProtocol  {
    @objc func selectImage(image : UIImage?)
}

class WallPapperCutViewController : UIViewController {
    
    @IBOutlet var bottomViewHeight : NSLayoutConstraint!
    @IBOutlet var backView : UIView!
    weak var delegate : CutViewControllerProtocol!
    var contentView : CutView!
    var image : UIImage!
    
    override func viewDidLoad() {

        let height : CGFloat = ScreenHeight - bottomViewHeight.constant - iPhoneXSafeDistance - 30
        let width = height / ScreenHeight * ScreenWidth
        
        let frame = CGRect.init(x: (ScreenWidth - width) / 2.0,
                                y: iPhoneXSafeDistanceTop + 15,
                                width: width,
                                height: height)
        contentView = CutView.init(frame: frame)
        contentView.image = image
        contentView.layer.masksToBounds = false
        contentView.clipsToBounds = false
        self.view.insertSubview(contentView, at: 0)
        
        let layer = CAShapeLayer.init()
        backView.layer.addSublayer(layer)
        let path = CGMutablePath.init()
        path.addRect(self.view.bounds)
        path.addRect(frame)
        layer.fillRule = CAShapeLayerFillRule.evenOdd
        layer.path = path
        layer.fillColor = UIColor.color(hex: 0x000000, alpha: 0.6).cgColor
        
        let boderView = UIView.init(frame: frame)
        boderView.layer.borderWidth = 1.0;
        boderView.layer.borderColor = UIColor.white.cgColor
        backView.addSubview(boderView)
        
    }
    
    @IBAction func actionOk() {
        let size = CGSize.init(width: ScreenWidth * 4, height: ScreenHeight * 4)
        let image = contentView.renderImage(finalSize: size)
        delegate.selectImage(image: image)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func actionCancel() {
        self.dismiss(animated: true, completion: nil)
    }

}
