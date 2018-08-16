//
// Created by Dawei on 5/25/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "BaseApi.h"


@implementation BaseApi {

}

- (NSError *)createError:(NSInteger)code message:(NSString *)message {
    return [NSError errorWithDomain:kBaseUrl code:code userInfo:[NSDictionary dictionaryWithObject:message forKey:NSLocalizedDescriptionKey]];
}

- (NSError *)createError:(NSInteger)code message:(NSString *)message userinfo:(NSDictionary *)userinfo{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
    [dic setObject:message forKey:NSLocalizedDescriptionKey];
    if(userinfo != nil && userinfo.count > 0){
        [dic setDictionary:userinfo];
    }
    return [NSError errorWithDomain:kBaseUrl code:code userInfo:dic];
}

@end