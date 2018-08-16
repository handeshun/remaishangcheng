//
// Created by Dawei on 10/19/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DesUtils : NSObject

/**
 * 加密
 * @param plainText
 * @return
 */
+ (NSString*)encrypt:(NSString*)plainText;

/**
 * 解密
 * @param encryptText
 * @return
 */
+ (NSString*)decrypt:(NSString*)encryptText;


@end