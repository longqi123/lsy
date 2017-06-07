//
//  Function.swift
//  GXTax
//
//  Created by J HD on 2017/1/5.
//  Copyright © 2017年 J HD. All rights reserved.
//

import Foundation

/// 屏幕宽度尺寸
public var screenWidth: CGFloat {
    return UIScreen.main.bounds.width
}

/// 屏幕高度尺寸
public var screenHeight: CGFloat {
    return UIScreen.main.bounds.height
}

/// 屏幕尺寸
public var screenRect: CGRect {
    return CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
}

///宽比
public var WidthRatio: CGFloat {
    
    return UIScreen.main.bounds.width/750
}

///高比
public var HeightRatio: CGFloat {
    
    return UIScreen.main.bounds.height/1334
}
public func getSize(text: String, maxSize: CGSize, attributes: [String: Any]) -> CGSize {
	return NSString(string: text).boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: attributes, context: nil).size
}

func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
	switch (lhs, rhs) {
	case let (l?, r?):
		return l < r
	case (nil, _?):
		return true
	default:
		return false
	}
}

func <= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
	switch (lhs, rhs) {
	case let (l?, r?):
		return l <= r
	case (nil, _?), (nil, nil):
		return true
	default:
		return false
	}
}

func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
	switch (lhs, rhs) {
	case let (l?, r?):
		return l > r
	case (_?, nil):
		return true
	default:
		return false
	}
}

func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
	switch (lhs, rhs) {
	case let (l?, r?):
		return l >= r
	case (_?, nil), (nil, nil):
		return true
	default:
		return false
	}
}


