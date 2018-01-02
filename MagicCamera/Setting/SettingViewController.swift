//
//  SettingViewController.swift
//  MagicCamera
//
//  Created by SuGuocai on 2017/12/19.
//  Copyright © 2017年 sugc. All rights reserved.
//

import Foundation


class SettingViewController: UIViewController, UITableViewDelegate {
    
    var tableView : UITableView!
    let manager : SettingViewManager = SettingViewManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
    }
    
    func layout() {
        self.view.backgroundColor = UIColor.white
        let frame = CGRect.init(x: 5, y: 20, width: 35, height: 35)
        let backBtn = UIButton.init(frame: frame)
        backBtn.setImage(UIImage.init(named: "icon_back_normal"), for: UIControlState.normal)
        backBtn.addTarget(self, action: #selector(back), for: UIControlEvents.touchUpInside)
        let tableViewFrame = CGRect.init(x: 0,
                                         y: 65,
                                         width: ScreenWidth,
                                         height: ScreenHeight - 45)
        tableView = UITableView.init(frame: tableViewFrame)
        tableView.delegate = manager
        tableView.dataSource = manager
        tableView.backgroundColor = UIColor.clear
        tableView.tableFooterView = UIView()
        self.view.addSubview(tableView)
        self.view.addSubview(backBtn)
    }
    
    func back() {
        self.navigationController?.popViewController(animated: true)
    }
    
}
