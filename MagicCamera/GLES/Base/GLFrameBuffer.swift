//
//  GLFrameBuffer.swift
//  Purika
//
//  Created by zj－db0548 on 2017/1/20.
//  Copyright © 2017年 魔方. All rights reserved.
//

import Foundation


class GLFrameBuffer {
    
    var framebufferId : GLuint = 0
    var renderbufferId : GLuint = 0
    var size : CGSize = CGSize.zero
    
    required init (){
        
    }
    
    convenience init (size : CGSize) {
        self.init()
        self.size = size
        setUpFrameBuffer()
    }
    
    func setUpFrameBuffer () {
        
        glGenRenderbuffers(1, &renderbufferId)
        glBindRenderbuffer(GLenum(GL_RENDERBUFFER), renderbufferId)
        
        glGenFramebuffers(1, &framebufferId)
        glBindFramebuffer(GLenum(GL_FRAMEBUFFER), framebufferId)
        
        glRenderbufferStorage(GLenum(GL_RENDERBUFFER), GLenum(GL_RGBA8_OES), GLsizei(size.width), GLsizei(size.height))
        glFramebufferRenderbuffer(GLenum(GL_FRAMEBUFFER), GLenum(GL_COLOR_ATTACHMENT0), GLenum(GL_RENDERBUFFER), framebufferId)
    }
    
    deinit {
        glDeleteRenderbuffers(1, &renderbufferId)
        glDeleteFramebuffers(1, &framebufferId)
    }
}
