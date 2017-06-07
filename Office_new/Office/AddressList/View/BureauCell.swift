//
//  BureauCell.swift
//  Office
//
//  Created by 梁仕友 on 2017/5/18.
//  Copyright © 2017年 roger. All rights reserved.
//

import UIKit

class BureauCell: UITableViewCell {

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var contentLab: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        img.layer.masksToBounds = true
        img.layer.cornerRadius = 4
        img.backgroundColor = UIColor.T2
        contentLab.font = UIFont.H5
        contentLab.textColor = UIColor.T2
    }
    
}
