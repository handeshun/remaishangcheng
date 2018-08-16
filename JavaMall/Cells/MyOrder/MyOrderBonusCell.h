//
// Created by Dawei on 7/3/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Bonus;

#define kCellIdentifier_MyOrderBonusCell @"MyOrderBonusCell"

@interface MyOrderBonusCell : UITableViewCell

- (void)configData:(Bonus *)bonus;

@end