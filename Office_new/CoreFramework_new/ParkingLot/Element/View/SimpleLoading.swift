//
//  SimpleLoading.swift
//  GXTax
//
//  Created by J HD on 2016/12/21.
//  Copyright © 2016年 J HD. All rights reserved.
//

import UIKit

fileprivate var objcKey = "loading"

extension UIViewController {
	
	fileprivate var loading: SimpleLoading? {
		get {
			if let l = objc_getAssociatedObject(self, &objcKey) as? SimpleLoading {
				return l
			} else {
				return nil
			}
		}
		set {
			objc_setAssociatedObject(self, &objcKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
		}
	}
	
	public func showloading(text: String = "加载中...") {
		guard let window = UIApplication.shared.keyWindow else {
			return
		}
		let loading = SimpleLoading(text: text)
		window.addSubview(loading)
		UIView.animate(withDuration: 0.33) {
			loading.alpha = 1
		}
		self.loading = loading
	}
	
	public func hideloading() {
		guard self.loading != nil else {
			return
		}
		self.loading?.hide()
		self.loading = nil
	}
	
}

class SimpleLoading: UIView {
	
	fileprivate init(text: String) {
		super.init(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
		backgroundColor = UIColor(white: 0, alpha: 0.66)
        self.alpha = 0.01
		let back = UIView()
		back.backgroundColor = .black
		back.layer.cornerRadius = 5
		back.clipsToBounds = true
		addSubview(back)
		back.snp.makeConstraints { (make) in
			make.width.equalTo(100)
			make.height.equalTo(100)
			make.center.equalTo(self)
		}
		
		let path = UIBezierPath()
		path.move(to: CGPoint(x: 0, y: 25))
		path.addArc(withCenter: CGPoint(x: 25, y: 25), radius: 25, startAngle: CGFloat(Double.pi), endAngle: CGFloat(Double.pi/2*1.2), clockwise: true)
		let shapeLayer = CAShapeLayer()
		shapeLayer.path = path.cgPath
		shapeLayer.lineWidth = 1
		shapeLayer.strokeColor = UIColor.white.cgColor
		shapeLayer.frame = CGRect(x: 25, y: 10, width: 50, height: 50)
		back.layer.addSublayer(shapeLayer)
		let animation = CAKeyframeAnimation(keyPath: "transform.rotation")
		animation.duration = 1
		animation.repeatCount = .infinity
		animation.values = [0.0, Double.pi/2, Double.pi, Double.pi*3/2, Double.pi*2]
		animation.keyTimes = [0.0, 0.25, 0.5, 0.75, 1.0]
		shapeLayer.add(animation, forKey: nil)
		
		let label = UILabel()
		label.text = text
		label.font = .normal(14)
		label.textColor = .white
		back.addSubview(label)
		label.snp.makeConstraints { (make) in
			make.bottom.equalTo(back).inset(10)
			make.centerX.equalTo(back)
		}
	}
	
	internal required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	fileprivate func hide() {
		UIView.animate(
			withDuration: 0.33,
			animations: { 
				self.alpha = 0.01
		}) { (b) in
			if b {
				self.removeFromSuperview()
			}
		}
	}
	
}
