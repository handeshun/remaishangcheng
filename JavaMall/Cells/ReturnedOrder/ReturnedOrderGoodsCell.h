//
// Created by Dawei on 7/3/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OrderItem;
@class ESRadioButton;
@protocol NumberChangedDelegate;

#define kCellIdentifier_ReturnedOrderGoodsCell @"ReturnedOrderGoodsCell"
@interface ReturnedOrderGoodsCell : UITableViewCell

-(void)configData:(OrderItem *)orderItem index:(NSInteger)index;

@property(assign, nonatomic) NSInteger value;

@property (strong, nonatomic) ESRadioButton *selectBtn;

@property(nonatomic, strong) NSObject<NumberChangedDelegate> *delegate;

@end