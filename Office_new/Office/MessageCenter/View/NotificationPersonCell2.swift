//
//  NotificationPersonCell2.swift
//  Office
//
//  Created by 梁仕友 on 2017/5/31.
//  Copyright © 2017年 roger. All rights reserved.
//
import UIKit

class NotificationPersonCell2: UICollectionViewCell {
    
    var image :UIImageView!
    var nameLab:UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        nameLab = UILabel()
        contentView.addSubview(nameLab)
        nameLab.textColor = UIColor.T6
        nameLab.font = UIFont.H8
        nameLab.textAlignment = .center
        nameLab.layer.masksToBounds = true
        nameLab.layer.cornerRadius = 20
        nameLab.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentView)
            make.centerX.equalTo(contentView)
            make.width.height.equalTo(40)
        }
        
        
        image = UIImageView()
        contentView.addSubview(image)
        image.image = UIImage(named: "icon_delete")
        image.snp.makeConstraints { (make) in
            make.bottom.equalTo(nameLab.snp.top).offset(8)
            make.right.equalTo(nameLab).offset(0)
            make.width.height.equalTo(10)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
