//
//  String+Extention.swift
//  CoreFramework
//	正则表达式验证
//  Created by roger on 2016/11/28.
//  Copyright © 2016年 roger. All rights reserved.
//

import Foundation

public enum CharType {
  case NUMBER // 数字
  case BLETTER // 大写字母
  case LETTER  // 小写字母
  case SPECILCHAR // 特殊字符
}

public extension String {
    
    /// 判断是否通过正则表达式验证
    ///
    /// - Parameter regex: 正则表达式
    /// - Returns: 是否符合正则表达式 true:符合 false:不符合
    public func test(regex: String) -> Bool {
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: self)
    }
    
    public func test(regex: Predicate) -> Bool {
        return NSPredicate(format: "SELF MATCHES %@", regex.rawValue).evaluate(with: self)
    }
    
    /// 检验密码等级
    ///
    /// - Returns: 0 不合格 1 低 2 中等 3 强
    public func cheakLevel() -> Int {
        var arr = [CharType]()
        var level = 0
        for char in Array(self.characters) {
            let b = (UnicodeScalar(String(char))?.hashValue)! as Int
            if b >= 48 && b <= 57 {
                if !arr.contains(CharType.NUMBER) {
                    arr.append(CharType.NUMBER)
                }
            } else if b >= 65 && b <= 90 {
                if !arr.contains(CharType.BLETTER) {
                    arr.append(CharType.BLETTER)
                }
            } else if b >= 97 && b <= 122 {
                if !arr.contains(CharType.LETTER) {
                    arr.append(CharType.LETTER)
                }
            } else {
                if !arr.contains(CharType.SPECILCHAR) {
                    arr.append(CharType.SPECILCHAR)
                }
            }
        }
        if arr.count == 1 {
            level = 1
        } else if arr.count == 2 && characters.count < 10 {
            level = 2
        } else if arr.count == 2 && characters.count >= 10 {
            level = 3
        } else if arr.count == 3 {
            level = 4
        } else if arr.count == 4 {
            level = 5
        } else {
            level = 1
        }
        return level
    }
    
    /// 把字符串金额变成保留两位小数点
    public var convertedAmountStr : String {
        if let amountStr = Float(self){
            return String(format: "%.2f", amountStr)
        }else{
            return "0.00"
        }
    }
    
    /// 字符串截取
    ///
    /// - Parameters:
    ///   - start: 开始索引下标
    ///   - end: 结束索引下标
    /// - Returns: <#return value description#>
    public func interceptRange(start: Int, end: Int) -> String {
        let startIndex = self.index(self.startIndex, offsetBy: start)
        let endIndex = self.index(self.startIndex, offsetBy: end+1)
        return self[Range(uncheckedBounds: (startIndex, endIndex))]
    }
    
    
    /// 使用NSRange替换String
    ///
    /// - Parameters:
    ///   - range: 一个NSRange格式形式的范围
    ///   - str: 替换的str
    public mutating func replaceRange(range: NSRange, with str: String) {
        if self != "" {
            if range.location >= characters.count {
                self += str
            } else {
                let start = index(startIndex, offsetBy: range.location)
                let end = index(start, offsetBy: range.length)
                replaceSubrange(start..<end, with: str)
            }
        } else {
            self += str
        }
    }
    
    public var dateFormate1: String {
        return self.replacingOccurrences(of: "/", with: "-")
    }
    
    public var dateFormate2: String {
        return self.components(separatedBy: " ")[0]
    }
    
    public var dateFormate4: String {
        return self.replacingOccurrences(of: "-", with: "/").components(separatedBy: " ")[0]
    }
    
    public var date: Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        return dateFormatter.date(from: self)
    }
    
    public var date2: Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: self)
    }
    
    public var date3: Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        return dateFormatter.date(from: self)
    }
    
    public var date4: Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMM"
        return dateFormatter.date(from: self)
    }
    
    public var date5: Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        return dateFormatter.date(from: self)
    }
    
    /// 是否是纯数字
    public var isPurnInt: Bool {
        let scan: Scanner = Scanner(string: self)
        var val:Int = 0
        return scan.scanInt(&val) && scan.isAtEnd
    }
    
    /// 模糊身份证号
    public var encryptIdCard: String {
        guard characters.count >= 18 else {
            return self
        }
        var newString = self
        let index = newString.startIndex
        let start = newString.index(index, offsetBy: 10)
        let end = newString.index(index, offsetBy: 14)
        newString.replaceSubrange(start..<end, with: "****")
        return newString
    }
    
    /// attributeString设置，适用于字符串左右两边颜色和字体大小不同
    ///
    /// - Parameters:
    ///   - string: 字符串
    ///   - head: 头部
    ///   - tail: 尾部
    ///   - headLength: 头部长度
    /// - Returns: attributeString
    public func getCustomAttributedString(_ head : (font: CGFloat, color: UIColor),_ tail : (font: CGFloat, color: UIColor), _ headLength : Int) -> NSMutableAttributedString {
        
        guard self.characters.count > 0 , head.font > 0, tail.font > 0, headLength > 0 else {
            return NSMutableAttributedString(string:self)
        }
        
        let attributeString = NSMutableAttributedString(string:self)
        attributeString.addAttribute(NSFontAttributeName, value: UIFont.normal(head.font),range: NSMakeRange(0,headLength - 1))
        attributeString.addAttribute(NSForegroundColorAttributeName, value: head.color,range: NSMakeRange(0,headLength - 1))
        attributeString.addAttribute(NSFontAttributeName, value: UIFont.normal(tail.font),range: NSMakeRange(headLength,attributeString.length - headLength))
        attributeString.addAttribute(NSForegroundColorAttributeName, value: tail.color,range: NSMakeRange(headLength,attributeString.length - headLength))
        return attributeString
        
    }
    
}
