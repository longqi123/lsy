//
//  AppIntroductionCell.swift
//  Office
//
//  Created by GA GA on 22/05/2017.
//  Copyright © 2017 roger. All rights reserved.
//

import UIKit
import CoreFramework
import SwiftyJSON

class AppIntroductionCell: UITableViewCell, UIScrollViewDelegate {
    
    var scrollView:UIScrollView?
    var lastImageView:UIImageView?
    var originalFrame:CGRect!
    var isDoubleTap:ObjCBool!
    
    var tapClosure: ((_ idx: Int)->Void)?

    var icon: UIImageView = {
        let myIcon = UIImageView()
        myIcon.contentMode = .scaleAspectFit
        myIcon.image = #imageLiteral(resourceName: "ying_yong_jie_shao")
        return myIcon
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.H3
        label.textColor = UIColor.T2
        label.text = "应用介绍"
        return label
    }()
    
    var introductionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.H5
        label.textColor = UIColor.T3
        return label
    }()
    
    var imagesScrollView = UIScrollView()
    
    var images = [Data]()
    
    var contentImage = [UIImageView]()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        contentView.addSubview(icon)
        icon.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).inset(12)
            make.top.equalTo(contentView).inset(15)
            make.width.height.equalTo(20)
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(icon.snp.right).offset(10)
            make.top.equalTo(icon)
        }
        
        contentView.addSubview(introductionLabel)
        introductionLabel.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
            make.right.equalTo(contentView).inset(10)
        }
        
        contentView.addSubview(imagesScrollView)
        imagesScrollView.alwaysBounceHorizontal = true
        imagesScrollView.snp.makeConstraints { (make) in
            make.top.equalTo(introductionLabel.snp.bottom).offset(15)
            make.left.equalTo(contentView).inset(12)
            make.right.equalTo(contentView).inset(12)
            make.height.equalTo(141)
        }
        
        contentView.addLine { (make) in
            make.top.equalTo(contentView)
            make.width.equalTo(contentView)
            make.height.equalTo(1)
            make.left.equalTo(contentView)
        }
        
        contentView.addLine { (make) in
            make.bottom.equalTo(contentView)
            make.top.equalTo(imagesScrollView.snp.bottom).offset(15)
            make.width.equalTo(contentView)
            make.height.equalTo(0.5)
            make.left.equalTo(contentView).inset(12)
        }

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(json: AppsDetaisModel) {
        introductionLabel.text = json.yysm
        
    }
    
    func setPic(images: [Data]) {
        for data in images {
            self.images.append(data)
        }
        
        for (i, row) in self.images.enumerated() {
            let myImage = UIImageView()
            myImage.image = UIImage(data: row)
            myImage.isUserInteractionEnabled = true

            let tap = UITapGestureRecognizer(target: self, action: #selector(AppIntroductionCell.showZoomImageView(tap:)))
            myImage.tag = i
            myImage.addGestureRecognizer(tap)
            
            imagesScrollView.addSubview(myImage)
            contentImage.append(myImage)
            
            if i == 0 {
                myImage.snp.makeConstraints({ (make) in
                    make.left.equalTo(imagesScrollView)
                    make.top.equalTo(imagesScrollView)
                    make.width.equalTo(79)
                    make.height.equalTo(imagesScrollView)
                    
                })
            } else if i == images.count - 1 {
                myImage.snp.makeConstraints({ (make) in
                    make.top.equalTo(imagesScrollView)
                    make.left.equalTo(contentImage[i - 1].snp.right).offset(11)
                    make.width.equalTo(79)
                    make.right.equalTo(imagesScrollView)
                    make.height.equalTo(imagesScrollView)
                    
                })
            } else {
                myImage.snp.makeConstraints({ (make) in
                    make.top.equalTo(imagesScrollView)
                    make.left.equalTo(contentImage[i - 1].snp.right).offset(11)
                    make.width.equalTo(79)
                    make.height.equalTo(imagesScrollView)
                })
            }
            
        }

    }
    
    func tapAction(sender : UITapGestureRecognizer) {
        let imageView = sender.view
        if let tag = imageView?.tag {
            tapClosure?(tag)
        }
    }
    
    func showZoomImageView(tap : UITapGestureRecognizer) {
        let bgView = UIScrollView.init(frame: UIScreen.main.bounds)
        bgView.backgroundColor = UIColor.black
        let tapBg = UITapGestureRecognizer.init(target: self, action: #selector(tapBgView(tapBgRecognizer:)))
        bgView.addGestureRecognizer(tapBg)
        let picView = tap.view as! UIImageView//view 强制转换uiimageView
        let imageView = UIImageView.init()
        imageView.image = picView.image;
        imageView.frame = bgView.convert(picView.frame, from: self)
        bgView.addSubview(imageView)
        UIApplication.shared.keyWindow?.addSubview(bgView)
        self.lastImageView = imageView
        self.originalFrame = imageView.frame
        self.scrollView = bgView
        self.scrollView?.maximumZoomScale = 1.5
        self.scrollView?.delegate = self
        
        UIView.animate(
            withDuration: 0.5,
            delay: 0.0,
            options: UIViewAnimationOptions.beginFromCurrentState,
            animations: {
                var frame = imageView.frame
                frame.size.width = bgView.frame.size.width
                frame.size.height = frame.size.width * ((imageView.image?.size.height)! / (imageView.image?.size.width)!)
                frame.origin.x = 0
                frame.origin.y = (bgView.frame.size.height - frame.size.height) * 0.5
                imageView.frame = frame
        }, completion: nil
        )
        
    }
    
    func tapBgView(tapBgRecognizer:UITapGestureRecognizer) {
        self.scrollView?.contentOffset = CGPoint.zero
        UIView.animate(withDuration: 0.5, animations: {
            self.lastImageView?.frame = self.originalFrame
            tapBgRecognizer.view?.backgroundColor = UIColor.clear
        }) { (finished:Bool) in
            tapBgRecognizer.view?.removeFromSuperview()
            self.scrollView = nil
            self.lastImageView = nil
        }
    }

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.lastImageView
    }
    
}

class AppInformationCell: UITableViewCell {
    
    var icon: UIImageView = {
        let myIcon = UIImageView()
        return myIcon
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "应用介绍"
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
