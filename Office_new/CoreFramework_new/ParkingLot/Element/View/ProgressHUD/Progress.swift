//
//  CSToast.swift
//  Example
//
//  Created by roger on 2017/04/11.
//  Copyright © 2016年 J HD. All rights reserved.
//

import UIKit

public enum ProgressType {
    
    ///成功
    case success
    ///其他
    case other
    ///失败
    case failure
    
}

class Progress: UIView{
    
    fileprivate var background = UIView()
    fileprivate var contentView = UIView()
    fileprivate var img = UIImageView()
    fileprivate var title = UILabel()
    fileprivate var block: (()->())?

    fileprivate static let shareInstance = Progress()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        
        //background
        addSubview(background)
        background.backgroundColor = UIColor(white: 0, alpha: 0.3)
        background.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        //contentView
        addSubview(contentView)
        contentView.layer.cornerRadius = 6
        contentView.backgroundColor = UIColor.white
        contentView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.height.equalTo(161)
        }
        
        //title
        contentView.addSubview(title)
        title.numberOfLines = 1
        title.adjustsFontSizeToFitWidth = true
        title.textAlignment = .center
        title.font = UIFont.normal(16)
        title.textColor = UIColor.T1
        title.snp.makeConstraints { (make) in
            make.center.equalTo(contentView).offset(25)
            make.left.equalTo(self).inset(14)
            make.right.equalTo(self).inset(14)
        }
        
        //img
        contentView.addSubview(img)
        img.isHidden = true
        img.snp.makeConstraints { (make) in
            make.centerX.equalTo(contentView)
            make.centerY.equalTo(contentView).offset(-15)
        }
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public static func show(_ title: String,_ type: ProgressType, block:(()->())? ){
        guard let window = UIApplication.shared.keyWindow else {return}
        
        let alertView = Progress.shareInstance
        window.addSubview(alertView)
        window.bringSubview(toFront: alertView)
        alertView.title.text = title
        alertView.block = block
        
        switch type {
        case .success:
            alertView.img.image = #imageLiteral(resourceName: "jiao_kuan_cheng_gong")
        case .other:
            alertView.img.image = #imageLiteral(resourceName: "jiao_kuan_cheng_gong")
        case .failure:
            alertView.img.image = #imageLiteral(resourceName: "jiao_kuan_shi_bai")
        }
        
        UIView.animate(withDuration: 0.33, animations: { 
            alertView.alpha = 1.0
        }) { (true) in
            UIView.animate(withDuration: 0.33, animations: {
                alertView.alpha = 0.0
            }, completion: { _ in
                alertView.removeFromSuperview()
                guard Progress.shareInstance.block != nil else {return}
                DispatchQueue.main.async(execute: {
                    block!()
                })
            })
        }
    }
}


