//
// Created by Dawei on 11/5/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "StoreGoodsCellFooter.h"
#import "View+MASAdditions.h"


@implementation StoreGoodsCellFooter {
    UIView *lineView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {

        lineView = [UIView new];
        lineView.backgroundColor = [UIColor colorWithHexString:kBorderLineColor];
        [self addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.height.equalTo(@0.5f);
        }];
    }
    return self;
}
@end