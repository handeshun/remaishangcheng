//
// Created by Dawei on 1/30/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ESButton : UIButton

- (instancetype)initWithTitle:(NSString *)title color:(UIColor *)color fontSize:(NSInteger)fontSize;

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) UIColor *color;
@property (strong, nonatomic) UIColor *selectedColor;
@property (assign, nonatomic) NSInteger fontSize;

@end