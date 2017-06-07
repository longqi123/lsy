//
//  Config.swift
//  CoreFramework
//
//  Created by roger on 2016/12/13.
//  Copyright © 2016年 roger. All rights reserved.
//

import Foundation

public struct KeyList {
	
	private init(){}
	
    // 是否显示引导页
	static let ifShowIntro = "com.gxtax.ifShowIntro"
    // 是否使用手势
	static let gesturePassword = "com.gxtax.gesturePassword"
    // 是否保存用户名
    static let needSaveUserID = "com.gxtax.needSaveUserID"
    // 自然人userID
    static let zrrUserID = "com.gxtax.zrrUserID"
	// 自然人密码
	static let zrrUserPassword = "com.gxtax.zrrUserPassword"
    // 单位纳税人userID
    static let dwnsrUserID = "com.gxtax.dwnsrUserID"
	// 单位纳税人密码
	static let dwnsrUserPassword = "com.gxtax.dwnsrUserPassword"
	
	// CSZ : 是否保存账号或密码code
	static let CSZ = "CSZ"
	// 登录用户类型
	static let loginUserType = "loginUserType"
	
	
}

public class Config {
	
	private init(){}
	
//	/// 默认环境
//	public static let environment = Environment.ChengDu
//	/// json中的默认配置信息
//	public static var config: Configuration!
	
	/// 用户是否登陆
	public static var isLogin = false
	
	/// 是否需要显示引导页
	public static var ifShowIntro: Bool {
		set{
			UserDefaults.standard.set(newValue, forKey: KeyList.ifShowIntro)
		}
		get{
			return UserDefaults.standard.bool(forKey: KeyList.ifShowIntro)
		}
	}
	
	/// 手势密码
	public static var gesturePassword: String? {
		set{
			UserDefaults.standard.set(newValue, forKey: KeyList.gesturePassword)
		}
		get{
			return UserDefaults.standard.value(forKey: KeyList.gesturePassword) as? String
		}
	}
    
    /// 保存用户名
    public static var needSaveUserID: Bool? {
        set{
            UserDefaults.standard.set(newValue, forKey: KeyList.needSaveUserID)
        }
        get{
            return UserDefaults.standard.value(forKey: KeyList.needSaveUserID) as? Bool
        }
    }
    
    /// 保存自然人账号
    public static var zrrUserID: String? {
        set{
            UserDefaults.standard.set(newValue, forKey: KeyList.zrrUserID)
        }
        get{
            return UserDefaults.standard.value(forKey: KeyList.zrrUserID) as? String
        }
    }
	
	/// 保存自然人密码
	public static var zrrUserPassword: String? {
		set{
			UserDefaults.standard.set(newValue, forKey: KeyList.zrrUserPassword)
		}
		get{
			return UserDefaults.standard.value(forKey: KeyList.zrrUserPassword) as? String
		}
	}
	
    /// 保存单位纳税人账号
    public static var dwnsrUserID: String? {
        set{
            UserDefaults.standard.set(newValue, forKey: KeyList.dwnsrUserID)
        }
        get{
            return UserDefaults.standard.value(forKey: KeyList.dwnsrUserID) as? String
        }
    }
	
	/// 保存单位纳税人密码
	public static var dwnsrUserPassword: String? {
		set{
			UserDefaults.standard.set(newValue, forKey: KeyList.dwnsrUserPassword)
		}
		get{
			return UserDefaults.standard.value(forKey: KeyList.dwnsrUserPassword) as? String
		}
	}
	
	/// 保存CSZ
	public static var CSZ: String? {
		set{
			UserDefaults.standard.set(newValue, forKey: KeyList.CSZ)
		}
		get{
			return UserDefaults.standard.value(forKey: KeyList.CSZ) as? String
		}
	}
	
	/// 保存用户登录类型
	public static var loginUserType: String? {
		set{
			UserDefaults.standard.set(newValue, forKey: KeyList.loginUserType)
		}
		get{
			return UserDefaults.standard.value(forKey: KeyList.loginUserType) as? String
		}
	}
	
	
	
	public static var currentDate = ""
	
	/// 极光推送 办税端appkey
	public static let gxydbsAppKey = "15d1b947e1967acd2535a6e1"
	
	/// 极光推送 办公端appkey
	public static let llydbgAppKey = "6b18bdb835fb7419e2b04283"
	
}
