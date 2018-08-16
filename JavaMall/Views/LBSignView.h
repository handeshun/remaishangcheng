//
//  LBSignView.h
//  JavaMall
//
//  Created by Guo Hero on 2017/11/25.
//  Copyright © 2017年 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseView.h"

@class ESButton;

@interface LBSignView : BaseView

/**
 * 设置取消事件
 */
- (void)setCancerAction:(SEL)action;

/**
 * 设置打卡事件
 */
- (void)setSignAction:(SEL)action;

@end
