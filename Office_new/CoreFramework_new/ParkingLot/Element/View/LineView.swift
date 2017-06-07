//
//  LineView.swift
//  Pods
//
//  Created by roger on 2017/4/1.
//
//

import UIKit

public class LineView: UIView {
    
    public override init(frame: CGRect) {
        super.init(frame: .zero)
        self.backgroundColor = UIColor.L1
        
        setNeedsLayout()
    }
    
    public override func layoutSubviews() {
        self.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}