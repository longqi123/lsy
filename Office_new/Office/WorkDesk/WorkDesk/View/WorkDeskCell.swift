//
//  WorkDeskCell.swift
//  Office
//
//  Created by roger on 2017/3/30.
//  Copyright © 2017年 roger. All rights reserved.
//

import UIKit

class WorkDeskCell: UICollectionViewCell {
    
    var appImage :UIImageView!
    var label :UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        appImage = UIImageView()
        contentView.addSubview(appImage)
        appImage.image = UIImage(named: "deng_ji_xin_xi")
        appImage.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentView).offset(-10)
            make.centerX.equalTo(contentView)
            make.width.height.equalTo(20)
        }
        
        label = UILabel()
        label.font = UIFont.normal(15)
        label.numberOfLines = 2
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        contentView.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentView).offset(20)
            make.centerX.equalTo(contentView)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(json: WorkDeskModel) {
        let imageData = json.yytbxzdz
        if let decodedData = Data(base64Encoded: imageData, options: .ignoreUnknownCharacters) {
            let image = UIImage(data: decodedData)
            appImage.image = image
        }
    }
}
