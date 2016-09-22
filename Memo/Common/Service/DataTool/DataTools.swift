//
//  DataTools.swift
//  Memo
//
//  Created by XuAzen on 16/9/22.
//  Copyright © 2016年 azen. All rights reserved.
//

import Foundation
import RealmSwift

public let MemoShareSuitName = "group.azen.MemoBean"
public let MemoShareUserDefault = NSUserDefaults(suiteName: MemoShareSuitName)
public let MemoSharePath = NSFileManager.defaultManager().containerURLForSecurityApplicationGroupIdentifier(MemoShareSuitName)

public struct MemoShareDataTool {
    static var knowledgeKey = "Memo.Data.Knowledge"
    static private var tmpDataArray = [KnowledgeBridge]()
}

//  save with realm
public extension MemoShareDataTool {
    
    static var shareRealm = Bootstrap.shareRealm
    
    static public func save(content: Knowledge) {
//        let groupURL = NSFileManager.defaultManager().containerURLForSecurityApplicationGroupIdentifier(MemoShareSuitName)
//        let fileURL = groupURL?.URLByAppendingPathComponent("demo.text")
//        try! content.writeToURL(fileURL!, atomically: true, encoding: NSUTF8StringEncoding)
        try! shareRealm?.write({
            shareRealm?.add(content, update: true)
        })
    }
}

//  save with userDefault 已废弃，使用Realm
public extension MemoShareDataTool {
    
    static private var isSaveing = false {
        didSet {
            if isSaveing == false && !tmpDataArray.isEmpty {
                save(tmpDataArray)
                tmpDataArray = [KnowledgeBridge]()
            }
        }
    }
    /**
     Save for Single Knowledge
     */
    public static func save(item: KnowledgeBridge) {
        guard isSaveing == false else {
            tmpDataArray.append(item)
            return
        }
        isSaveing = true
        var knowledges = MemoShareUserDefault?.objectForKey(knowledgeKey) as? [KnowledgeBridge] ?? [KnowledgeBridge]()
        knowledges.append(item)
        _writeCommit(knowledges)
    }
    /**
     Save for Knowledges
     */
    public static func save<S: SequenceType where S.Generator.Element: KnowledgeBridge>(item: S) {
        guard let item = item as? [KnowledgeBridge] else { return }
        guard isSaveing == false else {
            tmpDataArray.append(item)
            return
        }
        isSaveing = true
        var knowledges = MemoShareUserDefault?.objectForKey(knowledgeKey) as? [KnowledgeBridge] ?? [KnowledgeBridge]()
        knowledges.append(item)
        _writeCommit(knowledges)
    }
    /**
     Load Knowledges
     */
    public static func loadData() -> [KnowledgeBridge]? {
        guard let data = MemoShareUserDefault?.objectForKey(knowledgeKey) as? NSData else { return nil }
        let result = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? [KnowledgeBridge]
        return result
    }
    
    public static func clearData() {
        MemoShareUserDefault?.removeObjectForKey(knowledgeKey)
    }
    
    
    static private func _writeCommit(items: [KnowledgeBridge]) {
        guard !items.isEmpty else { return }
        var items = items
        if !tmpDataArray.isEmpty {
            items.appendContentsOf(tmpDataArray)
        }
        let savedData = NSKeyedArchiver.archivedDataWithRootObject(items)
        MemoShareUserDefault?.setObject(savedData, forKey: knowledgeKey)
        MemoShareUserDefault?.synchronize()
        isSaveing = false
    }
}