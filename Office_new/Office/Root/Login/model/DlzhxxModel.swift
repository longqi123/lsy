//
//  DlzhxxModel
//  Office
//
//  Created by GA GA on 22/05/2017.
//  Copyright © 2017 roger. All rights reserved.
//

import SwiftyJSON

/// 登录返回信息
struct DlzhxxModel {
    let swryxm: String //用户名
    let swjgDm: String //
    let swjgmc: String //税务机关名称
    let swryDm: String //
    let dlzhDm: String //账号
    
    init(json: JSON) {
        swryxm = json["swryxm"].stringValue
        swjgDm = json["swjgDm"].stringValue
        swjgmc = json["swjgmc"].stringValue
        swryDm = json["swryDm"].stringValue
        dlzhDm = json["dlzhDm"].stringValue
        
    }
}
