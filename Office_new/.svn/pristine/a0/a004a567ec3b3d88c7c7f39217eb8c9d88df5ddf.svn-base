//
//  AuditNotificationModel.swift
//  Office
//
//  Created by 梁仕友 on 2017/6/6.
//  Copyright © 2017年 roger. All rights reserved.
//

import UIKit
import HandyJSON
import SwiftyJSON

struct AuditNotificationModel :HandyJSON{
    var tzggztDm = ""
    var tzgguuid = ""
    var tzggztmc = ""
    var tzggnr = ""
    var ssrq = ""
    var tzggbt = ""
    init(json: JSON) {
        tzggztDm = json["tzggztDm"].stringValue
        tzgguuid = json["tzgguuid"].stringValue
        tzggztmc = json["tzggztmc"].stringValue
        tzggnr = json["tzggnr"].stringValue
        ssrq = json["ssrq"].stringValue
        tzggbt = json["tzggbt"].stringValue
    }
    public init() {
        
    }
}

