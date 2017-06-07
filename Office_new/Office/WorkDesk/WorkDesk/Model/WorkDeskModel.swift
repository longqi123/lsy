//
//  WorkDeskModel.swift
//  Office
//
//  Created by GA GA on 24/05/2017.
//  Copyright © 2017 roger. All rights reserved.
//

import UIKit
import SwiftyJSON
import HandyJSON

struct WorkDeskModel: HandyJSON {
    var yymc = ""
    var yyid = ""
    var yygzuuid = ""
    var gzlxx = ""
    var gzryDm = ""
    var yytbxzdz = ""
    var yywz = ""
    
    init(json: JSON) {
        yymc = json["yymc"].stringValue
        yyid = json["yyid"].stringValue
        yygzuuid = json["yygzuuid"].stringValue
        gzlxx = json["gzlxx"].stringValue
        gzryDm = json["gzryDm"].stringValue
        yytbxzdz = json["yytbxzdz"].stringValue
        yywz = json["yywz"].stringValue

    }
    
    public init() {}
}

extension WorkDeskModel: Comparable {
    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    static func ==(lhs: WorkDeskModel, rhs: WorkDeskModel) -> Bool {
        return lhs.yywz < rhs.yywz
        
    }
    
    /// Returns a Boolean value indicating whether the value of the first
    /// argument is less than that of the second argument.
    ///
    /// This function is the only requirement of the `Comparable` protocol. The
    /// remainder of the relational operator functions are implemented by the
    /// standard library for any type that conforms to `Comparable`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    static func <(lhs: WorkDeskModel, rhs: WorkDeskModel) -> Bool {
        return lhs.yywz < rhs.yywz
    }
    
}

struct WorkDeskImageModel {
    var images = [String]()
    var titles = [String]()
    var contentUrl = [String]()
    
    init(json: JSON) {
        for (_, item) in json {
            images.append(item["src"].stringValue)
            titles.append(item["title"].stringValue)
            contentUrl.append(item["href"].stringValue)
        }
    }
}
