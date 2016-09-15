//
//  String+Smart.swift
//  Base
//
//  Created by kenneth wang on 16/5/8.
//  Copyright © 2016年 st. All rights reserved.
//

import Foundation

// MARK: - others
public extension String {
    
    public var length: Int {
        return self.characters.count
    }
    
    public func has(string: String) -> Bool {
        if let _ = self.rangeOfString(string) {
            return true
        } else {
            return false
        }
    }
    
    public func replace(string: String, withString: String) -> String {
        return self.stringByReplacingOccurrencesOfString(string, withString: withString)
    }
}

// MARK: - URL String
public extension String {
    
    public var urlEncode: String {
        return self.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())!
    }
    
    public var urlDecode: String {
        return self.stringByRemovingPercentEncoding!
    }
}

// MARK: - Trim
public extension String {
    
    public enum TrimmingType {
        case Whitespace
        case WhitespaceAndNewLine
    }
    
    public func trim(trimmingType: TrimmingType) -> String {
        switch trimmingType {
        case .Whitespace:
            return stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        case .WhitespaceAndNewLine:
            return stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        }
    }
    
    public var removeAllWhitespaces: String {
        return self.stringByReplacingOccurrencesOfString(" ", withString: "").stringByReplacingOccurrencesOfString(" ", withString: "")
    }
    
    public var removeAllNewLines: String {
        return self.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet()).joinWithSeparator("")
    }
    
    public func truncate(length: Int, trailing: String? = nil) -> String {
        if self.characters.count > length {
            return self.substringToIndex(self.startIndex.advancedBy(length)) + (trailing ?? "")
        } else {
            return self
        }
    }
}