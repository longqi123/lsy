//
//  String+EX.swift
//  Office
//
//  Created by roger on 2017/5/24.
//  Copyright © 2017年 roger. All rights reserved.
//

import Foundation

public extension String {
    
    //sha1加密算法
    func SHA1() -> String {
        let data : Data = self.data(using: String.Encoding.utf8, allowLossyConversion: true)!
        var digest = [UInt8](repeating:0,count:Int(CC_SHA1_DIGEST_LENGTH))
        
        let dataBytes = data.withUnsafeBytes { (bytes: UnsafePointer<UInt8>) -> UnsafePointer<UInt8> in
            return bytes
        }
        let dataLength = CC_LONG(data.count)
        
        CC_SHA1(dataBytes, dataLength, &digest)
        
        let output = NSMutableString(capacity: Int(CC_SHA1_DIGEST_LENGTH))
        for byte in digest{
            output.appendFormat("%02x", byte)
        }
        return output as String
    }

    func getMd5() -> String {
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = CUnsignedInt(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)

        CC_MD5(str!, strLen, result)

        let hash = NSMutableString()
        for i in 0..<digestLen {
            hash.appendFormat("%02x", result[i])
        }

        result.deallocate(capacity: digestLen)
        return String(hash)
    }
}
