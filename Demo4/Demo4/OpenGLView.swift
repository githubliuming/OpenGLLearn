//
//  OpenGLView.swift
//  Demo4
//
//  Created by liuming on 2018/7/13.
//  Copyright © 2018年 yoyo. All rights reserved.
//

import Foundation
import OpenGLES.ES2
import UIKit

class OpenGLView: UIView {
    private var context: EAGLContext = EAGLContext(api: EAGLRenderingAPI.openGLES2)!

    private var colorRenderBuffer: GLuint = 0
    private var frameBuffer: GLuint = 0

    open override class var layerClass: Swift.AnyClass {
        return CAEAGLLayer.self
    }

    open func setupLayer() {
        let glLayer: CAEAGLLayer! = currentGLLayer()!
        // 设置 CAEAGLLayer 的透明度
        glLayer.opacity = 1.0
        glLayer.drawableProperties = [
            kEAGLDrawablePropertyRetainedBacking: false,
            kEAGLDrawablePropertyColorFormat: kEAGLColorFormatRGBA8,
        ]
    }

    private func setContext() {
        if EAGLContext.setCurrent(context) == false {
            print("config contenxt error")
            exit(1)
        }
    }

    private func currentGLLayer() -> CAEAGLLayer? {
        guard let glLayer: CAEAGLLayer = self.layer as? CAEAGLLayer else {
            print(" self layer can not convert to CAEAGLLayer")
            return nil
        }
        return glLayer
    }

    /// 申请并绑定 renderBuffer
    private func setRenderBuffer() {
        glGenRenderbuffers(1, &colorRenderBuffer)
        glBindRenderbuffer(GLenum(GL_RENDERBUFFER), colorRenderBuffer)
        context.renderbufferStorage(Int(GL_RENDERBUFFER), from: currentGLLayer())
    }

    /// 申请并绑定frameBuffer
    private func setFrameBuffer() {
        glGenFramebuffers(1, &frameBuffer)
        glBindFramebuffer(GLenum(GL_FRAMEBUFFER), frameBuffer)
        glFramebufferRenderbuffer(GLenum(GL_FRAMEBUFFER),
                                  GLenum(GL_COLOR_ATTACHMENT0),
                                  GLenum(GL_RENDERBUFFER),
                                  colorRenderBuffer)
    }

    /// 销毁申请的buffer
    private func destoryRenderAndFrameBuffer() {
        if colorRenderBuffer != 0 {
            glDeleteRenderbuffers(1, &colorRenderBuffer)
        }
        if frameBuffer != 0 {
            glDeleteFramebuffers(1, &frameBuffer)
        }
        colorRenderBuffer = 0
        frameBuffer = 0
    }

    private func render() {
        glClearColor(1.0, 0.5, 0.3, 0)
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT))
        context.presentRenderbuffer(Int(GL_RENDERBUFFER))
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setupLayer()
        setContext()
        destoryRenderAndFrameBuffer()
        setRenderBuffer()
        setFrameBuffer()
        render()
    }
}
