//
// Created by Dawei on 11/3/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "StoreBannerView.h"
#import "Masonry.h"
#import "ESLabel.h"
#import "UIView+Common.h"
#import "ESButton.h"
#import "Store.h"
#import "UIImageView+EMWebCache.h"

@implementation StoreBannerView {
    UIImageView *containerView;

    /**
     * 店铺logo
     */
    UIImageView *logoIv;

    /**
     * 店铺名称
     */
    ESLabel *nameLbl;

    /**
     * 店铺信用
     */
    ESLabel *creditLbl;

    /**
     * 关注人数
     */
    UIImageView *collectNumberBg;
    ESLabel *collectNumberLbl;
}

@synthesize collectBtn;

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
- (void)createUI {
    self.backgroundColor = [UIColor blackColor];

    containerView = [UIImageView new];
    containerView.image = [UIImage imageNamed:@"store_banner_default.png"];
    containerView.alpha = 0.7f;
    [self addSubview:containerView];
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];

    logoIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"store_logo_placeholder.png"]];
    logoIv.contentMode =  UIViewContentModeScaleAspectFill;
    [logoIv borderWidth:0.5f color:[UIColor colorWithHexString:@"#d1d1d1"] cornerRadius:0];
    [self addSubview:logoIv];
    [logoIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(2);
        make.bottom.equalTo(self).offset(-5);
        make.width.equalTo(@95);
        make.height.equalTo(@30);
    }];

    nameLbl = [[ESLabel alloc] initWithText:@"店铺名称店铺名称" textColor:[UIColor whiteColor] fontSize:14];
    nameLbl.shadowColor = [UIColor blackColor];
    nameLbl.shadowOffset = CGSizeMake(0.5f, 0.5f);
    [self addSubview:nameLbl];
    [nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(logoIv.mas_right).offset(5);
        make.top.equalTo(logoIv).offset(-5);
    }];

    creditLbl = [[ESLabel alloc] initWithText:@"5分" textColor:[UIColor whiteColor] fontSize:12];
    creditLbl.shadowColor = [UIColor blackColor];
    creditLbl.shadowOffset = CGSizeMake(0.5f, 0.5f);
    [self addSubview:creditLbl];
    [creditLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLbl);
        make.top.equalTo(nameLbl.mas_bottom).offset(2);
    }];

    collectBtn = [ESButton new];
    [collectBtn setImage:[UIImage imageNamed:@"store_collect_no.png"] forState:UIControlStateNormal];
    [collectBtn setImage:[UIImage imageNamed:@"store_collect_ok.png"] forState:UIControlStateSelected];
    [self addSubview:collectBtn];
    [collectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(3);
        make.top.equalTo(self).offset(45);
        make.width.equalTo(@64);
        make.height.equalTo(@29);
    }];

    collectNumberBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"store_collect_count.png"]];
    collectNumberBg.alpha = 0.2f;
    [self addSubview:collectNumberBg];
    [collectNumberBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(collectBtn);
        make.width.equalTo(collectBtn);
        make.top.equalTo(collectBtn.mas_bottom);
        make.height.equalTo(@19);
    }];
    collectNumberLbl = [[ESLabel alloc] initWithText:@"1989人" textColor:[UIColor colorWithHexString:@"#eeeeee"] fontSize:12];
    [self addSubview:collectNumberLbl];
    [collectNumberLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(collectNumberBg);
    }];
}

- (void)configData:(Store *)store {
    nameLbl.text = store.name;
    if(store.store_logo != nil && [store.store_logo isKindOfClass:[NSString class]] && store.store_logo.length > 0){
        [logoIv sd_setImageWithURL:store.store_logo placeholderImage:[UIImage imageNamed:@"store_logo_placeholder.png"]];
    }
    creditLbl.text = [NSString stringWithFormat:@"%d分", store.store_credit];
    [collectBtn setSelected:store.favorited];
    collectNumberLbl.text = [NSString stringWithFormat:@"%d人", store.store_collect];
}

@end