//
// Created by Dawei on 5/30/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "ESWhiteButton.h"
#import "UIButton+Common.h"
#import "UIView+Common.h"


@implementation ESWhiteButton {

}

- (instancetype)initWithTitle:(NSString *)title{
    self = [super init];
    if (self) {
        [self setTitle:title forState:UIControlStateNormal];
        [self setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
        [self setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];

        [self setBackgroundColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self setBackgroundColor:[UIColor grayColor] forState:UIControlStateSelected];
        [self setBackgroundColor:[UIColor whiteColor] forState:UIControlStateDisabled];

        [self borderWidth:0.5f color:[UIColor colorWithHexString:@"#d0d1d5"] cornerRadius:5];

    }
    return self;
}

@end