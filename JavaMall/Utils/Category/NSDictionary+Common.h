//
// Created by Dawei on 7/17/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Common)

- (BOOL)has:(NSString *)key;

- (NSString *)stringForKey:(NSString *)key;

- (NSString *)stringForKey:(NSString *)key defaultValue:(NSString *)defaultValue;

- (NSInteger)intForKey:(NSString *)key;

- (double)doubleForKey:(NSString *)key;

- (long long)longlongForKey:(NSString *)key;

@end
