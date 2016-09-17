//
//  RNHelper.swift
//  Memo
//
//  Created by XuAzen on 16/9/17.
//  Copyright © 2016年 azen. All rights reserved.
//

import Foundation
import UIKit
import React

class RNHelper {
    class var sharedInstance: RNHelper {
        struct Singleton {
            static let instance = RNHelper()
        }
        Singleton.instance.setupNotifyObserver()
        return Singleton.instance
    }
    
    func setupNotifyObserver() {
        NSNotificationCenter.defaultCenter().addObserverForName(MemoNofity.Memo_ChangeRootViewControllerToNative.rawValue, object: nil, queue: nil) { _ in
            appDelegate.changeRootViewController(isRN: false)
        }
    }
}

class RNViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _setupHelper()
        _setupRNView()
    }
    
    private func _setupHelper() {
        RNHelper.sharedInstance
    }
    
    private func _setupRNView() {
//        let strURL = "http://localhost:8081/index.ios.bundle?platform=ios&dev=true"
//        let jsCodeLocation = NSURL.init(string: strURL)
//        let jsCodeLocation = NSBundle.mainBundle().URLForResource("main", withExtension: "jsbundle")
        let jsCodeLocation = CodePush.bundleURL()
        let rootView = RCTRootView(bundleURL: jsCodeLocation, moduleName: "HelloRN", initialProperties: nil, launchOptions: nil)
        self.view = rootView
    }
}