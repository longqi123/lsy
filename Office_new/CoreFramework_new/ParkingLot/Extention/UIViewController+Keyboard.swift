//
//  Keyboard.swift
//  Example
//
//  Created by J HD on 2016/12/8.
//  Copyright © 2016年 J HD. All rights reserved.
//

import UIKit.UIViewController

@objc public protocol VCKeyboardDelegate: class {
	
	@objc optional func willShowAnimations(height: CGFloat)
	@objc optional func willShowCompletion(didShow: Bool)
	
	@objc optional func otherAction()
	@objc optional func otherHideAction()
	
	@objc optional func willHideAnimations()
	@objc optional func willHideCompletion(didHide: Bool)
	
}

extension VCKeyboardDelegate {
	
    func otherAction() { }
	
    func willShowCompletion(didShow: Bool) { }
	
    func otherHideAction() { }
	
    func willHideCompletion(didHide: Bool) { }
	
}

fileprivate var keyboardKey = "keyboard"

public extension UIViewController {
	
	public weak var keyboardDelegate: VCKeyboardDelegate?{
		get {
			return objc_getAssociatedObject(self, &keyboardKey) as? VCKeyboardDelegate
		}
		set {
			willChangeValue(forKey: "keyboardDelegate")
			objc_setAssociatedObject(self, &keyboardKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
			didChangeValue(forKey: "keyboardDelegate")
		}
	}
	
	func removeKeyboardNotification(){
		NotificationCenter.default.removeObserver(self)
	}
	
	func setKeyboardNotification(){
		NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
	}
	
	@objc private func keyBoardWillShow(_ note:Notification){
		guard let userInfo = (note as NSNotification).userInfo,
			let height = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size.height,
			let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber
			else{ return }
		UIView.animate(
			withDuration: duration.doubleValue,
			delay: 0,
			options: UIViewAnimationOptions(rawValue: UInt(duration.intValue) << 16),
			animations: {
				self.keyboardDelegate?.willShowAnimations!(height: height)
		},
			completion: keyboardDelegate?.willShowCompletion
		)
		self.keyboardDelegate?.otherAction()
	}
	
	@objc private func keyBoardWillHide(_ note:Notification){
		guard let userInfo = (note as NSNotification).userInfo,
			let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber
			else{ return }
		UIView.animate(
			withDuration: duration.doubleValue,
			delay: 0,
			options: UIViewAnimationOptions(rawValue: UInt(duration.intValue) << 16),
			animations: keyboardDelegate?.willHideAnimations ?? {},
			completion: keyboardDelegate?.willHideCompletion
		)
		self.keyboardDelegate?.otherHideAction()
	}
	
}
