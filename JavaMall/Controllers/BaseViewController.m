//
//  BaseViewController.m
//  JavaMall
//
//  Created by Dawei on 6/17/15.
//  Copyright (c) 2015 Enation. All rights reserved.
//

#import "BaseViewController.h"
#import "RootTabViewController.h"
#import "MBProgressHUD.h"
#import "Masonry.h"
#import "EMClient.h"

@implementation BaseViewController

- (UIView *)createErrorView:(NSString *)errorText {
    UIView *errorView = [UIView new];
    UIImageView *errorImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"load_failure"]];
    [errorView addSubview:errorImage];
    [errorImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(errorView.mas_centerY);
        make.centerX.equalTo(errorView.mas_centerX);
    }];

    UILabel *errorLabel = [UILabel new];
    [errorLabel setText:errorText];
    [errorLabel setTextColor:[UIColor darkGrayColor]];
    [errorLabel setFont:[UIFont systemFontOfSize:14]];
    [errorView addSubview:errorText];
  
    [errorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(errorView.mas_centerX);
        make.top.equalTo(errorImage.mas_bottom).with.offset(10);
    }];
    return errorView;
}

/**
 * 登录IM软件
 * @param imUser
 * @param imPass
 */
- (void)loginIM:(NSString *)imUser pass:(NSString *)imPass {
//    if ([EASEMOB_APP_KEY isEqualToString:@""]) {
//        return;
//    }
//    if (imUser == nil || imUser.length == 0) {
//        return;
//    }
//    //异步登陆账号
//    BOOL isAutoLogin = [EMClient sharedClient].options.isAutoLogin;
//    if (!isAutoLogin) {
//        __weak typeof(self) weakself = self;
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            EMError *error = [[EMClient sharedClient] loginWithUsername:imUser password:imPass];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                if (!error) {
//                    //设置是否自动登录
//                    [[EMClient sharedClient].options setIsAutoLogin:YES];
//                    NSLog(@"登录成功！");
//                } else {
//                    NSLog(@"登录失败!");
//                }
//            });
//        });
//    }
}

@end
