//
//  CGFloat+Stec.swift
//  UTraveler
//
//  Created by XuAzen on 16/3/8.
//  Copyright © 2016年 Beijing Yimay Holiday Information Science & Technology Co.,Ltd. All rights reserved.
//

import Foundation
import UIKit

public extension CGFloat {
    /// 返回根据屏幕缩放后的尺寸
    public var scalValue: CGFloat {
        get {
            let scal = UIScreen.mainScreen().bounds.size.width / 375.0
            return scal * CGFloat(native)
        }
    }
    
    public var onef: CGFloat {
        get {
            let leftPercentString = String.init(format: "%.1f", self)
            let leftPercentReal = Int((Float(leftPercentString) ?? 0) * 10.0)
            return CGFloat(leftPercentReal) * 0.1        }
    }
    
    public var twof: CGFloat {
        get {
            let leftPercentString = String.init(format: "%.2f", self)
            let leftPercentReal = Int((Float(leftPercentString) ?? 0) * 100.0)
            //  解决0.05转CGFloat 变为0.049999999997的bug
            let result = (CGFloat(leftPercentReal) + 0.000001) * 0.01
            return result
        }
    }
}