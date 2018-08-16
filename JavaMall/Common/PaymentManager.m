//
// Created by Dawei on 9/22/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "PaymentManager.h"


@implementation PaymentManager {

}

#pragma mark - LifeCycle
+(instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static PaymentManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[PaymentManager alloc] init];
    });
    return instance;
}

/**
 * 接收微信支付结果
 * @param resp
 */
- (void)onResp:(BaseResp *)resp {
    NSDictionary *userInfo = nil;
    if ([resp isKindOfClass:[PayResp class]]) {
        switch (resp.errCode) {
            case WXSuccess:
                userInfo = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:1], @"result", @"订单支付成功！", @"message", nil];
                break;
            case WXErrCodeCommon:
                userInfo = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:0], @"result", @"用户取消支付！", @"message", nil];
                break;
            default:
                userInfo = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:0], @"result", @"订单支付失败！", @"message", nil];
                break;
        }
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:nPaymentResult
                                                        object:nil
                                                      userInfo:userInfo];
}

/**
 * 处理支付宝支付结果
 * @param status
 */
+ (void)alipayResult:(int)status {
    NSDictionary *userInfo = nil;
    switch (status) {
        case 9000:
            userInfo = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:1], @"result", @"订单支付成功！", @"message", nil];
            break;
        case 8000:
            userInfo = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:2], @"result", @"订单正在处理中！", @"message", nil];
            break;
        case 4000:
            userInfo = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:0], @"result", @"订单支付失败！", @"message", nil];
            break;
        case 6001:
            userInfo = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:0], @"result", @"用户取消支付！", @"message", nil];
            break;
        case 6002:
            userInfo = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:0], @"result", @"网络连接出错，请您重试！", @"message", nil];
            break;
        default:
            break;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:nPaymentResult
                                                        object:nil
                                                      userInfo:userInfo];
}

/**
 * 处理银联支付结果
 * @param code
 * @param data
 */
+ (void)unionpayResult:(NSString *)code data:(NSDictionary *)data {
    NSDictionary *userInfo = nil;
    //结果code为成功时，先校验签名，校验成功后做后续处理
    if ([code isEqualToString:@"success"]) {
        //判断签名数据是否存在
        if (data == nil) {
            userInfo = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:0], @"result", @"订单支付失败！", @"message", nil];
        }else{
            userInfo = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:1], @"result", @"订单支付成功！", @"message", nil];
        }
    } else if ([code isEqualToString:@"fail"]) {
        userInfo = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:0], @"result", @"订单支付失败！", @"message", nil];
    } else if ([code isEqualToString:@"cancel"]) {
        userInfo = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:0], @"result", @"用户取消支付！", @"message", nil];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:nPaymentResult
                                                        object:nil
                                                      userInfo:userInfo];
}

@end