//
//  LoadingButton.swift
//  Example
//	简单LoadingButton
//  Created by J HD on 2016/12/1.
//  Copyright © 2016年 J HD. All rights reserved.
//

import UIKit

open class LoadingButton: UIButton {
	
	public  var loader: UIActivityIndicatorView = {
		let indicator = UIActivityIndicatorView()
		indicator.color = UIColor.white
		indicator.isHidden = true
		return indicator
	}()
	
	public init(){
		super.init(frame: CGRect.zero)
		addSubview(loader)
		setTitle("", for: .disabled)
		setBackgroundImage(UIImage(color: UIColor.lightGray), for: .disabled)
	}
	
	public override init(frame: CGRect) {
		super.init(frame: frame)
		addSubview(loader)
		setTitle("", for: .disabled)
		setBackgroundImage(UIImage(color: UIColor.lightGray), for: .disabled)
	}
	
	open override func layoutSubviews() {
		super.layoutSubviews()
		loader.center = CGPoint(x: bounds.midX, y: bounds.midY)
	}
	
	public required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	open func startLoading(){
		isEnabled = false
		loader.startAnimating()
		loader.isHidden = false
	}
	
	open func endLoading(){
		loader.isHidden = true
		isEnabled = true
		loader.stopAnimating()
	}
	
}
