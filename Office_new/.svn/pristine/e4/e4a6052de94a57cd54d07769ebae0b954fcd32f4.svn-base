//
//  AppSquareModel.swift
//  Office
//
//  Created by GA GA on 27/05/2017.
//  Copyright © 2017 roger. All rights reserved.
//

import SwiftyJSON
import HandyJSON

/// 登录返回信息
struct AppSquareModel: HandyJSON {
    var yyid = "" //
    var sfgz = "" //
    var yytbxzdz = "" //
    var yymc = "" //应用名称
    var gzlxx = "" //关注量
    
    init(json: JSON) {
        yyid = json["yyid"].stringValue
        sfgz = json["sfgz"].stringValue
        yytbxzdz = json["yytbxzdz"].stringValue
        yymc = json["yymc"].stringValue
        gzlxx = json["gzlxx"].stringValue
    }
    
    public init() {
        
    }
}
