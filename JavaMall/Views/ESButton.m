//
// Created by Dawei on 1/30/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "ESButton.h"

@implementation ESButton {

}

- (instancetype)initWithTitle:(NSString *)title color:(UIColor *)color fontSize:(NSInteger)fontSize{
    self = [super init];
    if (self) {
        [self setTitle:title forState:UIControlStateNormal];
        [self setTitleColor:color forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    }
    return self;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    CGRect bounds = self.bounds;
    if(bounds.size.width < 44 && bounds.size.height < 44) {
        CGFloat widthDelta = 44.0 - bounds.size.width;
        CGFloat heightDelta = 44.0 - bounds.size.height;
        bounds = CGRectInset(bounds, -0.5 * widthDelta, -0.5 * heightDelta);    //注意这里是负数，扩大了之前的bounds的范围
        return CGRectContainsPoint(bounds, point);
    }
    return CGRectContainsPoint(bounds, point);
}

- (void)setTitle:(NSString *)title {
    _title = title;
    [self setTitle:title forState:UIControlStateNormal];
}

- (void)setColor:(UIColor *)color {
    _color = color;
    [self setTitleColor:color forState:UIControlStateNormal];
}

- (void)setSelectedColor:(UIColor *)selectedColor {
    _selectedColor = selectedColor;
    [self setTitleColor:selectedColor forState:UIControlStateSelected];
}

- (void)setFontSize:(NSInteger)fontSize {
    _fontSize = fontSize;
    self.titleLabel.font = [UIFont systemFontOfSize:fontSize];
}


@end