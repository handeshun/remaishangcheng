//
// Created by Dawei on 6/29/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ReturnedOrder;
@class ESButton;


#define kCellIdentifier_MyReturnedOrderListTitleCell @"MyReturnedOrderListTitleCell"

@interface MyReturnedOrderListTitleCell : UITableViewCell

@property (strong, nonatomic) ESButton *detailBtn;

- (void)configData:(ReturnedOrder *)returnedOrder;

@end