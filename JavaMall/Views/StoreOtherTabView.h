//
// Created by Dawei on 11/3/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseView.h"


@interface StoreOtherTabView : BaseView

- (instancetype)initWithFrame:(CGRect)frame andTitle:(NSString *)title;

- (void)setSelected:(BOOL)selected;

- (void)setCount:(NSString *)count;

@end