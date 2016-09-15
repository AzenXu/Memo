//
//  UIViewcontroller+Stec.swift
//  JFoundation
//
//  Created by kenneth wang on 16/5/20.
//  Copyright © 2016年 st. All rights reserved.
//

import Foundation
import SafariServices
import CoreLocation

// MARK: - Heights
public extension UIViewController {
    
    public var statusBarHeight: CGFloat {
        
        if let window = view.window {
            let statusBarFrame = window.convertRect(UIApplication.sharedApplication().statusBarFrame, toView: view)
            return statusBarFrame.height
            
        } else {
            return 0
        }
    }
    
    public var navigationBarHeight: CGFloat {
        
        if let navigationController = navigationController {
            return navigationController.navigationBar.frame.height
            
        } else {
            return 0
        }
    }
    
    public var topBarsHeight: CGFloat {
        return statusBarHeight + navigationBarHeight
    }
}

// MARK: - alert
public extension UIViewController {
    
    public func stec_showAlert(withMessage message: String, cancelButton: Bool = false, handler: ((UIAlertAction) -> Void)?) {
        let alertController = UIAlertController(title: "提示", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.Default, handler: handler))
        if cancelButton {
            alertController.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil))
        }
        self .presentViewController(alertController, animated: true, completion: nil)
    }
}

// MARK: - openURL
public extension UIViewController {
    
    public func stec_openURL(URL: NSURL) {
        
        if #available(iOS 9.0, *) {
            let safariViewController = SFSafariViewController(URL: URL)
            presentViewController(safariViewController, animated: true, completion: nil)
            
        } else {
            UIApplication.sharedApplication().openURL(URL)
        }
    }
}

public extension UIViewController {
    
    public func stec_whetherOpenLocation() -> Bool {
        if(CLLocationManager.authorizationStatus() == .Denied) {
            //NSLog(@"定位服务当前可能尚未打开，请设置打开！");
            let alertController:UIAlertController = UIAlertController.init(title: "GPS未开启,无法提供定位服务", message: "请在系统设置中开启定位服务(设置>隐私>定位服务>开启九休APP)", preferredStyle: UIAlertControllerStyle.Alert)
            
            let leftAction:UIAlertAction = UIAlertAction.init(title: "确定", style: UIAlertActionStyle.Cancel, handler: { (UIAlertAction) -> Void in
                self.navigationController?.popViewControllerAnimated(true)
            })
            alertController.addAction(leftAction)
            self.presentViewController(alertController, animated: true, completion: nil)
            return false
        }
        
        return true
    }
}

public extension UIViewController {
    public func removeFromNavigationController() {
        if let index = self.navigationController?.viewControllers.indexOf(self) {
            self.navigationController?.viewControllers.removeAtIndex(index)
        } else {
            print("不在navigation中")
        }
    }
}
