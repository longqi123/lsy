//
//  BaseTableViewCell.swift
//  Office
//
//  Created by roger on 2017/3/30.
//  Copyright © 2017年 roger. All rights reserved.
//

import UIKit

open class BaseTableViewCell: UITableViewCell {

    override open func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        contentView.addSubview(LineView())
    }
    
    override public init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        contentView.addSubview(LineView())
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        // fatalError("init(coder:) has not been implemented")
    }
}
