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
    
}