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
            print(error)
            isSuccess = false
        }
        
        return isSuccess
    }
    
    func executeUpdate(sql:String!, Arguments:Array<Any>) -> Bool {
        var isSuccess = true
        do {
            try self.dbHandler.executeUpdate(sql, values: Arguments)
        }catch {
            //处理相关错误
            print(error)
            isSuccess = false
        }
        
        return isSuccess
    }
    
    func executeQuery(sql:String!) -> Array<Dictionary<String, Any>> {
        
        
        return self.executeQuery(sql: sql, values: nil)
    }
    
    //查询
    func executeQuery(sql:String!, values:[Any]?) -> Array<Dictionary<String, Any>> {
        
        var result : FMResultSet? = nil
        do{
            try result = dbHandler.executeQuery(sql, values: values)
        }catch {
            
        }
        
        var array : Array<Dictionary<String, Any>> = []
//        let intcolumName = result?.columnName(for: 0)
        
        
        while (result?.next())! {
            let intValue = result?.int(forColumn: "ID")
            
            //        let imgColumName = result?.columnName(for: 1)
            let imgValue = result?.data(forColumn: "image")
            
            var dic : Dictionary<String, Any> = [:]
            
            dic["ID"] = intValue
            dic["image"] = imgValue
            array.append(dic)
        }
        
        
        return array
    }
   
}









