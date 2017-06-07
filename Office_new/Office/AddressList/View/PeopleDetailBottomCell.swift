//
//  PeopleDetailBottomCell.swift
//  Office
//
//  Created by roger on 2017/4/10.
//  Copyright © 2017年 roger. All rights reserved.
//

import UIKit

class PeopleDetailBottomCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func sendMessage(_ sender: UIButton) {
        UIApplication.shared.openURL(URL(string: "sms://\("1391234567890")")!)
    }
    @IBAction func callPhone(_ sender: UIButton) {
        UIApplication.shared.openURL(URL(string: "tel://\("1391234567890")")!)

    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
