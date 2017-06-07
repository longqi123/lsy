//
//  BaseTabBarViewController.swift
//  Office
//
//  Created by roger on 2017/3/29.
//  Copyright © 2017年 roger. All rights reserved.
//

import UIKit

open class BaseTabBarViewController: UITabBarController {

    override open func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.isTranslucent = false
    }

    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
