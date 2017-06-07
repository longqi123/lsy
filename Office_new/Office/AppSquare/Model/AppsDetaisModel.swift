//
//  AppsDetaisModel.swift
//  Office
//
//  Created by GA GA on 01/06/2017.
//  Copyright © 2017 roger. All rights reserved.
//
import SwiftyJSON

///
struct AppsDetaisModel {
    var jrx = "" //
    var bbh = "" //
    var yysyfwDm = "" //
    var yymc = "" //应用名称
    var yysm = "" //
    var gxrq = "" //
    var sfgz = "" //
    var yyid = "" //
    var dx = "" //
    var yyfb = "" //
    var yytbxzdz = "" //
    var jsfdwDm = "" //
    var gllsuuid = "" //
    var gzlxx = ""//
    var yyjt = [JSON]()

    init(json: JSON) {
        jrx = json["jrx"].stringValue
        bbh = json["bbh"].stringValue
        yysyfwDm = json["yysyfwDm"].stringValue
        yymc = json["yymc"].stringValue
        yysm = json["yysm"].stringValue
        gxrq = json["gxrq"].stringValue
        sfgz = json["sfgz"].stringValue
        yyid = json["yyid"].stringValue
        dx = json["dx"].stringValue
        yyfb = json["yyfb"].stringValue
        yytbxzdz = json["yytbxzdz"].stringValue
//        yyjt = json["yyjt"].stringValue
        jsfdwDm = json["jsfdwDm"].stringValue
        gllsuuid = json["gllsuuid"].stringValue
        gzlxx = json["gzlxx"].stringValue
        yyjt = json["yyjt"]["yyxqfwResponselb"].arrayValue


    }
}
