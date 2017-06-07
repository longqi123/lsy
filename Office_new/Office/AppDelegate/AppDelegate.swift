//
//  AppDelegate.swift
//  Office
//
//  Created by roger on 2017/3/29.
//  Copyright © 2017年 roger. All rights reserved.
//

import UIKit
import CoreFramework
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,NIMLoginManagerDelegate {

    var window: UIWindow?
    fileprivate var sdkConfigDelegate: NTESSDKConfigDelegate? = nil

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let appKey2 = CSSDemoConfig.shared().appKey
        let cerName2 = CSSDemoConfig.shared().cerName
        NIMSDK.shared().register(withAppID: appKey2!, cerName: cerName2)
        NIMCustomObject.registerCustomDecoder(CSSCustomAttachmentDecoder())
        CSKit.shared().provider = CSSDataManager.sharedInstance()
        CSSLogManager.shared().start()
        
        
        //本地通知
//        let uns = UIUserNotificationSettings(types: [.alert,.badge,.sound], categories: nil)
//        UIApplication.shared.registerUserNotificationSettings(uns)
        
        //.alert为通知样式，.sound为通知伴有声音，.badge为桌面应用图标的右上角红色数字`
//        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (success, error) in
//            if success{
//                print("获取权限成功")
//            }
//            else{
//                print("获取权限失败")
//            }
//        }
        
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge]) { (granted, error) in
                if granted {
                    print("用户允许")
                } else {
                    print("用户不允许")
                }
            }
            
            // 1. 创建通知内容
            let content = UNMutableNotificationContent()
            content.title = "title"
            content.body = "body"
            content.subtitle = "subTile"
            
            // 2. 创建发送触发
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            
            // 3. 发送请求标识符
            let requestIdentifier = "com.onevcat.usernotification.myFirstNotification"
            // 4. 创建一个发送请求
            let request = UNNotificationRequest(identifier: requestIdentifier, content: content, trigger: trigger)
            // 将请求添加到发送中心
            UNUserNotificationCenter.current().add(request) { error in
                if error == nil {
                    print("Time Interval Notification scheduled: \\\\(requestIdentifier)")
                }
            }
        } else {
            // Fallback on earlier versions
        }
        
        //IM
        //setupNIMSDK
        self.sdkConfigDelegate = NTESSDKConfigDelegate()
        NIMSDKConfig.shared().delegate = self.sdkConfigDelegate
        NIMSDKConfig.shared().shouldSyncUnreadCount = false
        NIMSDKConfig.shared().maxAutoLoginRetryTimes = 10
//        let appKey = NTESDemoConfig.shared().appKey
//        let cerName = NTESDemoConfig.shared().cerName
//        NIMSDK.shared().register(withAppID: "1ee5a51b7d008254cd73b1d4369a9494", cerName: cerName)
//        NIMCustomObject.registerCustomDecoder(NTESCustomAttachmentDecoder())
        NIMKit.shared().registerLayoutConfig(NTESCellLayoutConfig.self)
        //setupServices
//        NTESLogManager.shared().start()
        NTESNotificationCenter.shared().start()
        NTESSubscribeManager.sharedInstance().start()
        //registerAPNs
        UIApplication.shared.registerForRemoteNotifications()
        let types: UIUserNotificationType = UIUserNotificationType.badge
        let settings: UIUserNotificationSettings = UIUserNotificationSettings.init(types: types, categories: nil)
        UIApplication.shared.registerUserNotificationSettings(settings)
        //commonInitListenEvents
        NIMSDK.shared().loginManager.add(self as! NIMLoginManagerDelegate)
        
       
//        root.present(LoginViewController(), animated: false, completion: nil)
        
        buildKeyWindow()
        LocalNotification.addNotification()
        return true
    }

    private func buildKeyWindow() {
        let rect = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)

        window = UIWindow(frame: rect)
        let isFristOpen = UserDefaults.standard.object(forKey: "isFristOpenApp")
        if isFristOpen == nil {
            window?.rootViewController = GuideViewController()
            UserDefaults.standard.set("isFristOpenApp", forKey: "isFristOpenApp")
        } else {
            let root = LoginViewController()
            self.window?.rootViewController = root
        }
        window?.makeKeyAndVisible()
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}
