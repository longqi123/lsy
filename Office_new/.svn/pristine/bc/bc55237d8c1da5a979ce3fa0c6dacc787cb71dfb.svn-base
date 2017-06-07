//
//  AppSquareManager.swift
//  Office
//
//  Created by roger on 2017/3/31.
//  Copyright © 2017年 roger. All rights reserved.
//

import Foundation

class AppSquareManager: NSObject {
    
    var dataSource: [AppInfoModel]
    var attentionData = [AppInfoModel]()

    static let shareInstance = AppSquareManager()
    
    private override init(){
        dataSource = AppSquareManager.getAppInfo()
    }
    
    static private func getAppInfo() -> [AppInfoModel]{
        guard let path = Bundle.main.path(forResource: "AppInfo", ofType: "plist") else {
            fatalError("读取系统配置失败")
        }
        var dataArray = [AppInfoModel]()

        let dic = NSDictionary(contentsOfFile: path)
        let array = dic?.object(forKey: "APP") as! NSArray
        for item in array {
            let data = AppInfoModel.deserialize(from: item as? NSDictionary)
            dataArray.append(data!)
        }
        return dataArray
    }
}
