//
//  Extension+Strng.swift
//  ABC360
//
//  Created by Lynch Wong on 10/27/16.
//  Copyright © 2016 abc360.com. All rights reserved.
//

import UIKit
import CommonCrypto

extension String {
    
    // MD5
    var md5: String {
        let str       = self.cString(using: .utf8)
        let strLen    = CC_LONG(self.lengthOfBytes(using: .utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        
        let result    = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        
        CC_MD5(str!, strLen, result)
        
        let hash = NSMutableString()
        for i in 0..<digestLen {
            hash.appendFormat("%02x", result[i])
        }
        
        result.deallocate()
        
        return String(format: hash as String)
    }

    /**
     根据字体、CGSize来计算字符串的高度
     
     - parameter size:   大小
     - parameter font:   字体
     
     - returns: 高度
     */
    func calculateSize(with size: CGSize, font: UIFont) -> CGSize {
        return (self as NSString).boundingRect(with: size,
                                        options: [.usesLineFragmentOrigin, .usesFontLeading],
                                        attributes: [NSAttributedString.Key.font: font],
                                        context: nil).size
    }

    func sha1() -> String {
        let data = self.data(using: String.Encoding.utf8)!
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA1_DIGEST_LENGTH))
        CC_SHA1((data as NSData).bytes, CC_LONG(data.count), &digest)
        let hexBytes = digest.map { String(format: "%02hhx", $0) }
        return hexBytes.joined(separator: "")
    }

