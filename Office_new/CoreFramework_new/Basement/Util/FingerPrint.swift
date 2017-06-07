//
//  FingerPrint.swift
//  ProjectExample
//	指纹识别
//  Created by J HD on 2016/11/28.
//  Copyright © 2016年 J HD. All rights reserved.
//

import LocalAuthentication

public func fingerPrintVerify(success:@escaping ()->Void, failure:@escaping ()->Void){
	
	//1.初始化TouchID句柄
	
	let authentication = LAContext()
	var error: NSError?
	
	//2.检查Touch ID是否可用
	//这里是采用认证策略 LAPolicy.DeviceOwnerAuthenticationWithBiometrics
	let isAvailable = authentication.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
	
	//3.处理结果
	if isAvailable{
		//--> 指纹生物识别方式
		authentication.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "需要您的指纹来进行识别验证", reply: {
			//当调用authentication.evaluatePolicy方法后，系统会弹提示框提示用户授权
			(suc, err) -> Void in
			if suc{
				success()
			}
			else{
				if #available(iOS 9.0, *) {
					authentication.invalidate()
				} else {
					// Fallback on earlier versions
				}
				failure()
			}
		})
	}
	else{
		//上面提到的硬件配置
		failure()
	}
	
}
