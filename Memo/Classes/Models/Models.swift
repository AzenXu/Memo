//
//  Knowledge.swift
//  Memo
//
//  Created by XuAzen on 16/9/15.
//  Copyright © 2016年 azen. All rights reserved.
//

import Foundation
import RealmSwift

public class Knowledge: Object {
    public dynamic var title: String = ""
    public dynamic var desc: String = ""
    public dynamic var updateTime: NSTimeInterval = NSDate().timeIntervalSince1970
    public dynamic var memoryCount: Int = 0
    
    override public static func primaryKey() -> String? {
        return "title"
    }
}

public  extension KnowledgeBridge {
    public func vatting() -> Knowledge {
        let knowledge = Knowledge()
        knowledge.title = title
        knowledge.desc = desc
        knowledge.updateTime = updateTime
        knowledge.memoryCount = 0
        return knowledge
    }
}
