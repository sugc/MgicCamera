//
//  WallPapperDBMananer.swift
//  MagicCamera
//
//  Created by SuGuocai on 2018/2/2.
//  Copyright © 2018年 sugc. All rights reserved.
//

import Foundation

class WallPapperDBMananer : NSObject {
    
    var dbMamager : DBManager!
    override init() {
        super.init()
        
        //打开数据库
        dbMamager = DBManager.init(dbName: "wallPapper")
    }
    
    func createTableIfNeeded() -> Bool {
        
        let sqlStr = "CREATE TABLE wallPapper.papperImage(ID INT PRIMARY KEY    NOT NULL, ID INT PRIMARY KEY     NOT NULL)"
        
        return false
    }
    
}
