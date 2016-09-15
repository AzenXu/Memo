//
//  UITabBar+Stec.swift
//  JFoundation
//
//  Created by 姜云锋 on 16/7/20.
//  Copyright © 2016年 st. All rights reserved.
//

import Foundation
import UIKit

public extension UITabBar {
    
    //显示小红点
    public func showBadgeOnItemIndex(index : Int){
        
        self.removeBadgeOnItemIndex(index)
        let badgeView : UIView = UIView()
        badgeView.tag=888 + index
        badgeView.layer.cornerRadius = 4
        badgeView.backgroundColor = UIColor.redColor()
        let tabFrame : CGRect = self.frame
        let percentX = (Double(index) + 0.55) / 4.0
        let x = ceilf(Float(percentX) * Float(tabFrame.size.width))
        let y = ceilf(Float(tabFrame.size.height) * 0.1)
        badgeView.frame = CGRectMake(CGFloat(x), CGFloat(y),8,8)
        self.addSubview(badgeView)
    }
    
    //隐藏小红点
    public func hideBadgeOnItemIndex(index : Int) {
        self.removeBadgeOnItemIndex(index)
    }
    
    //移除小红点
    func removeBadgeOnItemIndex(index : Int){
        for subView in self.subviews {
            if subView.tag == 888 + index {
                subView.removeFromSuperview()
            }
        }
    }
}

