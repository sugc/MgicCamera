//
//  WallPaperViewController.swift
//  MagicCamera
//
//  Created by SuGuocai on 2017/12/21.
//  Copyright © 2017年 sugc. All rights reserved.
//

import Foundation

class WallPaperViewController: UIViewController {
    //
    var tableView : UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
    }
    
    func layout() {
        //
        tableView = UITableView.init(frame: CGRect.zero)
    }
    
    //获取设置的图片
    func getData() {
        
    }
}
