//
//  SettingViewManager.swift
//  MagicCamera
//
//  Created by SuGuocai on 2017/12/20.
//  Copyright © 2017年 sugc. All rights reserved.
//

import Foundation
import UIKit

class SettingViewManager: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    let dataArray : Array<Dictionary<String,Any>> =
                    [["title":"关于","action":#selector(showAbout)],
                     ["title":"开屏壁纸","action":#selector(setlaunchImage)],
                     ["title":"意见反馈","action":#selector(sendSuggestion)]]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "settingViewCell")
        
        if cell == nil {
            cell = UITableViewCell.init(style: UITableViewCellStyle.value1, reuseIdentifier: "settingViewCell")
        }
        
        cell!.textLabel?.text = dataArray[indexPath.row]["title"] as? String
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let action = dataArray[indexPath.row]["action"]
        self.perform(action as! Selector)
    }
    
    func setlaunchImage() {
        
    }
    
    func showAbout() {
        
    }
    
    //意见反馈
    func sendSuggestion() {
        let suggestVC = SuggestionViewController()
        let delegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let nav = delegate.window!.rootViewController as! UINavigationController
        nav.pushViewController(suggestVC, animated: true)
    }
}
