//
//  UITableViewExtension.swift
//  Example
//
//  Created by J HD on 2016/12/7.
//  Copyright © 2016年 J HD. All rights reserved.
//

import UIKit.UITableView

public extension UITableView {
	
	///设置没有数据时默认提示语
	public func setDefaultBackground(_ str: String){
		let lbl = UILabel()
		lbl.text = str
		lbl.font = UIFont.normal(14)
		lbl.textColor = UIColor.T1
		lbl.textAlignment = .center
		backgroundView = lbl
	}
	
}
