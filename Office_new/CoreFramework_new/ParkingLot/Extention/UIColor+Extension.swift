//
//  UIColor+Extension.swift
//  Office
//
//  Created by roger on 2016/12/12.
//  Copyright © 2016年 J HD. All rights reserved.
//

import UIKit.UIColor

extension UIColor {
    
    /// 初始化一个颜色，默认透明度为1
    public convenience init(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat, alpha: CGFloat = 1.0){
        self.init(red: red/255, green: green/255, blue: blue/255, alpha: alpha)
    }
    
    /// 通过16进制数生成颜色
    ///可输入类型包括：#000000,000000,0x000000
    public convenience init(hexColor: String) {
        var red:   CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue:  CGFloat = 0.0
        var alpha: CGFloat = 1.0
        var value = hexColor
        if hexColor.hasPrefix("#") {
            let index = hexColor.index(hexColor.startIndex, offsetBy: 1)
            value = hexColor.substring(from: index)
        }
        if hexColor.hasPrefix("0x") {
            let index = hexColor.index(hexColor.startIndex, offsetBy: 2)
            value = hexColor.substring(from: index)
        }
        //缺少逻辑，如果是00000000，八位数的颜色值，前两位代表alpha
        if value.characters.count == 8 {
            //let index = hexColor.index(hexColor.startIndex, offsetBy: 2)
            //alpha = value.substring(with: index)
        }
        let scanner = Scanner(string: value)
        var hexValue: CUnsignedLongLong = 0
        if scanner.scanHexInt64(&hexValue) {
            switch (value.characters.count) {
            case 3:
                red   = CGFloat((hexValue & 0xF00) >> 8)       / 15.0
                green = CGFloat((hexValue & 0x0F0) >> 4)       / 15.0
                blue  = CGFloat(hexValue & 0x00F)              / 15.0
            case 4:
                red   = CGFloat((hexValue & 0xF000) >> 12)     / 15.0
                green = CGFloat((hexValue & 0x0F00) >> 8)      / 15.0
                blue  = CGFloat((hexValue & 0x00F0) >> 4)      / 15.0
                alpha = CGFloat(hexValue & 0x000F)             / 15.0
            case 6:
                red   = CGFloat((hexValue & 0xFF0000) >> 16)   / 255.0
                green = CGFloat((hexValue & 0x00FF00) >> 8)    / 255.0
                blue  = CGFloat(hexValue & 0x0000FF)           / 255.0
            case 8:
                red   = CGFloat((hexValue & 0xFF000000) >> 24) / 255.0
                green = CGFloat((hexValue & 0x00FF0000) >> 16) / 255.0
                blue  = CGFloat((hexValue & 0x0000FF00) >> 8)  / 255.0
                alpha = CGFloat(hexValue & 0x000000FF)         / 255.0
            default:
                break;
            }
        }
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    ///返回一个随机色
    public static func randomColor() -> UIColor {
        return UIColor(red: CGFloat(arc4random_uniform(256)), green: CGFloat(arc4random_uniform(256)), blue: CGFloat(arc4random_uniform(256)), alpha: 1.0)
    }
    
    public static var T1: UIColor {
        return UIColor(hexColor: "#000000")
    }
    
    public static var T2: UIColor {
        return UIColor(hexColor: "202020")
    }
    
    public static var T3: UIColor {
        return UIColor(hexColor: "4d4d4d")
    }
    
    public static var T4: UIColor {
        return UIColor(hexColor: "777777")
    }
    
    public static var T5: UIColor {
        return UIColor(hexColor: "#bbbbbb")
    }
    
    public static var T6: UIColor {
        return UIColor(hexColor: "#ffffff")
    }
    
    public static var T7: UIColor {
        return UIColor(hexColor: "#0070ea")
    }
    
    public static var T8: UIColor {
        return UIColor(hexColor: "ff8a00")
    }
    
    public static var T9: UIColor {
        return UIColor(hexColor: "0032e8")
    }
    
    public static var C1: UIColor {
        return UIColor(hexColor: "50a0f7")
    }
    public static var C2: UIColor {
        return UIColor(hexColor: "c188eb")
    }
    public static var C3: UIColor {
        return UIColor(hexColor: "4facfe")
    }
    public static var C4: UIColor {
        return UIColor(hexColor: "3bc88f")
    }
    public static var C5: UIColor {
        return UIColor(hexColor: "00e3ae")
    }
    public static var C6: UIColor {
        return UIColor(hexColor: "ffa800")
    }
    public static var C7: UIColor {
        return UIColor(hexColor: "8fd3f4")
    }
    
    public static var L1: UIColor {
        return UIColor(hexColor: "#e5e5e5")
    }
    
    public static var L2: UIColor {
        return UIColor(hexColor: "#d6d6d6")
    }
    
    public static var L3: UIColor {
        return UIColor(hexColor: "c9c9c9")
    }
    
    public static var B1: UIColor {
        return UIColor(hexColor: "#0070ea")
    }
    
    public static var B2: UIColor {
        return UIColor(hexColor: "#efeff4")
    }
    
	/// 系统色调
	public static var system: UIColor {
		return UIColor(0, 113, 233)
	}
	
	/// 背景色
	public static var background: UIColor {
		return .groupTableViewBackground
	}
	
	/// 绿色字体颜色
	public static var greenText: UIColor {
		return UIColor(110, 185, 29)
	}

	/// 透明黑色背景色
	public static var hover: UIColor {
		return UIColor(white: 0, alpha: 0.66)
	}
	
	/// textfield边线淡蓝色
	public static var lightBlue: UIColor {
		return UIColor(66, 180, 205)
	}
	
	/// textfield淡蓝色输入框
	public static var lightBlueTextField: UIColor {
		return UIColor(0, 255, 255)
	}
	
    /// 主页面的section
    public static var sectionText: UIColor {
        return UIColor(117, 117, 117)
    }
    
    
    /// 初始化一个颜色，默认透明度为1
    ///
    /// - Parameters:
    ///   - red: 红色 r值
    ///   - green: 绿色 g值
    ///   - blue: 蓝色 b值
    public convenience init(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat){
        self.init(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    
    /// 苹果默认分割线颜色
    public static var divider: UIColor {
        return UIColor(red: 0.783922, green: 0.780392, blue: 0.8, alpha: 1)
    }
    
    /// 一种灰色字体颜色
    public static var grayText: UIColor {
        return UIColor(153,153,153)
    }
    
    /// 蓝色title颜色
    public static var blueTitleText: UIColor {
        return UIColor(hexColor: "#0070ea")
    }
    
    /// 黑色字体颜色
    public static var blackText: UIColor {
        return UIColor(hexColor: "#373737")
    }
    
    /// 背景颜色
    public static var backGroundColor: UIColor {

        return UIColor(hexColor: "#efeff4")
    }

}