//
//  PersonalDetailModel.swift
//  Office
//
//  Created by 梁仕友 on 2017/5/25.
//  Copyright © 2017年 roger. All rights reserved.
//

import UIKit
import HandyJSON
import SwiftyJSON

/// 人员详情
struct PersonalDetailModel:HandyJSON {
    
    var jsrydm = ""
    var zsldDm = ""
    var sj = ""
    var jtdh = ""
    var swjgdm = ""
    var rydm = ""
    var zsldmc = ""
    var wxzh = ""
    var ryxm = ""
    var levelname = ""
    var xb = ""
    var dzyj = ""
    var swjgmc = ""
    var csdm = ""
    var bgdh = ""
    var qqzh = ""
    var dutyname = ""
    var csmc = ""
    
    init(json: JSON) {
        jsrydm = json["jsrydm"].stringValue
        zsldDm = json["zsldDm"].stringValue
        sj = json["sj"].stringValue
        jtdh = json["jtdh"].stringValue
        swjgdm = json["swjgdm"].stringValue
        rydm = json["rydm"].stringValue
        zsldmc = json["zsldmc"].stringValue
        wxzh = json["wxzh"].stringValue
        ryxm = json["ryxm"].stringValue
        levelname = json["levelname"].stringValue
        xb = json["xb"].stringValue
        dzyj = json["dzyj"].stringValue
        swjgmc = json["swjgmc"].stringValue
        csdm = json["csdm"].stringValue
        bgdh = json["bgdh"].stringValue
        qqzh = json["qqzh"].stringValue
        dutyname = json["dutyname"].stringValue
        csmc = json["csmc"].stringValue
    }
    public init() {
        
    }
}
