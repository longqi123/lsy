//
//  Date.swift
//  CoreFramework
//
//  Created by roger on 2016/11/28.
//  Copyright © 2016年 roger. All rights reserved.
//

import Foundation

public extension Date {
	
	/// 北京时间 当前时间
	public static var now: Date {
		return Date().addingTimeInterval(Double(TimeZone.current.secondsFromGMT(for: Date())))
	}
	
	/// 取消时区影响
	public func addOffset() -> Date {
		return self.addingTimeInterval(Double(TimeZone.current.secondsFromGMT(for: Date())))
	}
	
	/// 获取今天星期几
	public static var weekdayOfToday: Weekday?{
		guard let weekday = (Calendar.current as NSCalendar).components(.weekday, from: Date()).weekday else { return nil }
		return Weekday(rawValue: weekday)
	}
	
	/// 判断当前时间是否在一定时间范围内
	///
	/// - Parameters:
	///   - hour: 小时(小)
	///   - min: 分钟(小)
	///   - hour2: 小时(大)
	///   - min2: 小时(大)
	/// - Returns: 是否在范围内 true:在范围内 false:不在范围内或者时间bug
	public static func isTimeNowInZone(hour:Int, min:Int, hour2:Int, min2:Int) -> Bool{
		return Date.isTimeInZone(hour: hour, min: min, hour2: hour2, min2: min2, date: Date())
	}
	
	/// 判断一个时间是否在一个时间范围内
	///
	/// - Parameters:
	///   - hour: 小时(小)
	///   - min: 分钟(小)
	///   - hour2: 小时(大)
	///   - min2: 分钟(大)
	///   - date: 当前时间
	/// - Returns: 是否在范围内 true:在范围内 false:不在范围内或者时间bug
	public static func isTimeInZone(hour:Int, min:Int, hour2:Int, min2:Int, date: Date) -> Bool{
		let flags = NSCalendar.Unit.hour.rawValue | NSCalendar.Unit.minute.rawValue
		let com = (Calendar.current as NSCalendar).components(NSCalendar.Unit(rawValue: flags), from: date)
		guard let h = com.hour, let m = com.minute else {
			return false
		}
		guard hour <= h && hour2 >= h else{ return false }
		if hour == h{
			guard min <= m else{ return false }
		}
		if hour2 == h{
			guard min2 >= m else{ return false }
		}
		return true
	}
	
  /// 判断某个时间是否在一个时间点 多少小时 之前
  ///
  /// - Parameters:
  ///   - hour: 小时
  ///   - min: 分钟
  ///   - date: 某个时间
  ///   - interval: 时间间隔
  /// - Returns: true 在这个时间点多少小时之前
  public static func isTimeBefore(hour: Int, min: Int, date: Date, interval: Int) -> Bool {
    let flags = NSCalendar.Unit.hour.rawValue | NSCalendar.Unit.minute.rawValue
    let com = (Calendar.current as NSCalendar).components(NSCalendar.Unit(rawValue: flags), from: date)
    guard let h = com.hour, let m = com.minute else {
      return false
    }
    let interHour = h + interval
    guard interHour <= hour else {
      return false
    }
    if interHour == h {
      guard m <= min else {
        return false
      }
    }
    return true
  }
  
  public static func isTimeNowBefore(hour: Int, min: Int, interval: Int) -> Bool {
    return isTimeBefore(hour: hour, min: min, date: Date(), interval: interval)
  }
  
  /// 是不是今天之前
  ///
  /// - Parameter date: 时间
  /// - Returns: true 今天之前 - 从昨天开始
  public static func isBeforeToday(date: Date) -> Bool {
    let now = Date.now
    let d = date
    let flags = NSCalendar.Unit.day.rawValue | NSCalendar.Unit.month.rawValue | NSCalendar.Unit.year.rawValue
    let cmp = (Calendar.current as NSCalendar).components(NSCalendar.Unit(rawValue: flags), from: d, to: now, options: NSCalendar.Options(rawValue: UInt(0)))
    guard cmp.year >= 0 else {
      return false
    }
    if cmp.year == 0 {
      guard cmp.month >= 0 else {
        return false
      }
      if cmp.month == 0 {
        guard cmp.day >= 1 else {
          return false
        }
      }
    }
    return true
  }
  
