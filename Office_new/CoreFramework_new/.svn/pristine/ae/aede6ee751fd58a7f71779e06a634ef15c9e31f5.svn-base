//
//  Dictionary+Extension.swift
//  Pods
//
//  Created by roger on 2017/5/17.
//
//

import Foundation

extension Dictionary{
    ///两个字典合并，重复的值不会被添加
    static func +(dic1: inout Dictionary,dic2: Dictionary) -> Dictionary{
        for (key, value) in dic2 {
            dic1[key] = value
        }
        return dic1
    }
}
