//
//  NotificationPersonCell3.swift
//  Office
//
//  Created by 梁仕友 on 2017/5/31.
//  Copyright © 2017年 roger. All rights reserved.
//

import UIKit

class NotificationPersonCell3: UICollectionViewCell {
    
    var image :UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        image = UIImageView()
        contentView.addSubview(image)
        image.image = UIImage(named: "btn_add")
        image.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentView)
            make.centerX.equalTo(contentView)
            make.width.height.equalTo(40)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
