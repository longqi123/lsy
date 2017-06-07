//
//  MessageCenterData.swift
//  Office
//
//  Created by roger on 2017/3/30.
//  Copyright © 2017年 roger. All rights reserved.
//

import UIKit
import HandyJSON
import SwiftyJSON

struct MessageCenterData :HandyJSON{
    var rwzt1 = ""
    var rwfqr = ""
    var rwfqsj = ""
    init(json: JSON) {
        rwzt1 = json["rwzt1"].stringValue
        rwfqr = json["rwfqr"].stringValue
        rwfqsj = json["rwfqsj"].stringValue
    }
    public init() {
        
    }
}
