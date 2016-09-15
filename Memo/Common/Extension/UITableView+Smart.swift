//
//  UITableView+Smart.swift
//  Base
//
//  Created by kenneth wang on 16/5/8.
//  Copyright © 2016年 st. All rights reserved.
//

import Foundation
import UIKit

// MARK: - identifers
public extension UITableViewCell {
    
    public class func defaultIdentifier() -> String {
        return NSStringFromClass(self).componentsSeparatedByString(".").last!
    }
}

public extension UITableViewHeaderFooterView {
    
    public class func defaultIdentifier() -> String {
        return NSStringFromClass(self).componentsSeparatedByString(".").last!
    }
}

// MARK: - register cell
public extension UITableView {
    
    public func register<T: UITableViewCell>(cellClass `class`: T.Type) {
        registerClass(`class`, forCellReuseIdentifier: `class`.defaultIdentifier())
    }
    
    public func register<T: UITableViewCell>(nib: UINib, forClass `class`: T.Type) {
        registerNib(nib, forCellReuseIdentifier: `class`.defaultIdentifier())
    }
}

// MARK: - register headerFooter
public extension UITableView {
    public func register<T: UITableViewHeaderFooterView>(headerFooterClass `class`: T.Type) {
        registerClass(`class`, forHeaderFooterViewReuseIdentifier: `class`.defaultIdentifier())
    }
    
    public func register<T: UITableViewHeaderFooterView>(nib: UINib, forHeaderFooterClass `class`: T.Type) {
        registerNib(nib, forHeaderFooterViewReuseIdentifier: `class`.defaultIdentifier())
    }
}

// MARK: - dequeueReusableCell
public extension UITableView {
    
    public func dequeueReusableCell<T: UITableViewCell>(withClass `class`: T.Type) -> T? {
        return dequeueReusableCellWithIdentifier(`class`.defaultIdentifier()) as? T
    }
    
    public func dequeueReusableCell<T: UITableViewCell>(withClass `class`: T.Type, forIndexPath indexPath: NSIndexPath) -> T {
        guard let cell = dequeueReusableCellWithIdentifier(`class`.defaultIdentifier(), forIndexPath: indexPath) as? T else {
            fatalError("Error: cell with identifier: \(`class`.defaultIdentifier()) for index path: \(indexPath) is not \(T.self)")
        }
        return cell
    }
    
    public func dequeueResuableHeaderFooterView<T: UITableViewHeaderFooterView>(withClass `class`: T.Type) -> T? {
        return dequeueReusableHeaderFooterViewWithIdentifier(`class`.defaultIdentifier()) as? T
    }
}
