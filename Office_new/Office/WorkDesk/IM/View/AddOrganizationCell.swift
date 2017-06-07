//
//  AddOrganizationCell.swift
//  Office
//
//  Created by 梁仕友 on 2017/5/26.
//  Copyright © 2017年 roger. All rights reserved.
//

import UIKit

class AddOrganizationCell: UITableViewCell {

    
    @IBOutlet weak var nameLab: UILabel!
    
    
    @IBOutlet weak var xunzhong: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        nameLab.font = UIFont.H3
        nameLab.textColor = UIColor.T2
        selectionStyle = .none
    }

}
