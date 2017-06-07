//
//  Personaldetailcell2.swift
//  Office
//
//  Created by 梁仕友 on 2017/5/17.
//  Copyright © 2017年 roger. All rights reserved.
//

import UIKit

class Personaldetailcell2: UITableViewCell {

    @IBOutlet weak var nameLab: UILabel!
    
    @IBOutlet weak var contentLab: UILabel!
    
    @IBOutlet weak var leftBtn: UIButton!
    
    @IBOutlet weak var rightBtn: UIButton!
    
    var doneBlock:((_ btntag:Int) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentLab.font = UIFont.H3
        contentLab.textColor = UIColor.T2
        nameLab.font = UIFont.H8
        nameLab.textColor = UIColor.T4
       
    }
    
    @IBAction func leftBtnclick(_ sender: Any) {
        self.doneBlock!(100)
    }
    
    @IBAction func rightBtnClick(_ sender: Any) {
        self.doneBlock!(200)
    }
}
