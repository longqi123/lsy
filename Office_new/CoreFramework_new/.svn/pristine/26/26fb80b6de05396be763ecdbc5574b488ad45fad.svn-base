//
//  UIViewExtension.swift
//  ProjectExample
//
//  Created by J HD on 2016/11/28.
//  Copyright © 2016年 J HD. All rights reserved.
//

import UIKit.UIView
import SnapKit

public enum BorderPosition {
	case left
	case right
	case top
	case bottom
}

public extension UIView {

	/// 添加一条直线
	///
	/// - Parameter closure: 约束闭包
	/// - Returns: 线
	@discardableResult public func addLine(_ closure: (_ make: ConstraintMaker) -> Void) -> UIView{
		let line = UIView()
		line.backgroundColor = UIColor.L1
		line.translatesAutoresizingMaskIntoConstraints = false
		addSubview(line)
		line.snp.makeConstraints(closure)
		return line
	}
	
	/// 添加一条border(暂时不能添加圆角)
	///
	/// - Parameter position: 边的位置
	/// - Returns: 对应的边
	@discardableResult public func addBorder(_ position: BorderPosition) -> UIView {
		switch position {
		case .left:
			return self.addLine({ (make) in
				make.left.equalTo(self)
				make.top.equalTo(self)
				make.bottom.equalTo(self)
				make.width.equalTo(dividerWidth)
			})
		case .right:
			return self.addLine({ (make) in
				make.right.equalTo(self)
				make.top.equalTo(self)
				make.bottom.equalTo(self)
				make.width.equalTo(dividerWidth)
			})
		case .top:
			return self.addLine({ (make) in
				make.top.equalTo(self)
				make.left.equalTo(self)
				make.right.equalTo(self)
				make.height.equalTo(dividerWidth)
			})
		case .bottom:
			return self.addLine({ (make) in
				make.bottom.equalTo(self)
				make.left.equalTo(self)
				make.right.equalTo(self)
				make.height.equalTo(dividerWidth)
			})
		}
	}
}

extension UIView {
    
    //圆角矩形 圆角半径为5
    public static var panel: UIView {
        let v = UIView()
        v.backgroundColor = .white
        v.layer.cornerRadius = 5
        v.clipsToBounds = true
        return v
    }
    
    //圆角矩形 自定义圆角
    public func setCornerRadius(cornerRadius: CGFloat){
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = true
    }
    
    // 预交矩形有边框宽度和颜色
    public func setCornerRadiusBorder(cornerRadius: CGFloat, borderWidth: CGFloat, borderColor: UIColor) {
        self.layer.cornerRadius = cornerRadius
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = borderWidth
        self.layer.masksToBounds = true
    }
    
    // 自定义四个圆角矩形的任意一个或者多个
    // 使用方法 self.view.roundCorners(corners: [.topLeft, .bottomRight], radius: 45)
    public func roundCorners(corners:UIRectCorner, radius: CGFloat){
        let borderLayer = CAShapeLayer()
        borderLayer.frame = self.layer.bounds
        borderLayer.strokeColor = UIColor.clear.cgColor
        borderLayer.fillColor = UIColor.init(red: 160/255, green: 203/255, blue: 249/255, alpha: 1).cgColor
        borderLayer.lineWidth = 1.0
        let path = UIBezierPath(roundedRect: self.bounds,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        borderLayer.path = path.cgPath
        self.layer.addSublayer(borderLayer)
    }
}
