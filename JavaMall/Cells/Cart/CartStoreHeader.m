//
// Created by Dawei on 11/1/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Masonry/View+MASAdditions.h>
#import "CartStoreHeader.h"
#import "Store.h"
#import "ESButton.h"
#import "ESLabel.h"


@implementation CartStoreHeader {
    UIView *line;
    UIView *headerView;

    UIImageView *iconIv;
    UIImageView *goToStoreIv;
    ESLabel *storeNameLbl;

}

@synthesize selectBtn, activityBtn;
@synthesize isEditing;

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

- (void)setupUI {
    self.backgroundColor = [UIColor whiteColor];

    headerView = [UIView new];
    headerView.backgroundColor = [UIColor colorWithHexString:@"#f1f2f6"];
    [self addSubview:headerView];
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.height.equalTo(@10);
    }];

    line = [UIView new];
    line.backgroundColor = [UIColor colorWithHexString:kBorderLineColor];
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(headerView.mas_bottom);
        make.height.equalTo(@0.5f);
    }];

    activityBtn = [ESButton new];
    [activityBtn setImage:[UIImage imageNamed:@"activity.png"] forState:UIControlStateNormal];
    [activityBtn setImage:[UIImage imageNamed:@"activity.png"] forState:UIControlStateSelected];
    [activityBtn setHidden:YES];
    [self addSubview:activityBtn];
    [activityBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView.mas_bottom).offset(11);
        make.right.equalTo(self).offset(-10);
        make.width.equalTo(@45);
        make.height.equalTo(@20);
    }];

    selectBtn = [ESButton new];
    [selectBtn setBackgroundImage:[UIImage imageNamed:@"cart_round_check1.png"] forState:UIControlStateNormal];
    [selectBtn setBackgroundImage:[UIImage imageNamed:@"cart_round_check2.png"] forState:UIControlStateSelected];
    [self addSubview:selectBtn];
    [selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView.mas_bottom).offset(11);
        make.left.equalTo(self).offset(10);
        make.width.height.equalTo(@18);
    }];

    iconIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"store.png"]];
    [self addSubview:iconIv];
    [iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(selectBtn.mas_right).offset(15);
        make.top.equalTo(headerView.mas_bottom).offset(10);
        make.width.height.equalTo(@20);
    }];

    storeNameLbl = [[ESLabel alloc] initWithText:@"" textColor:[UIColor blackColor] fontSize:14];
    [self addSubview:storeNameLbl];
    [storeNameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView.mas_bottom).offset(12);
        make.left.equalTo(iconIv.mas_right).offset(5);
    }];

    goToStoreIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gotostore.png"]];
    [self addSubview:goToStoreIv];
    [goToStoreIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(storeNameLbl.mas_right).offset(5);
        make.top.equalTo(headerView.mas_bottom).offset(15);
        make.width.height.equalTo(@10);
    }];

}

- (void)configData:(Store *)store section:(NSInteger)section{
    storeNameLbl.text = store.name;
    if(isEditing) {
        [selectBtn setSelected:store.selected];
    }else{
        [selectBtn setSelected:store.checked];
    }
    selectBtn.tag = section;
    activityBtn.tag = section;
    [activityBtn setHidden:!(store.activity_id > 0)];
}

@end