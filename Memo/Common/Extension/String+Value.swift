//
//  String+Value.swift
//  JFoundation
//
//  Created by zhaoyingze on 16/8/3.
//  Copyright © 2016年 st. All rights reserved.
//

import Foundation

public extension String {
    
    public static func hasValue(string : String?) -> Bool {
        
        if let str = string {
            
            let abstr = str.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            
            if abstr.length > 0 {
                
                return true
            }
        }
        
        return false
    }
}