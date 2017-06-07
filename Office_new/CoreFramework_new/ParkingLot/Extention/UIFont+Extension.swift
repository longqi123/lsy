//
//  UIFontExtension.swift
//  Example
//
//  Created by J HD on 2016/12/7.
//  Copyright © 2016年 J HD. All rights reserved.
//

import UIKit.UIFont

public extension UIFont {
	
	/// 用一个大小初始化对应字体
	///
	/// - Parameter size: 字体大小
	/// - Returns: 返回对应大小的字体，默认HelveticaNeue-Light否则系统字体,可以自定义
	public class func normal(_ size: CGFloat) -> UIFont {
		return UIFont.systemFont(ofSize: size)
	}
    
    public static var H1: UIFont {
        return UIFont.systemFont(ofSize: 19)
    }
    
    public static var H2: UIFont {
        return UIFont.systemFont(ofSize: 18)
    }
    
    public static var H3: UIFont {
        return UIFont.systemFont(ofSize: 17)
    }
    
    public static var H4: UIFont {
        return UIFont.systemFont(ofSize: 16)
    }
    
    public static var H5: UIFont {
        return UIFont.systemFont(ofSize: 15)
    }
    
    public static var H6: UIFont {
        return UIFont.systemFont(ofSize: 14)
    }
    
    public static var H7: UIFont {
        return UIFont.systemFont(ofSize: 13)
    }
    
    public static var H8: UIFont {
        return UIFont.systemFont(ofSize: 12)
    }
    
    public static var H9: UIFont {
        return UIFont.systemFont(ofSize: 11)
    }
    
    public static var H10: UIFont {
        return UIFont.systemFont(ofSize: 8)
    }
	
    
}