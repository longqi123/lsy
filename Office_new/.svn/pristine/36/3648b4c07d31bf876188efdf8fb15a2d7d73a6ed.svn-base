//
//  LoginButtonCell.swift
//  Office
//
//  Created by GA GA on 17/05/2017.
//  Copyright © 2017 roger. All rights reserved.
//

import UIKit

class LoginButtonCell: UITableViewCell {
    
    var loginButton = UIButton()
    

    init() {
        super.init(style: .default, reuseIdentifier: nil)
        selectionStyle = .none
        
        loginButton.setTitle("登  录", for: .normal)
        loginButton.setTitleColor(.white, for: .normal)
        //warning 谭宇翔删除了system颜色值
//        loginButton.setBackgroundImage(UIImage(color: .red), for: .normal)
        loginButton.backgroundColor = UIColor.B1
        loginButton.layer.cornerRadius = 22
        loginButton.clipsToBounds = true
        loginButton.titleLabel?.font = .normal(15)
        
        contentView.addSubview(loginButton)
        loginButton.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).inset(50)
            make.height.equalTo(44)
            make.right.equalTo(contentView).inset(50)
            make.top.equalTo(contentView).inset(77)
            make.bottom.equalTo(contentView)
        }
        
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
