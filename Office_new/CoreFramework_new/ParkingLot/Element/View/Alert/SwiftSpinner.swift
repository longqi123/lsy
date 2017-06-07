//
//  SwiftSpinner.swift
//  Example
//
//  Created by J HD on 2016/12/9.
//  Copyright © 2016年 J HD. All rights reserved.
//

import UIKit

open class SwiftSpinner: UIView {

	// MARK: - Init
	
	//
	// Custom init to build the spinner UI
    convenience init(innerColor: UIColor = UIColor(248, 82, 85), outerColor: UIColor = UIColor(248, 82, 85)){
		self.init(frame: CGRect.zero)
		innerCircle.strokeColor = innerColor.cgColor
		outerCircle.strokeColor = outerColor.cgColor
	}
	
	public override init(frame: CGRect) {
		super.init(frame: frame)
		
		outerCircleView.frame.size = frameSize
		outerCircle.path = UIBezierPath(ovalIn: CGRect(x: 0.0, y: 0.0, width: frameSize.width, height: frameSize.height)).cgPath
		outerCircle.lineWidth = 4.0
		outerCircle.strokeStart = 0.0
		outerCircle.strokeEnd = 0.45
		outerCircle.lineCap = kCALineCapRound
		outerCircle.fillColor = UIColor.clear.cgColor
		outerCircleView.layer.addSublayer(outerCircle)
		outerCircle.strokeStart = 0.0
		outerCircle.strokeEnd = 1.0
		addSubview(outerCircleView)
		
		innerCircleView.frame.size = frameSize
		let innerCirclePadding: CGFloat = 6
		innerCircle.path = UIBezierPath(ovalIn: CGRect(x: innerCirclePadding, y: innerCirclePadding, width: frameSize.width - 2*innerCirclePadding, height: frameSize.height - 2*innerCirclePadding)).cgPath
		innerCircle.lineWidth = 2.0
		innerCircle.strokeStart = 0.5
		innerCircle.strokeEnd = 0.9
		innerCircle.lineCap = kCALineCapRound
		innerCircle.fillColor = UIColor.clear.cgColor
		innerCircleView.layer.addSublayer(innerCircle)
		innerCircle.strokeStart = 0.0
		innerCircle.strokeEnd = 1.0
		addSubview(innerCircleView)
		isUserInteractionEnabled = true
	}
	
	//
	// observe the view frame and update the subviews layout
	//
	open override var frame: CGRect {
		didSet {
			if frame == CGRect.zero {
				return
			}
			outerCircleView.center = center
			innerCircleView.center = center
		}
	}
	
	//
	// Start the spinning animation
	//
	open var animating: Bool = false {
		willSet (shouldAnimate) {
			if shouldAnimate && !animating {
				spinInner()
				spinOuter()
			}
		}
		didSet {
			// update UI
			if animating {
				self.outerCircle.strokeStart = 0.0
				self.outerCircle.strokeEnd = 0.7
				self.innerCircle.strokeStart = 0.5
				self.innerCircle.strokeEnd = 0.9
			} else {
				self.outerCircle.strokeStart = 0.2
				self.outerCircle.strokeEnd = 1.0
				self.innerCircle.strokeStart = 0.0
				self.innerCircle.strokeEnd = 1.0
			}
		}
	}
	
	
	// MARK: - Private interface
	
	//
	// layout elements
	//
	
	let frameSize = CGSize(width: 50.0, height: 50.0)
	
	fileprivate var outerCircleView = UIView()
	fileprivate var innerCircleView = UIView()
	
	fileprivate let outerCircle = CAShapeLayer()
	fileprivate let innerCircle = CAShapeLayer()
	
	required public init?(coder aDecoder: NSCoder) {
		fatalError("Not coder compliant")
	}
	
	fileprivate var currentOuterRotation: CGFloat = 0.0
	fileprivate var currentInnerRotation: CGFloat = 0.1
	
	fileprivate func spinOuter() {
		
		if superview == nil {
			return
		}
		
		let duration = Double(Float(arc4random()) /  Float(UInt32.max)) * 2.0 + 1.5
		let randomRotation = Double(Float(arc4random()) /  Float(UInt32.max)) * Double.pi/4 + Double.pi/4
		
		//outer circle
		UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.0, options: [], animations: {
			self.currentOuterRotation -= CGFloat(randomRotation)
			self.outerCircleView.transform = CGAffineTransform(rotationAngle: self.currentOuterRotation)
		}, completion: {_ in
			let waitDuration = Double(Float(arc4random()) /  Float(UInt32.max)) * 1.0 + 1.0
			GCD.delay(seconds: waitDuration, completion: {
				if self.animating {
					self.spinOuter()
				}
			})
		})
	}
	
	fileprivate func spinInner() {
		if superview == nil {
			return
		}
		
		//inner circle
		UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.0, options: [], animations: {
			self.currentInnerRotation += CGFloat(Double.pi/4)
			self.innerCircleView.transform = CGAffineTransform(rotationAngle: self.currentInnerRotation)
		}, completion: {_ in
			GCD.delay(seconds: 0.5, completion: {
				if self.animating {
					self.spinInner()
				}
			})
		})
	}
	
}

