//
// Created by Dawei on 6/22/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Receipt;

#define kCellIdentifier_ReceiptContentCell @"ReceiptContentCell"
@interface ReceiptContentCell : UITableViewCell

@property(strong, nonatomic) NSMutableArray *buttons;

- (void)configData:(NSMutableArray *)nameArray receipt:(Receipt *)receipt selectType:(NSInteger)selectType;

+ (CGFloat)cellHeightWithObj:(NSMutableArray *)nameArray;

@end