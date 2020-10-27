//
//  UIView+JW.swift
//  petLife
//
//  Created by 龙铁拳 on 2019/8/27.
//  Copyright © 2019 HJ. All rights reserved.
//

import UIKit
public extension UIView {
    
    /// 部分圆角
    ///
    /// - Parameters:
    ///   - corners: 需要实现为圆角的角，可传入多个
    ///   - radii: 圆角半径
    func jw_corner(byRoundingCorners corners: UIRectCorner, radii: CGFloat,viewBounds:CGRect) {
        let maskPath = UIBezierPath(roundedRect: viewBounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radii, height: radii))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = viewBounds
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
    }
    
    //加载xib
    func loadViewFromNib() -> UIView {
        let className = type(of: self)
        let bundle = Bundle(for: className)
        let name = NSStringFromClass(className).components(separatedBy: ".").last
        let nib = UINib(nibName: name!, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return view
    }
    
    ///x轴坐标
    var x: CGFloat {
        get {
            return self.frame.origin.x
        }
        set {
            var tmpFrame = self.frame
            tmpFrame.origin.x = newValue
            self.frame = tmpFrame
        }
    }
    
    ///y轴坐标
    var y: CGFloat {
        get {
            return self.frame.origin.y
        }
        set {
            var tmpFrame = self.frame
            tmpFrame.origin.y = newValue
            self.frame = tmpFrame
        }
    }
    
    ///宽度
    var width: CGFloat {
        get {
            return self.frame.size.width
        }
        set {
            var tmpFrame = self.frame
            tmpFrame.size.width = newValue
            self.frame = tmpFrame
        }
    }
    
    ///高度
    var height: CGFloat {
        get {
            return self.frame.size.height
        }
        set {
            var tmpFrame = self.frame
            tmpFrame.size.height = newValue
            self.frame = tmpFrame
        }
    }
    
    /// 最右边约束x值
    var maxX: CGFloat {
        get {
            return self.frame.origin.x + self.frame.size.width
        }
        set {
            var tmpFrame = self.frame;
            tmpFrame.origin.x = newValue - tmpFrame.size.width;
            self.frame = tmpFrame;
        }
    }
    
    /// 最下边约束y值
    var maxY: CGFloat {
        get {
            return self.frame.origin.y + self.frame.size.height
        }
        set {
            var tmpFrame = self.frame;
            tmpFrame.origin.y = newValue - tmpFrame.size.height;
            self.frame = tmpFrame;
        }
    }
    
    /// 设置x轴中心点
    var centerX: CGFloat {
        get {
            return self.center.x
        }
        set {
            self.center = CGPoint(x: newValue, y: self.center.y);
        }
    }
    
    /// 设置y轴中心点
    var centerY: CGFloat {
        get {
            return self.center.y
        }
        set {
            self.center = CGPoint(x: self.center.x, y: newValue);
        }
        
    }
    
    /// 设置size
    var size: CGSize {
        get {
            return self.frame.size
        }
        set {
            self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: newValue.width, height: newValue.height)
        }
    }
    
    /// 设置orgin
    var origin: CGPoint {
        get {
            return self.frame.origin
        }
        set {
            self.frame = CGRect(x: newValue.x, y: newValue.y, width: self.frame.size.width, height: self.frame.size.height)
        }
    }
    
    /// 设置圆角
    var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
            self.layer.masksToBounds = true
        }
    }
    
    
    
    /// 移除所有子视图
    func removeAllSubviews() {
        while self.subviews.count > 0 {
            self.subviews.last?.removeFromSuperview()
        }
    }
    
}
