//
//  AuditOpinionCell.swift
//  Office
//
//  Created by 梁仕友 on 2017/6/2.
//  Copyright © 2017年 roger. All rights reserved.
//

import UIKit

class AuditOpinionCell: UITableViewCell,UITextViewDelegate {

    @IBOutlet weak var content: UITextView!
    
    @IBOutlet weak var placeLab: UILabel!
    
    var reviewBlock:((_ contentStr:String) -> Void)?
    
    var contentStr = "11"
    override func awakeFromNib() {
        super.awakeFromNib()
        content.font = UIFont.H5
        content.textColor = UIColor.T3
        self.content.delegate = self
        self.placeLab.isUserInteractionEnabled = false
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(contentTextclick))
        self.content.addGestureRecognizer(tapGes)

    }
    func contentTextclick(){
        self.placeLab.isHidden = true
        self.content.becomeFirstResponder()
    }
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.characters.count > 0 {
            let str = textView.text
            if (str?.characters.count)! > 100 {
                textView.text = (str! as NSString).substring(to: 100)
                self.contentStr = (str! as NSString).substring(to: 100)
            }else{
                self.contentStr = str!
            }
            self.reviewBlock!(self.contentStr)
        }
    }
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return true
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            self.content.resignFirstResponder()
            return false
        }
        return true
    }

}
