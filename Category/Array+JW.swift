//
//  Array+JW.swift
//  YiDianHaoSheng
//
//  Created by 龙铁拳 on 2020/9/10.
//  Copyright © 2020 HJ. All rights reserved.
//

import Foundation

extension Array {
    // 防止数组越界
        subscript(index: Int, safe: Bool) -> Element? {
        if safe {
            if self.count > index {
                return self[index]
            }
            else {
                return nil
            }
        }
        else {
            return self[index]
        }
    }
    
    
}
