//
//  StatusUtil.swift
//  MagicCamera
//
//  Created by SuGuocai on 2018/1/10.
//  Copyright © 2018年 sugc. All rights reserved.
//

import Foundation

let ShowWallPaperKeyString = "ShowWallPaperKeyString"

func checkIsNeedShowWallPaper() -> Bool {
    let item = UserDefaults.standard.object(forKey: ShowWallPaperKeyString)
    if item == nil {
        return true
    }
   return item as! Bool
}

func setIsNeedShowWallPaper(isNeedShow : Bool)->Void {
    UserDefaults.standard.set(isNeedShow, forKey: ShowWallPaperKeyString);
}
