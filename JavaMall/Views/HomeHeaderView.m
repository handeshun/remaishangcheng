//
// Created by Dawei on 1/5/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Masonry/View+MASAdditions.h>
#import "HomeHeaderView.h"


@implementation HomeHeaderView {
    UIButton *scanBtn;
    UIView *searchView;
    UIButton *imBtn;
    UIImageView *imNote;
    UIButton *addressBtn;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setFrame:CGRectMake(0, 0, kScreen_Width, kTopHeight-4)];
        [self createUI];
    }
    return self;
}

/**
 * 设置背景色透明度
 */
- (void) setBackgroundAlpha:(float) alpha{
   // self.backgroundColor = [[UIColor colorWithHexString:@"#c91523"]  colorWithAlphaComponent:alpha];
    [self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg1.png"]]];
}

/**
 * 创建界面
 */
- (void)createUI{
//    self.backgroundColor = [UIColor colorWithHexString:@"#c91523"];
    [self setBackgroundAlpha:1.0];

    //扫一扫
    scanBtn = [UIButton new];
    [scanBtn setImage:[UIImage imageNamed:@"home_scan"] forState:UIControlStateNormal];
    [scanBtn setTitle:@"扫啊扫" forState:UIControlStateNormal];
    [scanBtn setTitleEdgeInsets:UIEdgeInsetsMake(33, -30, 0, 0)];
    scanBtn.titleLabel.font = [UIFont systemFontOfSize:10];
    [self addSubview:scanBtn];
    [scanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY).with.offset(5);
        make.left.equalTo(self.mas_left).offset(5);
        make.size.mas_equalTo(CGSizeMake(40,40));
    }];

    //消息按钮
    imBtn = [UIButton new];
    [imBtn setImage:[UIImage imageNamed:@"home_im"] forState:UIControlStateNormal];
    [imBtn setTitle:@"客服" forState:UIControlStateNormal];
    [imBtn setTitleEdgeInsets:UIEdgeInsetsMake(33, -37, 0, 0)];
    imBtn.titleLabel.font = [UIFont systemFontOfSize:10];
    [self addSubview:imBtn];
    [imBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY).with.offset(5);
        make.right.equalTo(self.mas_right).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];

    //消息小红点
    imNote = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"im_dot"]];
    [imNote setHidden:YES];
    [self addSubview:imNote];
    [imNote mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(imBtn.mas_centerY).with.offset(-7);
        make.right.equalTo(imBtn.mas_right).with.offset(-15);
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
        make.left.equalTo(scanBtn.mas_right).offset(-5);
        make.top.equalTo(self.mas_top).offset(25);
        make.bottom.equalTo(self.mas_bottom).offset(-5);
      //  make.width.equalTo(@(kScreen_Width - 30));
        make.right.equalTo(self.mas_right).offset(-10);
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

//    addressBtn = [UIButton new];
//    [addressBtn setImageEdgeInsets:UIEdgeInsetsMake(15, 0, 0, 5)];
//    [addressBtn setImage:[UIImage imageNamed:@"home_dress"] forState:UIControlStateNormal];
//    [self addSubview:addressBtn];
//    [addressBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.mas_centerY);
//        make.right.equalTo(self.mas_right).offset(5);
//        make.size.mas_equalTo(CGSizeMake(40, 40));
//    }];
}

/**
 * 设置扫一扫的事件
 */
- (void)setScanAction:(SEL)action {
    [scanBtn addTarget:[self viewController] action:action forControlEvents:UIControlEventTouchUpInside];
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
 * 设置消息事件
 */
- (void)setIMAction:(SEL)action {
    [imBtn addTarget:[self viewController] action:action forControlEvents:UIControlEventTouchUpInside];
}

- (void)hideIM {
    [imBtn setHidden:YES];
//    [searchView mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.mas_top).with.offset(25);
//        make.left.equalTo(scanBtn.mas_right).with.offset(-5);
//        make.bottom.equalTo(self.mas_bottom).with.offset(-5);
//        make.right.equalTo(self).with.offset(-5);
//    }];
}

/**
 * 设置是否有新消息
 * @param have
 */
- (void)setHaveMessage:(BOOL)have{
    [imNote setHidden:!have];
}

/**
 * 设置地图的事件
 */
- (void)setDressAction:(SEL)action {
    [addressBtn addTarget:[self viewController] action:action forControlEvents:UIControlEventTouchUpInside];
}


@end
