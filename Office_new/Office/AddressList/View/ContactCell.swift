//
//  ContactCell.swift
//  Office
//
//  Created by roger on 2017/3/31.
//  Copyright © 2017年 roger. All rights reserved.
//

import UIKit
import CoreFramework

class ContactCell: UITableViewCell {

    @IBOutlet weak var photoLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var notification: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        nameLabel.textColor = UIColor.T2
        nameLabel.font = UIFont.H5

        notification.textColor = UIColor.T3
        notification.font = UIFont.H8
        
        photoLabel.textColor = UIColor.T6
        photoLabel.font = UIFont.H8
        photoLabel.layer.masksToBounds = true
        photoLabel.layer.cornerRadius = 20

    }
}
