//
//  LookUpFilter.swift
//  Purika
//
//  Created by zj－db0548 on 2017/1/26.
//  Copyright © 2017年 魔方. All rights reserved.
//

import Foundation

class LookUpFilter: BaseFilter {
    
    
    var lookupTexture : GLTexture!
    var lookupTextureSlot : GLuint = 0
    var lookupImage : UIImage!
    var sourceImage : UIImage! {
        didSet {
            size = CGSize(width: Int(sourceImage.size.width), height: Int(sourceImage.size.height))
        }
    }
    
    required init() {
        super.init()
        
    }
    
    required init(vString : String, fString : String ){
        super.init(vString: vString, fString: fString)
        textureScale = tmpTexCoords
        textPosition = tmpVertices
    }
    
    required init(lookupImage: UIImage) {
        
        var vertString : String!
        var fragString : String!
        let vertStringP = Bundle.main.path(forResource:"LookupVertex16", ofType: "glsl")
        
        let fragStringP = Bundle.main.path(forResource: "LookupFragment16", ofType: "glsl")
        do {
            vertString = try String(contentsOfFile: vertStringP!)
            fragString = try String(contentsOfFile: fragStringP!)
            
        }catch{
            print("read shader error")
        }
        
        super.init(vString : vertString, fString : fragString)
        textureScale = tmpTexCoords
        textPosition = tmpVertices
        self.lookupImage = lookupImage
    }
   
    
    override func addImageSource() {
        lookupTexture = GLTexture(image: lookupImage)
        texture = GLTexture(image: sourceImage)
    }
    
    override func getAttr() {
        positionSlot = program.getAttribute(key: "Position")
        textureCoordsSlot = program.getAttribute(key: "TextureCoords")
        textureSlot = program.getUniform(key: "Texture")
        lookupTextureSlot = program.getUniform(key: "lookupTexture")
        
    }
    
    override func render(){
        
        glViewport(0, 0, GLsizei(size.width), GLsizei(size.height));
        
        glActiveTexture(GLenum(GL_TEXTURE2))
        glBindTexture(GLenum(GL_TEXTURE_2D), texture.textureId)
        glUniform1i(GLint(textureSlot), 2);
        
        glActiveTexture(GLenum(GL_TEXTURE1))
        glBindTexture(GLenum(GL_TEXTURE_2D), lookupTexture.textureId)
        glUniform1i(GLint(lookupTextureSlot), 1);

        
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

}
