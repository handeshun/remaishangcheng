//
//  Constants.h
//  JavaMall
//
//  Created by Dawei on 7/7/15.
//  Copyright (c) 2015 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Member;
@class Setting;

@interface Constants : NSObject

/**
 * 设置登录的会员信息
 */
+ (void)setMember:(Member *)member;

/**
 * 获取当前登录的会员信息
 */
+ (Member *)currentMember;

/**
 * 设置系统设置参数
 * @param setting
 */
+ (void)setSetting:(Setting *)setting;

/**
 * 获取当前设置
 * @return
 */
+ (Setting *)setting;

/**
 * 是否已经登录
 */
+ (BOOL)isLogin;


+ (void)setAction:(NSString *)toAction;

+ (NSString *)action;

/**
 * 是否显示客服
 * @return
 */
+ (BOOL)showIM;

@end
