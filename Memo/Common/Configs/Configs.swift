//
//  Configs.swift
//  Memo
//
//  Created by XuAzen on 16/9/15.
//  Copyright © 2016年 azen. All rights reserved.
//

import Foundation

public struct MemoConfig {
    
    public struct Settings {
        public static var netEnvType: NetEnvModel {
            return .Develop
        }
    }
    
    public enum NetEnvModel {
        case Develop
        case Online
    }
}

public enum MemoNofity: String {
    case Memo_ChangeRootViewControllerToNative
}