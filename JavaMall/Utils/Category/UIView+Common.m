//
// Created by Dawei on 10/21/15.
// Copyright (c) 2015 Enation. All rights reserved.
//

#import "UIView+Common.h"


@implementation UIView (Common)

- (void)circleFrame {
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = self.frame.size.width/2;
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = [UIColor colorWithHexString:@"0xdddddd"].CGColor;
}

- (void)borderWidth:(CGFloat)width color:(UIColor *)color cornerRadius:(CGFloat)cornerRadius {
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = cornerRadius;
    self.layer.borderWidth = width;
    if (!color) {
        self.layer.borderColor = [UIColor colorWithHexString:@"0xdddddd"].CGColor;
    }else{
        self.layer.borderColor = color.CGColor;
    }
}

- (void) bottomBorder:(UIColor *)color{
    [self bottomBorder:color size:self.frame.size];
}

- (void) bottomBorder:(UIColor *)color size:(CGSize) size{
    float lineHeight = 0.5f;
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(0, size.height - lineHeight, size.width, lineHeight);
    layer.backgroundColor = color.CGColor;
    [self.layer addSublayer:layer];
}

- (void) topBorder:(UIColor *)color{
    [self topBorder:color size:self.frame.size];
}

- (void) topBorder:(UIColor *)color size:(CGSize) size{
    float lineHeight = 0.5f;
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(0, 0, size.width, lineHeight);
    layer.backgroundColor = color.CGColor;
    [self.layer addSublayer:layer];
}

- (void)setY:(CGFloat)y{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (void)setX:(CGFloat)x{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (void)setOrigin:(CGPoint)origin{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (void)setHeight:(CGFloat)height{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (void)setWidth:(CGFloat)width{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (void)setSize:(CGSize)size{
    CGRect frame = self.frame;
    frame.size.width = size.width;
    frame.size.height = size.height;
    self.frame = frame;
}


@end