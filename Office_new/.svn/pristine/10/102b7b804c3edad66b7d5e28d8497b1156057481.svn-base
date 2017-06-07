//
//  GuideViewController.swift
//  Office
//
//  Created by GA GA on 07/06/2017.
//  Copyright © 2017 roger. All rights reserved.
//

import UIKit
import CoreFramework

class GuideViewController: UIViewController {
    
    let scrollView = UIScrollView()
    var contentImage = [UIImageView]()
    let pageControl = UIPageControl()
    var sureButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor.B1
        btn.setTitle("立即体验", for: .normal)
        return btn
    }()
    
    /// 图片源
    let images = ["1.jpg", "2.jpg", "3.jpg"]

    override func viewDidLoad() {
        super.viewDidLoad()
        makeUI()
    }

}

extension GuideViewController {
    func makeUI() {
        
        view.addSubview(scrollView)
        scrollView.isPagingEnabled = true
        scrollView.bounces = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        
        view.addSubview(pageControl)
        pageControl.currentPage = 0
        pageControl.numberOfPages = images.count
        pageControl.currentPageIndicatorTintColor = .black
        pageControl.pageIndicatorTintColor = .gray
        pageControl.snp.makeConstraints { (make) in
            make.bottom.equalTo(scrollView).inset(10)
            make.centerX.equalTo(scrollView)
            make.height.equalTo(20)
            make.width.equalTo(300)
        }
        
        for (i, row) in images.enumerated() {
            let imageView = UIImageView()
            imageView.image = UIImage(named: row)
            scrollView.addSubview(imageView)
            contentImage.append(imageView)
            if i == 0 {
                imageView.snp.makeConstraints({ (make) in
                    make.left.equalTo(scrollView)
                    make.top.equalTo(scrollView)
                    make.width.equalTo(scrollView)
                    make.height.equalTo(scrollView)
                    
                })
            } else if i == images.count - 1 {
                imageView.snp.makeConstraints({ (make) in
                    make.top.equalTo(scrollView)
                    make.left.equalTo(contentImage[i - 1].snp.right)
                    make.width.equalTo(scrollView)
                    make.right.equalTo(scrollView)
                    make.height.equalTo(scrollView)
                    
                })
                
            } else {
                imageView.snp.makeConstraints({ (make) in
                    make.top.equalTo(scrollView)
                    make.left.equalTo(contentImage[i - 1].snp.right)
                    make.width.equalTo(scrollView)
                    make.height.equalTo(scrollView)
                })

            }
        }
        

        scrollView.addSubview(sureButton)
        sureButton.addTarget(self, action: #selector(tap), for: .touchUpInside)
        sureButton.snp.makeConstraints({ (make) in
            make.bottom.equalTo(view.snp.bottom).inset(40)
            make.centerX.equalTo(contentImage[images.count - 1])
            make.width.equalTo(100)
            make.height.equalTo(30)
        })
    }
}

extension GuideViewController {
    func tap() {
        let root = LoginViewController()
        UIApplication.shared.keyWindow?.rootViewController = root
    }
}

extension GuideViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = page
    }
    
}
