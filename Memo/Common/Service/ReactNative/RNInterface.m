//
//  RNInterface.m
//  Memo
//
//  Created by XuAzen on 16/9/17.
//  Copyright © 2016年 azen. All rights reserved.
//

#import "RNInterface.h"

@interface RNInterface()

@end

@implementation RNInterface
- (instancetype)init {
    return self;
}

@synthesize bridge = _bridge;

/*
 *  这个宏用来指定，JS访问这个模块时的名字。括号中传空表示使用类名
 */
RCT_EXPORT_MODULE();

/**
 *  这个宏用来声明定义了一个可以提供给RN组件调用的方法
 *  msg: RN调用时携带的参数
 */
RCT_EXPORT_METHOD(sendMessage:(NSString *)msg)
{
    NSLog(@"收到的来自RN的消息：%@",msg);
    //  检测是否为JSON数据
    NSData *data = [msg dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    if (error) {
        NSLog(@"解析错误：%@", error);
    }
    
    //通过和RN约定的字符串调起相应功能
    NSString *login = [dic objectForKey:@"msgType"];
    if ([login isEqualToString:@"callKnowledgeList"]) {
        [self _callKnowledgeList];
    }
}

- (void)_callKnowledgeList {
    NSLog(@"调起knowledgeList");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Memo_ChangeRootViewControllerToNative" object:nil];
}


- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}

@end
