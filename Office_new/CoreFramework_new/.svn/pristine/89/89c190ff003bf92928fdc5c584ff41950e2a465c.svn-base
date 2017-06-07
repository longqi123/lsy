//
//  Enum.swift
//  GXTax
//
//  Created by roger on 2017/3/23.
//  Copyright © 2017年 J HD. All rights reserved.
//

import Foundation

public enum Predicate: String {
    
    /// 中文名字
    case name = "(^[\\u4e00-\\u9fa5]+$)"
    /// 身份证号
    case IDnumber = "(\\d{15}$|^\\d{18}$|^\\d{17}(\\d|X|x))$"
    /// 用户名
    case username = "^[a-zA-Z0-9_]{6,32}$"
    /// 密码
    case password = "^(?![a-zA-Z0-9]+$)(?![^a-zA-Z/D]+$)(?![^0-9/D]+$).{8,16}$"
    /// 手机号码
    case phoneNumber = "1([3-9])\\d{9}$"
    /// 密码等级弱 纯数字，纯字母，纯特殊字符
    case low = "^(?:\\d+|[a-zA-Z]+|[!@#$%^&*]+)$"
    ///  字母+数字，字母+特殊字符，数字+特殊字符
    case medium = "^(?![a-zA-z]+$)(?!\\d+$)(?![!@#$%^&*]+$)[a-zA-Z\\d!@#$%^&*]+$"
    ///  字母+数字+特殊字符
    case strong = "^(?![a-zA-z]+$)(?!\\d+$)(?![!@#$%^&*]+$)(?![a-zA-z\\d]+$)(?![a-zA-z!@#$%^&*]+$)(?![\\d!@#$%^&*]+$)[a-zA-Z\\d!@#$%^&*]+$"
    /// 存数字
    case num = "^[0-9]*$"
    /// 纯小写字母
    case lowLetters = "^[a-z]+$"
    /// 纯大写字母
    case capitalLetters = "^[A-Z]+$"
    /// 纯特殊字符
    case specialChar = "^[@#$%^&]+$"
}
