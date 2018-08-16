//
// Created by Dawei on 3/23/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "GoodsStoreCell.h"
#import "UIView+Common.h"
#import "ESLabel.h"
#import "View+MASAdditions.h"
#import "Store.h"
#import "UIImageView+WebCache.h"


@implementation GoodsStoreCell {

    UIView *headerLine;
    UIView *footerLine;

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
    ESLabel *creditTitleLbl;
    ESLabel *creditLbl;

    /**
     * 店铺描述评分
     */
    ESLabel *descTitleLbl;
    ESLabel *descLbl;

    /**
     * 店铺服务评分
     */
    ESLabel *serviceTitleLbl;
    ESLabel *serviceLbl;

    /**
     * 店铺发货评分
     */
    ESLabel *deliveryTitleLbl;
    ESLabel *deliveryLbl;

    /**
     * 收藏人数
     */
    ESLabel *collectTitleLbl;
    ESLabel *collectLbl;

    /**
     * 商品数量
     */
    ESLabel *goodsNumberTitleLbl;
    ESLabel *goodsNumberLbl;

    /**
     * 店铺好评率
     */
    ESLabel *rateTitleLbl;
    ESLabel *rateLbl;

    UIView *view1;
    UIView *view2;
    UIView *view3;
}

@synthesize gotoStoreBtn;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        headerLine = [UIView new];
        headerLine.backgroundColor = [UIColor colorWithHexString:kBorderLineColor];
        [self addSubview:headerLine];
        [headerLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self);
            make.height.equalTo(@0.5f);
        }];

        footerLine = [UIView new];
        footerLine.backgroundColor = [UIColor colorWithHexString:kBorderLineColor];
        [self addSubview:footerLine];
        [footerLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(self);
            make.height.equalTo(headerLine);
        }];

        logoIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"store_logo_placeholder.png"]];
        logoIv.contentMode =  UIViewContentModeScaleAspectFill;
        [logoIv borderWidth:0.5f color:[UIColor colorWithHexString:@"#d1d1d1"] cornerRadius:0];
        [self addSubview:logoIv];
        [logoIv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(self).offset(10);
            make.width.equalTo(@95);
            make.height.equalTo(@30);
        }];

        nameLbl = [[ESLabel alloc] initWithText:@"店铺名称" textColor:[UIColor blackColor] fontSize:14];
        [self addSubview:nameLbl];
        [nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(logoIv.mas_right).offset(10);
            make.top.equalTo(logoIv).offset(5);
        }];

//        creditLbl = [[ESLabel alloc] initWithText:@"0" textColor:[UIColor colorWithHexString:@"#f22c2d"] fontSize:14];
//        [self addSubview:creditLbl];
//        [creditLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(nameLbl);
//            make.right.equalTo(self).offset(-10);
//        }];
//
//        creditTitleLbl = [[ESLabel alloc] initWithText:@"信用" textColor:[UIColor colorWithHexString:@"#90939c"] fontSize:14];
//        [self addSubview:creditTitleLbl];
//        [creditTitleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(creditLbl);
//            make.right.equalTo(creditLbl.mas_left).offset(-5);
//        }];


        //平分为三个区间
        view1 = [UIView new];
