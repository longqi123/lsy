//
//  SendNotificationControllerCell.swift
//  Office
//
//  Created by 梁仕友 on 2017/5/27.
//  Copyright © 2017年 roger. All rights reserved.
//

import UIKit
import CoreFramework

class SendNotificationControllerCell: UITableViewCell {

    @IBOutlet weak var yiduStatule: UILabel!
    
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var content: UILabel!
    
    @IBOutlet weak var statue: UILabel!
    
    @IBOutlet weak var time: UILabel!
    
    @IBOutlet weak var okBtn: UIButton!
    
    @IBOutlet weak var setailBtn: UIButton!
    
    var ConfirmBlock:(() -> Void)?
    
    @IBAction func okBtn(_ sender: Any) {
        self.ConfirmBlock!()
    }
    
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
        setailBtn.titleLabel?.font = .H8
        setailBtn.setTitleColor(.T2, for: .normal)
        setailBtn.isUserInteractionEnabled = false
    }
}
class ReceiveNotificationHeader: UITableViewHeaderFooterView {
    let headerLab = UILabel()
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.addSubview(headerLab)
        headerLab.textColor = UIColor.T3
        headerLab.font = UIFont.H5
        headerLab.snp.makeConstraints { (make) in
            make.bottom.equalTo(contentView).inset(10)
            make.height.equalTo(20)
            make.centerX.equalTo(contentView)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
class SendNotificationHeader: UITableViewHeaderFooterView {
    let headerLab = UILabel()
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = UIColor.white
        contentView.addSubview(headerLab)
        headerLab.textColor = UIColor.T2
        headerLab.font = UIFont.H3
        headerLab.snp.makeConstraints { (make) in
            make.bottom.equalTo(contentView).inset(10)
            make.height.equalTo(20)
            make.left.equalTo(12)
            make.top.equalTo(contentView).inset(10)
        }
        contentView.addLine { (make) in
            make.bottom.equalTo(contentView)
            make.height.equalTo(0.5)
            make.left.equalTo(0)
            make.right.equalTo(0)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
