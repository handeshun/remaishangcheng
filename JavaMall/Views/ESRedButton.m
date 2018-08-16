//
// Created by Dawei on 5/14/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "ESRedButton.h"
#import "UIButton+Common.h"
#import "UIView+Common.h"


@implementation ESRedButton {

}

- (instancetype)initWithTitle:(NSString *)title{
    self = [super init];
    if (self) {
        [self setTitle:title forState:UIControlStateNormal];
        [self setTitleColor:[UIColor colorWithHexString:@"#b3b3b3"] forState:UIControlStateDisabled];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];

        UIImage *normalImage = [UIImage imageNamed:@"red_btn_normal.png"];
        normalImage = [normalImage resizableImageWithCapInsets:UIEdgeInsetsMake(normalImage.size.height*0.5,
                normalImage.size.width*0.5, normalImage.size.height*0.5,
                normalImage.size.width*0.5)resizingMode:UIImageResizingModeStretch];
        [self setBackgroundImage:normalImage forState:UIControlStateNormal];

        UIImage *selectedImage = [UIImage imageNamed:@"red_btn_selected.png"];
        selectedImage = [selectedImage resizableImageWithCapInsets:UIEdgeInsetsMake(selectedImage.size.height*0.5,
                selectedImage.size.width*0.5, selectedImage.size.height*0.5,
                selectedImage.size.width*0.5)resizingMode:UIImageResizingModeStretch];
        [self setBackgroundImage:selectedImage forState:UIControlStateSelected];

        UIImage *disabledImage = [UIImage imageNamed:@"red_btn_disabled.png"];
        disabledImage = [disabledImage resizableImageWithCapInsets:UIEdgeInsetsMake(disabledImage.size.height*0.5,
                disabledImage.size.width*0.5, disabledImage.size.height*0.5,
                disabledImage.size.width*0.5)resizingMode:UIImageResizingModeStretch];
        [self setBackgroundImage:disabledImage forState:UIControlStateDisabled];

    }
    return self;
}
@end