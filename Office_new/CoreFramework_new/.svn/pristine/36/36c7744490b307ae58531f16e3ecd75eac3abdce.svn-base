//
//  WebViewController.swift
//  Basic
//	带进度条的WKWebViewController
//  Created by J HD on 2016/11/25.
//  Copyright © 2016年 J HD. All rights reserved.
//

import UIKit
import WebKit

open class JWebViewController: UIViewController {
	
	private let obk1 = "loading"
	private let obk2 = "estimatedProgress"
	
	///webView
	open let webView = WKWebView()
	///进度条
	open let progress: CAShapeLayer = {
		let shape = CAShapeLayer()
		let path = UIBezierPath()
		path.move(to: CGPoint(x: 0, y: 1.5))
		path.addLine(to: CGPoint(x: UIScreen.main.bounds.width, y: 1.5))
		shape.path = path.cgPath
		shape.strokeColor = UIColor(102,153,255).cgColor
		shape.fillColor = UIColor.clear.cgColor
		shape.strokeStart = 0
		shape.strokeEnd = 0
		shape.lineWidth = 3
		shape.fillRule = kCAFillRuleNonZero
		shape.lineCap = kCALineCapRound
		return shape
	}()
	
	public init(url: URL, cachePolicy: URLRequest.CachePolicy = .returnCacheDataElseLoad, timeout: TimeInterval = 8){
		super.init(nibName: nil, bundle: nil)
		webView.load(URLRequest(url: url, cachePolicy: cachePolicy, timeoutInterval: timeout))
		webView.addObserver(self, forKeyPath: obk1, options: .new, context: nil)
		webView.addObserver(self, forKeyPath: obk2, options: .new, context: nil)
	}
	
	public convenience init?(urlString: String, cachePolicy: URLRequest.CachePolicy = .returnCacheDataElseLoad, timeout: TimeInterval = 8){
		guard let URL = URL(string: urlString) else{
			return nil
		}
		self.init(url: URL, cachePolicy: cachePolicy, timeout: timeout)
	}
	
	required public init?(coder aDecoder: NSCoder) {
		fatalError()
	}
	
	open override func loadView() {
		view = webView
	}
	
	open override func viewDidLoad() {
		super.viewDidLoad()
		webView.backgroundColor = .white
		webView.allowsBackForwardNavigationGestures = true
		webView.layer.addSublayer(progress)
	}
	
	open override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		progress.frame = CGRect(x: 0, y: topLayoutGuide.length, width: view.bounds.width, height: 3)
	}
	
	open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
		guard let keyPath = keyPath, let change = change else { return }
		switch keyPath {
		case obk1:
			guard let val = change[NSKeyValueChangeKey.newKey] as? Bool , !val else{ return }
			webView.removeObserver(self, forKeyPath: obk1, context: nil)
			webView.removeObserver(self, forKeyPath: obk2, context: nil)
			GCD.delay(seconds: 0.2, completion: {
				self.progress.opacity = 0
			})
		case obk2:
			guard let val = change[NSKeyValueChangeKey.newKey] as? CGFloat else{ return }
			progress.strokeEnd = val
		default:break
		}
	}
	
}
