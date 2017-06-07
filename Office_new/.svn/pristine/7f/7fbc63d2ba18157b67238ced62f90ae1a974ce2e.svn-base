//
//  LocalNotification.swift
//  Office
//
//  Created by roger on 2017/6/6.
//  Copyright © 2017年 roger. All rights reserved.
//

import Foundation

class LocalNotification: NSObject {
    
    /** 添加创建并添加本地通知 */
    class func addNotification() {
        // 初始化一个通知
        let localNoti = UILocalNotification()
        
        // 通知的触发时间，例如即刻起15分钟后
        
        localNoti.fireDate = NSDate(timeIntervalSinceNow: 10) as Date
        // 设置时区
        localNoti.timeZone = NSTimeZone.default
        // 通知上显示的主题内容
        localNoti.alertBody = "通知上显示的提示内容"
        // 收到通知时播放的声音，默认消息声音
        localNoti.soundName = UILocalNotificationDefaultSoundName
        //待机界面的滑动动作提示
        localNoti.alertAction = "打开应用"
        // 应用程序图标右上角显示的消息数
        localNoti.applicationIconBadgeNumber = 0
        // 通知上绑定的其他信息，为键值对
        localNoti.userInfo = ["id": "1",  "name": "xxxx"]
        
        // 添加通知到系统队列中，系统会在指定的时间触发
        UIApplication.shared.scheduleLocalNotification(localNoti)
    }
    
}
