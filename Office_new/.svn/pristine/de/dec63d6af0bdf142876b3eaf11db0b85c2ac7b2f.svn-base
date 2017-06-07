//
//  AppListCell.swift
//  Office
//
//  Created by GA GA on 22/05/2017.
//  Copyright © 2017 roger. All rights reserved.
//

import UIKit

class AppListCell: UITableViewCell {
    
    /// 关注或取消
    var isFollowedClosure: (()->Void)?

    var headImage: UIImageView = {
        let head = UIImageView()
        head.layer.cornerRadius = 25
        head.contentMode = .scaleAspectFit
        head.clipsToBounds = true
        head.clipsToBounds = true
        return head
    }()
    
    var followers: UILabel = {
        let label = UILabel()
        label.font = UIFont.H3
        label.textColor = UIColor.T5
        return label
    }()
    
    var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.H3
        label.textColor = UIColor.T2
        return label
    }()
    
    var followButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "guan_zhu"), for: .normal)
        return button
    }()
    
    func setButtonStyle(state: Bool) {
        if state {
            followButton.setImage(#imageLiteral(resourceName: "yi_guan_zhu"), for: .normal)
        } else {
            followButton.setImage(#imageLiteral(resourceName: "guan_zhu"), for: .normal)
        }
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        contentView.addSubview(headImage)
        headImage.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).inset(10)
            make.height.equalTo(50)
            make.width.equalTo(50)
            make.top.equalTo(contentView).inset(20)
            make.centerY.equalTo(contentView)
        }
        
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(headImage.snp.right).offset(10)
            make.top.equalTo(contentView)
            make.bottom.equalTo(contentView.snp.centerY)
            make.width.equalTo(100)
        }
        
        contentView.addSubview(followers)
        followers.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel)
            make.left.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp.bottom)
            make.bottom.equalTo(headImage)
        }
        
        contentView.addSubview(followButton)
        followButton.addTarget(self, action: #selector(followed), for: .touchUpInside)
        followButton.snp.makeConstraints { (make) in
            make.right.equalTo(contentView).inset(10)
            make.height.equalTo(30)
            make.width.equalTo(60)
            make.centerY.equalTo(contentView)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func set(json: AppSquareModel) {
        nameLabel.text = json.yymc
        let sfgz = json.sfgz
        let imageData = json.yytbxzdz
        followers.text = json.gzlxx + "人已关注"
        if let decodedData = Data(base64Encoded: imageData, options: .ignoreUnknownCharacters) {
            let image = UIImage(data: decodedData)
            headImage.image = image
        }
        if sfgz == "01" {
            setButtonStyle(state: true)
        } else {
            setButtonStyle(state: false)
        }
    }
    
    func set(json: WorkDeskModel) {
        nameLabel.text = json.yymc
        let imageData = json.yytbxzdz
        followers.text = json.gzlxx + "人已关注"

        if let decodedData = Data(base64Encoded: imageData, options: .ignoreUnknownCharacters) {
            let image = UIImage(data: decodedData)
            headImage.image = image
        }
        setButtonStyle(state: true)
    }
    
    func set(json: AppsDetaisModel) {
        nameLabel.text = json.yymc
        let sfgz = json.sfgz
        let imageData = json.yytbxzdz
        followers.text = json.gzlxx + "人已关注"

        if let decodedData = Data(base64Encoded: imageData, options: .ignoreUnknownCharacters) {
            let image = UIImage(data: decodedData)
            headImage.image = image
        }
        if sfgz == "01" {
            setButtonStyle(state: true)
        } else {
            setButtonStyle(state: false)
        }
    }
    
    func followed() {
        isFollowedClosure?()
    }
}
