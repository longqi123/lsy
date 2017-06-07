//
//  DetailModel.swift
//  GXTax
//
//  Created by roger on 2017/2/23.
//  Copyright © 2017年 J HD. All rights reserved.
//

import SwiftyJSON

public struct DetailModel {
    
    var nsrsbh = ""
    var nsrmc = "" //纳税人名称
    var zgswskfjmc = ""
    var scjydz = ""
    
    public init(json: [JSON]) {
        for item in json {
            let value = item.dictionaryObject
            nsrsbh = value?["nsrsbh"] as! String
            nsrmc = value?["nsrmc"] as! String
            zgswskfjmc = value?["zgswskfjmc"] as! String
            scjydz = value?["scjydz"] as! String
        }
    }
}
