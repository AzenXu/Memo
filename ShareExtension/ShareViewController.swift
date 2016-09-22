//
//  CustomViewController.swift
//  Memo
//
//  Created by XuAzen on 16/9/21.
//  Copyright © 2016年 azen. All rights reserved.
//

import UIKit

class ShareViewController: UIViewController {
    @IBOutlet weak var shareBox: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        shareBox.layer.cornerRadius = 5
        shareBox.clipsToBounds = true
        
        
        guard let info = getExtensionContextInfos().first else { return }
        self.titleLabel.attributedText = info.content ?? NSAttributedString(string: "啊哦，木有获取到")
        self.descTextView.text = info.title?.string ?? "这里可以添加点备注...虽然目前可能没什么大用" //"这里可以添加点备注...虽然目前可能没什么大用..."
        
        let attachmentType = "public.url"
        getSingleAttachement(withIdentifier: attachmentType) { [weak self] (result, title, content) in
            guard let `self` = self, result = result as? NSURL else {return}
            dispatch_async(dispatch_get_main_queue(), {
                self.titleLabel.attributedText = title ?? content ?? NSAttributedString(string: "啊哦，木有获取到")
                self.descTextView.text = result.absoluteString
            })
        }
    }
    
    @IBAction func addToMemoClick() {
        if let title = titleLabel.attributedText?.string {
            let desc = descTextView.text == "这里可以添加点备注...虽然目前可能没什么大用" ? "" : descTextView.text
            write(toRealm: title, desc: desc)
        }
        extensionContext?.completeRequestReturningItems(nil, completionHandler: nil)
    }
    
    @IBAction func cancelClick() {
        extensionContext?.cancelRequestWithError(NSError(domain: "CustomShareError", code: NSUserCancelledError, userInfo: nil))
    }
    
}

struct ExtensionContextInfo {
    var title: NSAttributedString?
    var content: NSAttributedString?
    
    init(title: NSAttributedString?, content: NSAttributedString?) {
        self.title = title
        self.content = content
    }
}

extension ShareViewController {
    
    private func getExtensionContextInfos() -> [ExtensionContextInfo] {
        var infos = [ExtensionContextInfo]()
        for i in 0..<extensionContext!.inputItems.count {
            guard let item = extensionContext?.inputItems[i] as? NSExtensionItem else { break }
            let title = item.attributedTitle
            let content = item.attributedContentText
            infos.append(ExtensionContextInfo(title: title, content: content))
        }
        return infos
    }
    
    private func getSingleAttachement(withIdentifier UTIString: String, callBack: ((result: NSSecureCoding, title: NSAttributedString?, content: NSAttributedString?)->())?) {
        //  从分享内容中摘出url来
        //  获取宿主应用分享的内容
        for i in 0..<extensionContext!.inputItems.count {
            guard let item = extensionContext?.inputItems[i] as? NSExtensionItem, attachments = item.attachments else { break }
            let title = item.attributedTitle
            let content = item.attributedContentText
            for j in 0..<attachments.count {
                guard let itemProvider = attachments[j] as? NSItemProvider else { break }
                if itemProvider.hasItemConformingToTypeIdentifier(UTIString) {
                    itemProvider.loadItemForTypeIdentifier(UTIString, options: nil, completionHandler: { (item, error) in
                        if let item = item {
                            callBack?(result: item, title: title, content: content)
                        }
                    })
                }
            }
        }
    }
    
    private func write(toRealm title: String, desc: String = "") {
        let kno = Knowledge()
        kno.title = title
        kno.desc = desc
        MemoShareDataTool.save(kno)
    }
}

//  废弃的方法
extension ShareViewController {
    private func write(toUserDefault title: String, desc: String = "") {
        let test = KnowledgeBridge()
        test.title = title
        test.desc = desc
        MemoShareDataTool.save(test)
    }
    private func wirte(toDir content: String)  {
        let groupURL = NSFileManager.defaultManager().containerURLForSecurityApplicationGroupIdentifier(MemoShareSuitName)
        let fileURL = groupURL?.URLByAppendingPathComponent("demo.text")
        try! content.writeToURL(fileURL!, atomically: true, encoding: NSUTF8StringEncoding)
    }
}
