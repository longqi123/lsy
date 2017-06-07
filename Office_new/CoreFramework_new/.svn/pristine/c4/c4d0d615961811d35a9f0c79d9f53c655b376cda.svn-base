//
//  CustomToolbarView.swift
//  NewhopeMilkman
//
//  Created by choice on 16/9/21.
//  Copyright © 2016年 Scott. All rights reserved.
//

import UIKit

///便捷定义TextField的inputView
public class CustomToolbarView: UIView {
    
    public var doneBlock: (() -> Void)?
//    var cancelBlock: (() -> Void)?
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: self.bounds.height)
        
        initUI(frame: frame)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initUI(frame: frame)
    }
    
    func initUI(frame: CGRect) {
        let topView = UIToolbar.init(frame: frame)
//        let cancelBtn = UIBarButtonItem.init(title: "取消", style: .plain, target: self, action: #selector(CustomToolbarView.cancelBoard))
        let spaceFlexible = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let doneBtn = UIBarButtonItem.init(title: "完成", style: .plain, target: self, action: #selector(CustomToolbarView.comfirmBoard))
        topView.setItems([spaceFlexible, doneBtn], animated: true)
        addSubview(topView)
    }
    
    //完成闭包
    public func comfirmBoard() {
        self.doneBlock?()
    }
    
    ///取消闭包
//    func cancelBoard() {
//        self.cancelBlock?()
//    }
}
