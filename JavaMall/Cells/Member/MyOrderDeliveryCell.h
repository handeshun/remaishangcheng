//
// Created by Dawei on 9/23/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Delivery;

#define kCellIdentifier_MyOrderDeliveryCell @"MyOrderDeliveryCell"

@interface MyOrderDeliveryCell : UITableViewCell

+ (CGFloat)cellHeightWithObj:(Delivery *)delivery;

- (void)configData:(Delivery *)delivery;

@end