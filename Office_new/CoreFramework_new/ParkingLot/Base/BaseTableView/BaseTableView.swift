//
//  BaseTableView.swift
//  Office
//
//  Created by roger on 2017/3/30.
//  Copyright © 2017年 roger. All rights reserved.
//

import UIKit

open class BaseTableView: UITableView {

    override public init(frame: CGRect, style: UITableViewStyle) {
        
        super.init(frame: frame, style: .plain)
        separatorStyle = .none
        self.backgroundColor = UIColor.B2
        indicatorStyle = .default
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
