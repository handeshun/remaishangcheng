//
// Created by Dawei on 5/31/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "CheckoutCouponCell.h"
#import "Masonry.h"
#import "ESLabel.h"
#import "UIView+Common.h"
#import "Bonus.h"
#import "Cart.h"
#import "Store.h"

@implementation CheckoutCouponCell {
    UIView *headerView;
    UIView *footerView;

    ESLabel *titleLbl;
    ESLabel *couponLbl;
    ESLabel *couponCountLbl;
    UIImageView *arrowIV;
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

        arrowIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"right_arrow.png"]];
        [self addSubview:arrowIV];
        [arrowIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.width.equalTo(@9);
            make.height.equalTo(@15);
            make.right.equalTo(self).offset(-10);
        }];

        titleLbl = [[ESLabel alloc] initWithText:@"优惠券" textColor:[UIColor darkGrayColor] fontSize:14];
        [self addSubview:titleLbl];
        [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self).offset(10);
            make.width.equalTo(@50);
        }];

        couponCountLbl = [[ESLabel alloc] initWithText:@" 无可用 " textColor:[UIColor whiteColor] fontSize:12];
        couponCountLbl.backgroundColor = [UIColor colorWithHexString:@"#f65050"];
        [couponCountLbl borderWidth:0.5f color:[UIColor whiteColor] cornerRadius:3];
        [self addSubview:couponCountLbl];
        [couponCountLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(titleLbl.mas_right).offset(5);
            make.centerY.equalTo(self);
        }];

        couponLbl = [[ESLabel alloc] initWithText:@"未使用" textColor:[UIColor darkGrayColor] fontSize:12];
        couponLbl.textAlignment = NSTextAlignmentRight;
        [self addSubview:couponLbl];
        [couponLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.right.equalTo(arrowIV.mas_left).offset(-10);
            make.left.equalTo(couponCountLbl.mas_right).offset(10);
        }];

    }
    return self;
}

- (void)configData:(Cart *)cart {
    double money = 0.0;
    int count = 0;
    for(Store *store in cart.storeList){
        if(store.bonus != nil){
            money += store.bonus.money;
        }
        if(store.bonusList != nil){
            count += store.bonusList.count;
        }
    }

    couponCountLbl.text = [NSString stringWithFormat:@" %d张可用 ", count];
    if(money <= 0){
        couponLbl.text = @"未使用";
    }else{
        couponLbl.text = [NSString stringWithFormat:@"已抵用%.2f元", money];
    }
}

@end