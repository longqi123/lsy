//
//  AnnouncementControllerCell.swift
//  Office
//
//  Created by 梁仕友 on 2017/5/27.
//  Copyright © 2017年 roger. All rights reserved.
//

import UIKit
import CoreFramework

class AnnouncementControllerCell: BaseTableViewCell {

    @IBOutlet weak var content: UILabel!
    
    @IBOutlet weak var photoImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        content.font = UIFont.H3
        content.textColor = UIColor.T2
        photoImg.contentMode = .scaleToFill
    }

}
