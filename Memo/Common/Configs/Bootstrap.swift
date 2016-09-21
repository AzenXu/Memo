//
//  Bootstrap.swift
//  Memo
//
//  Created by XuAzen on 16/9/16.
//  Copyright © 2016年 azen. All rights reserved.
//

import Foundation
import RealmSwift


let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

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
}

public extension Bootstrap {
    public static func dealDatas() {
        /*
            due to uncaught exception 'NSInvalidUnarchiveOperationException', reason: '*** -[NSKeyedUnarchiver decodeObjectForKey:]: cannot decode object of class (ShareExtension.KnowledgeBridge) for key (NS.objects); the class may be defined in source code or a library that is not linked'
        */
        guard let knowledgeBridges = MemoShareDataTool.loadData() else { return }
        let knowledges = knowledgeBridges.map { return $0.vatting() }
        let realm = Bootstrap.cachedDataRealm
        try! realm?.write({
            realm?.add(knowledges, update: true)
        })
    }
}