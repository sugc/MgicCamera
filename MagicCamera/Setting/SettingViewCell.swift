//
//  SettingViewCell.swift
//  MagicCamera
//
//  Created by SuGuocai on 2017/12/19.
//  Copyright © 2017年 sugc. All rights reserved.
//

import Foundation
import UIKit


class SettingViewCell : UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(type:Int) {
        super.init(style: UITableViewCellStyle.default, reuseIdentifier: "settingViewCell")
    }
    
    
    init(frame: CGRect) {
        super.init(style: UITableViewCellStyle.default, reuseIdentifier: "settingViewCell")
    }
    
    
    func layout(type:Int) {
        //
//        let button
        
    }
    
    
    
}
