//
// Created by Dawei on 6/21/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "ESCheckButton.h"
#import "UIView+Common.h"


@implementation ESCheckButton {

}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [self setImage:[UIImage imageNamed:@"radio_select.png"] forState:UIControlStateSelected];
        self.backgroundColor = [UIColor whiteColor];
        self.titleLabel.font = [UIFont systemFontOfSize:13];
        [self borderWidth:0.5f color:[UIColor colorWithHexString:kBorderLineColor] cornerRadius:3.0f];
    }
    return self;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    self.layer.borderColor = selected ? [[UIColor redColor] CGColor] : [[UIColor colorWithHexString:kBorderLineColor] CGColor];
}

- (void)setTitle:(NSString *)title {
    [self setTitle:title forState:UIControlStateNormal];
}

@end