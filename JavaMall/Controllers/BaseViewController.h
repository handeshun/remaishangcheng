//
//  BaseViewController.h
//  JavaMall
//
//  Created by Dawei on 6/17/15.
//  Copyright (c) 2015 Enation. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

/**
 * 创建一个错误信息视图
 */
- (UIView *) createErrorView:(NSString *) errorText;

/**
 * 登录环信IM软件
 * @param imUser
 * @param imPass
 */
- (void)loginIM:(NSString *)imUser pass:(NSString *)imPass;


@end
