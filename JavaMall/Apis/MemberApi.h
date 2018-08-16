//
// Created by Dawei on 5/25/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseApi.h"

@class Member;
@class Goods;

@interface MemberApi : BaseApi

/**
 * 加载登录验证图片
 */
- (void) loadLoginImage:(UIImageView *)imageview;

/**
 * 加载注册验证图片
 */
- (void) loadRegisterImage:(UIImageView *)imageview;

/**
 * 登录
 */
- (void)login:(NSString *)username password:(NSString *)password vcode:(NSString *)vcode success:(void (^)(Member *member))success failure:(void (^)(NSError *error))failure;

/**
 * 是否已经登录
 */
- (void)isLogin:(void (^)(BOOL logined))success failure:(void (^)(NSError *error))failure;

/**
 * 退出登录
 */
- (void)logout:(void (^)())success failure:(void (^)(NSError *error))failure;

/**
 * 获取当前登录用户的详细信息
 */
- (void)info:(void (^)(Member *member))success failure:(void (^)(NSError *error))failure;

/**
 * 打卡
 */
- (void)sign:(void (^)(Member *member))success failure:(void (^)(NSError *error))failure;

/**
 * 修改资料
 */
- (void)saveInfo:(Member *)member success:(void (^)())success failure:(void (^)(NSError *error))failure;

/**
 * 修改密码
 */
- (void)changePassword:(NSString *)oldPass newPass:(NSString *)newPass rePass:(NSString *)rePass success:(void (^)())success failure:(void (^)(NSError *error))failure;


/**
 * 获取积分明细
 */
- (void)pointHistory:(NSInteger)page success:(void (^)(NSMutableArray *pointArray))success failure:(void (^)(NSError *error))failure;

/**
 * 获取秒杀列表
 */
- (void)seckill:(NSString *)keyword page:(NSInteger)page success:(void (^)(NSMutableArray *storeList))success failure:(void (^)(NSError *error))failure;

/**
 * 拼团列表
 */
- (void)pintuan:(NSString *)keyword page:(NSInteger)page success:(void (^)(NSMutableArray *storeList))success failure:(void (^)(NSError *error))failure;
/**
 * 登录
 */
- (void)register:(NSString *)username password:(NSString *)password vcode:(NSString *)vcode success:(void (^)(Member *member))success failure:(void (^)(NSError *error))failure;

/**
 * 发送找回密码的手机验证码
 */
- (void)sendFindCode:(NSString *)mobile success:(void (^)())success failure:(void (^)(NSError *error))failure;

/**
 * 验证手机验证码是否正确
 */
- (void)validMobileCode:(NSString *)mobile mobileCode:(NSString *)mobileCode success:(void (^)())success failure:(void (^)(NSError *error))failure;

/**
 * 手机修改密码
 */
- (void)mobileChangePassword:(NSString *)mobile mobileCode:(NSString *)mobileCode password:(NSString *)password success:(void (^)())success failure:(void (^)(NSError *error))failure;

/**
 * 发送手机注册验证码
 */
- (void)sendRegisterCode:(NSString *)mobile success:(void (^)())success failure:(void (^)(NSError *error))failure;

/**
 * 手机注册
 */
- (void)mobileRegister:(NSString *)mobile mobileCode:(NSString *)mobileCode password:(NSString *)password success:(void (^)(Member *member))success failure:(void (^)(NSError *error))failure;

/**
 * 获取优惠券列表
 * @param page 页码
 * @param type 类型：0为未使用；1为已使用；2为已过期
 * @param success
 * @param failure
 */
- (void)bonus:(NSInteger)page type:(NSInteger)type success:(void (^)(NSMutableArray *bonusArray))success failure:(void (^)(NSError *error))failure;

/**
 * 获取各种优惠券数量
 * @param failure
 * @param failure
 */
- (void)bonusCount:(void (^)(NSInteger unusedCount, NSInteger usedCount, NSInteger expriedCount))success failure:(void (^)(NSError *error))failure;

/**
 *  第三方绑定已有账号 并登陆
 *
 *  @param connectType 第三方类型
 *  @param openid      唯一标识id
 *  @param username    用户名
 *  @param password    密码
 *  @param success     成功回调
 *  @param failure     失败回调
 */
-(void)mLoginBind:(NSString *) connectType openid:(NSString *)openid username:(NSString *)username password:(NSString *)password success:(void (^)(Member *member))success failure:(void (^)(NSError *error))failure;

/**
 *  第三方登录
 *
 *  @param connectType 第三方类型
 *  @param openid      唯一标示id
 *  @param success     成功回调
 *  @param failure     失败回调
 */
-(void)mLogin:(NSString *) connectType openid:(NSString *)openid success:(void (^)(Member *member))success failure:(void (^)(NSError *error))failure;

/**
 *  注册账号 并且绑定第三方账号
 *
 *  @param connectType 第三方类型
 *  @param openid      唯一标识id
 *  @param username    用户名
 *  @param password    密码
 *  @param nikename    第三方昵称
 *  @param face        第三方头像
 *  @param success     成功回调
 *  @param failure     失败回调
 */
-(void)mRegisterBind:(NSString *) connectType openid:(NSString *)openid username:(NSString *)username password:(NSString *)password nikename:(NSString *)nikename face:(NSString *)face success:(void (^)(Member *member))success failure:(void (^)(NSError *error))failure;

@end
