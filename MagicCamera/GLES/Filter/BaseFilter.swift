//
//  BaseFilter.swift
//  Purika
//
//  Created by zj－db0548 on 2017/1/20.
//  Copyright © 2017年 魔方. All rights reserved.
//

import Foundation

class BaseFilter {
    
    var program : GLProgram!
    var texture : GLTexture!
    var fbo : GLFrameBuffer!
    var context : EAGLContext!
    
    var textureSlot : GLuint = 0 //纹理
    var positionSlot : GLuint = 0 //绘图位置
    var textureCoordsSlot : GLuint! //纹理范围
    var textPosition : Array<GLfloat> = []
    var textureScale : Array <GLfloat> = []

    var vertString : String!
    var fragString : String!
    var size : CGSize = UIScreen.main.bounds.size
    var rawImagePixelsTemp : UnsafeMutablePointer<GLubyte>?
    
    var backGoundImage : UIImage! = nil
    
    required init() {
       
    }
    
    required init(vString : String, fString : String ){
        vertString = vString
        fragString = fString

    }
    
    
    //初始化openGL
    func prepare () {
        
        context = EAGLContext(api: EAGLRenderingAPI.openGLES3)
        EAGLContext.setCurrent(context)
        
        fbo = GLFrameBuffer(size: self.size)
        program = GLProgram(vSring: vertString, fString: fragString)
        addImageSource()
        
        //必须在gl环境初始化完成后再生成纹理
        if backGoundImage != nil {
            texture = GLTexture(image: backGoundImage)
        }
        getAttr()
    }
    
    //设置纹理, GL_TEXTURE0 已经被使用
    func addImageSource() {
        
    }
    
    //获取参数
    func getAttr() {
        positionSlot = program.getAttribute(key: "Position")
        textureCoordsSlot = program.getAttribute(key: "TextureCoords")
        textureSlot = program.getUniform(key: "Texture")
    }
    
    func render(){
//        glClearColor(0.0, 1.0, 1.0, 1.0)
//        glClear(GLbitfield(GL_COLOR_BUFFER_BIT));
        glViewport(0, 0, GLsizei(size.width), GLsizei(size.height));
        glActiveTexture(GLenum(GL_TEXTURE2))
        glBindTexture(GLenum(GL_TEXTURE_2D), texture.textureId)
        glUniform1i(GLint(textureSlot), 2);

        let i = Int32(glCheckFramebufferStatus(GLenum(GL_FRAMEBUFFER)))
        if i == GL_FRAMEBUFFER_UNSUPPORTED {
            print("GL_FRAMEBUFFER_UNSUPPORTED")
        }
        
        glVertexAttribPointer(textureCoordsSlot, 2, GLenum(GL_FLOAT), GLboolean(GL_FALSE), 0, textureScale);
        glEnableVertexAttribArray(textureCoordsSlot);
        glVertexAttribPointer(GLuint(positionSlot), 3, GLenum(GL_FLOAT), GLboolean(GL_FALSE), 0, textPosition);
        glEnableVertexAttribArray(GLuint(positionSlot));
        
        let indices : Array <GLubyte> = [
            0,1,2,
            1,2,3
        ]
        
        glDrawElements(GLenum(GL_TRIANGLES), 6, GLenum(GL_UNSIGNED_BYTE), indices);
        context?.presentRenderbuffer(Int(GL_RENDERBUFFER))
    }

    //从FBO中获取图片
    func getSaveImage()->UIImage {
        let length = Int(size.width * size.height * 4)
        rawImagePixelsTemp = UnsafeMutablePointer<UInt8>.allocate(capacity:length)
        glReadPixels(0,
                     0,
                     GLsizei(size.width),
                     GLsizei(size.height),
                     GLenum(GL_RGBA),
                     GLenum(GL_UNSIGNED_BYTE),
                     rawImagePixelsTemp)
        
        let dataProvider = CGDataProvider(dataInfo: nil,
                                          data: rawImagePixelsTemp!,
                                          size: length,
                                          releaseData: {info,data,size in
                                        print("aaaaaa%d",size)
                                            data.deallocate(bytes: size, alignedTo: 1)
        })
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        let imageFromByte = CGImage(width: Int(size.width),
                                    height: Int(size.height),
                                    bitsPerComponent: 8,
                                    bitsPerPixel: 32,
                                    bytesPerRow: 4 * Int(size.width),
                                    space: colorSpace,
                                    bitmapInfo: CGBitmapInfo(),
                                    provider: dataProvider!,
                                    decode: nil,
                                    shouldInterpolate: false,
                                    intent: .defaultIntent)
        
        let returnImage = UIImage(cgImage:imageFromByte!)
        return returnImage
    }

    deinit {
        print("release basefilter")
    }
    
    func clear() {

    }
}
