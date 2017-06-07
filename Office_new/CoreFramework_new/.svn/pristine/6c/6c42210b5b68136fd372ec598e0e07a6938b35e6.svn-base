//
//  GxTextViewExtension.swift
//  GXTax
//
//  Created by Peng Guo on 2017/3/22.
//  Copyright © 2017年 J HD. All rights reserved.
//

import Foundation

extension UITextView {
	
	/// 给textView添加完成按钮
	public func addDoneToolBar() {
		let doneToolBar = CustomToolbarView(frame: CGRect.init(x: 0, y: 0, width: screenWidth, height: 40))
		self.inputAccessoryView = doneToolBar
		doneToolBar.doneBlock = { [unowned self] in
			self.resignFirstResponder()
		}
	}
}
