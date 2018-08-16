//
// Created by Dawei on 6/22/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Bonus;
@class ESRadioButton;

#define kCellIdentifier_BonusCell @"BonusCell"
@interface BonusCell : UITableViewCell

@property (strong, nonatomic) ESRadioButton *radioBtn;

- (void)configData:(Bonus *)bonus;

+ (CGFloat)cellHeightWithObj:(Bonus *)bonus;

@end