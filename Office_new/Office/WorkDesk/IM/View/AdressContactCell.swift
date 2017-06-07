//
//  AdressContactCell.swift
//  Office
//
//  Created by 梁仕友 on 2017/5/26.
//  Copyright © 2017年 roger. All rights reserved.
//

import UIKit

class AdressContactCell: UITableViewCell {

    @IBOutlet weak var xuanZhongImg: UIButton!
    
    @IBOutlet weak var photolab: UILabel!
    
    @IBOutlet weak var nameLab: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        nameLab.textColor = UIColor.T2
        nameLab.font = UIFont.H5

        photolab.textColor = UIColor.T6
        photolab.font = UIFont.H8
        photolab.layer.masksToBounds = true
        photolab.layer.cornerRadius = 20
        
    }
}
