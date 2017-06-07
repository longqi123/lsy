//
//  SelectCell.swift
//  GXTax
//
//  Created by J HD on 2016/12/27.
//  Copyright © 2016年 J HD. All rights reserved.
//

import UIKit

class SelectCell: UITableViewCell {
	
	var ifShowSelectedStyle = false {
		didSet {
			setNeedsDisplay()
		}
	}
	
	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: .default, reuseIdentifier: reuseIdentifier)
		textLabel?.font = .normal(13)
	}
	
	override func draw(_ rect: CGRect) {
		super.draw(rect)
		let circle = UIBezierPath(ovalIn: CGRect(x: rect.width - 36, y: 17, width: 16, height: 16))
		UIColor.gray.setStroke()
		circle.stroke()
		if ifShowSelectedStyle {
			let circle2 = UIBezierPath(ovalIn: CGRect(x: rect.width - 44, y: 9, width: 32, height: 32))
			UIColor.lightGray.withAlphaComponent(0.6).setFill()
			circle2.fill()
			let hover = UIBezierPath(rect: rect)
			UIColor.lightGray.withAlphaComponent(0.3).setFill()
			hover.fill()
		}
	}
	
	override func setSelected(_ selected: Bool, animated: Bool) {
		ifShowSelectedStyle = selected
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}
