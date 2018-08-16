//
//  AppDelegate.m
//  JavaMall
//
//  Created by Dawei on 5/30/15.
//  Copyright (c) 2015 Enation. All rights reserved.
//

#import "AppDelegate.h"
#import <AlipaySDK/AlipaySDK.h>
#import <UMSocialCore/UMSocialCore.h>
#import "UPPaymentControl.h"
#import "AFNetworkReachabilityManager.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "RootTabViewController.h"
#import "BaseNavigationController.h"
#import "EaseSDKHelper.h"
#import "PaymentManager.h"
#import "DesUtils.h"
#import "ControllerHelper.h"
#import "Goods.h"
#import "StoreViewController.h"
#import "StoreGoodsListViewController.h"
#import "StoreCategoryViewController.h"
#import "MyBonusViewController.h"
#import "StoreListViewController.h"
#import "AdViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {


    [NSThread sleepForTimeInterval:4];
    //网络
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    if (AD_ENABLE) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        AdViewController *ad = [[AdViewController alloc]init];
        ad.window = self.window;
        [self.window setRootViewController:[storyboard instantiateViewControllerWithIdentifier:@"Ad"]];
    } else {
        RootTabViewController *rootTabViewController = [[RootTabViewController alloc] init];
        UINavigationController *navigationController = [[BaseNavigationController alloc] initWithRootViewController:rootTabViewController];
        [self.window setRootViewController:navigationController];

//        StoreListViewController *storeListViewController = [StoreListViewController new];
//        [self.window setRootViewController:storeListViewController];
    }

    //向微信注册
    if (![WECHAT_APP_ID isEqualToString:@""]) {
        [WXApi registerApp:WECHAT_APP_ID];
    }

    //注册友盟
    [[UMSocialManager defaultManager] setUmSocialAppkey:UM_APP_KEY];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:WECHAT_APP_ID appSecret:WECHAT_APP_SECRET redirectURL:kBaseUrl];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:QQ_ID/*设置QQ平台的appID*/  appSecret:nil redirectURL:kBaseUrl];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:SINA_KEY  appSecret:SINA_SECRET redirectURL:AUTH_URL];
    [[UMSocialManager defaultManager]openLog:YES];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationDidBecomeActiveNotification
                                                  object:nil];
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    if (![WECHAT_APP_ID isEqualToString:@""] && [[url description] containsString:WECHAT_APP_ID]) {
        return [WXApi handleOpenURL:url delegate:self];
    }
    return YES;
}


- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if(!result) {
        result = [self handleUrl:url];
    }
    return result;
}

/**
 * 处理支付url
 * @param url
 * @return
 */
- (BOOL)handleUrl:(NSURL *)url {
    //跳转支付宝钱包进行支付，处理支付结果
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            int resultStatus = [[resultDic objectForKey:@"resultStatus"] intValue];
            [PaymentManager alipayResult:resultStatus];
        }];
    } else if (![WECHAT_APP_ID isEqualToString:@""] && [[url description] containsString:WECHAT_APP_ID]) {
        return [WXApi handleOpenURL:url delegate:[PaymentManager sharedManager]];
    } else if ([url.host containsString:@"uppayresult"]) {
        [[UPPaymentControl defaultControl] handlePaymentResult:url completeBlock:^(NSString *code, NSDictionary *data) {
            [PaymentManager unionpayResult:code data:data];
        }];
    }
    return YES;
}

@end
