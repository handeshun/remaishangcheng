//
// Created by Dawei on 11/10/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kCellIdentifier_GoodsBonusCell @"GoodsBonusCell"

@interface GoodsBonusCell : UITableViewCell

+ (CGFloat)cellHeightWithObj:(NSMutableArray *)bonusList;

- (void)configData:(NSMutableArray *)bonusList;

@end