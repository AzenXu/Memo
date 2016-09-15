//
//  SmartTask.swift
//  Base
//
//  Created by kenneth wang on 16/5/8.
//  Copyright © 2016年 st. All rights reserved.
//

import Foundation
import UIKit

public typealias CancelableTask = (cancel: Bool) -> Void

/**
 延迟执行任务
 
 - parameter time: 延迟时间
 - parameter work: 任务闭包
 
 - returns:
 */
public func delay(time: NSTimeInterval, work: dispatch_block_t) -> CancelableTask? {
    
    var finalTask: CancelableTask?
    
    let cancelableTask: CancelableTask = { cancel in
        if cancel {
            finalTask = nil // key
            
        } else {
            dispatch_async(dispatch_get_main_queue(), work)
        }
    }
    
    finalTask = cancelableTask
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(time * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
        if let task = finalTask {
            task(cancel: false)
        }
    }
    
    return finalTask
}

/**
 取消执行任务
 
 - parameter cancelableTask: 
 */
public func cancel(cancelableTask: CancelableTask?) {
    cancelableTask?(cancel: true)
}

/**
 测量函数的执行时间
 
 - parameter f: 函数
 */
public func measure(f: () -> ()) {
    let start = CACurrentMediaTime()
    f()
    let end = CACurrentMediaTime()
    print("测量时间：\(end - start)")
}
