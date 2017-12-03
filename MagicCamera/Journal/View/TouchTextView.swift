//
//  TouchTextView.swift
//  Purika
//
//  Created by sugc on 11/08/2017.
//  Copyright © 2017 魔方. All rights reserved.
//

import Foundation

protocol TouchTextViewDelegate {
    func textViewWillBeginEdit(textView:TouchTextView);
}

class TouchTextView: UITextView {
    
   
    var touchDelegate : TouchTextViewDelegate!
   
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
    }
    
    
    
    convenience init(frame: CGRect) {
        self.init(frame: frame, textContainer: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        touchDelegate.textViewWillBeginEdit(textView: self)
    }

}
