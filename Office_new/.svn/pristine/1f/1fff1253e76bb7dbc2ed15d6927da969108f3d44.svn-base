//
//  AppSquareGeneralView.swift
//  Office
//
//  Created by GA GA on 19/05/2017.
//  Copyright © 2017 roger. All rights reserved.
//

import UIKit

class AppSquareGeneralView: UIView {

    
    var appImage: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .red
        image.layer.cornerRadius = 15
        image.isUserInteractionEnabled = true
        return image
    }()
    var appName: UILabel = {
        let label = UILabel()
        label.backgroundColor = .yellow
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(appImage)
        appImage.snp.makeConstraints { (make) in
            make.top.equalTo(self).inset(10)
            make.centerX.equalTo(self)
            make.width.equalTo(30)
            make.height.equalTo(30)
        }
        self.addSubview(appName)
        appName.snp.makeConstraints { (make) in
            make.top.equalTo(appImage.snp.bottom).offset(10)
            make.height.equalTo(30)
            make.width.equalTo(100)
            make.centerX.equalTo(appImage)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
