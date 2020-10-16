//
//  UIColor+JW.swift
//  UpClassiPhone
//
//  Created by jasonwang on 2018/8/3.
//  Copyright © 2018年 Abc360. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(rgb: UInt) {
        self.init(rgb: rgb, alpha: 1.0)
    }
    
    convenience init(rgb: UInt, alpha: Float) {
        self.init(red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat((rgb & 0x0000FF)) / 255.0,
                  alpha: CGFloat(alpha))
    }
    
    static func jw_colorInt(int:UInt) -> UIColor {
        return UIColor(rgb:int,alpha: 1.0)
    }
    
    static func jw_colorInt(int:UInt,alpha: Float) -> UIColor {
        return UIColor(rgb:int,alpha: alpha)
    }
}

extension UIColor {
    class var ThemeColor: UIColor {
        return UIColor(rgb: 0x09C36C)
    }
    class var TitleColor: UIColor {
        return UIColor(rgb: 0x222222)
    }
    
    class var DetailTitleColor: UIColor {
        return UIColor(rgb: 0x999999)
    }
    
    class var Color_666666: UIColor {
        return UIColor(rgb: 0x666666)
    }
    
    class var backGrayColor: UIColor {
        return UIColor(rgb: 0xF4F4F4)
    }
    
    class var showdenColor: UIColor {
        return UIColor(rgb: 0xA3DCE7)
    }
}

