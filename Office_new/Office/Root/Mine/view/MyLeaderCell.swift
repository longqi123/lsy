//
//  MyLeaderCell.swift
//  Office
//
//  Created by GA GA on 18/05/2017.
//  Copyright © 2017 roger. All rights reserved.
//

import UIKit

class MyLeaderCell: UITableViewCell {
    
    var tapClosure: (()->Void)?

    var selectImage: UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "mei_xuan_zhong_zhuang_tai_big")
        image.contentMode = .center
        return image
    }()
    var portraitName: UILabel = {
        let imageLabel = UILabel()
        imageLabel.textColor = UIColor.T6
        imageLabel.font = UIFont.H8
        imageLabel.layer.cornerRadius = 20
        imageLabel.clipsToBounds = true
        imageLabel.textAlignment = .center
        return imageLabel
    }()
    var name: UILabel = {
        let label = UILabel()
        label.font = UIFont.H2
        label.textColor = UIColor.T1
        return label
    }()
    
    var position: UILabel = {
        let label = UILabel()
        label.font = UIFont.H6
        label.textColor = UIColor.T3
        return label
    }()
    
    var line: UIView = {
        let line = UIView()
        line.backgroundColor = UIColor.L1
        return line
    }()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        contentView.addSubview(selectImage)
        selectImage.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).inset(12)
            make.centerY.equalTo(contentView)
            make.height.equalTo(22)
            make.width.equalTo(22)
        }
        
        contentView.addSubview(portraitName)
        let red = CGFloat(arc4random_uniform(255))/CGFloat(255.0)
        let green = CGFloat( arc4random_uniform(255))/CGFloat(255.0)
        let blue = CGFloat(arc4random_uniform(255))/CGFloat(255.0)
        let alpha = 1.0
        portraitName.backgroundColor = UIColor.init(red:red, green:green, blue:blue , alpha: CGFloat(alpha))
        portraitName.snp.makeConstraints { (make) in
            make.left.equalTo(selectImage.snp.right).offset(20)
            make.centerY.equalTo(contentView)
            make.height.equalTo(42)
            make.width.equalTo(42)
        }
        
        contentView.addSubview(name)
        name.snp.makeConstraints { (make) in
            make.left.equalTo(portraitName.snp.right).offset(10)
            make.top.equalTo(portraitName)
        }
        
        contentView.addSubview(position)
        position.snp.makeConstraints { (make) in
            make.bottom.equalTo(portraitName)
            make.left.equalTo(name)
        }
        
        contentView.addSubview(line)
        line.snp.makeConstraints { (make) in
            make.left.equalTo(portraitName)
            make.height.equalTo(0.5)
            make.bottom.equalTo(contentView)
            make.right.equalTo(contentView)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func set(json: TxlModel1) {
        name.text = json.ryxm
        position.text = json.levelname
        let xm = json.ryxm
        let dm = json.rydm
            if (xm.characters.count) > 2 {
                portraitName.text = (xm as NSString).substring(with: NSMakeRange((xm.characters.count) - 2, 2))
            }else{
                portraitName.text = xm
            }
            portraitName.backgroundColor = setNameBackColor(name: xm, dm: dm)
    }
    
}

class MyLeaderHeaderView: UIView {
    
    var department: UILabel = {
        let label = UILabel()
        label.font = UIFont.H3
        label.numberOfLines = 0
        label.textColor = UIColor.T2
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        self.addSubview(department)
        department.snp.makeConstraints { (make) in
            make.left.equalTo(self).inset(12)
            make.right.equalTo(self).inset(12)
            make.top.equalTo(self).inset(17)
            make.bottom.equalTo(self).inset(17)
        }
        
        self.addLine { (make) in
            make.left.equalTo(self)
            make.right.equalTo(self)
            make.bottom.equalTo(self)
            make.height.equalTo(0.5)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(json: TxlModel1) {
        department.text = json.swjgmc + " - " + json.csmc
    }
}