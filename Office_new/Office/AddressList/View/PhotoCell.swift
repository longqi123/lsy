//
//  PhotoCell.swift
//  Office
//
//  Created by roger on 2017/4/10.
//  Copyright © 2017年 roger. All rights reserved.
//

import UIKit
import CoreFramework

class PhotoCell: BaseTableViewCell {

    @IBOutlet weak var name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
