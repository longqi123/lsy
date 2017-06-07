//
//  UIButtonExtension.swift
//  GXTax
//
//  Created by J HD on 2016/12/27.
//  Copyright © 2016年 J HD. All rights reserved.
//

import UIKit.UIButton

extension UIButton {
	
	public convenience init(title: String) {
		self.init(frame: .zero)
		layer.cornerRadius = 5
		clipsToBounds = true
		setBackgroundImage(UIImage(color: UIColor.B2), for: .normal)
		setTitle(title, for: .normal)
		setTitleColor(.white, for: .normal)
		titleLabel?.font = .normal(15)
	}
}
