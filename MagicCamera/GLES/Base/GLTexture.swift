//
//  GLTexture.swift
//  Purika
//
//  Created by zj－db0548 on 2017/1/20.
//  Copyright © 2017年 魔方. All rights reserved.
//

import Foundation


class GLTexture {
    
    
    var textureId : GLuint = 0
    var textureSize : CGSize = CGSize.zero
    
    required init (){
        
    }
    
    convenience init(image : UIImage){
        self.init()
        textureId = texture(image: image)
    }

    func texture(image : UIImage) -> GLuint{
        
        let width : Int = Int(image.size.width)
        let height : Int = Int(image.size.height)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let imageData = UnsafeMutablePointer<GLubyte>.allocate(capacity: width * height * 4)
        
        let cgContext = CGContext(data: imageData, width: width, height: height, bitsPerComponent: 8, bytesPerRow: 4 * width, space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Big.rawValue)

        cgContext?.draw(image.cgImage!, in: CGRect(x: 0,
                                                   y: 0,
                                                   width: width,
                                                   height: height))
        
        //顺序很重要
        glEnable(GLenum(GL_TEXTURE_2D))
        glGenTextures(1, &textureId)
        glBindTexture(GLenum(GL_TEXTURE_2D), textureId)
        
        glTexImage2D(GLenum(GL_TEXTURE_2D),
                     0,
                     GL_RGBA,
                     GLsizei(width),
                     GLsizei(height),
                     0,
                     GLenum(GL_RGBA),
                     GLenum(GL_UNSIGNED_BYTE),
                     imageData)
        
        //设置不重复填充
        glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_WRAP_S), GL_CLAMP_TO_EDGE);
        glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_WRAP_T), GL_CLAMP_TO_EDGE);
        glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_MIN_FILTER),GL_LINEAR);
        glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_MAG_FILTER),GL_LINEAR);
        imageData.deallocate()
        return textureId
    }
    
    func delete() {
//        glDeleteTextures(1, &textureId)
    }
    
    static func getTexture(count : NSInteger) {
        var texures : Array<GLuint> = Array<GLuint>.init(repeating: 0, count: count)
        glGenTextures(GLsizei(count), &texures)
        for i in 0...count {
            glBindBuffer(GLenum(GL_TEXTURE_2D), texures[i])
        }
    }
    
    
    //一次性获取多个纹理
    static func texturesWithImageArray(images : Array<UIImage>)->Array<GLuint>{
        let count = images.count
        var texures : Array<GLuint> = Array<GLuint>.init(repeating: 0, count: count)
        glEnable(GLenum(GL_TEXTURE_2D))
        glGenTextures(GLsizei(count), &texures)
        
        for i in 0...(count - 1) {
            let image : UIImage = images[i] 
            let width = Int(image.size.width)
            let height = Int(image.size.height)
            let colorSpace = CGColorSpaceCreateDeviceRGB()
            let imageData = UnsafeMutablePointer<GLubyte>.allocate(capacity: width * height * 4)
            
            let cgContext = CGContext(data: imageData, width: width, height: height, bitsPerComponent: 8, bytesPerRow: 4 * width, space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Big.rawValue)
            
            cgContext?.draw(image.cgImage!, in: CGRect(x: 0,
                                                       y: 0,
                                                       width: width,
                                                       height: height))
            
            glBindBuffer(GLenum(GL_TEXTURE_2D), texures[i])
            glTexImage2D(GLenum(GL_TEXTURE_2D),
                         0,
                         GL_RGBA,
                         GLsizei(width),
                         GLsizei(height),
                         0,
                         GLenum(GL_RGBA),
                         GLenum(GL_UNSIGNED_BYTE),
                         imageData)

            glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_WRAP_S), GL_CLAMP_TO_EDGE);
            glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_WRAP_T), GL_CLAMP_TO_EDGE);
            glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_MIN_FILTER),GL_LINEAR);
            glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_MAG_FILTER),GL_LINEAR);
            imageData.deallocate()
        }
        return texures
    }
    
    deinit {
        glDeleteTextures(1, &textureId)
    }
    
}