//        view1.backgroundColor = [UIColor redColor];
        view2 = [UIView new];
        view3 = [UIView new];
        [self addSubview:view1];
        [self addSubview:view2];
        [self addSubview:view3];
        [view1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(logoIv.mas_bottom).offset(12);
            make.left.equalTo(self);
            make.width.equalTo(@(kScreen_Width/3));
            make.height.equalTo(@60);
        }];
        [view2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.width.equalTo(view1);
            make.left.equalTo(view1.mas_right);
        }];
        [view3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.width.equalTo(view1);
            make.left.equalTo(view2.mas_right);
        }];

        //店铺描述评分
        UIView *descView = [UIView new];
        [view1 addSubview:descView];
        [descView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@55);
            make.height.equalTo(@20);
            make.top.centerX.equalTo(view1);
        }];

        descTitleLbl = [[ESLabel alloc] initWithText:@"描述" textColor:[UIColor colorWithHexString:@"#90939c"] fontSize:14];
        [descView addSubview:descTitleLbl];
        [descTitleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(descView);
        }];

        descLbl = [[ESLabel alloc] initWithText:@"0" textColor:[UIColor colorWithHexString:@"#f22c2d"] fontSize:14];
        [descView addSubview:descLbl];
        [descLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(descView);
            make.left.equalTo(descTitleLbl.mas_right).offset(5);
        }];

        //收藏人数
        collectLbl = [[ESLabel alloc] initWithText:@"0" textColor:[UIColor blackColor] fontSize:16];
        [view1 addSubview:collectLbl];
        [collectLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(view1);
            make.top.equalTo(descLbl.mas_bottom).offset(10);
        }];
        collectTitleLbl = [[ESLabel alloc] initWithText:@"收藏人数" textColor:[UIColor colorWithHexString:@"#90939c"] fontSize:12];
        [view1 addSubview:collectTitleLbl];
        [collectTitleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(view1);
            make.top.equalTo(collectLbl.mas_bottom).offset(2);
        }];


        //店铺服务评分
        UIView *serviceView = [UIView new];
        [view2 addSubview:serviceView];
        [serviceView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(descView);
            make.top.centerX.equalTo(view2);
        }];

        serviceTitleLbl = [[ESLabel alloc] initWithText:@"服务" textColor:[UIColor colorWithHexString:@"#90939c"] fontSize:14];
        [serviceView addSubview:serviceTitleLbl];
        [serviceTitleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(serviceView);
        }];

        serviceLbl = [[ESLabel alloc] initWithText:@"0" textColor:[UIColor colorWithHexString:@"#f22c2d"] fontSize:14];
        [serviceView addSubview:serviceLbl];
        [serviceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(serviceView);
            make.left.equalTo(serviceTitleLbl.mas_right).offset(5);
        }];

        //商品数量
        goodsNumberLbl = [[ESLabel alloc] initWithText:@"0" textColor:[UIColor blackColor] fontSize:16];
        [view2 addSubview:goodsNumberLbl];
        [goodsNumberLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(view2);
            make.top.equalTo(serviceView.mas_bottom).offset(10);
        }];
        goodsNumberTitleLbl = [[ESLabel alloc] initWithText:@"全部商品" textColor:[UIColor colorWithHexString:@"#90939c"] fontSize:12];
        [view2 addSubview:goodsNumberTitleLbl];
        [goodsNumberTitleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(view2);
            make.top.equalTo(goodsNumberLbl.mas_bottom).offset(2);
        }];

        //店铺物流评分
        UIView *deliveryView = [UIView new];
        [view3 addSubview:deliveryView];
        [deliveryView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(descView);
            make.top.centerX.equalTo(view3);
        }];

        deliveryTitleLbl = [[ESLabel alloc] initWithText:@"物流" textColor:[UIColor colorWithHexString:@"#90939c"] fontSize:14];
        [deliveryView addSubview:deliveryTitleLbl];
        [deliveryTitleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(deliveryView);
        }];

        deliveryLbl = [[ESLabel alloc] initWithText:@"0" textColor:[UIColor colorWithHexString:@"#f22c2d"] fontSize:14];
        [deliveryView addSubview:deliveryLbl];
        [deliveryLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(deliveryView);
            make.left.equalTo(deliveryTitleLbl.mas_right).offset(5);
        }];

        //卖家信用
        rateLbl = [[ESLabel alloc] initWithText:@"0" textColor:[UIColor blackColor] fontSize:16];
        [view3 addSubview:rateLbl];
        [rateLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(view3);
            make.top.equalTo(deliveryView.mas_bottom).offset(10);
        }];
        rateTitleLbl = [[ESLabel alloc] initWithText:@"卖家信用" textColor:[UIColor colorWithHexString:@"#90939c"] fontSize:12];
        [view3 addSubview:rateTitleLbl];
        [rateTitleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(view3);
            make.top.equalTo(rateLbl.mas_bottom).offset(2);
        }];

        gotoStoreBtn = [UIButton new];
        [gotoStoreBtn setTitle:@" 进入店铺" forState:UIControlStateNormal];
        [gotoStoreBtn setImage:[UIImage imageNamed:@"store.png"] forState:UIControlStateNormal];
        gotoStoreBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [gotoStoreBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [gotoStoreBtn borderWidth:0.5f color:[UIColor colorWithHexString:@"#a6a7a9"] cornerRadius:3];
        [self addSubview:gotoStoreBtn];
        [gotoStoreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(view1.mas_bottom).offset(20);
            make.left.equalTo(self).offset(20);
            make.right.equalTo(self).offset(-20);
            make.height.equalTo(@35);
        }];

    }
    return self;
}

- (void)configData:(Store *)store {
    nameLbl.text = store.name;
    if(store.store_logo != nil && [store.store_logo isKindOfClass:[NSString class]] && store.store_logo.length > 0){
        [logoIv sd_setImageWithURL:[NSURL URLWithString:store.store_logo] placeholderImage:[UIImage imageNamed:@"store_logo_placeholder.png"]];
    }
    descLbl.text = [NSString stringWithFormat:@"%.1f", store.store_desccredit];
    serviceLbl.text = [NSString stringWithFormat:@"%.1f", store.store_servicecredit];
    deliveryLbl.text = [NSString stringWithFormat:@"%.1f", store.store_deliverycredit];
    collectLbl.text = [NSString stringWithFormat:@"%d", store.store_collect];
    goodsNumberLbl.text = [NSString stringWithFormat:@"%d", store.goods_num];
    rateLbl.text = [NSString stringWithFormat:@"%d", store.store_credit];
}


@end
