//
// Created by Dawei on 5/25/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    ESParameterError = 0,
    ESConnectError = 1,
    ESDataError = 2,
    ESLogicError = 3
} CustomerErrorFailed;

#define CODE_KEY @"result"
#define MESSAGE_KEY @"message"
#define DATA_KEY @"data"

@interface BaseApi : NSObject{

}

/**
 * 创建一条错误信息
 */
- (NSError *)createError:(NSInteger)code message:(NSString *)message;

/**
 * 创建一条错误信息
 */
- (NSError *)createError:(NSInteger)code message:(NSString *)message userinfo:(NSDictionary *)userinfo;

@end