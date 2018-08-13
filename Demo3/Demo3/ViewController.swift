//
//  ViewController.swift
//  Demo3
//
//  Created by liuming on 2018/7/12.
//  Copyright © 2018年 yoyo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var drawnView: DrawnView?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        let y: CGFloat = (view.frame.size.height - view.bounds.width) / 2.0

        drawnView = DrawnView(frame: CGRect(x: 0, y: y, width: view.frame.size.width, height: view.frame.width))
        drawnView?.image = UIImage(named: "WechatIMG29.jpeg")
        view.addSubview(drawnView!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
