//
//  Weekday.swift
//  ProjectExample
//
//  Created by J HD on 2016/11/28.
//  Copyright © 2016年 J HD. All rights reserved.
//

import Foundation

public enum Weekday: Int {
	
	///星期日
	case sunday = 1
	///星期一
	case monday = 2
	///星期二
	case tuesday = 3
	///星期三
	case wednesday = 4
	///星期四
	case thursday = 5
	///星期五
	case friday = 6
	///星期六
	case saturday = 7
	
	/// 根据数字初始化Weekday
	///
	/// - Parameter rawValue: 对应星期数字
	public init(rawValue: Int){
		switch rawValue {
		case 1:
			self = .sunday
		case 2:
			self = .monday
		case 3:
			self = .tuesday
		case 4:
			self = .wednesday
		case 5:
			self = .thursday
		case 6:
			self = .friday
		case 7:
			self = .saturday
		default:
			fatalError("error weekday")
		}
	}
	
	/// 是否是周末
	public var isWeekend:Bool{
		switch self {
		case .saturday, .sunday:
			return true
		default:
			return false
		}
	}
	
}
