//
//  GLProgram.swift
//  Purika
//
//  Created by zj－db0548 on 2017/1/20.
//  Copyright © 2017年 魔方. All rights reserved.
//

import Foundation


class GLProgram {
    
    var programId : GLuint = 0
    var vShader : GLuint = 0
    var fShader : GLuint = 0
    
    required init (){
        programId = glCreateProgram()
    }
    
    convenience init(vSring : String, fString : String) {
        self.init()
        
        vShader = compileShader(type: GLenum(GL_VERTEX_SHADER), ShaderString: vSring)
        fShader = compileShader(type: GLenum(GL_FRAGMENT_SHADER), ShaderString: fString)
        
        glAttachShader(programId, vShader)
        glAttachShader(programId, fShader)
        
        link()
        use()
    }
    
    func use() {
        glUseProgram(programId)
        
    }
    
    func link()  {
        glLinkProgram(programId)
    }
    
    
    func compileShader(type: GLenum ,ShaderString: String!)->GLuint{
        
        var shader : GLuint!
        var status : GLint = 0
        var source : UnsafePointer<GLchar>?
        
        source = UnsafePointer<GLchar>(ShaderString)
        var sourceLength = GLint(ShaderString.lengthOfBytes(using: String.Encoding.utf8))
        if source == nil {
            
            return 0
        }
        
        shader  = glCreateShader(type)
        let cString = ShaderString.cString(using: String.Encoding.utf8)
        var tempString : UnsafePointer<GLchar>? =  UnsafePointer<GLchar>(cString)
        glShaderSource(shader, 1,&tempString, &sourceLength)
        glCompileShader(shader)
        
        glGetShaderiv(shader, GLenum(GL_COMPILE_STATUS), &status)
        
        if status == GL_FALSE {
            print("_______________________________error")
        }
        
        return shader
    }

    func getAttribute(key : String) -> GLuint {
        let id = glGetAttribLocation(programId, key)
        return GLuint(id)
    }
    
    func getUniform (key : String) -> GLuint {
        let id = glGetUniformLocation(programId, key)
        return GLuint(id)
    }
    
    deinit {
        glDeleteShader(vShader)
        glDeleteShader(fShader)
        glDeleteProgram(programId)
    }
}





