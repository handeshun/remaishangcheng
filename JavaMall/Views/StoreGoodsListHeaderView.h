//
// Created by Dawei on 3/18/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseView.h"

@protocol MaskDelegate;
@protocol SearchDelegate;

typedef enum {
    List,
    Grid
} ListStyle;

@interface StoreGoodsListHeaderView : BaseView <UITextFieldDelegate>

- (instancetype)initWithFrame:(CGRect)frame;

- (void)setBackAction:(SEL)action;

- (IBAction)cancel;

@property(strong, nonatomic) id <MaskDelegate> maskDelegate;

@property(strong, nonatomic) id <SearchDelegate> searchDelegate;

@end