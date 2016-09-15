//
//  UIColor+Smart.swift
//  Base
//
//  Created by kenneth wang on 16/5/8.
//  Copyright © 2016年 st. All rights reserved.
//

import Foundation
import UIKit

// MARK: - color convert
public extension UIColor {
    
    class func stec_color(withHex hex: Int) -> UIColor {
        return UIColor.stec_color(withHex: hex, alpha: 1)
    }
    
    class func stec_color(withHex hex: Int, alpha: CGFloat) -> UIColor {
        return UIColor(red: ((CGFloat)((hex & 0xFF0000) >> 16) / 255.0), green: ((CGFloat)((hex & 0xFF00) >> 8)) / 255.0, blue: ((CGFloat)(hex & 0xFF)) / 255.0, alpha: alpha)
    }
    
    class func stec_color(withHexString hex:String) -> UIColor {
        return UIColor.stec_color(withHexString: hex, alpha: 1)
    }
    
    class func stec_color(withHexString hex:String, alpha: CGFloat) -> UIColor {
        var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).uppercaseString
        
        if (cString.hasPrefix("#")) {
            cString = (cString as NSString).substringFromIndex(1)
        }
        
        if (cString.characters.count != 6) {
            return UIColor.grayColor()
        }
        let rString = (cString as NSString).substringToIndex(2)
        let gString = ((cString as NSString).substringFromIndex(2) as NSString).substringToIndex(2)
        let bString = ((cString as NSString).substringFromIndex(4) as NSString).substringToIndex(2)
        
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        NSScanner(string: rString).scanHexInt(&r)
        NSScanner(string: gString).scanHexInt(&g)
        NSScanner(string: bString).scanHexInt(&b)
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: alpha)
    }
    
    class func stec_randomColor() -> UIColor {
        return UIColor(red: CGFloat(Double(arc4random_uniform(100)) * 0.01), green: CGFloat(Double(arc4random_uniform(100)) * 0.01), blue: CGFloat(Double(arc4random_uniform(100)) * 0.01), alpha: 1)
    }
}