//
//  Network.swift
//  GXTax
//
//  Created by J HD on 2016/12/15.
//  Copyright © 2016年 J HD. All rights reserved.
//

import AFNetworking
import SwiftyJSON

//public let ServerURL = System.config.speicalUrl
public let ServerURL = "https://182.151.197.164:6011/"
private let PostRoute = ServerURL + "entry"
private let UploadRoute = ServerURL + "DataReceive"
private let DownloadPortraitRoute = ServerURL + "DataDownload"
private let DownloadRoute = ServerURL + "FlzlDownload"

fileprivate func paraJ3Maker(s: String, tranId: String) -> [String: Any] {
	return paraMaker(data: ["s": s, "tranId": tranId], sid: "D6666", extra: [:])
}

fileprivate func paraJ3Maker2(s: String?, tranId: String?, sid: String? = "D6666") -> [String: Any] {
    var dic = [String:String]()
    
    if let s = s {
        dic["s"] = s
    }
    if let tranId = tranId {
        dic["tranId"] = tranId
    }
    return paraMaker(data: dic, sid: sid!, extra: [:])
}

public class Network{
	
	/// 隐藏初始化方法
	private init(){}
	
	/// 公用session
	public static let manager: AFHTTPSessionManager = {
		let config = URLSessionConfiguration.default
		config.timeoutIntervalForRequest = 10
		let manager = AFHTTPSessionManager(sessionConfiguration: config)
		manager.requestSerializer = AFJSONRequestSerializer(writingOptions: .prettyPrinted)
		manager.responseSerializer = AFJSONResponseSerializer(readingOptions: .allowFragments)
		manager.responseSerializer.acceptableContentTypes = ["application/json", "text/json", "text/JavaScript", "text/html", "text/plain", "image/png", "application/octet-stream","image/jpeg","application/x-www-form-urlencoded;charset=utf-8"]
		return manager
	}()
	
	public static let httpsManager: AFHTTPSessionManager = {
		let config = URLSessionConfiguration.default
		config.timeoutIntervalForRequest = 100
		config.timeoutIntervalForResource = 100
		let manager = AFHTTPSessionManager(sessionConfiguration: config)
		manager.requestSerializer = AFJSONRequestSerializer(writingOptions: .prettyPrinted)
		manager.requestSerializer.timeoutInterval = 100
        manager.responseSerializer = AFHTTPResponseSerializer()
//		manager.responseSerializer = AFJSONResponseSerializer(readingOptions: .allowFragments)
		manager.responseSerializer.acceptableContentTypes = ["application/json",
		                                                     "text/json",
		                                                     "text/JavaScript",
		                                                     "text/html",
		                                                     "text/plain",
		                                                     "image/png",
		                                                     "application/octet-stream",
		                                                     "image/jpg",
		                                                     "multipart/form-data",
                                                             "image/jpeg"]
        
        
		return manager
	}()
	
	/// 专用处理zip文件下载
	public static let zipManager: AFHTTPSessionManager = {
		let config = URLSessionConfiguration.default
		config.timeoutIntervalForRequest = 30
		config.timeoutIntervalForResource = 30
		let manager = AFHTTPSessionManager(sessionConfiguration: config)
		manager.responseSerializer = AFHTTPResponseSerializer()
		manager.responseSerializer.acceptableContentTypes = ["application/zip"]
		return manager
	}()
	
	/// 简单post
	///
	/// - Parameters:
	///   - url: api地址
	///   - parameter: 参数
	///   - success: 成功事件
	///   - failure: 失败事件
	public static func post(
		parameter: [String: Any]?,
		success: @escaping (JSON) -> Void,
		failure: @escaping (String)->()
		){
		manager.post(
			PostRoute,
			parameters: parameter,
			progress: nil,
			success: { (task:URLSessionDataTask, data:Any?) in
				if let d = data{
					let json = JSON(d)
					success(json)
				}
				else{
					failure("请求失败")
				}
		}) { (task:URLSessionDataTask?, error:Error) in
			failure(error.localizedDescription)
		}
	}
	
