//
//  ApplicationExtensions.swift
//  Memo
//
//  Created by XuAzen on 16/9/20.
//  Copyright © 2016年 azen. All rights reserved.
//

public let shareSuite = "group.azen.MemoBean"
public let shareUserDefaults = NSUserDefaults(suiteName: shareSuite)
class ApplicationExtensions: NSObject {
    class func dealWithSharedContent() {
        print(shareUserDefaults?.stringForKey("has-new-share"))
        print(shareUserDefaults?.objectForKey("share-url"))
//        if shareUserDefaults?.stringForKey("has-new-share") == "true" {
//            print("新的分享！\(shareUserDefaults?.objectForKey("share-url"))")
//            shareUserDefaults?.setObject("false", forKey: "has-new-share")
//        }
        
        let groupURL = NSFileManager.defaultManager().containerURLForSecurityApplicationGroupIdentifier(shareSuite)
        let fileURL = groupURL?.URLByAppendingPathComponent("demo.text")
        let str = try! String(contentsOfURL: fileURL!, encoding: NSUTF8StringEncoding)
        print(fileURL)
        print(str)
    }
}
