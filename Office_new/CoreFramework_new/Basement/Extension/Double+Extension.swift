//
//  Double+Extension.swift
//  CoreFramework
//	数字处理
//  Created by roger on 2016/12/2.
//  Copyright © 2016年 roger. All rights reserved.
//

import Foundation

public extension Double {
	
	/// 保留两位小数 12.21 默认保留两位
	public var tdpString: String {
		return keepDecimalPlace(decimalPlace: 2)
	}
	
	/// 保留几位小数
	///
	/// - Parameter decimalPlace: 小数位数
	/// - Returns: 保留小数位数后的字符串
	public func keepDecimalPlace(decimalPlace place: Int) -> String {
		precondition(place >= 0)
		return String(format: "%.\(place)f", self)
	}
	
	/// 百分号保留两位小数 12.21% 默认保留两位
	public var percentString: String? {
		return keepPercentStyle(decimalPlace: 2)
	}
	
	/// 百分号显示，保留固定位数小数(带四舍五入)
	/// 仅支持保留0到5位小数位数
	/// - Parameter place: 小数位数
	/// - Returns: 转化为百分数，并保留固定小数位数的字符串
	public func keepPercentStyle(decimalPlace place: Int) -> String? {
		precondition(place >= 0)
		var zeroString = ""
		for i in 0..<place {
			if i == 0{
				zeroString.append(".")
			}
			zeroString.append("0")
		}
		let formatter = NumberFormatter()
		formatter.positiveFormat = "##0\(zeroString)%"
		formatter.negativeFormat = "-##0\(zeroString)%"
		formatter.roundingMode = .halfUp
		return formatter.string(from: NSNumber(value: self))
	}
	
	/// 金钱类型字符串 默认保留两位 1000,000,000.00
	public var moneyString: String? {
		return keepMoneyStyle(decimalPlace: 2)
	}
	
	/// 转换成金钱显示方式,逗号分隔 100,000,000.00
	///
	/// - Parameter place: 小数位数
	/// - Returns: 转换后的字符串
	public func keepMoneyStyle(decimalPlace place: Int) -> String? {
		precondition(place >= 0)
		var zeroString = ""
		for i in 0..<place {
			if i == 0{
				zeroString.append(".")
			}
			zeroString.append("0")
		}
		let formatter = NumberFormatter()
		formatter.positiveFormat = "###,##0\(zeroString)"
		formatter.negativeFormat = "-###,##0\(zeroString)"
		formatter.roundingMode = .halfUp
		return formatter.string(from: NSNumber(value: self))
	}
	
}
