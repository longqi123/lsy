//
//  AddBureauCell.swift
//  Office
//
//  Created by 梁仕友 on 2017/5/26.
//  Copyright © 2017年 roger. All rights reserved.
//

import UIKit

class AddBureauCell: UITableViewCell {

    
    @IBOutlet weak var xunzhong: UIButton!
    
    @IBOutlet weak var nameLab: UILabel!
    
    var ChioceBlock: ((_ isClick:Bool) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        nameLab.font = UIFont.H5
        nameLab.textColor = UIColor.T2
    }
    
    @IBAction func xuangZhongClick(_ sender: Any) {
        xunzhong.isSelected = !xunzhong.isSelected
        self.ChioceBlock!(xunzhong.isSelected)
    }
}
