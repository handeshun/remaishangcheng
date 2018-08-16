//
// Created by Dawei on 5/11/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "UIButton+Common.h"


@implementation UIButton (Common)

- (instancetype)initWithTitle:(NSString *)title color:(UIColor *)color fontSize:(NSInteger)fontSize{
    self = [super init];
    if (self) {
        [self setTitle:title forState:UIControlStateNormal];
        [self setTitleColor:color forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    }
    return self;
}

- (void)setBackgroundColor:(UIColor *)color forState:(UIControlState)state
{
    [self setBackgroundImage:[self imageWithColor:color] forState:state];
}

- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
}

@end