//
//  Basic.swift
//  Basic
//
//  Created by J HD on 2016/11/25.
//  Copyright © 2016年 J HD. All rights reserved.
//

import UIKit

/// 显示比例
public var scale: CGFloat{
	return UIScreen.main.scale
}

/// 分割线宽
public var dividerWidth: CGFloat{
	return 1/scale
}

/// 屏幕尺寸类型
///
/// - other: 其他 3gs
/// - small: 小屏 5,5s,se
/// - medium: 中等屏幕 6,6s,7
/// - big: puls屏幕 6p,6sp,7p
public enum ScreenType{
	
	/// 其他
	case other
	
	/// 5和SE的尺寸
	case small
	
	/// 2x 6和7的尺寸
	case medium
	
	/// 3x 各种plus屏幕
	case big
	
}

/// 公共
public struct Util {
	
	/// 隐藏初始化方法
	private init(){}
	
	/// 屏幕尺寸类型
	public static let screenType: ScreenType = {
		switch screenHeight{
		case 667:
			return .medium
		case 568:
			return .small
		case 736:
			return .big
		default:
			return .other
		}
	}()
	
	/// 系统版本
	public static let sysVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
	/// app名称
	public static let appName = Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String
	
}
