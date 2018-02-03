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
        dbMamager = DBManager.init(dbName: "pomeloDB")
        let isSuccess = createTableIfNeeded()
        
        if !isSuccess {
            print("init dataBase failure")
        }
    }
    
    func createTableIfNeeded() -> Bool {
        
        let sqlStr = "CREATE TABLE if not exists wallPapper (ID integer PRIMARY KEY autoincrement,  image blob NOT NULL)"
        let isSuccess = dbMamager.excuteUpdate(sqlString: sqlStr)
        print("")
        return isSuccess
    }
    
    func inserImage(image:UIImage) {
        let data = UIImagePNGRepresentation(image)
        let sql = "insert into wallPapper (image) values (?)"
        let isSuccess = dbMamager.executeUpdate(sql: sql, Arguments: [data!])
        
        if !isSuccess {
            print("insert failure")
        }
    }
    
    
    func getAllImage() -> Dictionary<Int, UIImage> {
        
        let sql = "select ID, image from wallPapper order by number asc"
        
        let array = dbMamager.executeQuery(sql: sql)
        
        for dic in array {
            
            let data = dic["image"] as! Data
            let image = UIImage.init(data: data)
            
            print("")
        }
        
        
        return [:]
    }
    
    
}
