//
//  auditCell.swift
//  Office
//
//  Created by 梁仕友 on 2017/6/3.
//  Copyright © 2017年 roger. All rights reserved.
//

import UIKit

class auditCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var content: UILabel!
    
    @IBOutlet weak var yiduStatue: UILabel!

    @IBOutlet weak var auditStatue: UILabel!
    
    @IBOutlet weak var time: UILabel!
    
    @IBOutlet weak var okBtn: UIButton!
    
    @IBOutlet weak var detail: UIButton!
    
    
    @IBAction func okBtnclick(_ sender: Any) {
        self.ConfirmBlock!()
    }
    
    var ConfirmBlock:(() -> Void)?
    

    override func awakeFromNib() {
        super.awakeFromNib()
        title.font = UIFont.H5
        title.textColor = UIColor.T2
        content.font = UIFont.H7
        content.textColor = UIColor.T3
        time.font = UIFont.H8
        time.textColor = UIColor.T3
        okBtn.titleLabel?.font = .H5
        okBtn.setTitleColor(.T7, for: .normal)
        detail.titleLabel?.font = .H8
        detail.setTitleColor(.T2, for: .normal)
        auditStatue.font = UIFont.H7
        auditStatue.textColor = UIColor.T3
        detail.isUserInteractionEnabled = false
    }
    
}
