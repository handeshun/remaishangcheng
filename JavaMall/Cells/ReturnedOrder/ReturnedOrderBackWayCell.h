//
// Created by Dawei on 7/3/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ESTextField;

#define kCellIdentifier_ReturnedOrderBackWayCell @"ReturnedOrderBackWayCell"

@interface ReturnedOrderBackWayCell : UITableViewCell

@property(strong, nonatomic) NSString *refundWay;

@property (strong, nonatomic) ESTextField *moneyTf;

-(void)selectType:(NSString *)backWay;
@end