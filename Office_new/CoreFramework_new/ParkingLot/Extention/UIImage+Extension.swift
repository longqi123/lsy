//
//  UIImageExtension.swift
//  Basic
//
//  Created by J HD on 2016/11/25.
//  Copyright © 2016年 J HD. All rights reserved.
//

import UIKit.UIImage

public extension UIImage {
	
	/// 用颜色初始化一张图片，默认大小为(1，1)
	///
	/// - Parameters:
	///   - color: 对应颜色
	///   - size: 生成图片大小
	public convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)){
		let rect = CGRect(origin: CGPoint.zero, size: size)
		UIGraphicsBeginImageContext(size)
		guard let context = UIGraphicsGetCurrentContext() else { return nil }
		context.setFillColor(color.cgColor)
		context.fill(rect)
		guard let image = UIGraphicsGetImageFromCurrentImageContext()?.cgImage else { return nil }
		self.init(cgImage: image)
		UIGraphicsEndImageContext()
	}
	
	/// 伸缩图片
	///
	/// - Parameters:
	///   - image: 需要伸缩处理的图片
	///   - scaleFloat: 伸缩比例
	/// - Returns: 伸缩后的图片
	public static func scaleImage(_ image:UIImage, scaleFloat:CGFloat) -> UIImage? {
		let size = CGSize(width: image.size.width * scaleFloat, height: image.size.height * scaleFloat)
		UIGraphicsBeginImageContext(size)
		guard let context = UIGraphicsGetCurrentContext() else { return nil }
		let transform = CGAffineTransform.identity.scaledBy(x: scaleFloat, y: scaleFloat)
		context.concatenate(transform)
		image.draw(at: CGPoint.zero)
		let newimg = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		return newimg
	}
	
    // 缩放成固定大小
    public static func sizeImage(_ image: UIImage, size: CGSize) -> UIImage? {
        let scalex = size.width / image.size.width
        let scaley = size.height / image.size.height
        UIGraphicsBeginImageContext(size)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        let transform = CGAffineTransform.identity.scaledBy(x: scalex, y: scaley)
        context.concatenate(transform)
        image.draw(at: CGPoint.zero)
        let newimg = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newimg
    }
    
    
    //把横屏图片调整成竖屏图片
    var CGImageWithCorrectOrientation: CGImage? {
        if imageOrientation == .down {
            return self.cgImage
        }
        UIGraphicsBeginImageContext(size)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        if imageOrientation == .right {
            context.rotate(by: 90 * CGFloat(Double.pi)/180)
        } else if imageOrientation == .left {
            context.rotate(by: -90 * CGFloat(Double.pi)/180)
        } else if imageOrientation == .up {
            context.rotate(by: 180 * CGFloat(Double.pi)/180)
        }
        draw(at: .zero)
        let cgImage = context.makeImage()
        UIGraphicsEndImageContext()
        return cgImage
    }
    
    public func resizedImageByWidth(width: CGFloat) -> UIImage? {
        if size.width < width {
            return self
        } else {
            guard let imgRef = self.CGImageWithCorrectOrientation else { return nil }
            let original_width = CGFloat(imgRef.width)
            let ratio = width/original_width
            return UIImage.scaleImage(self, scaleFloat: ratio)
        }
    }
    
}
