//
// Created by Dawei on 3/18/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "GoodsListHeaderView.h"
#import "Masonry.h"

@implementation GoodsListHeaderView {
    UIButton *backBtn;
    UIButton *styleBtn;
    ListStyle listStyle;
    UIView *searchView;

    UILabel *searchTitle;

    GoodsListHeaderStyleBlock styleBlock;
}

- (instancetype) initWithFrame:(CGRect) frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setFrame:frame];
        [self createUI];
    }
    return self;
}


- (void) createUI{
    self.backgroundColor = [UIColor colorWithHexString:kHeaderBackgroundColor];

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

    //切换样式按钮
    styleBtn = [UIButton new];
    [styleBtn setImage:[UIImage imageNamed:@"product_list_grid"] forState:UIControlStateNormal];
    [styleBtn setContentMode:UIViewContentModeCenter];
    [styleBtn addTarget:self action:@selector(changeStyle) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:styleBtn];
    [styleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).with.offset(2);
        make.top.equalTo(self).with.offset(20);
        make.size.mas_equalTo(CGSizeMake(40,40));
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
        make.top.equalTo(self.mas_top).with.offset(28);
        make.left.equalTo(backBtn.mas_right).offset(-25);
        make.height.equalTo(@26);
        make.right.equalTo(styleBtn.mas_left).with.offset(-2);
    }];

    //搜索框图标
    UIImageView *searchIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"searchbar_search"]];
    [searchView addSubview:searchIcon];
    [searchIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(searchView);
        make.left.equalTo(searchView.mas_left).with.offset(8);
    }];

    //搜索框提示文字
    searchTitle = [UILabel new];
    [searchTitle setText:@"搜索商品/店铺"];
    [searchTitle setTextColor:[UIColor colorWithHexString:@"#848689"]];
    [searchTitle setFont:[UIFont systemFontOfSize:12]];
    [searchView addSubview:searchTitle];
    [searchTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(searchView);
        make.left.equalTo(searchIcon.mas_right).offset(5);
    }];
}

/**
 * 设置切换样式的回调事件
 */
- (void) setStyleBlock:(GoodsListHeaderStyleBlock) _block{
    styleBlock = _block;
}

/**
 * 设置后退事件
 */
- (void) setBackAction:(SEL)action{
    [backBtn addTarget:[self viewController] action:action forControlEvents:UIControlEventTouchUpInside];
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
 * 设置搜索框文本
 */
- (void) setTitle:(NSString *)title{
    searchTitle.text = title;
}

/**
 * 设置切换样式的事件
 */
- (void) changeStyle{
    if(listStyle == List) {
        listStyle = Grid;
        [styleBtn setImage:[UIImage imageNamed:@"product_list"] forState:UIControlStateNormal];
    }else{
        listStyle = List;
        [styleBtn setImage:[UIImage imageNamed:@"product_list_grid"] forState:UIControlStateNormal];
    }
    if(styleBlock != nil){
        styleBlock(listStyle);
    }
}


@end