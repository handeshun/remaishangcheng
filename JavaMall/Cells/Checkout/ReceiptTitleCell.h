//
// Created by Dawei on 6/22/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Receipt;

#define kCellIdentifier_ReceiptTitleCell @"ReceiptTitleCell"

@interface ReceiptTitleCell : UITableViewCell

@property(strong, nonatomic) NSMutableArray *buttons;

@property(strong, nonatomic) UITextField *companyNameTf;

@property(strong, nonatomic) UITextField *numberTf;

- (void)configData:(Receipt *)receipt :(NSInteger)selectType;

@end