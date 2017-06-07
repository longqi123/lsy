//
//  NotificationPersonCell4.swift
//  Office
//
//  Created by 梁仕友 on 2017/6/1.
//  Copyright © 2017年 roger. All rights reserved.
//

import UIKit

@objc class NotificationPersonCell4: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var switck: UISwitch!
    
    @IBAction func switchClick(_ sender: Any) {
        
        if self.switck.isOn {
            self.switchONClick!(true)
        }else{
            self.switchONClick!(false)
        }
    }
    
    var switchONClick:((_ switchOn:Bool) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        title.font = UIFont.H3
        title.textColor = UIColor.T2
        
    }
}
