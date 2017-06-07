//
//  NotificationDetailCell.swift
//  Office
//
//  Created by 梁仕友 on 2017/5/31.
//  Copyright © 2017年 roger. All rights reserved.
//

import UIKit

class NotificationDetailCell: UITableViewCell {

    
    @IBOutlet weak var content: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        content.font = UIFont.H5
        content.textColor = UIColor.T3
    }
}