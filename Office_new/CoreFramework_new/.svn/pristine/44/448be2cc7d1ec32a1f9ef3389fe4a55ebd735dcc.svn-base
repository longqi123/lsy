//
//  ImageViewerController.swift
//  Example
//
//  Created by J HD on 2016/12/9.
//  Copyright © 2016年 J HD. All rights reserved.
//

import UIKit

public extension UIImage {
	
	///图片实际占位frame
	public var scaledFrame: CGRect{
		let scRatio = screenWidth/screenHeight
		let ratio = size.width/size.height
		if scRatio > ratio{
			let width = screenHeight*ratio
			return CGRect(x: (screenWidth - width)/2, y: 0, width: width, height: screenHeight)
		}
		else{
			let height = screenWidth/ratio
			return CGRect(x: 0, y: (screenHeight - height)/2, width: screenWidth, height: height)
		}
	}
	
}

public class ImageViewerController: UIViewController {
	
	public var scrollView = UIScrollView()
	public var imageView = UIImageView()
	
	public let image: UIImage
	
	public init(image: UIImage, ifNotShowImage: Bool = true){
		self.image = image
		super.init(nibName: nil, bundle: nil)
		imageView.isHidden = ifNotShowImage
	}
	
	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override public func viewDidLoad() {
		super.viewDidLoad()
		
		scrollView.backgroundColor = .black
		scrollView.maximumZoomScale = 2
		scrollView.minimumZoomScale = 1
		scrollView.contentSize = CGSize(width: screenWidth, height: screenHeight)
		scrollView.delegate = self
		view.addSubview(scrollView)
		scrollView.snp.makeConstraints { (make) in
			make.edges.equalTo(view)
		}
		
		imageView.image = image
		imageView.frame = image.scaledFrame
		imageView.backgroundColor = UIColor.white
		imageView.contentMode = .scaleAspectFit
		scrollView.addSubview(imageView)
		
		let tap = UITapGestureRecognizer(target: self, action: #selector(ImageViewerController.tap(_:)))
		view.addGestureRecognizer(tap)
		
		let tap2 = UITapGestureRecognizer(target: self, action: #selector(ImageViewerController.tap2(_:)))
		tap2.numberOfTapsRequired = 2
		view.addGestureRecognizer(tap2)
		
		tap.require(toFail: tap2)
		
	}
	
	public func tap(_ gesture: UITapGestureRecognizer){
		let l = gesture.location(in: view)
		if !imageView.frame.contains(l) || !scrollView.isZooming{
			DispatchQueue.main.async(execute: {
				self.dismiss(animated: true, completion: nil)
			})
		}
	}
	
	public func tap2(_ gesture: UITapGestureRecognizer){
		let l = gesture.location(in: view)
		if imageView.frame.contains(l){
			scrollView.setZoomScale(1.0, animated: true)
		}
	}
	
}

extension ImageViewerController: UIScrollViewDelegate{
	
	public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
		return imageView
	}
	
	public func scrollViewDidZoom(_ scrollView: UIScrollView) {
		
		let cw = scrollView.contentSize.width/2
		let ch = scrollView.contentSize.height/2
		
		let sw = screenWidth/2
		let sh = screenHeight/2
		
		if cw > sw{
			imageView.center.x = cw
		}
		else{
			imageView.center.x = sw
		}
		if ch > sh{
			imageView.center.y = ch
		}
		else{
			imageView.center.y = sh
		}
		
	}
	
	public func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
		guard let v = view , scale == 1.0 else{ return }
		v.center = CGPoint(x: screenWidth/2, y: screenHeight/2)
	}
	
}
