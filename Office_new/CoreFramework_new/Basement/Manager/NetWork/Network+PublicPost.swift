//
//  PublicPost.swift
//  GXTax
//
//  Created by J HD on 2017/1/17.
//  Copyright © 2017年 J HD. All rights reserved.
//

import UIKit

extension Network {
    
    /// 获取系统时间
    public static func getSystemDate(
        success: @escaping (_ dateTime: TimeInterval, _ dateString: String) -> Void,
        failure: ((String)->Void)? = nil) {
        let para = paraMaker(data: [:], sid: "D1011", extra: [:])
        Network.post(parameter: para, success: { (json) in
            let data = json["result"]["data"]
            let dateTime = data["dateTime"].doubleValue as TimeInterval
            let dateString = data["dateStr"].stringValue
            success(dateTime, dateString)
        }) { (error) in
            failure?(error)
        }
    }
    
    /// 生成pdf
    public static func getPDF(params: String, filename: String, formId:String, success: @escaping (URL)->Void, failure: @escaping (String)->Void) {
        let para = paraMaker(data: ["params": params, "formId": formId], sid: "D1004", extra: [:])
        Network.post(parameter: para, success: { (json) in
            let result = json["result"]
            if let message = result["error"]["message"].string {
                failure(message)
            } else {
                guard let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else { return }
                let documentsPath = URL(fileURLWithPath: path)
                let logsPath = documentsPath.appendingPathComponent("pdfs")
                do {
                    try FileManager.default.createDirectory(at: logsPath, withIntermediateDirectories: true, attributes: nil)
                } catch let error as NSError {
                    NSLog("Unable to create directory \(error.debugDescription)")
                }
                let fileUrl = logsPath.appendingPathComponent("\(filename).pdf")
                let data = result["data"]["file"].stringValue.data(using: .isoLatin1)
                do {
                    try data?.write(to: fileUrl)
                } catch {
                    failure(error.localizedDescription)
                }
                success(fileUrl)
            }
        }) { (error) in
            failure(error)
        }
    }
    
}
