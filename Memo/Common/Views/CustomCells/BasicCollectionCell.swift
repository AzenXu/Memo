//
//  BasicCollectionCell.swift
//  JFoundation
//
//  Created by XuAzen on 16/7/4.
//  Copyright © 2016年 st. All rights reserved.
//

//MARK:- Basic Collection Elements

import UIKit

public class BasicCollectionCell: UICollectionViewCell {
    public var clickCallBack: (()->())?
    public class func registMe(collectionView: UICollectionView) {
        let className = NSStringFromClass(self)
        collectionView.registerClass(self.classForCoder(), forCellWithReuseIdentifier: className)
    }
    
    public class func dequeueMe(collectionView: UICollectionView, indexPath: NSIndexPath) -> UICollectionViewCell {
        let className = NSStringFromClass(self)
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(className, forIndexPath: indexPath)
        return cell
    }
    
    override public func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if clickCallBack != nil {
            clickCallBack!()
        }
        super.touchesEnded(touches, withEvent: event)
    }
}

public class BasicCollectionSupplement: UICollectionReusableView {
    public var clickCallBack: (()->())?
    
    public class func registMe(collectionView: UICollectionView, forSupplementaryViewOfKind: String) {
        collectionView.registerClass(self.classForCoder(), forSupplementaryViewOfKind: forSupplementaryViewOfKind, withReuseIdentifier: NSStringFromClass(self))
    }
    public class func dequeueMe(collectionView: UICollectionView, elementKind: String, indexPath: NSIndexPath) -> UICollectionReusableView {
        let element = collectionView.dequeueReusableSupplementaryViewOfKind(elementKind, withReuseIdentifier: NSStringFromClass(self), forIndexPath: indexPath)
        return element
    }
    
    override public func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if clickCallBack != nil {
            clickCallBack!()
        }
        super.touchesBegan(touches, withEvent: event)
    }
}

public class BasicTableCell: UITableViewCell {
    public var clickCallBack: (()->())?
    
    public class func registMe(tableView: UITableView) {
        let className = NSStringFromClass(self)
        tableView.registerClass(self.classForCoder(), forCellReuseIdentifier: className)
    }
    
    public class func dequeueMe(tableView: UITableView, indexPath: NSIndexPath) -> UITableViewCell {
        let className = NSStringFromClass(self)
        let cell = tableView.dequeueReusableCellWithIdentifier(className, forIndexPath: indexPath)
        return cell
    }
    
    public override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
        clickCallBack?()
    }
}