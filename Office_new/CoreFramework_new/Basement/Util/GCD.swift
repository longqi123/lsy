//
//  GCD.swift
//  Basic
//
//  Created by J HD on 2016/11/25.
//  Copyright © 2016年 J HD. All rights reserved.
//

import Foundation

public class GCD {
	
	/// 延迟一定时间执行
	///
	/// - Parameters:
	///   - seconds: 延迟时间（秒）
	///   - completion: 完成事件
  public static func delay(seconds: Double, completion: @escaping ()->Void) {
		DispatchQueue.main.asyncAfter(
		deadline: DispatchTime.now() + Double(Int64(Double(NSEC_PER_SEC)*seconds)) / Double(NSEC_PER_SEC)){
			completion()
		}
	}
	
}
