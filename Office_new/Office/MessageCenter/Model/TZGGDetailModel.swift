//
//  TZGGDetailModel.swift
//  Office
//
//  Created by 梁仕友 on 2017/6/5.
//  Copyright © 2017年 roger. All rights reserved.
//

import UIKit
import HandyJSON
import SwiftyJSON

struct TZGGDetailModel :HandyJSON{
    var xgrq = ""
    var tzggbt = ""
    var txsj = ""
    var sprq = ""
    var spyj = ""
    var tzggztmc = ""
    var tzggnr = ""
    var tzxxzfbz = ""
    var fbrq = ""
    var sprmc = ""
    var lrrq = ""
    var fbrmc = ""
    var sprDm = ""
    var fbrDm = ""
    var cxrq = ""
    var lrrmc = ""
    var chrmc = ""
    var sfszrw = ""
    var spjg = ""
    var tzgguuid = ""
    var lrrDm = ""
    var ssrq = ""
    var chrDm = ""
    var chrq = ""
    var tzggztDm = ""
    var jzrq = ""
    init(json: JSON) {
        chrq = json["chrq"].stringValue
        xgrq = json["xgrq"].stringValue
        sprDm = json["sprDm"].stringValue
        lrrq = json["lrrq"].stringValue
        tzxxzfbz = json["tzxxzfbz"].stringValue
        tzggztDm = json["tzggztDm"].stringValue
        sprq = json["sprq"].stringValue
        jzrq = json["jzrq"].stringValue
        sfszrw = json["sfszrw"].stringValue
        spyj = json["spyj"].stringValue
        fbrq = json["fbrq"].stringValue
        tzggnr = json["tzggnr"].stringValue
        spjg = json["spjg"].stringValue
        lrrmc = json["lrrmc"].stringValue
        txsj = json["txsj"].stringValue
        lrrDm = json["lrrDm"].stringValue
        fbrmc = json["fbrmc"].stringValue
        tzggbt = json["tzggbt"].stringValue
        tzgguuid = json["tzgguuid"].stringValue
        chrmc = json["chrmc"].stringValue
        cxrq = json["cxrq"].stringValue
        ssrq = json["ssrq"].stringValue
        sprmc = json["sprmc"].stringValue
        tzggztmc = json["tzggztmc"].stringValue
        fbrDm = json["fbrDm"].stringValue
        chrDm = json["chrDm"].stringValue
    }
    public init() {
        
    }
}
