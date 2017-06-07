//
//  DetailCell.swift
//  GXTax
//
//  Created by roger on 2017/2/23.
//  Copyright © 2017年 J HD. All rights reserved.
//

import UIKit

class DetailCell: UITableViewCell {
    
    var rows: [String] {
        return ["纳税人识别号:", "纳税人名称:", "主管税务所科分局:", "经营地址:"]
    }
    
    func set(model: DetailModel) {
        dataLabel[0].text = model.nsrsbh
        dataLabel[1].text = model.nsrmc
        dataLabel[2].text = model.zgswskfjmc
        dataLabel[3].text = model.scjydz
    }
    
    var titleLabel = [UILabel]()
    var dataLabel = [UILabel]()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor.B1
        contentView.backgroundColor = UIColor.white

        for (i, row) in rows.enumerated() {
            let label = UILabel()
            label.text = row
            label.font = .normal(12)
            label.textColor = .black
            contentView.addSubview(label)
            let detail = UILabel()
            detail.font = .normal(12)
            detail.textColor = .darkText
            detail.textAlignment = .left
            detail.numberOfLines = 1
            contentView.addSubview(detail)
            titleLabel.append(label)
            dataLabel.append(detail)
            detail.snp.makeConstraints({ (make) in
                if i == 0 {
                    make.top.equalTo(contentView).inset(12)
                } else {
                    make.top.greaterThanOrEqualTo(titleLabel[i - 1].snp.bottom).offset(16).priority(900)
                    make.top.equalTo(dataLabel[i - 1].snp.bottom).offset(16).priority(899)
                }
                make.right.equalTo(contentView).inset(12)
                if i == rows.count - 1 {
                    make.bottom.equalTo(contentView).inset(12)
                }
            })
            
            
            if i == rows.count - 1 {
                label.snp.makeConstraints({ (make) in
                    make.top.equalTo(detail)
                    make.left.equalTo(contentView).inset(12)
                    make.right.equalTo(detail.snp.left).offset(-8)
                    make.bottom.lessThanOrEqualTo(contentView).inset(12)
                })
            } else {
                label.snp.makeConstraints({ (make) in
                    make.top.equalTo(detail)
                    make.left.equalTo(contentView).inset(12)
                    make.right.equalTo(detail.snp.left).offset(-8)
                })
            }
            
            label.setContentHuggingPriority(800, for: .horizontal)
            label.setContentCompressionResistancePriority(800, for: .horizontal)
            detail.setContentHuggingPriority(600, for: .horizontal)
            detail.setContentCompressionResistancePriority(600, for: .horizontal)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}