//
//  TencentSideBarController.swift
//  Tencent
//	仿QQ侧滑边栏
//  Created by J HD on 2016/12/2.
//  Copyright © 2016年 J HD. All rights reserved.
//

import UIKit

//fileprivate var screenWidth: CGFloat {
//	return UIScreen.main.bounds.width
//}
//
//fileprivate var screenHeight: CGFloat {
//	return UIScreen.main.bounds.height
//}

public protocol TencentSideBarDelegate {
	
	/// 侧边栏已经关闭
	func menuDidClosed()
	
	/// 侧边栏已经打开
	func menuDidOpened()
	
}

public class TencentSidebarController: UIViewController {
	
	/// false为关闭 true为开启
	public var menuStatus = false
	public var percent:CGFloat = 0.84
	
	public var delegate: TencentSideBarDelegate?
	
	public  var edgeGesture: UIScreenEdgePanGestureRecognizer = {
		let gesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(pan(_:)))
		gesture.edges = .left
		return gesture
	}()
	public  var panGesture: UIPanGestureRecognizer = {
		let gesture = UIPanGestureRecognizer(target: self, action: #selector(pan(_:)))
		gesture.isEnabled = false
		return gesture
	}()
	public  var closeMenuTapGetsture: UITapGestureRecognizer = {
		let gesture = UITapGestureRecognizer(target: self, action: #selector(closeMenu))
		return gesture
	}()
	
	public let left: UIViewController
	public let center: UIViewController
	
	public init(leftbar barController: UIViewController, center: UIViewController){
		left = barController
		self.center = center
		super.init(nibName: nil, bundle: nil)
	}
	
	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	public override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = UIColor.white
		left.view.frame = CGRect(x: -screenWidth*percent/2, y: 0, width: screenWidth*percent, height: screenHeight)
		center.view.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
		center.view.addGestureRecognizer(edgeGesture)
		center.view.addGestureRecognizer(panGesture)
		addChildViewController(left)
		view.addSubview(left.view)
		left.didMove(toParentViewController: self)
		addChildViewController(center)
		view.addSubview(center.view)
		center.didMove(toParentViewController: self)
	}
	
	func pan(_ ges: UIPanGestureRecognizer){
		switch ges.state {
		case .began, .changed, .possible:
			let p = ges.translation(in: center.view)
			guard p.x + center.view.frame.origin.x <= screenWidth*percent && p.x + center.view.frame.origin.x >= 0 else { return }
			center.view.transform.tx += p.x
			left.view.transform.tx += p.x/2
			ges.setTranslation(CGPoint.zero, in: view)
		case .ended, .cancelled, .failed:
			let v = ges.velocity(in: center.view)
			if menuStatus{
				(center.view.transform.tx < 2*screenWidth/5 || v.x < -400) ? closeMenu() : openMenu()
			}
			else{
				(center.view.transform.tx >= 2*screenWidth/5 || v.x > 400) ? openMenu() : closeMenu()
			}
		}
	}

	/// 关闭menu
	public func closeMenu(){
		menuStatus = false
		UIView.animate(withDuration: min(0.2,Double(center.view.transform.tx/screenWidth)), animations: {
			self.center.view.transform = CGAffineTransform.identity
			self.left.view.transform = CGAffineTransform.identity
		})
		center.view.removeGestureRecognizer(closeMenuTapGetsture)
		panGesture.isEnabled = false
		edgeGesture.isEnabled = true
		delegate?.menuDidClosed()
	}

	/// 打开menu
	public func openMenu(){
		menuStatus = true
		UIView.animate(withDuration: min(0.2,1-Double(center.view.transform.tx/screenWidth)), animations: {
			self.center.view.transform.tx = screenWidth*self.percent
			self.left.view.transform.tx = screenWidth*self.percent/2
		})
		center.view.addGestureRecognizer(closeMenuTapGetsture)
		panGesture.isEnabled = true
		edgeGesture.isEnabled = false
		delegate?.menuDidOpened()
	}
	
}
