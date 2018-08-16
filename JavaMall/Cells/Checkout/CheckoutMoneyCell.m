//
// Created by Dawei on 5/31/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "CheckoutMoneyCell.h"
#import "Masonry.h"
#import "ESLabel.h"
#import "OrderPrice.h"

@implementation CheckoutMoneyCell {
    UIView *headerView;
    UIView *footerView;

    ESLabel *totalTitleLbl;
    ESLabel *totalLbl;

    ESLabel *shippingTitleLbl;
    ESLabel *shippingLbl;

    ESLabel *couponTitleLbl;
    ESLabel *counponLbl;

    ESLabel *actTitleLbl;
    ESLabel *actLbl;
    
    ESLabel *shuomingLab;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];

        headerView = [UIView new];
        headerView.backgroundColor = [UIColor colorWithHexString:@"#e4e5e7"];
        [self addSubview:headerView];

        footerView = [UIView new];
        footerView.backgroundColor = [UIColor colorWithHexString:@"#e4e5e7"];
        [self addSubview:footerView];

        [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self);
            make.height.equalTo(@0.5f);
        }];

        [footerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(self);
            make.height.equalTo(headerView);
        }];

        totalTitleLbl = [[ESLabel alloc] initWithText:@"商品金额" textColor:[UIColor colorWithHexString:@"#a7a7a7"] fontSize:14];
        [self addSubview:totalTitleLbl];
        [totalTitleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(10);
            make.top.equalTo(self).offset(10);
        }];
        totalLbl = [[ESLabel alloc] initWithText:@"￥0.00" textColor:[UIColor colorWithHexString:@"#f65050"] fontSize:14];
        [self addSubview:totalLbl];
        [totalLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-10);
            make.top.equalTo(self).offset(10);
        }];

        shippingTitleLbl = [[ESLabel alloc] initWithText:@"运费" textColor:[UIColor colorWithHexString:@"#a7a7a7"] fontSize:14];
        [self addSubview:shippingTitleLbl];
        [shippingTitleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(10);
            make.top.equalTo(totalTitleLbl.mas_bottom).offset(10);
        }];
        shippingLbl = [[ESLabel alloc] initWithText:@"+￥0.00" textColor:[UIColor colorWithHexString:@"#f65050"] fontSize:14];
        [self addSubview:shippingLbl];
        [shippingLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-10);
            make.top.equalTo(totalLbl.mas_bottom).offset(10);
        }];

        couponTitleLbl = [[ESLabel alloc] initWithText:@"优惠券" textColor:[UIColor colorWithHexString:@"#a7a7a7"] fontSize:14];
        [self addSubview:couponTitleLbl];
        [couponTitleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(10);
            make.top.equalTo(shippingTitleLbl.mas_bottom).offset(10);
        }];
        counponLbl = [[ESLabel alloc] initWithText:@"-￥0.00" textColor:[UIColor colorWithHexString:@"#f65050"] fontSize:14];
        [self addSubview:counponLbl];
        [counponLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-10);
            make.top.equalTo(shippingLbl.mas_bottom).offset(10);
        }];

        //促销活动优惠
        actTitleLbl = [[ESLabel alloc] initWithText:@"促销优惠" textColor:[UIColor colorWithHexString:@"#a7a7a7"] fontSize:14];
        [self addSubview:actTitleLbl];
        [actTitleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(10);
            make.top.equalTo(couponTitleLbl.mas_bottom).offset(10);
        }];
        actLbl = [[ESLabel alloc] initWithText:@"-￥0.00" textColor:[UIColor colorWithHexString:@"#f65050"] fontSize:14];
        [self addSubview:actLbl];
        [actLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-10);
            make.top.equalTo(counponLbl.mas_bottom).offset(10);
        }];

    }
    return self;
}

- (void)configData:(OrderPrice *)orderPrice {
    totalLbl.text = [NSString stringWithFormat:@"￥%.2f", orderPrice.goodsPrice];
    shippingLbl.text = [NSString stringWithFormat:@"￥%.2f", orderPrice.shippingPrice];
    counponLbl.text = [NSString stringWithFormat:@"-￥%.2f", orderPrice.discountPrice];
    actLbl.text = [NSString stringWithFormat:@"-￥%.2f", orderPrice.actDiscount];
}


@end
