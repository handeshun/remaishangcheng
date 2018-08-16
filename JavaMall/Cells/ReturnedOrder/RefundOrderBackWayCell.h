//
// Created by Dawei on 7/3/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ESTextField;

#define kCellIdentifier_RefundOrderBackWayCell @"RefundOrderBackWayCell"

@interface RefundOrderBackWayCell : UITableViewCell

@property(strong, nonatomic) ESTextField *moneyTf;

/**
 * 设置退款方式
 * @param type
 */
- (void)setType:(NSString *)type :(NSString *)money;

@end