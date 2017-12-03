//
//  SGLLongPicFilter.swift
//  Purika
//
//  Created by zj－db0548 on 2017/1/12.
//  Copyright © 2017年 魔方. All rights reserved.
//

import Foundation
import OpenGLES
import OpenGLES.ES3


class SGLLongPicFilter : BaseFilter {
    
    
    var ratio : Double = 0.5  {
        didSet {
    
        }
    }
    var images : Array <UIImage>! = [] {
        
        didSet {
            calculate()
        }
    }
    
    private var positionArray : Array<CGRect> = []
    
    required init() {
        super.init()
        
    }
    
    required init(vString : String, fString : String ){
        super.init(vString: vString, fString: fString)
        
    }
    
    convenience init(imageArray : Array<UIImage>) {
        var vertString : String!
        var fragString : String!
        let vertStringP = Bundle.main.path(forResource:"MTShaderVertex", ofType: "glsl")
        
        let fragStringP = Bundle.main.path(forResource: "MTShaderFragment", ofType: "glsl")
        do {
            vertString = try String(contentsOfFile: vertStringP!)
            fragString = try String(contentsOfFile: fragStringP!)
            
        }catch{
            print("read shader error")
        }

        self.init(vString : vertString, fString : fragString)
        images = imageArray
        calculate()
    }
    
    override func render(){
        
        //逐张渲染到FBO
        
        let textures = GLTexture.texturesWithImageArray(images: images)
        self.textureScale = tmpTexCoords
        for i in 0...((images?.count)! - 1) {
            self.texture.textureId = textures[i]
            if i != 0 {
                self.textureScale = getTextureScale()
            }else {
                self.textureScale = [
                    0.0, 1.0,
                    1.0, 1.0,
                    0.0, 0.0,
                    1.0, 0.0
                ]
            }
            
            let position = positionArray[i]
            self.textPosition = getGLPosition(glPosition: position, viewPort: size)
            
        
            super.render()
        }
    }
    
    //计算画布大小
    func calculate() {
        
        var maxW : CGFloat = 0.0
        
        for image in images! {
            
            if maxW < image.size.width {
                maxW = image.size.width
            }
            
        }
        
        if maxW > 1024 {
            maxW = 1024
        }
        for i in 0...((images?.count)! - 1) {
            let image = images?[i]
            
            var y = 0.0
            var height = 0.0
            
            if i != 0 {
                let temp = positionArray[i-1]
                y = Double(temp.origin.y.native + temp.size.height.native)
                
            }
            
            height = (Double(maxW.native * ((image?.size.height.native)! / (image?.size.width.native)!))) 
            
            if i != 0 {
                height = height * ratio
            }
            
            let position = CGRect(x:0,
                                  y: CGFloat(y),
                                  width: maxW,
                                  height: CGFloat(height))
            positionArray.append(position)
        }
        
        let height = (positionArray.last?.size.height)! + (positionArray.last?.origin.y)!
        size = CGSize(width: maxW,
                      height: height)
        
    }
    
    //计算图片位置
    func getGLPosition(glPosition : CGRect, viewPort : CGSize) ->Array<GLfloat>{
        
        let x = glPosition.origin.x / viewPort.width * 2 - 1
        let y = glPosition.origin.y / viewPort.height * 2 - 1
        let c = (glPosition.origin.x + glPosition.width) / viewPort.width * 2 - 1
        let d = (glPosition.origin.y + glPosition.height) / viewPort.height * 2 - 1

        
        let positios : Array<GLfloat> = [
            Float(x), Float(d),0,    //左上角
            Float(c), Float(d),0,     //右上角
            Float(x), Float(y),0,   //左下角
            Float(c), Float(y),0     //右下角
        ]
        return positios
    }
    
    func getTextureScale() -> Array<GLfloat> {
        let texScale : Array <GLfloat> = [
            0.0, 1.0,
            1.0, 1.0,
            0.0, 1.0 * (1 - GLfloat(ratio)),
            1.0, 1.0 * (1 - GLfloat(ratio))
        ]
        
        return texScale
    }
}











