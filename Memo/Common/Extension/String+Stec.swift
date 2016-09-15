//
//  String+Stec.swift
//  JFoundation
//
//  Created by kenneth wang on 16/5/15.
//  Copyright © 2016年 st. All rights reserved.
//

import Foundation
// MARK: - Type Chack
public extension String {
    
    public static func isNumberString() -> Bool {
        let match = "[0-9]+"
        let predicate = NSPredicate(format: "SELF matches %@", match)
        return predicate.evaluateWithObject("\(self)")
    }
}

// MARK: - TFS key to NSURL
public extension String {
    
//    public func resourceURL(withWidth width: Int, height: Int) -> NSURL {
//        return safeResourceURL(withWidth: width, height: height)!
//    }
//    
//    public func safeResourceURL(withWidth width: Int, height: Int) -> NSURL? {
//        func format(tfsKey: String, width: Int, height: Int) -> String {
//            let stringArray = tfsKey.componentsSeparatedByString(".")
//            guard stringArray.count > 1 else {
//                return stringArray.first! + "_\(width)x\(height)"
//            }
//            
//            var result = stringArray.first!
//            for (index, value) in stringArray.enumerate() {
//                if index != 0 {
//                    if index != stringArray.count - 1 {
//                        result = result + ".\(value)"
//                    } else {
//                        let lowerValue = value.lowercaseString
//                        if lowerValue.containsString("png") || lowerValue.containsString("jpg")
//                            || lowerValue.containsString("gif") || lowerValue.containsString("jpeg")
//                            || lowerValue.containsString("pmp") {
//                            result = result + "_\(width)x\(height)." + value
//                        } else {
//                            result = result + "." + value + "_\(width)x\(height)"
//                        }
//                    }
//                }
//            }
//            
//            return result
//        }
//        
//        return NSURL(string: UTravConfig.Settings.netEnvType.tfsDownloadUrl + format(self, width: width, height: height))
//    }
}

public extension String {
    public func trimmed() -> String {
        return self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
    }
    
    public func replace(before: String, after:String) -> String {
        return self.stringByReplacingOccurrencesOfString(before, withString: after)
    }
    public func filterString() -> String {
        let nssting = NSString(string: self)
        let doNotWanted = NSCharacterSet(charactersInString: "@[]{}（#%-*+=_）\\|~(＜＞$%^&*)_+ ")//特殊符号包含空格，，，
        let changedString = nssting.stringByTrimmingCharactersInSet(doNotWanted)
        
        return changedString
    }
    //是否包含字符串
//    public func has(s:String) -> Bool{
//        if (self.rangeOfString(s) != nil) {
//            return true
//        }else{
//            return false
//        }
//    }
//    
//    public func length() -> Int{
//        return self.characters.count
//    }
    
    //超出用...代替
    public func st_substring(index: Int) -> String {
        self.replace("...出发", after: "")
        if self.length > index {
            let index = self.startIndex.advancedBy(index - 1)
            return self.substringToIndex(index) + "...出发"
        }
        return "\(self)" + "出发"
    }
    
    public func append(string: String?) -> String {
        var result = self
        if let string = string {
            result += string
        }
        return result
    }
}
