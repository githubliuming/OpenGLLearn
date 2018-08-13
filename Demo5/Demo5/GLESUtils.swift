//
//  GLESUtils.swift
//  Demo5
//
//  Created by liuming on 2018/7/13.
//  Copyright © 2018年 yoyo. All rights reserved.
//

import Foundation
import OpenGLES.ES2
class GLESUtils: NSObject {
    //    public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)
    open class func loadShader(shaderType type: GLenum,
                               shaderPath path: String) -> GLuint {
        do {
            let shaderString: String = try! String(contentsOfFile: path, encoding: .utf8)
            return loadShader(shaderType: type, shaderString: shaderString)
        }
    }

    open class func loadShader(shaderType type: GLenum, shaderString shaderStr: String) -> GLuint {
        let shader = glCreateShader(type)
        if shader == 0 {
            print("Error: failed to create shder")
            return 0
        }

        var cStringSource = (shaderStr as NSString).utf8String
        glShaderSource(shader, GLsizei(1), &cStringSource, nil)
        glCompileShader(shader)
        var compiled: GLint = 0
        glGetShaderiv(shader, GLenum(GL_COMPILE_STATUS), &compiled)
        if compiled != 0 {
            var infoLen: GLint = 0
            glGetShaderiv(shader, GLenum(GL_INFO_LOG_LENGTH), &infoLen)

            if infoLen > 1 {
                var infoLog: Array<GLchar> = Array<GLchar>.init(repeating: 0, count: Int(infoLen))
                glGetShaderInfoLog(shader, GLsizei(infoLen), nil, &infoLog)
            }
        }

        return 0
    }
}
