//
//  DrawnView.swift
//  Demo3
//
//  Created by liuming on 2018/7/12.
//  Copyright © 2018年 yoyo. All rights reserved.
//

import UIKit
import GLKit
import OpenGLES
class DrawnView: GLKView {
    
    public var image:UIImage?;
    
    /// 动画时长
    public var animationTime:Double = 5.0;
    /// 是否正在动画中
    public var isAnimation = false;
    ///动画计时器
    private var timer:Timer?;
    private var effect:GLKBaseEffect = GLKBaseEffect.init();
    private var hasLoadTexture = false;
    private var vertexArray :Array<[GLfloat]> = Array<[GLfloat]>.init();
    private let originVertex:[GLfloat] = [
        -1.0,-1.0,0.0,  0.0,1.0,  //左上
         1.0,-1.0,0.0,  1.0,1.0,  //右上
        -1.0,1.0,0.0,   0.0,0.0,  //左下
        
        -1.0,1.0,0.0,   0.0,0.0,  //左下
         1.0,-1.0,0.0,  1.0,1.0,  //右上
         1.0,1.0,0.0,    1.0,0.0   //右下
    ];
    override init(frame: CGRect) {
        super.init(frame: frame);
    
        self.drawableColorFormat = .RGBA8888;
        self.drawableDepthFormat = .format24;
        self.context = EAGLContext.init(api: EAGLRenderingAPI.openGLES2)!;
        self.delegate = self;
        vertexArray.append(originVertex);
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        fatalError("init(coder:) has not been implemented")
    }
    
    private func loadVertex()  {
        
        guard let img:UIImage = image as UIImage! else {
            print("image is nil!");
            return;
        }
        do {
            let textureInfo = try GLKTextureLoader.texture(with: img.cgImage!, options: nil);
            self.effect.texture2d0.enabled = GLboolean(GL_TRUE);
            self.effect.texture2d0.name = textureInfo.name;
            self.effect.texture2d0.target = GLKTextureTarget(rawValue: textureInfo.target)!;
        } catch let error {
            print("load texture is faild error info = \(error)");
        }
    }
    
    public func startAnimation(){
        //分割纹理
        
        startTimer();
    }
    
    private func invalidateTimer() {
        
        guard let t:Timer = timer as Timer! else {
            return;
        }
        t.invalidate();
        timer = nil;
        isAnimation = false;
    }
    private func startTimer() {
        invalidateTimer();
        timer = Timer.init(timeInterval: 1.0/60.0, repeats: true, block: { (t) in
            //1、跟新每块区域的顶点坐标
            //2、重新绘制
        });
    }
    
    /// 分割纹理
    private func splitVertexCrood(){
        
    }
}
extension DrawnView:GLKViewDelegate {
    func glkView(_ view: GLKView, drawIn rect: CGRect) {
        
        if EAGLContext.current() != self.context {
            EAGLContext.setCurrent(self.context);
        }
        if hasLoadTexture == false {
            loadVertex();
            hasLoadTexture = true;
        }
        
        glClearColor(1.0, 0.4, 0.6, 1);
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT));
        effect.prepareToDraw();
        for vertext:[GLfloat] in vertexArray {
            var buffer:GLuint = 0;
            glGenBuffers(1, &buffer);
            glBindBuffer(GLenum(GL_ARRAY_BUFFER), buffer);
            glBufferData(GLenum(GL_ARRAY_BUFFER),
                         MemoryLayout<GLfloat>.size * vertext.count,
                         vertext,
                         GLenum(GL_DYNAMIC_DRAW));
            //顶点属性
            glEnableVertexAttribArray(GLuint(GLKVertexAttrib.position.rawValue));
            glVertexAttribPointer(GLuint(GLKVertexAttrib.position.rawValue),
                                  3,
                                  GLenum(GL_FLOAT),
                                  GLboolean(GL_FALSE),
                                  GLsizei(MemoryLayout<GLfloat>.size * 5),
                                  nil);
            
            
           //纹理属性
            let offest:GLsizeiptr = MemoryLayout<GLfloat>.size * 3;
            glEnableVertexAttribArray(GLuint(GLKVertexAttrib.texCoord0.rawValue));
            glVertexAttribPointer(GLuint(GLKVertexAttrib.texCoord0.rawValue),
                                  2,
                                  GLenum(GL_FLOAT),
                                  GLboolean(GL_FALSE),
                                  GLsizei(MemoryLayout<GLfloat>.size * 5),
                                  UnsafePointer.init(bitPattern: offest));
            glDrawArrays(GLenum(GL_TRIANGLES), 0, 6);
        }
    }
}
