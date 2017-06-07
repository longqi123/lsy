//
//  NetworkManager.swift
//  Test
//
//  Created by roger on 2017/5/12.
//  Copyright © 2017年 roger. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

public enum ReturnType {
    case JSON
    case STRING
}

public class NetworkManager {
    
    static let sharedInstance = NetworkManager()
    private let sessionManager: SessionManager!
    
    private init() {
        /**
         URLSessionConfiguration 对象用于对 URLSession 对象进行初始化配置。这也是 URLSession 与 NSURLConnection 相比最明显的改进之一，我们可以配置每个 session 的缓存，协议，cookie，以及证书策略（credential policy），甚至跨程序共享这些信息。这将允许程序和网络基础框架之间相互独立，不会发生干扰。
         URLSessionConfiguration 还有如：超时时间、缓存策略、Cookie 策略、安全策略等属性的设置
         */
        let configuration = URLSessionConfiguration.default
        
        //超时时长，许多开发人员试图使用 timeoutInterval 去限制发送请求的总时间，但这误会了timeoutIntervalForRequest 的意思：报文之间的时间。
        configuration.timeoutIntervalForRequest = 30
        
        //整个资源请求时长，实际上提供了整体超时的特性，这应该只用于后台传输，而不是用户实际上可能想要等待的任何东西。
        configuration.timeoutIntervalForResource = 30
        
        // 设置同时连接到一台服务器的最大连接数。对于一个 host 的最大并发连接数，iOS 默认数值是 4
        configuration.httpMaximumConnectionsPerHost = 4
        
        //通过Alamofire设置默认的请求头
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        
        sessionManager = Alamofire.SessionManager(configuration: configuration)
    }
    
    
    ///发送一条POST请求
    public static func post(
        url:String,
        parameter: [String: Any]?,
        returnType: ReturnType? = ReturnType.JSON,
        success: @escaping (Any) -> Void,
        failure: @escaping (Error)->()){
        
        let url = URL(string: url)
        guard url != nil else {return}
        
        switch returnType! {
        case .JSON:
            //返回数据类型为json
            NetworkManager.sharedInstance.sessionManager.request(url!, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: nil).responseData(completionHandler: { response in
                debugPrint(response)
                
                switch response.result {
                case .success:
                    if let result = response.result.value {
                        let json = JSON(result)
                        success(json)
                    }
                case .failure(let error):
                    failure(error)
                }
            })
            
        case .STRING:
            //返回数据类型为string
            NetworkManager.sharedInstance.sessionManager.request(url!, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: nil).responseString(completionHandler: { response in
                debugPrint(response)
                
                switch response.result {
                case .success:
                    if let result = response.result.value {
                        success(result)
                    }
                case .failure(let error):
                    failure(error)
                }
            })
            
        }
    }
    
    ///发送一条GET请求
    public static func get(
        url:String,
        parameter: [String: Any]?,
        success: @escaping (JSON) -> Void,
        failure: @escaping (Error)->()){
        
        let url = URL(string: url)
        guard url != nil else {return}
        
        NetworkManager.sharedInstance.sessionManager.request(url!, method: .get, parameters: parameter, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            debugPrint(response)
            
            switch response.result {
            case .success:
                if let result = response.result.value {
                    let json = JSON(result)
                    success(json)
                }
            case .failure(let error):
                failure(error)
            }
        }
    }
    
}
