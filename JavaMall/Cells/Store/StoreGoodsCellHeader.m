//
// Created by Dawei on 11/5/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "StoreGoodsCellHeader.h"
#import "View+MASAdditions.h"
#import "ESLabel.h"


@implementation StoreGoodsCellHeader {
    UIView *spaceView;
    UIView *lineView;
}

@synthesize titleLbl;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];

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

        titleLbl = [[ESLabel alloc] initWithText:@"超值单品" textColor:[UIColor darkGrayColor] fontSize:16];
        [self addSubview:titleLbl];
        [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(10);
            make.top.equalTo(lineView.mas_bottom).offset(10);
        }];
    }

    return self;
}



@end