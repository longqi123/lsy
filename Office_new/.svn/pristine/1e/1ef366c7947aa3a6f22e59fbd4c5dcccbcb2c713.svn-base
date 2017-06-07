//
//  ApplicationSquareCell.swift
//  Office
//
//  Created by GA GA on 18/05/2017.
//  Copyright © 2017 roger. All rights reserved.
//

import UIKit
import CoreFramework

class ApplicationSquareCell: UICollectionViewCell {
    
    var appImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.layer.cornerRadius = 15
        image.clipsToBounds = true
        image.isUserInteractionEnabled = true
        return image
    }()
    var appName: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .white
        contentView.addSubview(appImage)
        appImage.snp.makeConstraints { (make) in
            make.top.equalTo(contentView).inset(11)
            make.width.height.equalTo(30)
            make.centerX.equalTo(contentView)
            
        }
        contentView.addSubview(appName)
        appName.snp.makeConstraints { (make) in
            make.top.equalTo(appImage.snp.bottom).offset(10)
            make.centerX.equalTo(appImage)
            make.bottom.equalTo(contentView).inset(21)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(json: AppSquareModel) {
        appName.text = json.yymc
        
        let imageData = json.yytbxzdz
        if let decodedData = Data(base64Encoded: imageData, options: .ignoreUnknownCharacters) {
            let image = UIImage(data: decodedData)
            appImage.image = image
        }

    }
}

class ApplicationSquareHeader: UICollectionReusableView {
    
    var tapClosure: (()->Void)?
    
    var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.T1
        label.font = UIFont.H3
        label.textAlignment = .left
        return label
    }()
    
    var rankLabel: UILabel = {
        let label = UILabel()
        label.text = "top3"
        label.textColor = UIColor.T7
        label.font = UIFont.H5
        label.textAlignment = .left
        return label
    }()
    
    var rightImage: UIImageView = {
        let pic = UIImageView()
        pic.image = #imageLiteral(resourceName: "san_ge_dian")
        pic.contentMode = .scaleAspectFit
        pic.isUserInteractionEnabled = true
        return pic
    }()
    
    public static func initReuseView(collectionView: UICollectionView, elementKind: String, identifier: String, indexPath: IndexPath) ->  ApplicationSquareHeader{
        var header: ApplicationSquareHeader!
        
        header = collectionView.dequeueReusableSupplementaryView(ofKind: elementKind, withReuseIdentifier: identifier, for: indexPath) as! ApplicationSquareHeader
        header.rightImage.tag = indexPath.section
        return header
        
    }
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self).inset(10)
            make.height.equalTo(33)
            make.centerY.equalTo(self)
        }
        
        self.addSubview(rankLabel)
        rankLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel.snp.right).offset(10)
            make.height.equalTo(33)
            make.centerY.equalTo(self)
        }
        
        self.addSubview(rightImage)
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        rightImage.addGestureRecognizer(tap)
        rightImage.snp.makeConstraints { (make) in
            make.right.equalTo(self).inset(10)
            make.centerY.equalTo(self)
        }
        
        let line = UIView()
        self.addSubview(line)
        line.backgroundColor = UIColor.L1
        line.snp.makeConstraints { (make) in
            make.height.equalTo(0.5)
            make.bottom.equalTo(self)
            make.width.equalTo(self)
            make.left.equalTo(self)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tapAction() {
        tapClosure?()
    }
    
    func set(name: String) {
        if name == "10001" {
            nameLabel.text = "查询类"
        } else if name == "10002" {
            nameLabel.text = "统计类"
        } else if name == "10003" {
            nameLabel.text = "调查通知"
        } else {
            nameLabel.text = "系统管理"
        }
    }
}

class ApplicationSquareFooter: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.B2
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
