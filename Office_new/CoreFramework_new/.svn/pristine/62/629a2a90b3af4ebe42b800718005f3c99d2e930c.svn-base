//
//  CGRect+Extension.swift
//  CoreFramework
//
//  Created by roger on 2017/1/11.
//  Copyright © 2017年 roger. All rights reserved.
//

public extension CGRect {
    
    //根据文字，字体大小，区域 返回尺寸
    public static func getTextRect(text:String,font:UIFont,size:CGSize) -> CGRect {
        let attributes = [NSFontAttributeName: font]
        let option = NSStringDrawingOptions.usesLineFragmentOrigin
        let rect:CGRect = text.boundingRect(with: size, options: option, attributes: attributes, context: nil)
        return rect;
    }

}
