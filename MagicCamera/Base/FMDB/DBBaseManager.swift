//
//  DBBaseManager.swift
//  MagicCamera
//
//  Created by SuGuocai on 2018/2/2.
//  Copyright © 2018年 sugc. All rights reserved.
//

import Foundation
import FMDB

class DBManager: NSObject {
    private var dbHandler : FMDatabase!
    
    //初始化并打开数据库
    init(dbName:String!) {
        //拼接路径
        super.init()
        var path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
        path = path! + "/" + dbName
        
        dbHandler = FMDatabase.init(path: path)
        let isOpen = dbHandler.open()
        if !isOpen {
            //
            print("dataBase init failure")
        }
    }
    
    
    //关闭数据库
    func close() {
        let isClose = dbHandler!.close()
        if !isClose {
            print("close dataBase failure")
        }
    }
    
    
    //执行sql语句
    func excuteUpdate(sqlString:String!) -> Bool {
        
        var isSuccess = true
        do {
            try self.dbHandler.executeUpdate(sqlString, values: [])
        }catch {
            //处理相关错误
            isSuccess = false
        }
        
        return isSuccess
    }
    
}









