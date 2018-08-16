//
// Created by Dawei on 6/19/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Address;
@class ESButton;
#define kCellIdentifier_SelectAddressCell @"SelectAddressCell"

@interface SelectAddressCell : UITableViewCell

@property (strong, nonatomic) ESButton *editBtn;

- (void)configData:(Address *)address index:(NSInteger)row;

@end