//
// Created by Dawei on 5/30/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "CartEditView.h"
#import "ESButton.h"
#import "ESLabel.h"
#import "ESWhiteButton.h"
#import "ESRedButton.h"
#import "View+MASAdditions.h"


@implementation CartEditView {
    ESButton *checkBtn;
    ESButton *favoriteBtn;
    ESButton *deleteBtn;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder])
        [self setupUI];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame])
        [self setupUI];
    return self;
}

/**
 * 创建UI界面
 */
- (void)setupUI {
    self.backgroundColor = [UIColor colorWithHexString:@"#eaedf2"];
    checkBtn = [[ESButton alloc] initWithTitle:@"全选" color:[UIColor darkGrayColor] fontSize:14];
    [checkBtn setImage:[UIImage imageNamed:@"cart_round_check1.png"] forState:UIControlStateNormal];
    [checkBtn setImage:[UIImage imageNamed:@"cart_round_check2.png"] forState:UIControlStateSelected];
    [checkBtn setImageEdgeInsets:UIEdgeInsetsMake(0.0, -10, 0.0, 0.0)];
    [self addSubview:checkBtn];

    favoriteBtn = [[ESWhiteButton alloc] initWithTitle:@"移入收藏"];
    favoriteBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:favoriteBtn];

    deleteBtn = [[ESRedButton alloc] initWithTitle:@"删除"];
    deleteBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:deleteBtn];

    //开始布局
    [checkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20);
        make.centerY.equalTo(self);
    }];

    [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-10);
        make.centerY.equalTo(self);
        make.width.equalTo(@70);
        make.height.equalTo(@30);
    }];

    [favoriteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(deleteBtn.mas_left).offset(-10);
        make.centerY.height.width.equalTo(deleteBtn);
    }];
}

- (void)setChecked:(BOOL)checked {
    [checkBtn setSelected:checked];
}

- (void)setCheckAction:(SEL)action {
    [checkBtn addTarget:[self viewController] action:action forControlEvents:UIControlEventTouchUpInside];
}

- (void)setFavoriteAction:(SEL)action {
    [favoriteBtn addTarget:[self viewController] action:action forControlEvents:UIControlEventTouchUpInside];
}

- (void)setDeleteAction:(SEL)action {
    [deleteBtn addTarget:[self viewController] action:action forControlEvents:UIControlEventTouchUpInside];
}


@end