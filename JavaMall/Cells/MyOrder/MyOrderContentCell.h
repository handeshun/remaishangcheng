//
// Created by Dawei on 7/3/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Order;

#define kCellIdentifier_MyOrderContentCell @"MyOrderContentCell"

@interface MyOrderContentCell : UITableViewCell

- (void)configData:(NSString *)content headerLine:(BOOL)showHeaderLine footerLine:(BOOL)showFooterLine;

@end