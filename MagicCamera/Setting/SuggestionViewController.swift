//
//  SuggestionViewController.swift
//  MagicCamera
//
//  Created by SuGuocai on 2017/12/21.
//  Copyright © 2017年 sugc. All rights reserved.
//

import Foundation

class SuggestionViewController: UIViewController {
    
    var textFiled : UITextField!
    var textView : UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
    }
    
    func layout()  {
        self.view.backgroundColor = UIColor.gray
        let label = UILabel.init(frame: CGRect.init(x: 0,
                                                    y: iPhoneXSafeDistanceTop,
                                                    width:ScreenWidth,
                                                    height: 40))
        label.backgroundColor = UIColor.clear
        label.text = "帮助与反馈"
        label.textAlignment = NSTextAlignment.center
//        self.navigationItem.title = "帮助与反馈"
        let leftButton = UIButton(frame: CGRect(x: 15,
                                                y: iPhoneXSafeDistanceTop,
                                                width: 40,
                                                height: 40 ))
        leftButton.setTitle("返回", for: UIControlState.normal)
        leftButton.addTarget(self,
                             action: #selector(goBack) ,
                             for: UIControlEvents.touchUpInside)
        
        let sendBtn = UIButton(frame: CGRect(x: ScreenWidth - 55,
                                             y: iPhoneXSafeDistanceTop,
                                             width: 40,
                                             height: 40))
        sendBtn.setTitle("发送", for: UIControlState.normal)
        sendBtn.addTarget(self, action: #selector(sendInfo), for: UIControlEvents.touchUpInside)
        
        
        textFiled = UITextField(frame: CGRect(x: 15,
                                              y: 100,
                                              width: UIScreen.main.bounds.width - 30,
                                              height: 35))
        textFiled.layer.cornerRadius = 3.0
        textFiled.layer.masksToBounds = true
        textFiled.placeholder = "请输入您的邮箱"
        textFiled.backgroundColor = UIColor.white
        
        let tipsLabel = UILabel(frame: CGRect(x: 0,
                                              y: textFiled.bottom + 5,
                                              width: UIScreen.main.bounds.width,
                                              height: 30 ));
        tipsLabel.textAlignment = NSTextAlignment.center
        tipsLabel.text = "有什么不爽的，尽管吐槽吧"
        textView = UITextView(frame: CGRect(x: 0,
                                            y: tipsLabel.bottom + 5,
                                            width: UIScreen.main.bounds.width,
                                            height: UIScreen.main.bounds.height / 3.0))
        
        self.view.addSubview(label)
        self.view.addSubview(leftButton)
        self.view.addSubview(sendBtn)
        self.view.addSubview(tipsLabel)
        self.view.addSubview(textFiled)
        self.view.addSubview(textView)
    }
    
    func goBack() {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func sendInfo() {
        
        var sendInfo = "eamil:"
        if textFiled.text != nil  {
            sendInfo = sendInfo + textFiled.text!
        }
        
        if textView.text != nil  {
            sendInfo = sendInfo + "<-->message:"
            sendInfo = sendInfo + textView.text
        }
        
        
        let attr = ["info":sendInfo]
        Answers.logCustomEvent(withName: "advise", customAttributes: attr)
        let maskView = UIView(frame: UIScreen.main.bounds)
        maskView.backgroundColor = UIColor.color(hex: 0x00000, alpha: 0.8)
        
        UIView.animate(withDuration: 0.5,
                       animations: {
                        self.view.endEditing(true)
        }, completion: {(flag : Bool)->Void in
            let label = UILabel(frame:  CGRect(x: 0,
                                               y: 160,
                                               width: UIScreen.main.bounds.width,
                                               height: 50))
            label.text = "感谢您的宝贵意见，我们会尽快回复"
            label.textColor = UIColor.white
            label.textAlignment = NSTextAlignment.center
            
            self.view.addSubview(maskView)
            maskView.addSubview(label)
            
            let t : TimeInterval = 2.0
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + t, execute: {
                self.goBack()
            })
        })
        
    }
}
