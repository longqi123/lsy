//
//  AddressListManager.swift
//  Office
//
//  Created by roger on 2017/4/8.
//  Copyright © 2017年 roger. All rights reserved.
//

import Foundation
import HandyJSON

class AddressListManager: NSObject {
    
    var dataSource: [[AddressListModel]]
    
    static let shareInstance = AddressListManager()
    
    private override init(){
        dataSource = AddressListManager.getAppInfo()
    }
    
    static private func getAppInfo() -> [[AddressListModel]]{
        guard let path = Bundle.main.path(forResource: "OrganizationInfo", ofType: "plist") else {
            fatalError("读取系统配置失败")
        }
        var dataArray = [[AddressListModel]]()
        
        let dic = NSDictionary(contentsOfFile: path)
        
        var arr1 = [AddressListModel]()
        let array1 = dic?.object(forKey: "第一税务所") as! NSArray
        for item in array1 {
            let data = AddressListModel.deserialize(from: item as? NSDictionary)
            arr1.append(data!)
        }
        dataArray.append(arr1)
        
        var arr2 = [AddressListModel]()
        let array2 = dic?.object(forKey: "政策法规科") as! NSArray
        for item in array2 {
            let data = AddressListModel.deserialize(from: item as? NSDictionary)
            arr2.append(data!)
        }
        dataArray.append(arr2)
        
        var arr3 = [AddressListModel]()
        let array3 = dic?.object(forKey: "办公室") as! NSArray
        for item in array3 {
            let data = AddressListModel.deserialize(from: item as? NSDictionary)
            arr3.append(data!)
        }
        dataArray.append(arr3)
        
        var arr4 = [AddressListModel]()
        let array4 = dic?.object(forKey: "第九税务局") as! NSArray
        for item in array4 {
            let data = AddressListModel.deserialize(from: item as? NSDictionary)
            arr4.append(data!)
        }
        dataArray.append(arr4)
        
        return dataArray

    }
}
