//
//  UIView+Stec.swift
//  JFoundation
//
//  Created by kenneth wang on 16/5/24.
//  Copyright © 2016年 st. All rights reserved.
//

import Foundation
import UIKit

// MARK: - add rounded corner
//sample: let view = UIView(frame: CGRectMake(1,2,3,4)) view.addCorner(radius: 6)
public extension UIView {
    
    private func drawRoundedCorner(radius: CGFloat, borderWidth: CGFloat, backgroundColor: UIColor, borderColor: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.frame.size, false, UIScreen.mainScreen().scale);
        let context: CGContextRef = UIGraphicsGetCurrentContext()!;
        
        CGContextSetFillColorWithColor(context, backgroundColor.CGColor);
        CGContextSetLineWidth(context, borderWidth);
        CGContextSetStrokeColorWithColor(context, borderColor.CGColor);
        
        let bounds: CGRect = CGRectMake(borderWidth / 2.0, borderWidth / 2.0, self.bounds.size.width - borderWidth, self.bounds.size.height - borderWidth);
        
        CGContextMoveToPoint(context, CGRectGetMinX(bounds), radius);
        CGContextAddArcToPoint(context, CGRectGetMinX(bounds), CGRectGetMinY(bounds), radius, CGRectGetMinY(bounds), radius);
        CGContextAddArcToPoint(context, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds), CGRectGetMinY(bounds) + radius, radius);
        CGContextAddArcToPoint(context, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), CGRectGetMaxX(bounds) - radius, CGRectGetMaxY(bounds), radius);
        CGContextAddArcToPoint(context, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMinX(bounds), CGRectGetMaxY(bounds) - radius, radius);
        
        CGContextClosePath(context);
        CGContextDrawPath(UIGraphicsGetCurrentContext(), .FillStroke);
        let output: UIImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return output;
    }
    
    public func addCorner(radius: CGFloat, borderWidth: CGFloat, backgroundColor: UIColor, borderColor: UIColor) {
        let imageView = UIImageView(image: drawRoundedCorner(radius, borderWidth: borderWidth, backgroundColor: backgroundColor, borderColor: borderColor))
        self.insertSubview(imageView, atIndex: 0)
    }
}

// MARK: - 给View添加渐变背景色
public extension UIView {
    
    public func addGradientWithColor(color: UIColor) {
        self.addGradientWithColor(UIColor.clearColor(), toColor: color)
    }
    
    public func addGradientWithColor(fromColor: UIColor, toColor: UIColor) {
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = [fromColor.CGColor, toColor.CGColor]
        self.layer.insertSublayer(gradient, atIndex: 0)
    }
}

// MARK: - convertToImage
public extension UIView {
    public func convertToImage() -> UIImage {
//        UIGraphicsBeginImageContext(self.frame.size)
        UIGraphicsBeginImageContextWithOptions(self.frame.size, false, UIScreen.mainScreen().scale)
        self.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

// 给View的某一个角添加圆角
public extension UIView {
    public func addCorner(corners: UIRectCorner, cornerRadii: CGSize) {
        let maskPath: UIBezierPath = UIBezierPath.init(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: cornerRadii)
        let maskLayer: CAShapeLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = maskPath.CGPath
        self.layer.mask = maskLayer
    }
}
