//
//  NSObject+Stec.swift
//  JFoundation
//
//  Created by kenneth wang on 16/8/19.
//  Copyright © 2016年 st. All rights reserved.
//

import Foundation


public extension NSObject {
    
    /// the name of class 
    public var nameOfClass: String {
        return NSStringFromClass(self.classForCoder).componentsSeparatedByString(".").last!
    }

}