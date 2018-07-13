//
//  ViewController.swift
//  Demo4
//
//  Created by liuming on 2018/7/13.
//  Copyright © 2018年 yoyo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let glView:OpenGLView = OpenGLView.init(frame:CGRect.init(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height));
        self.view.addSubview(glView);
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

