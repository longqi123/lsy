//
//  ImageAnimator.swift
//  GXTax
//
//  Created by J HD on 2017/2/16.
//  Copyright © 2017年 J HD. All rights reserved.
//

import UIKit

public enum TransitionStatus {
	
	case present
	case dismiss
	
}

fileprivate extension UIImageView{
	
	func scaleToScreenFrame() -> CGRect?{
		guard let image = image else{ return nil }
		let ratio = image.size.width/image.size.height
		let screenRatio = screenWidth/screenHeight
		let width: CGFloat
		let height: CGFloat
		if ratio > screenRatio {
			width = screenWidth
			height = screenWidth/ratio
		} else {
			width = screenHeight*ratio
			height = screenHeight
		}
		let point = CGPoint(x: 0, y:(screenHeight - height)/2)
		return CGRect(origin: point, size: CGSize(width: width, height: height))
	}
	
}

public class ImageAnimator: NSObject, UIViewControllerAnimatedTransitioning {
	
    public var status: TransitionStatus
	public var originFrame = CGRect.zero
	public let finalCenter: CGPoint
	
	public var successClosure: (()->Void)?
	
	public var image: UIImageView?
	
	public init(image: UIImageView? = nil, status: TransitionStatus = .present, finalCenter: CGPoint){
		self.image = image?.copyView()
		self.status = status
		self.finalCenter = finalCenter
	}
	
	public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
		return 0.33
	}
	
	public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
		let containerView = transitionContext.containerView
		guard let toView = transitionContext.view(forKey: UITransitionContextViewKey.to) else{ return }
		
		guard let image = image else {
			transitionContext.completeTransition(true)
			return
		}
		
		let finalFrame: CGRect
		if status == .present{
			image.frame = originFrame
			finalFrame = image.scaleToScreenFrame()!
		}
		else{
			image.isHidden = false
			finalFrame = originFrame
		}
		containerView.addSubview(toView)
		containerView.addSubview(image)
		
		UIView.animate(
			withDuration: 0.33,
			animations: {
				image.frame = finalFrame
		},
			completion: {
				if $0 {
					image.isHidden = true
					self.successClosure?()
					transitionContext.completeTransition(true)
				}
			}
		)
	}
	
}
