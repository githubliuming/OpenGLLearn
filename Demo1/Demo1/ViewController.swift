//
//  ViewController.swift
//  Demo1
//
//  Created by liuming on 2018/7/11.
//  Copyright © 2018年 yoyo. All rights reserved.
//

import UIKit
import GLKit
import OpenGLES.ES2
class ViewController: UIViewController {
    
    private var context:EAGLContext = EAGLContext.init(api:.openGLES2)!;
    private var effect:GLKBaseEffect = GLKBaseEffect.init();
    private var buffer:GLuint = 0;
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupConfig();
        loadTexture();
        initVertexCoordinates();
    }
    func setupConfig(){
        
        let glView:GLKView = self.view as! GLKView;
        glView.context = context;
        //设置渲染颜色格式
        glView.drawableColorFormat = .RGBA8888;
        //设置渲染深度
        glView.drawableDepthFormat = .format24;
        EAGLContext.setCurrent(context);
        
    }
    func initVertexCoordinates()  {
        
//        [-0.5 0]   [0,0.5]
        //前三位顶点坐标  后两位纹理坐标
        let vertext:[GLfloat] = [
            //左半部分
            0, 1.0, 0.0,    0.5, 0.0, //右下
            0, -1.0, 0.0,    0.5, 1.0, //右上
            -1.0, -1.0, 0.0,    0, 1.0, //左上
            
            0.0, 1.0, 0.0,    0.5, 0.0, //右下
            -1.0, -1.0, 0.0,   0, 1.0, //左上
            -1.0, 1.0, 0.0,   0.0, 0.0, //左下
            
            //右半部分
            1.0, 1.0, 0.0,     0.0, 0.0, //右下
            1.0, -1.0, 0.0,    0, 1.0, //右上
            0, -1.0, 0.0,     0.5, 1.0, //左上

            1.0, 1.0, 0.0,    0.0, 0.0, //右下
            0.0, -1.0, 0.0,   0.5, 1.0, //左上
            0.0, 1.0, 0.0,   0.5, 0.0, //左下
        ];
        //生成新缓存对象。并返回缓存buffer id
        glGenBuffers(1, &buffer);
        //将申请的缓存对象绑定到GL_ARRAY_BUFFER中
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), buffer);
        //将顶点数据拷贝到缓存对象中
        glBufferData(GLenum(GL_ARRAY_BUFFER), GLsizeiptr(MemoryLayout<GLfloat>.size * vertext.count) , vertext, GLenum(GL_STATIC_DRAW));
        
        //启用顶点
        glEnableVertexAttribArray(GLuint(GLKVertexAttrib.position.rawValue));
        glVertexAttribPointer(GLuint(GLKVertexAttrib.position.rawValue),
                              3,
                              GLenum(GL_FLOAT),
                              GLboolean(GL_FALSE),
                              GLsizei(MemoryLayout<GLfloat>.size * 5), nil);
        
        //启用纹理
        let offset :GLsizeiptr = MemoryLayout<GLfloat>.size * 3;
        glEnableVertexAttribArray(GLuint(GLKVertexAttrib.texCoord0.rawValue));
        glVertexAttribPointer(GLuint(GLKVertexAttrib.texCoord0.rawValue),
                              2,
                              GLenum(GL_FLOAT),
                              GLboolean(GL_FALSE),
                              GLsizei(MemoryLayout<GLfloat>.size * 5),
                              UnsafeRawPointer.init(bitPattern: offset));
        
        
    }
    
    func loadTexture() {
        
        let filePath :String = Bundle.main.path(forResource: "test", ofType: "jpg")!;
        
        do {
            //[GLKTextureLoaderOriginBottomLeft:false]
            let textureInfo:GLKTextureInfo = try GLKTextureLoader.texture(withContentsOfFile: filePath, options:nil);
            effect.texture2d0.enabled = GLboolean(GL_TRUE);
            effect.texture2d0.name = textureInfo.name;
            
        } catch let error {
            
            print("error is \(error.localizedDescription)");
        }
        
    }
    override     func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    deinit {
        
        if  buffer != 0 {
            EAGLContext.setCurrent(nil);
        }
    }
}

extension ViewController:GLKViewDelegate {
    func glkView(_ view: GLKView, drawIn rect: CGRect) {
        glClearColor(0.1, 0.5, 0.0, 1);
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT));
        effect.prepareToDraw();
        glDrawArrays(GLenum(GL_TRIANGLES), 0, 12);
        
    }
    
    
}

