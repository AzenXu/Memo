//
//  ModesBridge.swift
//  Memo
//
//  Created by XuAzen on 16/9/21.
//  Copyright © 2016年 azen. All rights reserved.
//

import Foundation

public let MemoShareSuitName = "group.azen.MemoBean"
public let MemoShareUserDefault = NSUserDefaults(suiteName: MemoShareSuitName)

public class KnowledgeBridge: NSObject, NSCoding {
    public dynamic var title: String = ""
    public dynamic var desc: String = ""
    public dynamic var updateTime: NSTimeInterval = NSDate().timeIntervalSince1970
    
    public func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(title, forKey: "title")
        aCoder.encodeObject(desc, forKey: "desc")
        aCoder.encodeDouble(updateTime, forKey: "updateTime")
    }
    public required init?(coder aDecoder: NSCoder) {
        title = aDecoder.decodeObjectForKey("title") as? String ?? ""
        desc = aDecoder.decodeObjectForKey("desc") as? String ?? ""
        updateTime = aDecoder.decodeDoubleForKey("updateTime")
    }
    public override init() {
        super.init()
    }
}

public struct MemoShareDataTool {
    static var knowledgeKey = "Memo.Data.Knowledge"
    static private var tmpDataArray = [KnowledgeBridge]()
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