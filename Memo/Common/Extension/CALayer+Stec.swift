//
//  CALayer+Stec.swift
//  JFoundation
//
//  Created by Tony on 16/9/7.
//  Copyright © 2016年 st. All rights reserved.
//

import Foundation
import UIKit

public extension CALayer {
    /**
     设置圆角
     
     - parameter cornerRadius:    圆角半径
     - parameter shouldRasterize: 是否进行内存缓存以便复用
     */
    public func setCorner(cornerRadius: CGFloat, shouldRasterize: Bool = false) {
        self.cornerRadius = cornerRadius
        self.masksToBounds = true
        if shouldRasterize {
            self.shouldRasterize = true
            self.rasterizationScale = UIScreen.mainScreen().scale
        }
    }
}