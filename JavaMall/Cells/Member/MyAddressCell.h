//
// Created by Dawei on 7/14/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Address;
@class ESButton;
@class ESRadioButton;

#define kCellIdentifier_MyAddressCell @"MyAddressCell"

@interface MyAddressCell : UITableViewCell

@property(strong, nonatomic) ESButton *editBtn;

@property(strong, nonatomic) ESButton *deleteBtn;

@property(strong, nonatomic) ESRadioButton *defaultBtn;

- (void)configData:(Address *)address;

@end