	/// 对金三接口的post
	///
	/// - Parameters:
	///   - s: xml格式数据
	///   - tranId: 接口id
	///   - success: 成功闭包
	///   - failure: 失败闭包
	public static func postJinThree(
		s: String,
		tranId: String,
		success: @escaping (JSON) -> Void,
		failure: @escaping (String)->()
		){
		manager.post(
			PostRoute,
			parameters: paraJ3Maker(s: s, tranId: tranId),
			progress: nil,
			success: { (task:URLSessionDataTask, data:Any?) in
				if let d = data{
					let json = JSON(d)
					if let error = json["result"]["error"]["message"].string{
						failure(error)
					} else {
						success(json["result"])
					}
				}
				else{
					failure("请求失败")
				}
		}) { (task:URLSessionDataTask?, error:Error) in
			failure(error.localizedDescription)
		}
	}
    
    public static func postJinThree2(
        s: String?,
        tranId: String?,
        sid:String?,
        success: @escaping (JSON) -> Void,
        failure: @escaping (String)->()
        ){
        manager.post(
            PostRoute,
            parameters: paraJ3Maker2(s: s, tranId: tranId, sid: sid),
            progress: nil,
            success: { (task:URLSessionDataTask, data:Any?) in
                if let d = data{
                    let json = JSON(d)
                    if let error = json["result"]["error"]["message"].string{
                        failure(error)
                    } else {
                        success(json["result"])
                    }
                }
                else{
                    failure("请求失败")
                }
        }) { (task:URLSessionDataTask?, error:Error) in
            failure(error.localizedDescription)
        }
    }
	
	/// 通用查询
	///
	/// - Parameters:
	///   - data: 入参
	///   - success: 成功闭包
	///   - failure: 失败闭包
	public static func generalQuery(
		data: XmlFormatter,
		success: @escaping (JSON)->Void,
		failure: @escaping (String)->Void) {
		let para = paraMaker(data: ["s": data.xmlString, "tranId": "CX.DZCX.executeQueryKhd"], sid: "D6666", extra: [:])
		Network.post(parameter: para, success: success, failure: failure)
	}
	
	/// 请求代码表
	///
	/// - Parameters:
	///   - data: 入参
	///   - success: 成功闭包
	///   - failure: 失败闭包
	public static func queryCodeTable(
		data: [(dname: String, param: [[String: [String]]])],
		success: @escaping ([JSON])->Void,
		failure: @escaping (String)->Void)
	{
		let value = data.map(codeTableParaMaker)
		let para = paraMaker(data: ["value": value], sid: "D1055", extra: [:])
		Network.post(parameter: para, success: { (json) in
			if let error = json["result"]["error"]["message"].string{
				failure(error)
			} else {
				let data = json["result"]["value"].arrayValue
				success(data)
			}
		}, failure: failure)
	}
    
    
  /// 模糊查询请求
  ///
  /// - Parameters:
  ///   - data: 入参
  ///   - success: 成功闭包
  ///   - failure: 失败闭包
  public static func queryFuzzy(
      data: [(dname: String, operation: String, param: [[String: [String]]])],
      success: @escaping ([JSON])->Void,
      failure: @escaping (String)->Void)
  {
		let value = data.map(fuzzyParaMaker)
		let param = paraMaker(data: ["value": value], sid: "D1055", extra: [:])
		Network.post(parameter: param, success: { (json) in
			if let error = json["result"]["error"]["message"].string{
				failure(error)
			} else {
				let data = json["result"]["value"].arrayValue
				success(data)
			}
		}, failure: failure)
  }
	
