//
//  RootViewController.swift
//  Office
//
//  Created by roger on 2017/4/25.
//  Copyright © 2017年 roger. All rights reserved.
//

import AFNetworking
import UIKit
import CoreFramework

//定义一个结构体，存储认证相关信息
struct IdentityAndTrust {
    var identityRef:SecIdentity
    var trust:SecTrust
    var certArray:AnyObject
}

class RootViewController: BaseTabBarViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let workDesk = WorkDeskViewController()
        let workDeskNav = BaseNavigationController(rootViewController: workDesk)
        workDesk.title = "工作"
        workDeskNav.title = "工作"
        workDesk.tabBarItem.image = UIImage(named: "tab_1_normal")
        workDesk.tabBarItem.selectedImage = UIImage(named: "tab_1_selected")
        
        let messageCenter = MessageCenterViewController()
        let messageCenterNav = BaseNavigationController(rootViewController: messageCenter)
        messageCenter.title = "任务通知"
        messageCenterNav.title = "消息中心"
        messageCenter.tabBarItem.image = UIImage(named: "tab_2_normal")
        messageCenter.tabBarItem.selectedImage = UIImage(named: "tab_2_selected")
        
        let appSquare = AppSquareViewController()
        let appSquareNav = BaseNavigationController(rootViewController: appSquare)
        appSquare.title = "应用广场"
        appSquareNav.title = "应用广场"
        appSquare.tabBarItem.image = UIImage(named: "tab_3_normal")
        appSquare.tabBarItem.selectedImage = UIImage(named: "tab_3_selected")
        
        let addressList = AddressListViewController()
        let addressListNav = BaseNavigationController(rootViewController: addressList)
        addressList.title = "通讯录"
        addressListNav.title = "通讯录"
        addressList.tabBarItem.image = UIImage(named: "tab_4_normal")
        addressList.tabBarItem.selectedImage = UIImage(named: "tab_4_selected")
        
        viewControllers = [workDeskNav,messageCenterNav,appSquareNav,addressListNav]
        
    }
}