  /// 是不是今天
  ///
  /// - Parameter date: 时间
  /// - Returns: true 今天
  public static func isToday(date: Date) -> Bool {
    return Calendar.current.isDateInToday(date)
  }
  
  
  /// 是不是几天内
  public static func isAFewday(date: Date, few: Int) -> Bool {
    let now = Date.now
    let d = date
    let flags = NSCalendar.Unit.day.rawValue | NSCalendar.Unit.month.rawValue | NSCalendar.Unit.year.rawValue
    let cmp = (Calendar.current as NSCalendar).components(NSCalendar.Unit(rawValue: flags), from: now, to: d, options: NSCalendar.Options(rawValue: UInt(0)))
    guard let year = cmp.year, let month = cmp.month, let day = cmp.day else {
      return false
    }
    guard year == 0 && month == 0 else {
      return false
    }
    guard 0 <= day && day <= few else {
      return false
    }
    return true
  }
  
  /// 获取去年的这个月的第一天
  ///
  /// - Returns:
  public static func getLastYear() -> String {
    let now = Date.now
    let flags = NSCalendar.Unit.day.rawValue | NSCalendar.Unit.month.rawValue | NSCalendar.Unit.year.rawValue
    let com = (Calendar.current as NSCalendar).components(NSCalendar.Unit(rawValue: flags), from: now)
    guard let y = com.year, let m = com.month else {
      return ""
    }
    guard m >= 10 else {
      return String(y - 1) + "-0" + String(m) + "-01"
    }
    return String(y - 1) + "-" + String(m) + "-01"
  }
	/// 格式1 1992-06-09
	public var format1: String {
		let formatter = DateFormatter()
		formatter.dateFormat = "yyyy-MM-dd"
		return formatter.string(from: self)
	}
	
	/// 格式2 1992-06-09 24:11:11
	public var format2: String {
		let formatter = DateFormatter()
		formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
		return formatter.string(from: self)
	}
	
	/// 格式3 1992年06月09日
	public var format3: String {
		let formatter = DateFormatter()
		formatter.dateFormat = "yyyy年MM月dd日"
		return formatter.string(from: self)
	}
    
    /// 格式4 1992/06/09
    public var format4: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter.string(from: self)
    }
	
	/// 格式5 06月09日 15:30
	public var format5: String {
		let formatter = DateFormatter()
		formatter.dateFormat = "MM月dd日 HH:mm"
		return formatter.string(from: self)
	}
	
	/// 格式6 06月09日
	public var format6: String {
		let formatter = DateFormatter()
		formatter.dateFormat = "MM月dd日"
		return formatter.string(from: self)
	}
	
	/// 格式7 1992/06/09 24:11:11
	public var format7: String {
		let formatter = DateFormatter()
		formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
		return formatter.string(from: self)
	}
    
    /// 格式1 1992-06-09
    public var format8: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM"
        return formatter.string(from: self)
    }
    
    /// 获得本月的起始日期和结束日期
    public static var monthRange: (start: String, end: String)? {
        let now = Date()
        let calendar = Calendar.current
        guard let range = calendar.range(of: .day, in: .month, for: now) else { return nil }
        var start = now.format4
        var end = start
        let endIndex = start.endIndex
        let startIndex = start.index(endIndex, offsetBy: -2)
        start.replaceSubrange(startIndex..<endIndex, with: "01")
        end.replaceSubrange(startIndex..<endIndex, with: (range.upperBound - 1).description)
        return (start, end)
    }	
}
