//
// Created by Dawei on 6/28/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ESButton;
@class ESImageButton;
@class Member;

#define kCellIdentifier_PersonOrderCell @"PersonOrderCell"

@interface PersonOrderCell : UITableViewCell

@property(strong, nonatomic) ESImageButton *paymentBtn;

@property(strong, nonatomic) ESImageButton *shippingBtn;

@property(strong, nonatomic) ESImageButton *commentBtn;

@property(strong, nonatomic) ESImageButton *returnedBtn;

- (void)configData:(Member *)member;

@end