//
//  RNInterface.h
//  Memo
//
//  Created by XuAzen on 16/9/17.
//  Copyright © 2016年 azen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RCTBridgeModule.h"   //  RCTBridgeModule协议在这里
#import "RCTBridge.h"         //  向RN发事件的
#import "RCTEventDispatcher.h"  //  也是向RN发事件的

@interface RNInterface : NSObject<RCTBridgeModule>

@end
