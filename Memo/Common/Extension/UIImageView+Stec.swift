//
//  UIImageView+Stec.swift
//  JFoundation
//
//  Created by kenneth wang on 16/5/17.
//  Copyright © 2016年 st. All rights reserved.
//

import Foundation
import UIKit

// MARK: - add rounded corner
public extension UIImageView {

    public func addCorner(radius: CGFloat) {
        self.image = self.image?.circleImage(radius: radius, size: self.bounds.size)
    }
}