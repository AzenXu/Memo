//
//  UIButton+Smart.swift
//  Base
//
//  Created by kenneth wang on 16/5/8.
//  Copyright © 2016年 st. All rights reserved.
//

import Foundation
import UIKit

public extension UIButton {
    
    override public func pointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool {
        var bounds = self.bounds
        //若原热区小于44x44，则放大热区，否则保持原大小不变
        let widthDelta : CGFloat = max(44.0 - bounds.size.width, 0)
        let heightDelta : CGFloat = max(44.0 - bounds.size.height, 0)
        bounds = CGRectInset(bounds, -0.5 * widthDelta, -0.5 * heightDelta)
        return CGRectContainsPoint(bounds, point);
    }
}