	/// 上传文件
	///
	/// - Parameters:
	///   - tranId: 上传文件节点
	///   - s: 字符串
	///   - file: 文件数据
	///   - progress: 进度
	///   - success: 成功闭包
	///   - failure: 失败闭包
	public static func uploadFile(
		id: String,
		sid: String,
		fileName: String,
		file: Data,
		progress: @escaping (Double)->Void,
		success: @escaping (JSON)->Void,
		failure: @escaping (String)->Void)
	{
		httpsManager.post(
			UploadRoute,
			parameters: nil,
			constructingBodyWith: { (formData) in
				formData.appendPart(withFileData: file, name: "upFile", fileName: fileName, mimeType: "application/octet-stream")
				formData.appendPart(withForm: "{\"sid\":\"\(sid)\", \"data\":{\"id\":\"\(id)\"}, \"extra\":{}}".data(using: .utf8)!, name: "param")
		},
			progress: { (uploadProgress) in
				progress(uploadProgress.fractionCompleted)
		}, success: { (task, responseObject) in
			if let d = responseObject{
				let json = JSON(d)
				success(json["result"]["value"])
			}
			else{
				failure("请求失败")
			}
		}) { (task, error) in
			failure(error.localizedDescription)
		}
	}
    
    /// 上传头像
    ///
    /// - Parameters:
    ///   - sid: sid
    ///   - fileName: 名字
    ///   - file: 图片文件
    ///   - userKey: 用户识别号
    ///   - progress: 进度
    ///   - success: 成功闭包
    ///   - failure: 失败闭包
    public static func uploadPortrait(
        sid :String,
        fileName: String,
        file: Data,
        userKey: String,
        progress: @escaping (Double)->Void,
        success: @escaping ([JSON])->Void,
        failure: @escaping (String)->Void)
    {
        httpsManager.post(
            UploadRoute,
            parameters: nil,
            constructingBodyWith: { (formData) in
                formData.appendPart(withFileData: file, name: "image", fileName: fileName, mimeType: "image/jpg")
                formData.appendPart(withForm: "{\"data\":{\"userKey\":\"\(userKey)\"}, \"sid\":\"\(sid)\", \"extra\":{}}".data(using: .utf8)!, name: "param")
        },
            progress: { (uploadProgress) in
                progress(uploadProgress.fractionCompleted)
        },
            success: { (task, responseObject) in
            if let d = responseObject{
                let json = JSON(d)
                success([json])
            }
            else{
                failure("请求失败")
            }
        }) { (task, error) in
            failure(error.localizedDescription)
        }
    }
	
    public static func downloadPortrait(
        sid :String,
        userKey: String,
        progress: @escaping (Double)->Void,
        success: @escaping (Data)->Void,
        failure: @escaping (String)->Void)
    {
        
        let para = ["data":["userKey":"\(userKey)"], "sid":"\(sid)", "extra":[:]] as [String : Any]
                let path = DownloadPortraitRoute
        httpsManager.post(path, parameters: para, progress: { abc in
//            print("sdfsfsdfsfsd")
        }, success: { (task, data) in
            if let data = data as? Data {
                success(data)
            } else {
                failure("文件下载失败")
            }

        }) { (task, error) in
            print("error\(error)")
        } 
    }

    
	/// 附件资料下载文件
	///
	/// - Parameters:
	///   - fn: fn码
	///   - success: 成功回调
	///   - failure: 失败回调
	public static func downloadFile(
		fn: String,
		success: @escaping (Data)->Void,
		failure: ((String)->Void)?) {
		Network.zipManager.post(
			DownloadRoute + "?fn=\(fn)",
			parameters: nil,
			progress: { print($0) }, success: { (task, data) in
				if let data = data as? Data {
					success(data)
				} else {
					failure?("文件下载失败")
				}
		}) { (task, error) in
			failure?(error.localizedDescription)
		}
	}
	
	/// 附件资料下载文件
	///
	/// - Parameters:
	///   - fn: fn码
	///   - success: 成功回调
	///   - failure: 失败回调
	public static func downloadFile(url: String?,
	                         fn: String,
	                         success: @escaping (Data)->Void,
	                         failure: ((String)->Void)?) {
		if url != nil {
			zipManager.post(
				url! + "?fn=\(fn)",
				parameters: nil,
				progress: { print($0) }, success: { (task, data) in
					if let data = data as? Data {
						success(data)
					} else {
						failure?("文件下载失败")
					}
			}) { (task, error) in
				failure?(error.localizedDescription)
			}
		}
	}
	
}
