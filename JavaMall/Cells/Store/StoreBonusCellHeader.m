//
// Created by Dawei on 11/5/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "StoreBonusCellHeader.h"
#import "View+MASAdditions.h"


@implementation StoreBonusCellHeader {
    UIView *spaceView;
    UIView *lineView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        spaceView = [UIView new];
        spaceView.backgroundColor = [UIColor colorWithHexString:@"#f3f2f7"];
        [self addSubview:spaceView];
        [spaceView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self);
            make.height.equalTo(@5);
        }];

        lineView = [UIView new];
        lineView.backgroundColor = [UIColor colorWithHexString:kBorderLineColor];
        [self addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(spaceView.mas_bottom);
            make.height.equalTo(@0.5f);
        }];
    }
    return self;
}
@end