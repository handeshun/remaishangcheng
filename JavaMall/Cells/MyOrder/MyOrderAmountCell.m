//
// Created by Dawei on 7/3/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "MyOrderAmountCell.h"
#import "Masonry.h"
#import "ESLabel.h"
#import "Order.h"
#import "NSString+Common.h"
#import "DateUtils.h"


@implementation MyOrderAmountCell {
    UIView *headerLine;
    UIView *footerLine;

    ESLabel *amountTitleLbl;
    ESLabel *amountLbl;

    ESLabel *couponTitleLbl;
    ESLabel *counponLbl;

    ESLabel *actTitleLbl;
    ESLabel *actLbl;

    ESLabel *shippingTitleLbl;
    ESLabel *shippingLbl;

    UIView *line;

    ESLabel *paymentTitleLbl;
    ESLabel *paymentLbl;

    ESLabel *createTimeLbl;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        headerLine = [UIView new];
        headerLine.backgroundColor = [UIColor colorWithHexString:@"#e4e5e7"];
        [self addSubview:headerLine];

        footerLine = [UIView new];
        footerLine.backgroundColor = [UIColor colorWithHexString:@"#e4e5e7"];
        [self addSubview:footerLine];

        [headerLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self);
            make.height.equalTo(@0.5f);
        }];

        [footerLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(self);
            make.height.equalTo(headerLine);
        }];

        amountTitleLbl = [[ESLabel alloc] initWithText:@"商品总额" textColor:[UIColor darkGrayColor] fontSize:14];
        [self addSubview:amountTitleLbl];
        [amountTitleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(self).offset(10);
            make.width.equalTo(@100);
        }];

        amountLbl = [[ESLabel alloc] initWithText:@"" textColor:[UIColor colorWithHexString:@"#f35257"] fontSize:14];
        amountLbl.textAlignment = NSTextAlignmentRight;
        [self addSubview:amountLbl];
        [amountLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(amountTitleLbl);
            make.right.equalTo(self).offset(-10);
        }];

        couponTitleLbl = [[ESLabel alloc] initWithText:@"-优惠" textColor:[UIColor darkGrayColor] fontSize:14];
        [self addSubview:couponTitleLbl];
        [couponTitleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(10);
            make.top.equalTo(amountTitleLbl.mas_bottom).offset(10);
            make.width.equalTo(amountTitleLbl);
        }];

        counponLbl = [[ESLabel alloc] initWithText:@"" textColor:[UIColor colorWithHexString:@"#f35257"] fontSize:14];
        counponLbl.textAlignment = NSTextAlignmentRight;
        [self addSubview:counponLbl];
        [counponLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(couponTitleLbl);
            make.right.equalTo(amountLbl);
        }];

        actTitleLbl = [[ESLabel alloc] initWithText:@"-促销优惠" textColor:[UIColor darkGrayColor] fontSize:14];
        [self addSubview:actTitleLbl];
        [actTitleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(10);
            make.top.equalTo(couponTitleLbl.mas_bottom).offset(10);
            make.width.equalTo(couponTitleLbl);
        }];

        actLbl = [[ESLabel alloc] initWithText:@"" textColor:[UIColor colorWithHexString:@"#f35257"] fontSize:14];
        actLbl.textAlignment = NSTextAlignmentRight;
        [self addSubview:actLbl];
        [actLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(actTitleLbl);
            make.right.equalTo(amountLbl);
        }];

        shippingTitleLbl = [[ESLabel alloc] initWithText:@"+运费" textColor:[UIColor darkGrayColor] fontSize:14];
        [self addSubview:shippingTitleLbl];
        [shippingTitleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(10);
            make.top.equalTo(actTitleLbl.mas_bottom).offset(10);
            make.width.equalTo(amountTitleLbl);
        }];

        shippingLbl = [[ESLabel alloc] initWithText:@"" textColor:[UIColor colorWithHexString:@"#f35257"] fontSize:14];
        shippingLbl.textAlignment = NSTextAlignmentRight;
        [self addSubview:shippingLbl];
        [shippingLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(shippingTitleLbl);
            make.right.equalTo(amountLbl);
        }];

        line = [UIView new];
        line.backgroundColor = [UIColor colorWithHexString:@"#e4e5e7"];
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(10);
            make.right.equalTo(self);
            make.height.equalTo(@0.5f);
            make.top.equalTo(shippingTitleLbl.mas_bottom).offset(10);
        }];

        paymentLbl = [[ESLabel alloc] initWithText:@"" textColor:[UIColor colorWithHexString:@"#f35257"] fontSize:14];
        [paymentLbl setFont:[UIFont boldSystemFontOfSize:16]];
        [self addSubview:paymentLbl];
        [paymentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-10);
            make.top.equalTo(line).offset(10);
        }];

        paymentTitleLbl = [[ESLabel alloc] initWithText:@"实付款:" textColor:[UIColor darkGrayColor] fontSize:16];
        [self addSubview:paymentTitleLbl];

        createTimeLbl = [[ESLabel alloc] initWithText:@"" textColor:[UIColor grayColor] fontSize:12];
        [self addSubview:createTimeLbl];
        [createTimeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(paymentTitleLbl.mas_bottom).offset(10);
            make.right.equalTo(self).offset(-10);
        }];
    }
    return self;
}

- (void)configData:(Order *)order {
    amountLbl.text = [NSString stringWithFormat:@"￥%.2f", order.goodsAmount];
    shippingLbl.text = [NSString stringWithFormat:@"￥%.2f", order.shippingAmount];
    counponLbl.text = [NSString stringWithFormat:@"￥%.2f", order.discount];
    actLbl.text = [NSString stringWithFormat:@"￥%.2f", order.actDiscount];
    paymentLbl.text = [NSString stringWithFormat:@"￥%.2f", order.needPayMoney];
    [paymentTitleLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(0 - [paymentLbl.text getSizeWithFont:[UIFont boldSystemFontOfSize:16]].width - 10);
        make.top.equalTo(paymentLbl);
    }];
    createTimeLbl.text = [NSString stringWithFormat:@"下单时间:%@", [DateUtils dateToString:order.createTime withFormat:@"yyyy-MM-dd HH:mm:ss"]];
}


@end