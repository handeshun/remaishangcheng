//
// Created by Dawei on 1/5/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "CategoryHeaderView.h"
#import <Masonry.h>


@implementation CategoryHeaderView {
    UIView *searchView;
}

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
        make.left.equalTo(self.mas_left).with.offset(5);
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
    UILabel *searchTitle = [UILabel new];
    [searchTitle setText:@"搜索商品/店铺"];
    [searchTitle setTextColor:[UIColor colorWithHexString:@"#848689"]];
    [searchTitle setFont:[UIFont systemFontOfSize:12]];
    [searchView addSubview:searchTitle];
    [searchTitle mas_makeConstraints:^(MASConstraintMaker *make) {
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

@end