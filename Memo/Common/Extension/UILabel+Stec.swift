//
//  UILabel+Stec.swift
//  JFoundation
//
//  Created by zhangdekai on 16/6/13.
//  Copyright © 2016年 st. All rights reserved.
//

import Foundation
import UIKit

// MARK: - 计算带行间距的UILabel 高度

// MARK: - 根据文字长度计算Label长度
public extension UILabel {
    
    public func calculateLabelWidth(font:UIFont,labelHeight:CGFloat,labelText:String) ->CGFloat {
        
        let statusLabelText: NSString = labelText
        let size = CGSizeMake(900, labelHeight)
        let dic = NSDictionary(object: font, forKey: NSFontAttributeName)
        let strSize = statusLabelText.boundingRectWithSize(size, options: .UsesLineFragmentOrigin, attributes: dic as? [String : AnyObject], context: nil).size
        return strSize.width
    }
}
