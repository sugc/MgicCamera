//
//  SettingViewController.swift
//  MagicCamera
//
//  Created by SuGuocai on 2017/12/19.
//  Copyright © 2017年 sugc. All rights reserved.
//

import Foundation
import UIKit

class SettingViewController: UIViewController, UITableViewDelegate {
    
    var tableView : UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    func layout() {
        tableView = UITableView.init(frame: self.view.bounds)
        tableView.delegate = self
        
        self.view.addSubview(tableView)
    }
    
    
    
}
