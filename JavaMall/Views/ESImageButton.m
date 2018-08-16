//
// Created by Dawei on 6/28/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "ESImageButton.h"
#import "NSString+Common.h"


@implementation ESImageButton {

}

- (instancetype)initWithTitle:(NSString *)title image:(UIImage *)image fontSize:(NSInteger)fontSize{
    self = [super init];
    if (self) {
        CGFloat titleWidth = [title getSizeWithFont:[UIFont systemFontOfSize:fontSize]].width;
        [self setImage:image forState:UIControlStateNormal];
        [self setTitle:title forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:fontSize];
        [self setTitleEdgeInsets:UIEdgeInsetsMake(image.size.height + 5, -image.size.width, 0, 0)];
        [self setImageEdgeInsets:UIEdgeInsetsMake(-15, 0, 0, -titleWidth)];
    }
    return self;
}

@end