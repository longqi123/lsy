//
//  AppSquareCell.swift
//  Office
//
//  Created by roger on 2017/3/30.
//  Copyright © 2017年 roger. All rights reserved.
//

import UIKit
import CoreFramework

@objc protocol AppSquareCellDelegate{
    func attentionBtnClicked()
}

class AppSquareCell: BaseTableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var attentionBtn: UIButton!
    @IBOutlet weak var AppImageView: UIImageView!
    var data: AppInfoModel!
    weak var delegate: AppSquareCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        attentionBtn.backgroundColor = UIColor.B1
        attentionBtn.layer.cornerRadius = 5
        attentionBtn.layer.borderWidth = 1
        attentionBtn.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    func setDataSource(data:AppInfoModel){
        self.data = data
        titleLabel.text = self.data.name
        descriptionLabel.text = self.data.description
        AppImageView.image = UIImage(named: data.imageName!)
    }

    @IBAction func attentionBtnClicked(_ sender: UIButton) {
        
        if sender.titleLabel?.text == "关注" {
            
            if self.data.needDownload == true {
                delegate?.attentionBtnClicked()
            }
            
            self.data.isAttention = false
            sender.setTitle("取消关注", for: .normal)
            AppSquareManager.shareInstance.attentionData.append(data)
        }else{
            let array = AppSquareManager.shareInstance.attentionData

            for (key,item) in array.enumerated() {
                if item.name == data.name {
                    AppSquareManager.shareInstance.attentionData.remove(at: key)
                }
            }
            self.data.isAttention = true
            sender.setTitle("关注", for: .normal)
        }
        
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
