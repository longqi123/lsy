//
//  ReviewResultsCell.swift
//  Office
//
//  Created by 梁仕友 on 2017/6/2.
//  Copyright © 2017年 roger. All rights reserved.
//

import UIKit

class ReviewResultsCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    
    
    @IBOutlet weak var segemet: UISegmentedControl!
    
    
    @IBAction func segementClick(_ sender: Any) {
        if (sender as AnyObject).selectedSegmentIndex == 0 {
            self.segementBlock!("通过")
        }else{
            self.segementBlock!("不通过")
        }
        
    }
    var segementBlock:((_ segementResults:String) -> Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        title.font = UIFont.H3
        title.textColor = UIColor.T2
        segemet.tintColor = UIColor.B1
    }
}
