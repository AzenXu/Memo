//
//  Array+Stec.swift
//  JFoundation
//
//  Created by XuAzen on 16/8/22.
//  Copyright © 2016年 st. All rights reserved.
//

import Foundation

extension Array {
    public subscript (safe index: Int) -> Element? {
        if self.count > index {
            return self[index]
        } else {
            return nil
        }
    }
    
    public mutating func append(newElement: Array) {
        appendContentsOf(newElement)
    }
}
