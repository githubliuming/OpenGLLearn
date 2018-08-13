//
//  ViewController.swift
//  Demo2
//
//  Created by liuming on 2018/7/12.
//  Copyright © 2018年 yoyo. All rights reserved.
//

import GLKit
import OpenGLES
import UIKit
class ViewController: UIViewController {
    var glView: GLKView?
    var contex: EAGLContext = EAGLContext(api: .openGLES2)!
    var effect: GLKBaseEffect = GLKBaseEffect()
    // 纹理数组
    var textureArray: Array<GLKTextureInfo> = Array<GLKTextureInfo>.init()
    // 顶点数组
    var vertextArray: Array<[GLfloat]> = Array<[GLfloat]>.init()

    // 画中画的层级
    var level: Int = 4
    // 画中画的比例
    var scale: Double = 0.85

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let y: CGFloat = (view.bounds.size.height - view.bounds.size.width) / 2.0

        glView = GLKView(frame: CGRect(x: 0, y: y, width: view.bounds.size.width, height: view.bounds.size.width))
        glView?.delegate = self
        view.addSubview(glView!)

        glView?.context = contex
        glView?.drawableColorFormat = .RGBA8888
        glView?.drawableDepthFormat = .format24

        EAGLContext.setCurrent(contex)

        initVertext()
        loadTexture()
    }

    // 初始化顶点坐标
    func initVertext() {
        // 前三位顶点坐标  后两位纹理坐标
        let originVertex: [GLfloat] = [
            -1.0, -1.0, 0.0, 0.0, 1.0, // 左上
            1.0, -1.0, 0.0, 1.0, 1.0, // 右上
            -1.0, 1.0, 0.0, 0.0, 0.0, // 左下

            -1.0, 1.0, 0.0, 0.0, 0.0, // 左下
            1.0, -1.0, 0.0, 1.0, 1.0, // 右上
            1.0, 1.0, 0.0, 1.0, 0.0, // 右下
        ]
        vertextArray.append(originVertex)
        // 按照层级和比例关系生成画中画的顶点
        var nowLevel: Int = 1
        while nowLevel < level {
            let nowScale: Float = powf(Float(scale), Float(nowLevel))
            var index: Int = 0
            var nowVertex: Array<GLfloat> = Array<GLfloat>.init()
            let preIndex: Int = nowLevel - 1
            let preVertex: [GLfloat] = vertextArray[preIndex]
            while index < preVertex.count {
                let a: Int = index % 5
                if a <= 2 {
                    nowVertex.append(preVertex[index] * GLfloat(nowScale))
                } else {
                    nowVertex.append(preVertex[index])
                }
                index += 1
            }
            vertextArray.append(nowVertex)
            nowLevel += 1
        }
    }

    // 加载纹理
    func loadTexture() {
        do {
            let path1: String = Bundle.main.path(forResource: "WechatIMG29", ofType: "jpeg")!
            let bgTexture: GLKTextureInfo = try GLKTextureLoader.texture(withContentsOfFile: path1, options: nil)
            effect.texture2d0.enabled = GLboolean(GL_TRUE)
            effect.texture2d0.name = bgTexture.name
            effect.texture2d0.target = GLKTextureTarget(rawValue: bgTexture.target)!

        } catch let error {
            print("\n error is \(error)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: GLKViewDelegate {
    func glkView(_: GLKView, drawIn _: CGRect) {
        glClearColor(1.0, 0.3, 0.5, 1.0)
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT))
        effect.prepareToDraw()
        var index: Int = 0
        let count: Int = vertextArray.count
        while index < count {
            let vertex: [GLfloat] = vertextArray[index]

            var buffer: GLuint = 0
            glGenBuffers(1, &buffer)

            glBindBuffer(GLenum(GL_ARRAY_BUFFER), buffer)
            glBufferData(GLenum(GL_ARRAY_BUFFER), MemoryLayout<GLfloat>.size * vertex.count, vertex, GLenum(GL_STATIC_DRAW))

            glEnableVertexAttribArray(GLuint(GLKVertexAttrib.position.rawValue))
            glVertexAttribPointer(GLuint(GLKVertexAttrib.position.rawValue), 3, GLenum(GL_FLOAT), GLboolean(GL_FALSE), GLsizei(MemoryLayout<GLfloat>.size * 5), nil)

            let offset: GLsizeiptr = MemoryLayout<GLfloat>.size * 3
            glEnableVertexAttribArray(GLuint(GLKVertexAttrib.texCoord0.rawValue))
            glVertexAttribPointer(GLuint(GLKVertexAttrib.texCoord0.rawValue), 2, GLenum(GL_FLOAT), GLboolean(GL_FALSE), GLsizei(MemoryLayout<GLfloat>.size * 5), UnsafeRawPointer(bitPattern: offset))

            glDrawArrays(GLenum(GL_TRIANGLES), 0, 6)
            index += 1
        }
    }
}
