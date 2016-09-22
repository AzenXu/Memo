//
//  ModesBridge.swift
//  Memo
//
//  Created by XuAzen on 16/9/21.
//  Copyright © 2016年 azen. All rights reserved.
//
//  已废弃..之前以为ShareExtensionTarget中使用第三方库会被拒审，才辗转用这这方法的😂

import Foundation

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