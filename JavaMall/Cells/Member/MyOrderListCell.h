//
// Created by Dawei on 6/29/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Order;
@class ESButton;

#define kCellIdentifier_MyOrderListCell @"MyOrderListCell"

@interface MyOrderListCell : UITableViewCell

@property(strong, nonatomic) ESButton *paymentBtn;

@property(strong, nonatomic) ESButton *rogBtn;

@property(strong, nonatomic) ESButton *returnedBtn;

@property (strong, nonatomic) ESButton *cancelBtn;

@property (strong, nonatomic) ESButton *viewReturnedBtn;

@property (strong, nonatomic) ESButton *deliveryBtn;//物流
- (void)configData:(Order *)order;

@end
