//
//  ReceiveNotificationModel.swift
//  Office
//
//  Created by 梁仕友 on 2017/6/5.
//  Copyright © 2017年 roger. All rights reserved.
//

import UIKit
import HandyJSON
import SwiftyJSON

struct ReceiveNotificationModel :HandyJSON{
    var tzggztDm = ""
    var tzgguuid = ""
    var tzggztmc = ""
    var tzggnr = ""
    var fbrq = ""
    var tzggbt = ""
    var yhqrbj = ""
    init(json: JSON) {
        tzggztDm = json["tzggztDm"].stringValue
        tzgguuid = json["tzgguuid"].stringValue
        tzggztmc = json["tzggztmc"].stringValue
        tzggnr = json["tzggnr"].stringValue
        fbrq = json["fbrq"].stringValue
        tzggbt = json["tzggbt"].stringValue
        yhqrbj = json["yhqrbj"].stringValue
    }
    public init() {
        
    }
}
