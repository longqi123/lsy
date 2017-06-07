//
//  MineCell.swift
//  Office
//
//  Created by GA GA on 17/05/2017.
//  Copyright © 2017 roger. All rights reserved.
//

import UIKit

class MineCell: UITableViewCell {
    
    let leftImageView = UIImageView()
    let titleLabel = UILabel()
    let detail = UILabel()
    let rightImageView = UIImageView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = UIColor.white
        
        contentView.addSubview(leftImageView)
        leftImageView.sizeToFit()
        leftImageView.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(12)
            make.centerY.equalTo(contentView.snp.centerY)
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.textColor = UIColor.T2
        titleLabel.font = UIFont.H3
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(leftImageView.snp.right).offset(20)
            make.centerY.equalTo(contentView)
        }
        
        contentView.addSubview(rightImageView)
        rightImageView.image = UIImage(named: "xia_yi_ge")
        rightImageView.sizeToFit()
        rightImageView.snp.makeConstraints { (make) in
            make.right.equalTo(contentView).inset(12)
            make.centerY.equalTo(contentView)
        }
        
        contentView.addSubview(detail)
        detail.textColor = UIColor.T3
        detail.font = UIFont.H5
        detail.snp.makeConstraints { (make) in
            make.right.equalTo(rightImageView.snp.left).offset(-10)
            make.centerY.equalTo(contentView)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

class MineHeaderView: UITableViewHeaderFooterView {
    var headerBackgroundImageView = UIImageView()
    var bottomView = UIView()
    var bottomLine = UIView()
    
    var headerName: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.layer.cornerRadius = 57.5
        label.clipsToBounds = true
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 30)
        return label
    }()
    
    var headerImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "mo_ren_tou_xiang.png")
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.cornerRadius = 57.5
        image.layer.borderColor = UIColor.white.cgColor
        image.layer.borderWidth = 1
        return image
    }()
    var headerButton = UIButton()
    var nameLabel = UILabel()
    var backButton: UIButton = {
        let btn = UIButton()
        btn.setImage(#imageLiteral(resourceName: "icon_back_left"), for: .normal)
        return btn
    }()
    
    var headerBlock: (() -> Void)?
    var backBlock: (() -> Void)?
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        makeUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func makeUI() {
        headerBackgroundImageView.image = #imageLiteral(resourceName: "wo_de_bg")
        contentView.addSubview(headerBackgroundImageView)
        headerBackgroundImageView.snp.makeConstraints { (make) in
            make.top.equalTo(contentView)
            make.left.equalTo(contentView)
            make.right.equalTo(contentView)
            make.height.equalTo(170)
        }
        
        bottomView.backgroundColor = UIColor.white
        contentView.addSubview(bottomView)
        bottomView.snp.makeConstraints { (make) in
            make.top.equalTo(headerBackgroundImageView.snp.bottom)
            make.left.equalTo(contentView)
            make.right.equalTo(contentView)
            make.height.equalTo(82)
        }
        
        bottomLine.backgroundColor = UIColor.B2
        contentView.addSubview(bottomLine)
        bottomLine.snp.makeConstraints { (make) in
            make.top.equalTo(bottomView.snp.bottom)
            make.left.equalTo(contentView)
            make.right.equalTo(contentView)
            make.height.equalTo(10)
            make.bottom.equalTo(contentView)
        }
        
        contentView.addSubview(headerImageView)
        headerImageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(contentView)
            make.top.equalTo(contentView).inset(91)
            make.width.equalTo(115)
            make.height.equalTo(115)
        }
        
        contentView.addSubview(headerName)
        headerName.snp.makeConstraints { (make) in
            make.edges.equalTo(headerImageView)
        }
        
        headerButton.backgroundColor = UIColor.clear
        headerButton.addTarget(self, action: #selector(headerImageAction), for: .touchUpInside)
        contentView.addSubview(headerButton)
        headerButton.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalTo(headerImageView)
        }
        
        nameLabel.font = UIFont.H2
        nameLabel.textColor = UIColor.T2
        nameLabel.textAlignment = .center
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(headerImageView.snp.bottom).offset(7)
            make.left.equalTo(0)
            make.right.equalTo(0)
        }
        
        contentView.addSubview(backButton)
        backButton.addTarget(self, action: #selector(back), for: .touchUpInside)
        backButton.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).inset(12)
            make.top.equalTo(contentView).inset(20)
        }
    }
    
    func set(json: DlzhxxModel?) {
        nameLabel.text = json?.swryxm
        
        if let name = json?.swryxm, let dm = json?.swryDm {
            if (name.characters.count) > 2 {
                headerName.text = (name as NSString).substring(with: NSMakeRange((name.characters.count) - 2, 2))
            }else{
                headerName.text = name
            }
            headerName.backgroundColor = setNameBackColor(name: name, dm: dm)

        }
    }
    
    func headerImageAction() {
        headerBlock?()
    }
    
    func back() {
        backBlock?()
    }
    
}


