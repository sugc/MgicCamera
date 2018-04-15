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
    private var array : Array<Dictionary<String,Any>>? = nil
    
    override init() {
        super.init()
        //打开数据库
        dbMamager = DBManager.init(dbName: "pomeloDB")
        let isSuccess = createTableIfNeeded()
        
        if isSuccess {
            addDefaultImageIfNeed()
        }
    }
    
    func createTableIfNeeded() -> Bool {
        let sqlStr = "CREATE TABLE if not exists wallPapper (ID integer PRIMARY KEY autoincrement,  image blob NOT NULL)"
        let isSuccess = dbMamager.excuteUpdate(sqlString: sqlStr)
        print("")
        return isSuccess
    }
    
    func inserImage(image:UIImage) ->Bool {
        let data = UIImagePNGRepresentation(image)
        let sql = "insert into wallPapper (image) values (?)"
        let isSuccess = dbMamager.executeUpdate(sql: sql, Arguments: [data!])
        if isSuccess {
            let id = dbMamager.lastRowId()
            let dic : Dictionary<String,Any> = ["ID":id,"image":data!]
            array?.append(dic)
        }else {
            print("insert failure")
        }
        return isSuccess
    }
    
    
    func getAllImageFromDb() -> Array<Dictionary<String,Any>>?  {
        let sql = "select ID, image from wallPapper order by ID asc"
        return dbMamager.executeQuery(sql: sql)
    }
    
    func getAllImage() -> Array<UIImage> {
        
        if array == nil {
            array = getAllImageFromDb()
        }
        
        var returnArray : Array<UIImage> = []
        
        for dic in array! {
            let data = dic["image"] as! Data
            let image = UIImage.init(data: data)
            returnArray.append(image!)
        }
        return returnArray;
    }
    
    //加入默认图片
    func addDefaultImageIfNeed() {
        let hasAddImage = UserDefaults.standard.bool(forKey: "hasAddDefaultWallPaper")
        if !hasAddImage {
            UserDefaults.standard.set(true, forKey: "hasAddDefaultWallPaper")
            let image = UIImage.init(named: "model1.jpg")
            inserImage(image: image!)
        }
    }
    
    func deleteImageAtIndex(index:NSInteger) ->Bool {
        //
        let ID = array![index]["ID"]
        let sql = String.init(format: "delete from wallPapper where ID = %ld", ID as! CVarArg)
        let isSuccess = dbMamager.excuteUpdate(sqlString: sql)
        if isSuccess {
            array?.remove(at: index)
        }
        return isSuccess
    }
    
    deinit {
        
    }
}
