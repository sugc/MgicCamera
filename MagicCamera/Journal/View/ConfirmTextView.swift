//
//  ComfirmTextView.swift
//  Purika
//
//  Created by sugc on 24/07/2017.
//  Copyright © 2017 魔方. All rights reserved.
//

import Foundation

protocol ConfirmTextViewDelegate : NSObjectProtocol {
    
    func viewFrameChanged(finalFrame:CGRect!)
    func textChanged(text:String)
}

class ConfirmTextView: UIView, UITextViewDelegate {
    var inputTextView: UITextView!
    var confirmButton: UIButton!
    weak var delegate : ConfirmTextViewDelegate!
    
    var text: String? {
        set(text){
            
            self.inputTextView.text = text
            self.inputTextView.becomeFirstResponder()

            let subStr =  text?.components(separatedBy: "\n").first
            
            if subStr != nil {
                let range = NSRange.init(location: (subStr?.characters.count)!, length: 0)
                inputTextView.selectedRange = range
                autoAjust()
            }
        }
        
        get{
            return inputTextView.text
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init() {
        super.init(frame: CGRect(x: 0,
                                 y: 0,
                                 width: UIScreen.main.bounds.width,
                                 height: 40 ))
        self.backgroundColor = UIColor.white
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        layout()
    }

    func layout() {
        //
        
        confirmButton = UIButton.init(frame: CGRect(x: UIScreen.main.bounds.width - 40,
                                                    y: self.height - 40,
                                                    width: 40,
                                                    height: 40 ))
        inputTextView = UITextView.init(frame: CGRect(x: 0,
                                                      y: 5,
                                                      width: UIScreen.main.bounds.width - 50,
                                                      height: self.height - 10))
        inputTextView.delegate = self
        inputTextView.isScrollEnabled = false
        confirmButton.backgroundColor = UIColor.red
        inputTextView.backgroundColor = UIColor.gray
        self.addSubview(inputTextView)
        self.addSubview(confirmButton)
    }
    
    //根据文字自动调整高度
    func autoAjust() {
        
        let size = inputTextView.sizeThatFits(CGSize(width: UIScreen.main.bounds.width - 50, height: CGFloat.greatestFiniteMagnitude))
        
        if size.height == inputTextView.height {
            return
        }
        
        inputTextView.frame = CGRect(x: inputTextView.frame.origin.x,
                                y: inputTextView.frame.origin.y,
                                width: inputTextView.frame.width,
                                height: size.height)
        let height = size.height + 10
        
        changeFrame(newFrame: CGRect(x: self.frame.origin.x,
                                     y: self.frame.origin.y - (height - self.frame.height),
                                     width: self.frame.width,
                                     height: height))
        
    }
    
    
    func changeFrame(newFrame:CGRect!)  {
        self.frame = newFrame
        delegate.viewFrameChanged(finalFrame: self.frame)
    }

//delegate
    func textViewDidChange(_ textView: UITextView) {
        autoAjust()
        delegate.textChanged(text: textView.text)
    }
}






