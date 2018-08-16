//
// Created by Dawei on 7/3/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ActivityGift;

#define kCellIdentifier_MyOrderGiftCell @"MyOrderGiftCell"

@interface MyOrderGiftCell : UITableViewCell

- (void)configData:(ActivityGift *)gift;

@end