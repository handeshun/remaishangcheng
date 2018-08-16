//
// Created by Dawei on 1/5/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "StoreListHeaderView.h"
#import "Masonry.h"


@implementation StoreListHeaderView {
    UIButton *backBtn;
    UIView *searchView;
}

@synthesize titleLbl;

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setFrame:CGRectMake(0, 0, kScreen_Width, 60)];
        [self createUI];
    }
    return self;
}

/**
 * 创建界面
 */
- (void)createUI{
    self.backgroundColor = [UIColor colorWithHexString:@"#FAFAFA"];

    //后退按钮
    backBtn = [UIButton new];
    [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backBtn setContentMode:UIViewContentModeCenter];
    [self addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(-5);
        make.top.equalTo(self).with.offset(21);
        make.size.mas_equalTo(CGSizeMake(64,40));
    }];

    //搜索框
    searchView = [UIView new];
    searchView.backgroundColor = [UIColor whiteColor];
    searchView.layer.borderColor = [UIColor colorWithHexString:@"#dbdbdb"].CGColor;
    searchView.layer.borderWidth = 0.5;
    searchView.layer.masksToBounds = YES;
    searchView.layer.cornerRadius = 3.0;
    [self addSubview:searchView];
    [searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(25);
        make.left.equalTo(backBtn.mas_right).offset(-25);
        make.bottom.equalTo(self.mas_bottom).with.offset(-5);
        make.right.equalTo(self.mas_right).with.offset(-5);
    }];

    //搜索框图标
    UIImageView *searchIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"searchbar_search"]];
    [searchView addSubview:searchIcon];
    [searchIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(searchView);
        make.left.equalTo(searchView.mas_left).with.offset(8);
    }];

    //搜索框提示文字
    titleLbl = [UILabel new];
    [titleLbl setText:@"搜索商品/店铺"];
    [titleLbl setTextColor:[UIColor colorWithHexString:@"#848689"]];
    [titleLbl setFont:[UIFont systemFontOfSize:12]];
    [searchView addSubview:titleLbl];
    [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(searchView);
        make.left.equalTo(searchIcon.mas_right).offset(5);
    }];

    //添加下划线
    float lineHeight = 0.5f;
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(0, self.frame.size.height - lineHeight, self.frame.size.width, lineHeight);
    layer.backgroundColor = [UIColor colorWithHexString:@"#cdcdcd"].CGColor;
    [self.layer addSublayer:layer];
}

/**
 * 设置搜索事件
 */
- (void)setSearchAction:(SEL)action {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:[self viewController] action:action];
    [tapGesture setNumberOfTapsRequired:1];
    [searchView addGestureRecognizer:tapGesture];
}

/**
 * 设置后退事件
 */
- (void) setBackAction:(SEL)action{
    [backBtn addTarget:[self viewController] action:action forControlEvents:UIControlEventTouchUpInside];
}

@end