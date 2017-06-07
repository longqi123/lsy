//
//  JSONResolver.swift
//  GXTax
//
//  Created by J HD on 2016/12/19.
//  Copyright © 2016年 J HD. All rights reserved.
//

import SwiftyJSON

public func paraMaker(data: [String: Any], sid: String, extra: [String: Any]) -> [String: Any] {
    return ["data": data, "sid": sid, "extra": extra]
}

public func codeTableParaMaker(dname: String, param: [[String: [String]]]) -> [String: Any] {
    return ["dname": dname, "param": param]
}

public func fuzzyParaMaker(dname: String, operation: String, param: [[String: [String]]]) -> [String: Any] {
    var dic = [String: Any]()
    dic["dname"] = dname
    if operation != "" {
        dic["operation"] = operation
    }
    if param[0].count > 0 {
        dic["param"] = param
    }
    return dic
}

extension JSON {
    
    public var info: JSON {
        return self["result"]["info"]
    }
}


