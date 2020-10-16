//
//  String+Check.swift
//  DingDongZaiXian
//
//  Created by Li Dong on 2020/10/16.
//

import UIKit

extension String {
    
    /// 检查是否手机号
    func isTelNumber() -> Bool
    {
        if self.count < 11 {
            return false
        }
        let mobile = "^1\\d{10}$"
        let regextestmobile = NSPredicate(format: "SELF MATCHES %@",mobile)
        return regextestmobile.evaluate(with: self)
    }
    
    /// 检查身份证号
    func isIdCardNumber() -> Bool {
        // 身份证号码为15位或者18位，15位时全为数字，18位前17位为数字，最后一位是校验位，可能为数字或字符X
        let reg = "^\\d{17}[0-9Xx]|\\d{15}"
        let regexIdCard = NSPredicate(format: "SELF MATCHES %@",reg)
        return regexIdCard.evaluate(with: self)
    }
    
    ///是否为纯数字
    func isDigital() -> Bool {
        let reg = "[0-9]*"
        let regexIdCard = NSPredicate(format: "SELF MATCHES %@",reg)
        return regexIdCard.evaluate(with: self)
    }
    
    ///是否为纯字母
    func isLetter() -> Bool {
        let reg = "[a-zA-Z]*"
        let regexIdCard = NSPredicate(format: "SELF MATCHES %@",reg)
        return regexIdCard.evaluate(with: self)
    }
    
    
    ///是否为数字和字母
    func isDigitalAndLetter() -> Bool {
        let reg = "[a-zA-Z0-9]*"
        let regexIdCard = NSPredicate(format: "SELF MATCHES %@",reg)
        return regexIdCard.evaluate(with: self)
    }
    
    ///是否为纯汉字
    func isChinese() -> Bool {
        let reg = "^[\u{4e00}-\u{9fa5}]+$"
        let regexIdCard = NSPredicate(format: "SELF MATCHES %@",reg)
        return regexIdCard.evaluate(with: self)
    }
    
    ///邮箱格式校验
    func isEmail() -> Bool {
        let reg = "([a-zA-Z0-9_-]+)@([a-zA-Z0-9_-]+)(\\.[a-zA-Z0-9_-]+)+$"
        let regexIdCard = NSPredicate(format: "SELF MATCHES %@",reg)
        return regexIdCard.evaluate(with: self)
    }
}
