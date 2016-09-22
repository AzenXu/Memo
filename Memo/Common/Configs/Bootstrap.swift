//
//  Bootstrap.swift
//  Memo
//
//  Created by XuAzen on 16/9/16.
//  Copyright © 2016年 azen. All rights reserved.
//

import Foundation
import RealmSwift

public struct Bootstrap {
    
    //  the realm instance
    public static var cachedDataRealm: Realm? {
        return try? Realm(configuration: getRealmConfigurationForCachedData())
    }
    
    public static func getRealmConfigurationForCachedData() -> Realm.Configuration {
        var config = Realm.Configuration()
        config.schemaVersion = 0
        config.migrationBlock = { _ in }
        config.fileURL = config.fileURL!.URLByDeletingLastPathComponent?.URLByAppendingPathComponent("Cached-\(MemoConfig.Settings.netEnvType).realm")
        print(config.fileURL?.absoluteString)
        return config
    }
    
    //  the realm instance
    public static var shareRealm: Realm? {
        return try? Realm(configuration: getRealmConfigurationForShare())
    }
    
    public static func getRealmConfigurationForShare() -> Realm.Configuration {
        var config = Realm.Configuration()
        config.schemaVersion = 0
        config.migrationBlock = { _ in }
        config.fileURL = MemoSharePath?.URLByAppendingPathComponent("Cached-\(MemoConfig.Settings.netEnvType).realm")
        config.objectTypes = [Knowledge.self]
        print(config.fileURL?.absoluteString)
        return config
    }
}

public extension Bootstrap {
    public static func dealDatas() {
        /*
            due to uncaught exception 'NSInvalidUnarchiveOperationException', reason: '*** -[NSKeyedUnarchiver decodeObjectForKey:]: cannot decode object of class (ShareExtension.KnowledgeBridge) for key (NS.objects); the class may be defined in source code or a library that is not linked'
        */
        guard let oriKnowledge = shareRealm?.objects(Knowledge) else { return }
        let shareKnowledges = oriKnowledge.map({ (ori) -> Knowledge in
            let knowledge = Knowledge()
            knowledge.title = ori.title
            knowledge.desc = ori.desc
            knowledge.updateTime = ori.updateTime
            return knowledge
        })
        try! cachedDataRealm?.write({
            cachedDataRealm?.add(shareKnowledges, update: true)
        })
        try! shareRealm?.write({
            shareRealm?.delete(oriKnowledge)
        })
        
//        guard let knowledgeBridges = MemoShareDataTool.loadData() else { return }
//        let knowledges = knowledgeBridges.map { return $0.vatting() }
//        let realm = Bootstrap.cachedDataRealm
//        try! realm?.write({
//            realm?.add(knowledges, update: true)
//        })
    }
}