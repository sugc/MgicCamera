//
//  MixFilter.swift
//  Purika
//
//  Created by zj－db0548 on 2017/1/24.
//  Copyright © 2017年 魔方. All rights reserved.
//

import Foundation

//按照透明度混合两张图片
class MixFilter : BaseFilter {
    
    private var hasDrawBack = false  //是否已经画过背景图片
    var backGroundImage: UIImage!
    var drawImage : UIImage!
    var alphaUniform : GLuint! = 0
    var backAlpha : CGFloat = 1.0
    var drawAlpha : CGFloat = 1.0
    var drawTextureScale : Array <GLfloat> = tmpTexCoords
    var drawTextPosition : Array <GLfloat> = tmpVertices
    required init() {
        super.init()
        
    }
    
    required init(vString : String, fString : String ){
        super.init(vString: vString, fString: fString)
        textureScale = tmpTexCoords
        textPosition = tmpVertices
    }
    
    convenience init(backGroundImage: UIImage, drawImage:UIImage) {
        
        var vertString : String!
        var fragString : String!
        let vertStringP = Bundle.main.path(forResource:"MixVertex", ofType: "glsl")
        
        let fragStringP = Bundle.main.path(forResource: "MixFragment", ofType: "glsl")
        do {
             vertString = try String(contentsOfFile: vertStringP!)
             fragString = try String(contentsOfFile: fragStringP!)
            
        }catch{
            print("read shader error")
        }

        self.init(vString : vertString, fString : fragString)
        setImages(backGroundImage: backGroundImage, drawImage: drawImage)
    }
    
    
    override func getAttr() {
        super.getAttr()
        alphaUniform = program.getUniform(key: "alpha")
    }

    override func render(){
        
        if !hasDrawBack {
            hasDrawBack = true
            self.texture = GLTexture(image: backGroundImage)
            glUniform1f(GLint(alphaUniform), GLfloat(backAlpha))
            super.render()
        }
        
        glUniform1f(GLint(alphaUniform), GLfloat(drawAlpha))
        textureScale = drawTextureScale
        textPosition = drawTextPosition
        glEnable(GLenum(GL_BLEND))
        glBlendFunc(GLenum(GL_SRC_ALPHA), GLenum(GL_ONE_MINUS_SRC_ALPHA))
        self.texture = GLTexture(image: drawImage)
        super.render()
    }
    
    func setImages(backGroundImage: UIImage, drawImage: UIImage)  {
        self.backGroundImage = backGroundImage
        self.drawImage = drawImage
        self.size = backGroundImage.size
        //计算drawSize
    }
}






