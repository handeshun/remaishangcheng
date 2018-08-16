//
// Created by Dawei on 6/28/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Member;
@class ESButton;

#define kCellIdentifier_PersonLoginCell @"PersonLoginCell"

@interface PersonLoginCell : UITableViewCell

@property(strong, nonatomic) ESButton *loginBtn;

@property(strong, nonatomic) ESButton *faceBtn;

@property(strong, nonatomic) ESButton *favoriteBtn;

@property(strong, nonatomic) ESButton *favoriteStoreBtn;

@property(strong, nonatomic) ESButton *pointBtn;

@property(strong, nonatomic) ESButton *mpBtn;

@property(strong, nonatomic) ESButton *signBtn;

- (void)configData:(Member *)member;

@end
