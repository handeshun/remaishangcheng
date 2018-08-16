//
// Created by Dawei on 11/7/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ESButton;
@class Bonus;

#define kCellIdentifier_MyBonusCell @"MyBonusCell"

@interface MyBonusCell : UITableViewCell

@property(strong, nonatomic) ESButton *useBtn;

- (void)configData:(Bonus *)bonus;

@end