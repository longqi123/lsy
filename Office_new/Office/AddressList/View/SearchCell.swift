//
//  SearchCell.swift
//  Office
//
//  Created by 梁仕友 on 2017/5/25.
//  Copyright © 2017年 roger. All rights reserved.
//

import UIKit

class SearchCell: UITableViewCell,UITextFieldDelegate {

    @IBOutlet weak var search: UITextField!
    
    var longBlock: ((_ searchString: String) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let backView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 15))
        backView.backgroundColor = UIColor.B2
        let imageView = UIImageView(image: #imageLiteral(resourceName: "sou_suo_xiao"))
        imageView.frame = CGRect(x: 5, y: 0, width: 15, height: 15)
        imageView.contentMode = .scaleAspectFill
        backView.addSubview(imageView)
        
        search.backgroundColor = UIColor.B2
        search.layer.masksToBounds = true
        search.layer.cornerRadius = 3
        search.leftView = backView
        search.placeholder = " 找人"
        search.delegate = self
        search.leftViewMode = .unlessEditing
        search.font = UIFont.H8
        search.clearButtonMode = .whileEditing
        search.returnKeyType = .search
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField.text?.characters.count)! > 0 {
            self.longBlock!(textField.text!)
        }
        textField.resignFirstResponder()
        return true
    }
}
