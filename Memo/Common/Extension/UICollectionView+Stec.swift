//
//  UICollectionView+Stec.swift
//  JFoundation
//
//  Created by kenneth wang on 16/5/21.
//  Copyright © 2016年 st. All rights reserved.
//

import Foundation
import UIKit

public extension UICollectionView {
    public func reloadData(section section: Int) {
        let range = NSRange(location: section, length: 1)
        self.reloadSections(NSIndexSet(indexesInRange: range))
    }
}
