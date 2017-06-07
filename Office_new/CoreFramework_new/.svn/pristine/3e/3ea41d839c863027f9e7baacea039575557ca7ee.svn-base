//
//  ProgressHUD.swift
//  Pods
//
//  Created by roger on 2017/4/11.
//
//

import Foundation
import UIKit

public class ProgressHUD {
    
    public class func progress(title: String, type: ProgressType, block:(()->())? = nil){
        
        switch type {
        case .success:
            Progress.show(title,.success, block: block)
        case .failure:
            Progress.show(title,.failure, block: block)
        case .other:
            Progress.show(title,.other, block: block)
        }
    }
    
    public class func alert(title: String, detail: String, type: AlertType, block: (()->())? = nil){
        
        switch type {
        case .failure:
            Alert.failure(title: title, detail: detail,failure: block)
        }
    }
    
    public class func select(items: [String],head: String?, block: ((IndexPath)->())? = nil, cancel: (()->())? = nil){
    
        Select.show(items: items,head: head,block: block, cancel: cancel)
    }
    
    //弹出底部toast
    public class func toast(message: String) {
        Toast.shareInstance.show(message)
    }
}



