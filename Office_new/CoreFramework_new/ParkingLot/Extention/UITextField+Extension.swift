//
//  UITextFieldExtension.swift
//  GXTax
//
//  Created by J HD on 2016/12/16.
//  Copyright © 2016年 J HD. All rights reserved.
//

import UIKit

public extension UITextField {
	
	/// 用于让textfield仅输入满足double格式
	/// 在delegate中使用
	/// - Parameter str: 新组成后的text
	/// - Returns: 是否允许新输入
	public func numberLock(str: String) -> Bool {
		guard Double(str) != nil || str == "" else{ return false }
		return true
	}
	
	/// 用于验证是否满足double格式
	///
	/// - Parameters:
	///   - range: 范围
	///   - string: 新替换text
	/// - Returns: 是否满足
	public func verifyNumForRange(shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		if var formerText = text {
			formerText.replaceRange(range: range, with: string)
			return numberLock(str: formerText)
		} else {
			return numberLock(str: string)
		}
	}
	
	
	/// 限制只能输入金额，保留两位小数点
	///
	/// - Parameters:
	///   - textField: 输入框
	///   - range: 范围
	///   - string: 新的字符串
	/// - Returns: 限制能否输入
	public func VerifyMoneyInput(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		let toString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
		if toString.characters.count > 0 {
			let stringRegex = "(\\+|\\-)?(([0]|(0[.]\\d{0,2}))|([1-9]\\d{0,999}(([.]\\d{0,2})?)))?"
			let moneyPredicate = NSPredicate(format: "SELF MATCHES %@",stringRegex)
			let flag = moneyPredicate.evaluate(with: toString)
			if flag == false {
				return false
			}
		}
		return true

	}
	
	///
	/// 给textfield内文字左右两边增加距离
	///
	/// - Parameter width: 边距
	public func setTextFieldPaddingForWidth(width: CGFloat){
		var frame = self.frame
		frame.size.width = width
		let view = UIView(frame: frame)
		self.leftViewMode = .always
		self.leftView = view
		self.rightView = view
	}
	
	
	/// 给textfield添加完成按钮
	public func addDoneToolBar() {
		let doneToolBar = CustomToolbarView(frame: CGRect.init(x: 0, y: 0, width: screenWidth, height: 40))
		self.inputAccessoryView = doneToolBar
		doneToolBar.doneBlock = { [unowned self] in
			self.resignFirstResponder()
		}

	}
	
}


