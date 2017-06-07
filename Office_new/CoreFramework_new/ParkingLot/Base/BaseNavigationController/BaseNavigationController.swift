//
//  BaseNavigationController.swift
//  Office
//
//  Created by roger on 2017/3/29.
//  Copyright © 2017年 roger. All rights reserved.
//


open class BaseNavigationController: UINavigationController {
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        //导航栏不透明
        navigationBar.isTranslucent = false
        //导航栏背景色
        navigationBar.barTintColor = UIColor.B1
        //导航栏字体颜色
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        //导航栏按钮颜色
        navigationBar.tintColor = UIColor.white
        
        //设置statusBar的字体颜色（第一步：在Info.plist中设置UIViewControllerBasedStatusBarAppearance 为NO）
        //此方法在iOS9之后作废
//        UIApplication.shared.statusBarStyle = .lightContent
        
        //设置title文字大小
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont.normal(18)]
        
        //去掉返回按钮上的文字
        let leftBar = UIBarButtonItem.appearance()
        leftBar.setBackButtonTitlePositionAdjustment(UIOffsetMake(0, -60), for: .default)
        
        //设置返回按钮的图片
        navigationBar.backIndicatorImage = #imageLiteral(resourceName: "icon_back")
        navigationBar.backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "icon_back")
    }

    //首选状态栏样式
    open override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
}
