//
//  UIScrollView+Stec.swift
//  JFoundation
//
//  Created by kenneth wang on 16/8/26.
//  Copyright © 2016年 st. All rights reserved.
//

import Foundation
import UIKit

public extension UIScrollView {
    
    public var stec_isAtTop: Bool {
        
        return contentOffset.y == -contentInset.top
    }
    
    public func stec_scrollsToTop() {
        
        let topPoint = CGPoint(x: 0, y: -contentInset.top)
        setContentOffset(topPoint, animated: true)
    }
    
    private func stec_zoomRectWithZoomPoint(zoomPoint: CGPoint, scale: CGFloat) -> CGRect {
        
        var scale = min(scale, maximumZoomScale)
        scale = max(scale, minimumZoomScale)
        
        let zoomFactor = 1.0 / self.zoomScale
        
        let translatedZoomPoint = CGPoint(
            x: (zoomPoint.x + self.contentOffset.x) * zoomFactor,
            y: (zoomPoint.y + self.contentOffset.y) * zoomFactor
        )
        
        let destinationRectWidth = self.bounds.width / scale
        let destinationRectHeight = self.bounds.height / scale
        let destinationRect = CGRect(
            x: translatedZoomPoint.x - destinationRectWidth * 0.5,
            y: translatedZoomPoint.y - destinationRectHeight * 0.5,
            width: destinationRectWidth,
            height: destinationRectHeight
        )
        
        return destinationRect
    }
    
    public func stec_zoomToPoint(zoomPoint: CGPoint, withScale scale: CGFloat, animated: Bool) {
        
        let zoomRect = stec_zoomRectWithZoomPoint(zoomPoint, scale: scale)
        self.zoomToRect(zoomRect, animated: animated)
    }
    
    public func stec_zoomToPoint(zoomPoint: CGPoint, withScale scale: CGFloat, animationDuration: NSTimeInterval, animationCurve: UIViewAnimationCurve) {
        
        let zoomRect = stec_zoomRectWithZoomPoint(zoomPoint, scale: scale)
        
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(animationDuration)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationCurve(animationCurve)
        
        self.zoomToRect(zoomRect, animated: false)
        
        UIView.commitAnimations()
    }
}