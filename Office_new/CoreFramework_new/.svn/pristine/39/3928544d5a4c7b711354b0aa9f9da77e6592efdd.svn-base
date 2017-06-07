//
//  Algorithm.swift
//  GXTax
//
//  Created by J HD on 2016/12/23.
//  Copyright © 2016年 J HD. All rights reserved.
//

import Foundation

fileprivate func partitionLomuto<T: Comparable>(_ a: inout [T], low: Int, high: Int) -> Int {
	let pivot = a[high]
	
	var i = low
	for j in low..<high {
		if a[j] <= pivot {
			(a[i], a[j]) = (a[j], a[i])
			i += 1
		}
	}
	
	(a[i], a[high]) = (a[high], a[i])
	return i
}

fileprivate func random(min: Int, max: Int) -> Int {
	assert(min < max)
	return min + Int(arc4random_uniform(UInt32(max - min + 1)))
}

/// 快速排序
///
/// - Parameters:
///   - a: 数组
///   - low: 较小范围
///   - high: 较大范围
func quicksortRandom<T: Comparable>(_ a: inout [T], low: Int, high: Int) {
	if low < high {
		let pivotIndex = random(min: low, max: high)
		(a[pivotIndex], a[high]) = (a[high], a[pivotIndex])
		
		let p = partitionLomuto(&a, low: low, high: high)
		quicksortRandom(&a, low: low, high: p - 1)
		quicksortRandom(&a, low: p + 1, high: high)
	}
}

/// 二分查找
///
/// - Parameters:
///   - a: 数组
///   - key: 查找的内容
/// - Returns: 返回的index
public func binarySearch<T: Comparable>(_ a: [T], key: T) -> Int? {
	var lowerBound = 0
	var upperBound = a.count
	while lowerBound < upperBound {
		let midIndex = lowerBound + (upperBound - lowerBound) / 2
		if a[midIndex] == key {
			return midIndex
		} else if a[midIndex] < key {
			lowerBound = midIndex + 1
		} else {
			upperBound = midIndex
		}
	}
	return nil
}


