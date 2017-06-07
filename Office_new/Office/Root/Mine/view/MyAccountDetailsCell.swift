//
//  MyAccountDetailsCell.swift
//  Office
//
//  Created by GA GA on 18/05/2017.
//  Copyright © 2017 roger. All rights reserved.
//

import UIKit

class MyAccountDetailsCell: UITableViewCell {
    
    let title: UILabel = {
        let label = UILabel()
        label.font = UIFont.H3
        label.textColor = UIColor.T2
        label.text = "系统版本："
        label.textAlignment = .center
        return label
    }()
    let acount: UILabel = {
        let label = UILabel()
        label.font = UIFont.H3
        label.textColor = UIColor.T2
        label.text = "账号："
        label.textAlignment = .left
        return label
    }()
    let name: UILabel = {
        let label = UILabel()
        label.font = UIFont.H3
        label.textColor = UIColor.T2
        label.text = "名称："
        label.textAlignment = .left
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(title)
        title.snp.makeConstraints { (make) in
            make.top.equalTo(contentView)
            make.left.equalTo(contentView).inset(5)
            make.right.equalTo(contentView)
            make.height.equalTo(44)
        }
        
        let line = UIView()
        line.backgroundColor = UIColor.L1
        contentView.addSubview(line)
        line.snp.makeConstraints { (make) in
            make.top.equalTo(title.snp.bottom)
            make.left.equalTo(contentView)
            make.right.equalTo(contentView)
            make.height.equalTo(1)
        }
        
        contentView.addSubview(acount)
        acount.snp.makeConstraints { (make) in
            make.top.equalTo(line.snp.bottom)
            make.left.equalTo(contentView).inset(5)
            make.right.equalTo(contentView)
            make.height.equalTo(44)

        }
        
        contentView.addSubview(name)
        name.snp.makeConstraints { (make) in
            make.top.equalTo(acount.snp.bottom)
            make.left.equalTo(contentView).inset(5)
            make.right.equalTo(contentView)
            make.height.equalTo(44)

        }
        
        let separateView = UIView()
        separateView.backgroundColor = UIColor.L1
        contentView.addSubview(separateView)
        separateView.snp.makeConstraints { (make) in
            make.top.equalTo(name.snp.bottom)
            make.height.equalTo(20)
            make.left.equalTo(contentView)
            make.right.equalTo(contentView)
            make.bottom.equalTo(contentView)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
