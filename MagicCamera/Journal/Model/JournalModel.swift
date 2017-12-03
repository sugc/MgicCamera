//
//  JournalModel.swift
//  Purika
//
//  Created by sugc on 28/06/2017.
//  Copyright © 2017 魔方. All rights reserved.
//

import Foundation

func RectFromStr(str:String) -> CGRect {
    
    let strArray = str.components(separatedBy: ",")
    
    if strArray.count != 4 {
        return CGRect.zero
    }
    
    let x = (strArray[0] as NSString).floatValue
    let y = (strArray[1] as NSString).floatValue
    let w = (strArray[2] as NSString).floatValue
    let h = (strArray[3] as NSString).floatValue
    
    return CGRect(x: CGFloat(x), y: CGFloat(y), width: CGFloat(w), height: CGFloat(h))
}

func SizeFromStr(str:String) ->CGSize {
    
    let strArray = str.components(separatedBy: ",")
    
    if strArray.count != 2 {
        return CGSize.zero
    }
    
    let w = (strArray[0] as NSString).floatValue
    let h = (strArray[1] as NSString).floatValue
    
    return CGSize(width: CGFloat(w), height: CGFloat(h))

}

struct textStruct {
    
    init(dic:Dictionary<String, Any>) {
        
        content = dic["content"] as! String
        let poisitionStr = dic["position"] as! String
        position = RectFromStr(str: poisitionStr)
        maxLength = dic["maxLength"] as! Int
        textColor = dic["textColor"] as! Int
        
        fontSize = dic["fontSize"] as! CGFloat
        let fontName = dic["fontName"] as! String
        var fontAttr = dic["fontAttr"] as! Dictionary<String, Any>
        
        let font = UIFont.init(name: fontName, size: fontSize)
        fontAttr[NSFontAttributeName] = font
        fontAttrDic = fontAttr
    }
    
    var fontAttrDic : Dictionary<String,Any>!
    var content : String!
    var position : CGRect!
    var maxLength : Int!
    var textColor : Int
    var fontSize : CGFloat!
    
}


struct decorateImageStruct {
    
    init(dic:Dictionary<String, Any>, currentPath: String!) {
        
        decorateImagegName = currentPath! + "/" + (dic["imageName"] as! String)
        let poisitionStr = dic["position"] as! String
        postion = RectFromStr(str: poisitionStr)
    }

    var decorateImagegName : String!
    var postion : CGRect!
}

struct JournalModel {
    
    init(configPath:String) {
        
        self.configPath = configPath
        
        let dicPath = configPath + "/" + "config.plist"
        let dic = NSDictionary(contentsOf:URL.init(fileURLWithPath: dicPath))!
        
        //解析所有字段
        sampleImage = configPath + "/" + (dic["sampleImage"] as! String)
        finalSize = SizeFromStr(str: dic["finalSize"] as! String)
        backColor = dic["backColor"] as? Int
        
        let backStr =  dic["backImage"] as? String
        if backStr != nil {
            backImage = configPath + "/" + backStr!
        }
        
        let foreStr = dic["foreImage"] as? String
        if foreStr != nil {
            foreImage = configPath + "/" + foreStr!
        }
        
        let decorateArray = dic["decorateImageArray"] as! Array<Dictionary<String, Any>>
        decorateImageArray = Array.init()
        for decorate in decorateArray {
            let dec = decorateImageStruct.init(dic: decorate, currentPath: configPath)
            decorateImageArray?.append(dec)
        }
        
        let textDicArray = dic["textArray"] as! Array<Dictionary<String, Any>>
        textArray = Array.init()
        for textDic in textDicArray  {
            let textStruc = textStruct.init(dic: textDic)
            textArray?.append(textStruc)
        }
        
        imageArray = Array.init()
        let imgArray = dic["imageArray"] as! Array<String>
        for str in imgArray {
            let frame = RectFromStr(str: str)
            imageArray.append(frame)
        }
    }
    
    var sampleImage : String?
    var configPath : String!
    var backColor : Int?
    var backImage : String?
    var foreImage : String?
    var imageArray : Array<CGRect>!
    var textArray : Array<textStruct>?
    var decorateImageArray : Array<decorateImageStruct>?
    var finalSize : CGSize!
}



























