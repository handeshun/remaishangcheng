//
// Created by Dawei on 11/1/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Store;
@class ESButton;


@interface CartStoreHeader : UIControl

//是否处于编辑模式
@property(assign, nonatomic) BOOL isEditing;

@property(strong, nonatomic) ESButton *selectBtn;

@property (strong, nonatomic) ESButton *activityBtn;

- (void)configData:(Store *)store section:(NSInteger)section;

@end