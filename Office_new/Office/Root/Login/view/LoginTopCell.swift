//
//  LoginTopCell.swift
//  Office
//
//  Created by GA GA on 17/05/2017.
//  Copyright © 2017 roger. All rights reserved.
//

import UIKit

class LoginTopCell: UITableViewCell {
    
    var avatar: UIImageView!
    init() {
        super.init(style: .default, reuseIdentifier: nil)
        selectionStyle = .none
        makeUI()
    }
    
    func makeUI() {
        selectionStyle = .none
        
        avatar = UIImageView()
        avatar.clipsToBounds = true
        avatar.image = #imageLiteral(resourceName: "login-bg")
        
        contentView.addSubview(avatar)
        avatar.snp.makeConstraints { (make) in
            make.top.equalTo(contentView)
            make.height.equalTo(200)
            make.bottom.equalTo(contentView).inset(20)
            make.left.equalTo(contentView)
            make.right.equalTo(contentView)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

