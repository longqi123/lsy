//
//  PublicFunction.swift
//  Office
//
//  Created by GA GA on 05/06/2017.
//  Copyright © 2017 roger. All rights reserved.
//

import Foundation
import CoreFramework
import SwiftyJSON

/// 设置头像背景颜色
///
/// - Parameters:
///   - name: 税务人员姓名
///   - dm: 税务人员代码
/// - Returns: 头像背景
public func setNameBackColor(name: String, dm: String) -> UIColor {
    let colorNum = (dm as NSString).substring(with: NSMakeRange((dm.characters.count) - 1, 1))
    let colorNumber = Int(colorNum)
    if colorNumber == 0 || colorNumber == 5 {
        return UIColor.C5
    }else if colorNumber == 1 || colorNumber == 6{
        return UIColor.C1
    }else if colorNumber == 2 || colorNumber == 7{
        return UIColor.C2
    }else if colorNumber == 3 || colorNumber == 8{
        return UIColor.C3
    }else {
        return UIColor.C4
    }
    
}

extension JSON {
    /// 针对接口有时传回单个数据，但不封装成array进行处理
    public var arrayResult: [JSON] {
        if let array = self.array {
            return array
        } else {
            return [self]
        }
    }
    
    
}
