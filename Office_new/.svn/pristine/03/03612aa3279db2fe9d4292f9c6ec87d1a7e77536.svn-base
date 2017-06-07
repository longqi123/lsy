//
//  passAndNameCell.swift
//  Office
//
//  Created by GA GA on 17/05/2017.
//  Copyright © 2017 roger. All rights reserved.
//

import UIKit

class passAndNameCell: UITableViewCell {
    var textFiled: LineTextField!

    init() {
        super.init(style: .default, reuseIdentifier: nil)
        selectionStyle = .none
        textFiled = LineTextField(linePadding: 0)
        textFiled.placeholder = "用户名/手机号"
        textFiled.font = UIFont.H4
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "avatar_user")
        imageView.contentMode = .center
        textFiled.leftView = imageView
        contentView.addSubview(textFiled)
        textFiled.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).inset(25)
            make.top.equalTo(contentView)
            make.height.equalTo(53)
            make.bottom.equalTo(contentView)
            make.right.equalTo(contentView).inset(25)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
