//
// Created by Dawei on 7/17/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "NSDictionary+Common.h"


@implementation NSDictionary (Common)

- (BOOL)has:(NSString *)key {
    if([self objectForKey:key] == nil || [[self objectForKey:key] isKindOfClass:[NSNull class]]){
        return NO;
    }
    return YES;
}

- (NSString *)stringForKey:(NSString *)key {
    return [self stringForKey:key defaultValue:@""];
}

- (NSString *)stringForKey:(NSString *)key defaultValue:(NSString *)defaultValue {
    if(![self has:key]){
        return defaultValue;
    }
    return [self objectForKey:key];
}

- (NSInteger)intForKey:(NSString *)key {
    if(![self has:key])
        return 0;
    return [[self objectForKey:key] intValue];
}

- (double)doubleForKey:(NSString *)key {
    if(![self has:key])
        return 0.0;
    return [[self objectForKey:key] doubleValue];
}

- (long long)longlongForKey:(NSString *)key {
    if(![self has:key])
        return 0;
    return [[self objectForKey:key] doubleValue];
}

@end
