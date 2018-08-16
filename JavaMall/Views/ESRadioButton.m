//
// Created by Dawei on 6/22/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "ESRadioButton.h"


@implementation ESRadioButton {

}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:@"cart_round_check1.png"] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:@"cart_round_check2.png"] forState:UIControlStateSelected];
        self.backgroundColor = [UIColor whiteColor];
        self.titleLabel.font = [UIFont systemFontOfSize:13];
        self.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    [self setTitle:title forState:UIControlStateNormal];
}

@end