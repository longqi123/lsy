//
//  NewNotificationCell1.swift
//  Office
//
//  Created by 梁仕友 on 2017/5/31.
//  Copyright © 2017年 roger. All rights reserved.
//

import UIKit

class NewNotificationCell1: UITableViewCell,UITextViewDelegate,UITextFieldDelegate {

    @IBOutlet weak var titleText: UITextField!
    
    @IBOutlet weak var placehoderLab: UILabel!
    
    @IBOutlet weak var contentText: UITextView!
    var titleStr = "11"
    var contentStr = "11"
    var CintentBlock:((_ contentStr:String,_ titleStr:String) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleText.font = UIFont.H3
        titleText.textColor = UIColor.T2
        contentText.font = UIFont.H5
        contentText.textColor = UIColor.T3
        self.titleText.returnKeyType = .done
        self.titleText.delegate = self
        self.contentText.delegate = self
        self.placehoderLab.isUserInteractionEnabled = false
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(contentTextclick))
        self.contentText.addGestureRecognizer(tapGes)
    }
    func contentTextclick(){
        self.placehoderLab.isHidden = true
        self.contentText.becomeFirstResponder()
    }
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.characters.count > 0 {
            let str = textView.text
            if (str?.characters.count)! > 200 {
                textView.text = (str! as NSString).substring(to: 200)
                self.contentStr = (str! as NSString).substring(to: 200)
            }else{
                self.contentStr = str!
            }
            self.CintentBlock!(self.contentStr,self.titleStr)
        }
    }
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return true
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            self.contentText.resignFirstResponder()
            return false
        }
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField.text?.characters.count)! > 0 {
            let str = textField.text
            if (str?.characters.count)! > 30 {
                textField.text = (str! as NSString).substring(to: 30)
                self.titleStr = (str! as NSString).substring(to: 30)
            }else{
                self.titleStr = str!
            }
            self.CintentBlock!(self.contentStr,self.titleStr)
        }
        self.titleText.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.CintentBlock!(self.contentStr,self.titleStr)
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        
        self.CintentBlock!(self.contentStr,self.titleStr)
    }
}
