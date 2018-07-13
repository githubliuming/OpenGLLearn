//
//  ViewController.swift
//  Demo3
//
//  Created by liuming on 2018/7/12.
//  Copyright © 2018年 yoyo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var drawnView:DrawnView?;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let y:CGFloat = (self.view.frame.size.height - self.view.bounds.width)/2.0;
        
        self.drawnView = DrawnView.init(frame: CGRect.init(x: 0, y: y, width: self.view.frame.size.width, height: self.view.frame.width));
        self.drawnView?.image = UIImage.init(named: "WechatIMG29.jpeg");
        self.view.addSubview(self.drawnView!);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

