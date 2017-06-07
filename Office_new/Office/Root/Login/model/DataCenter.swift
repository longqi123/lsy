//
//  DataCenter.swift
//  Office
//
//  Created by GA GA on 19/05/2017.
//  Copyright © 2017 roger. All rights reserved.
//

import UIKit

class DataCenter {

    /// 即时聊天或者视频添加的人
    static var ChatVideoAdddataSource: [TxlModel1] = []
    /// 加人需要的推送的控制器
    static var GlobalVieController:UIViewController!
    /// 通知公告选择的人
    static var AdddataSource: [TxlModel1] = []
    /// 可选择的最大人数
    static var PersonMaxiNum: Int?
    /// 选择组织ID数组
    static var organizationArrID: Array<Any>?
    /// 登录后信息
    static var dlzhxxModel: DlzhxxModel?
    /// 人员信息
    static var ryxqModel: RyxqModel?
    
    static var username: String?
    
    static var password: String?
    
    static var pushVC: String?
    
    private init(){}


}