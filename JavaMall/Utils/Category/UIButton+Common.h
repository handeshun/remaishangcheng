//
// Created by Dawei on 5/11/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIButton (Common)

- (instancetype)initWithTitle:(NSString *)title color:(UIColor *)color fontSize:(NSInteger)fontSize;

- (void)setBackgroundColor:(UIColor *)color forState:(UIControlState)state;

@end