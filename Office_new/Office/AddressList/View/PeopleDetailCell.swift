//
//  PeopleDetailCell.swift
//  Office
//
//  Created by roger on 2017/4/10.
//  Copyright © 2017年 roger. All rights reserved.
//

import UIKit
import CoreFramework

protocol PeopleDetailDelegate {
    func buttonClicked()
}

class PeopleDetailCell: BaseTableViewCell {

    @IBAction func buttonClicked(_ sender: UIButton) {
        //self.delegate?.buttonClicked()
        if titleLabel.text == "电话" {
            UIApplication.shared.openURL(URL(string: "tel://\(detailLabel.text!)")!)
        }else{
            UIApplication.shared.openURL(URL(string: "mailto://\(detailLabel.text!)")!)
        }
    }
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    public var delegate: PeopleDetailDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        titleLabel.textColor = UIColor.T3
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
