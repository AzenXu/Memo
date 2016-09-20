//
//  ShareViewController.swift
//  ShareExtension
//
//  Created by XuAzen on 16/9/20.
//  Copyright © 2016年 azen. All rights reserved.
//

import UIKit
import Social

public let shareSuite = "group.azen.MemoBean"
public let shareUserDefaults = NSUserDefaults(suiteName: shareSuite)

class ShareViewController: SLComposeServiceViewController {

    override func isContentValid() -> Bool {
        // Do validation of contentText and/or NSExtensionContext attachments here
        return true
    }

    override func didSelectPost() {
        //  1. 获取宿主分享内容
        print("这里应该转菊花")
        let attachmentType = "public.url"
        getSingleAttachement(withIdentifier: attachmentType) { [weak self] (result) in
            guard let `self` = self, result = result as? NSURL else {return}
            //  2. 写入userDefault
            self.write(toUserDefault: result.absoluteString, key: "share-url")
            self.write(toUserDefault: "true", key: "has-new-share")
            
            //  3. 测下写好了没
            let object = shareUserDefaults?.objectForKey("share-url")
            let obj2 = shareUserDefaults?.objectForKey("has-new-share")
            print(obj2)
            print(object)
            //  4. 处理完成关闭分享窗口
            self.extensionContext!.completeRequestReturningItems([], completionHandler: nil)
        }
    }
    
    private func write(toUserDefault content: String, key: String) {
        shareUserDefaults!.setObject(content, forKey: key)
    }
    
    private func wirte(toDir content: String)  {
        let groupURL = NSFileManager.defaultManager().containerURLForSecurityApplicationGroupIdentifier(shareSuite)
        let fileURL = groupURL?.URLByAppendingPathComponent("demo.text")
        try! content.writeToURL(fileURL!, atomically: true, encoding: NSUTF8StringEncoding)
    }
    
    private func getSingleAttachement(withIdentifier UTIString: String, callBack: ((result: NSSecureCoding)->())?) {
        //  从分享内容中摘出url来
        //  获取宿主应用分享的内容
        for i in 0..<extensionContext!.inputItems.count {
            guard let item = extensionContext?.inputItems[i] as? NSExtensionItem, attachments = item.attachments else { break }
            for j in 0..<attachments.count {
                guard let itemProvider = attachments[j] as? NSItemProvider else { break }
                if itemProvider.hasItemConformingToTypeIdentifier(UTIString) {
                    itemProvider.loadItemForTypeIdentifier(UTIString, options: nil, completionHandler: { (item, error) in
                        if let item = item {
                            callBack?(result: item)
                        }
                    })
                }
            }
        }
    }
    
    override func didSelectCancel() {
        super.didSelectCancel()
    }

    override func configurationItems() -> [AnyObject]! {
        // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
        return []
    }

}
