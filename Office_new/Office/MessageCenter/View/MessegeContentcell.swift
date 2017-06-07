//
//  MessegeContentcell.swift
//  Office
//
//  Created by 梁仕友 on 2017/5/27.
//  Copyright © 2017年 roger. All rights reserved.
//

import UIKit

class MessegeContentcell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var originator: UILabel!
    
    @IBOutlet weak var time: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        title.font = UIFont.H3
        title.textColor = UIColor.T2
        originator.font = UIFont.H5
        originator.textColor = UIColor.T3
        time.font = UIFont.H8
        time.textColor = UIColor.T4
        
    }
}
