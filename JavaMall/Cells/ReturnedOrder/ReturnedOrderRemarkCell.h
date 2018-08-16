//
// Created by Dawei on 7/3/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ESTextView;

#define kCellIdentifier_ReturnedOrderRemarkCell @"ReturnedOrderRemarkCell"

@interface ReturnedOrderRemarkCell : UITableViewCell

@property(strong, nonatomic) ESTextView *remarkTV;

@end