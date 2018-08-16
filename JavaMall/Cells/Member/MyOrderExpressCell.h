//
// Created by Dawei on 9/23/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Express;

#define kCellIdentifier_MyOrderExpressCell @"MyOrderExpressCell"

@interface MyOrderExpressCell : UITableViewCell

+ (CGFloat)cellHeightWithObj:(Express *)express;

- (void)configData:(Express *)express row:(NSInteger)row;

@end