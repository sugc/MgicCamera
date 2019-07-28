//
//  SuggestionViewController.swift
//  MagicCamera
//
//  Created by SuGuocai on 2017/12/21.
//  Copyright © 2017年 sugc. All rights reserved.
//

import Foundation
import skpsmtpmessage


class SuggestionViewController: UIViewController, SKPSMTPMessageDelegate {
    
    var textFiled : UITextField!
    var textView : UITextView!
    let mail = SKPSMTPMessage()
    
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
        leftButton.setTitle("返回", for: UIControl.State.normal)
        leftButton.addTarget(self,
                             action: #selector(goBack) ,
                             for: UIControl.Event.touchUpInside)
        
        let sendBtn = UIButton(frame: CGRect(x: ScreenWidth - 55,
                                             y: iPhoneXSafeDistanceTop,
                                             width: 40,
                                             height: 40))
        sendBtn.setTitle("发送", for: UIControl.State.normal)
        sendBtn.addTarget(self, action: #selector(sendInfo), for: UIControl.Event.touchUpInside)
        
        
        textFiled = UITextField(frame: CGRect(x: 15,
                                              y: 60,
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
        textView = UITextView(frame: CGRect(x: 10,
                                            y: tipsLabel.bottom + 5,
                                            width: UIScreen.main.bounds.width - 20,
                                            height: UIScreen.main.bounds.height / 3.0))
        textView.font = UIFont.systemFont(ofSize: 15)
        textView.layer.cornerRadius = 3.0
        textView.layer.masksToBounds = true
        
        self.view.addSubview(label)
        self.view.addSubview(leftButton)
        self.view.addSubview(sendBtn)
        self.view.addSubview(tipsLabel)
        self.view.addSubview(textFiled)
        self.view.addSubview(textView)
    }
    
    @objc func goBack() {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @objc func sendInfo() {
        mail.subject = "蜜柚相机意见反馈"
        mail.fromEmail = "suguocai_z@163.com"
        mail.toEmail = "suguocai_z@163.com"
        mail.relayHost = "smtp.163.com"
        mail.requiresAuth = true
        mail.login = "suguocai_z@163.com"
        mail.pass = "sugchahaha6"
        mail.wantsSecure = true
        mail.delegate = self
        var UserMail = ""
        var content = ""
        if self.textFiled.text != nil {
            UserMail = "发送邮箱 ———— " + self.textFiled.text! + "\n\n\n"
        }
        
        if textView.text == nil || textView.text == "" {
            return;
        }
        
        content = UserMail + textView.text
        let plainpart = [kSKPSMTPPartContentTypeKey:"text/plain; charset=UTF-8",
                                                      kSKPSMTPPartMessageKey:content,
                         kSKPSMTPPartContentTransferEncodingKey:"8bit"]
        mail.parts = [plainpart]
        DispatchQueue.main.async {
             self.mail.send()
        }
    }
    
    func messageSent(_ message: SKPSMTPMessage!) {
        print("success to send email")
    }
    
    func messageFailed(_ message: SKPSMTPMessage!, error: Error!) {
        print("failed to send email")
    }
}