    var length: Int {
        return self.count
    }
    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }
    
    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, length) ..< length]
    }
    
    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }
    
    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)), upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
    
    /**
     3DES的加密过程 和 解密过程
     
     - parameter op : CCOperation： 加密还是解密
     CCOperation（kCCEncrypt）加密
     CCOperation（kCCDecrypt) 解密
     
     - parameter key: 专有的key,一个钥匙一般
     - parameter iv : 可选的初始化向量，可以为nil
     - returns      : 返回加密或解密的参数
     */
    func threeDESEncryptOrDecrypt(op: CCOperation,key: String,iv: String) -> String? {
        
        // Key
        let keyData: NSData = (key as NSString).data(using: String.Encoding.utf8.rawValue)! as NSData
        let keyBytes         = UnsafeMutableRawPointer(mutating: keyData.bytes)
        
        // 加密或解密的内容
        var data: NSData = NSData()
        if op == CCOperation(kCCEncrypt) {
            data  = (self as NSString).data(using: String.Encoding.utf8.rawValue)! as NSData
        }
        else {
            data =  NSData(base64Encoded: self, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)!
        }
        
        let dataLength    = size_t(data.length)
        let dataBytes     = UnsafeMutableRawPointer(mutating: data.bytes)
        
        // 返回数据
        let cryptData    = NSMutableData(length: Int(dataLength) + kCCBlockSize3DES)
        let cryptPointer = UnsafeMutableRawPointer(cryptData!.mutableBytes)
        let cryptLength  = size_t(cryptData!.length)
        
        //  可选 的初始化向量
        let viData :NSData = (iv as NSString).data(using: String.Encoding.utf8.rawValue)! as NSData
        let viDataBytes    = UnsafeMutableRawPointer(mutating: viData.bytes)
        
        // 特定的几个参数
        let keyLength              = size_t(kCCKeySize3DES)
        let operation: CCOperation = UInt32(op)
        let algoritm:  CCAlgorithm = UInt32(kCCAlgorithm3DES)
        let options:   CCOptions   = UInt32(kCCOptionPKCS7Padding)
        
        var numBytesCrypted :size_t = 0
        
        let cryptStatus = CCCrypt(operation, // 加密还是解密
            algoritm, // 算法类型
            options,  // 密码块的设置选项
            keyBytes, // 秘钥的字节
            keyLength, // 秘钥的长度
            viDataBytes, // 可选初始化向量的字节
            dataBytes, // 加解密内容的字节
            dataLength, // 加解密内容的长度
            cryptPointer, // output data buffer
            cryptLength,  // output data length available
            &numBytesCrypted) // real output data length
        
        
        
        if UInt32(cryptStatus) == UInt32(kCCSuccess) {
            
            cryptData!.length = Int(numBytesCrypted)
            if op == CCOperation(kCCEncrypt)  {
                let base64cryptString = cryptData?.base64EncodedString(options: .lineLength64Characters)
                return base64cryptString
            }
            else {
                //   let base64cryptString = NSString(bytes: cryptPointer, length: cryptLength, encoding: NSUTF8StringEncoding) as? String  // 用这个会导致返回的JSON数据格式可能有问题，最好不用
                let base64cryptString = NSString(data: cryptData! as Data,  encoding: String.Encoding.utf8.rawValue) as String?
                return base64cryptString
            }
        } else {
            print("Error: \(cryptStatus)")
        }
        return nil
    }

    /// 字符串的匹配范围 方法二(推荐)
    ///
    /// - Parameters:
    ///     - matchStr: 要匹配的字符串
    /// - Returns: 返回所有字符串范围
    @discardableResult
    func jw_exMatchStrRange(_ matchStr: String) -> [NSRange] {
        var selfStr = self as NSString
        var withStr = Array(repeating: "X", count: (matchStr as NSString).length).joined(separator: "") //辅助字符串
        if matchStr == withStr { withStr = withStr.lowercased() } //临时处理辅助字符串差错
        var allRange = [NSRange]()
        while selfStr.range(of: matchStr).location != NSNotFound {
            let range = selfStr.range(of: matchStr)
            allRange.append(NSRange(location: range.location,length: range.length))
            selfStr = selfStr.replacingCharacters(in: NSMakeRange(range.location, range.length), with: withStr) as NSString
        }
        return allRange
    }
    
    /// 计算文本高度
    /// - Parameters:
    ///   - content: 文字内容
    ///   - font: 字体大小
    ///   - lineSpace: 行间距
    ///   - wordSpace: 字体间距
    ///   - width: 可显示的宽度
    ///   - maxHeight: 最大允许高度
    /// - Returns: 高度
     func getContentOfHeight(font: UIFont,lineSpace: CGFloat,wordSpace:CGFloat,width: CGFloat,maxHeight: CGFloat) -> CGFloat {
        
        let p = NSMutableParagraphStyle.init()
        p.lineSpacing = lineSpace
        
        let dic = [NSAttributedString.Key.font:font,NSAttributedString.Key.paragraphStyle:p,NSAttributedString.Key.kern:wordSpace] as [NSAttributedString.Key : Any]
        
        let size = self.boundingRect(with: CGSize(width: width, height: maxHeight), options: .usesLineFragmentOrigin, attributes: dic, context: nil).size
        
        return size.height
    }
    
    
    /// 默认获取内容高度（无行间距、文字间距）
    /// - Parameters:
    ///   - content: Label的文本内容
    ///   - font: Label字体大小
    ///   - width: Label可显示的宽度
    /// - Returns: Label高度
    func getHeight(font: UIFont, width: CGFloat) -> CGFloat {
        return getContentOfHeight(font: font, lineSpace: 0, wordSpace: 0, width: width, maxHeight: CGFloat.greatestFiniteMagnitude)
    }
    
    
    
    /// 计算Label文本内容宽度
    /// - Parameters:
    ///   - content: 文本内容
    ///   - font: Label字体大小
    ///   - lineSpace: 行间距
    ///   - wordSpace: 文字间距
    ///   - height: 可显示的高度
    ///   - maxWidth: 最大允许宽度
    /// - Returns: Label宽度
     func getContentOfWidth(font: UIFont,lineSpace: CGFloat,wordSpace:CGFloat,height: CGFloat,maxWidth: CGFloat) -> CGFloat {
        
        let p = NSMutableParagraphStyle.init()
        p.lineSpacing = lineSpace
        
        let dic = [NSAttributedString.Key.font:font,NSAttributedString.Key.paragraphStyle:p,NSAttributedString.Key.kern:wordSpace] as [NSAttributedString.Key : Any]
        
        let size = self.boundingRect(with: CGSize(width: maxWidth, height: height), options: .usesLineFragmentOrigin, attributes: dic, context: nil).size
        
        return size.width
    }
    
    
    /// 默认获取Label内容宽度（无行间距、文字间距）
    /// - Parameters:
    ///   - content: 文本内容
    ///   - font: 字体大小
    ///   - height: 行高
    ///   - maxWidth: 最大允许宽度
    /// - Returns: Label宽度
    func getWidth(font: UIFont,height: CGFloat,maxWidth: CGFloat) -> CGFloat {
        return getContentOfWidth(font: font, lineSpace: 0, wordSpace: 0, height: height, maxWidth: maxWidth)
    }
    

    //urlEncode编码
     
     func urlEncodeStr() -> String? {
         let charactersToEscape = "?!@#$^&%*+,:;='\"`<>()[]{}/\\| "
         let allowedCharacters = CharacterSet(charactersIn: charactersToEscape).inverted
         let upSign = self.addingPercentEncoding(withAllowedCharacters: allowedCharacters)
         return upSign
     }
     
     //urlEncode解码
     func decoderUrlEncodeStr() -> String? {
         var outputStr = self
         if let subRange = Range<String.Index>(NSRange(location: 0, length: outputStr.count), in: outputStr) { outputStr = outputStr.replacingOccurrences(of: "+", with: "", options: .literal, range: subRange) }
         return outputStr.removingPercentEncoding
     }
    
     // MARK: 字符串转字典
     func getDictionaryFromJSONString() -> NSDictionary{
      
         let jsonData:Data = self.data(using: .utf8)!
      
         let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
         if dict != nil {
             return dict as! NSDictionary
         }
         return NSDictionary()
          
      
     }

    
}

