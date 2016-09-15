//
//  Int64+Stec.swift
//  JFoundation
//
//  Created by kenneth wang on 16/5/30.
//  Copyright © 2016年 st. All rights reserved.
//

import Foundation

public extension Int64 {
    
    public var isEnterprise: Bool { //入驻的达人 0b10000
        if 32 & self == 32 {
            return true
        }
        return false
    }
    
    public var isGenius: Bool {//入驻的商户 0b100000
        if 16 & self == 16 {
            return true
        }
        return false
    }
    
    public var isMinister: Bool {//部长 0b100
        if 4 & self == 4 {
            return true
        }
        return false
    }
    
    public var isBigshot: Bool {//大咖 0b10
        if 2 & self == 2 {
            return true
        }
        return false
    }
    
    public var isMemeber: Bool {//会员 0b1
        if 1 & self == 1 {
            return true
        }
        return false
    }
    
    public var isCommontUser: Bool {//普通会员
        if 0 & self == 0 {
            return true
        }
        return false
    }
}

//
public extension Int64 {
    
    /**价钱转换带￥*/
    public func getPriceWithIconString() -> String {
        
        if (self % 10) > 0 {
            return ("￥" + String(format: "%.2f", Double(self)/100))
        } else if (self % 100) > 0 {
            return ("￥" + String(format: "%.1f", Double(self)/100))
        } else {
            return ("￥" + "\(self/100)")
        }
    }
    
    /**价钱转换不带￥*/
    public func getPriceString() -> String {
        
        if (self % 10) > 0 {
            return String(format: "%.2f", Double(self)/100)
        } else if (self % 100) > 0 {
            return String(format: "%.1f", Double(self)/100)
        } else {
            return "\(self/100)"
        }
    }
}