//
//  WallPaperViewController.swift
//  MagicCamera
//
//  Created by SuGuocai on 2017/12/21.
//  Copyright © 2017年 sugc. All rights reserved.
//

import Foundation

class WallPaperViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    //
    var tableView : UITableView!
    var imageArray : Array<Any>!
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
        //
        let fileManager = FileManager.init()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    //tableView delegate and datasource
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "wallPapperVCCell")
        if cell == nil {
            cell = UITableViewCell.init(style: UITableViewCellStyle.value1, reuseIdentifier: "wallPapperVCCell")
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
    }
}
