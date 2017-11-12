//
//  FilterManager.swift
//  MagicCamera
//
//  Created by sugc on 2017/9/22.
//  Copyright © 2017年 sugc. All rights reserved.
//

import Foundation

struct FilterThemeModle {
    init(path:String, dic:Dictionary<String,Any>) {
        themeID = path + "/" + (dic["themeID"] as! String)
        themeName = dic["themeName"] as! String
        themeImagePath = path + "/" + themeName + "/template.jpg"
        let filterConfigPath = path + "/" + themeName + "/filterConfig.plist"
        let filterArray = NSArray.init(contentsOfFile: filterConfigPath) as! Array<Dictionary<String, Any>>
        filterNumber = filterArray.count
        for dic in filterArray {
            let filterInfo = FilterInfo.init(path: path + "/" + themeName, dic: dic)
            filterInfos.append(filterInfo)
        }
    }
    
    var themeID : String!
    var themeName : String!
    var themeImagePath : String!
    var filterNumber : Int!
    var filterInfos : Array<FilterInfo>! = []
}

struct FilterInfo {
    
    init(path:String, dic:Dictionary<String,Any>) {
        filterID = dic["filterId"] as! String
        filterPath = path + filterID
        filterName = path + "/" + (dic["filterName"] as! String)
        lookImageName = path + "/" + filterID + "/lookup.png"
        thumderImageName = path + "/" + filterID + "/template.jpg"
    }
    
    var filterID : String!
    var filterPath : String!
    var filterName : String!
    var lookImageName : String!
    var thumderImageName : String!
}

class FilterManager {
    
    var configArray : Array<FilterThemeModle>!
    
    //初始化
    init() {
        //
    }
    
    convenience init(cofigPath:String) {
        let arrayPath = cofigPath + "/" + "config.plist"
        let array = NSArray.init(contentsOfFile: arrayPath) as! Array<Dictionary<String, Any>>
        self.init(configPath:cofigPath, configArray: array)
    }
    
    convenience init(configPath:String, configArray:Array<Dictionary<String, Any>>) {
        self.init()
        //
        var tempArray : Array<FilterThemeModle> = []
        for dic in configArray {
            let filterInfo = FilterThemeModle.init(path: configPath, dic: dic)
            tempArray.append(filterInfo)
        }
        self.configArray = tempArray
    }
    
    func getAllFilterInfo() ->Void {
        //
    }
    
    //获取滤镜链
    func getFilter(type:Int!, filePath:String!) -> Void {
        //
    }
}




