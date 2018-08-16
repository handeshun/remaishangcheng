//
// Created by Dawei on 5/31/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "CheckoutPaymentCell.h"
#import "Masonry.h"
#import "ESLabel.h"
#import "Shipping.h"
#import "Payment.h"
#import "Cart.h"
#import "CartGoods.h"
#import "Store.h"
#import "ShipType.h"

@implementation CheckoutPaymentCell {
    UIView *headerView;
    UIView *footerView;

    UIImageView *arrowIV;

    ESLabel *titleLbl;
    ESLabel *paymentLbl;
    ESLabel *shippingLbl;
    ESLabel *shippingTimeLbl;

    NSMutableArray *shippingTimeArray;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        shippingTimeArray = [NSArray arrayWithObjects:@"任意时间", @"仅工作日", @"仅休息日", nil];

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

        titleLbl = [[ESLabel alloc] initWithText:@"支付配送" textColor:[UIColor darkGrayColor] fontSize:14];
        [self addSubview:titleLbl];
        [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self).offset(10);
        }];

        paymentLbl = [[ESLabel alloc] initWithText:@"" textColor:[UIColor darkGrayColor] fontSize:12];
        paymentLbl.textAlignment = NSTextAlignmentRight;
        [self addSubview:paymentLbl];
        [paymentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(10);
            make.right.equalTo(arrowIV.mas_left).offset(-10);
            make.left.equalTo(titleLbl.mas_right).offset(10);
        }];

        shippingLbl = [[ESLabel alloc] initWithText:@"" textColor:[UIColor darkGrayColor] fontSize:12];
        shippingLbl.textAlignment = NSTextAlignmentRight;
        [self addSubview:shippingLbl];
        [shippingLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.left.equalTo(paymentLbl);
            make.top.equalTo(paymentLbl.mas_bottom).offset(5);
        }];

        shippingTimeLbl = [[ESLabel alloc] initWithText:@"" textColor:[UIColor darkGrayColor] fontSize:12];
        shippingTimeLbl.textAlignment = NSTextAlignmentRight;
        [self addSubview:shippingTimeLbl];
        [shippingTimeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.left.equalTo(paymentLbl);
            make.top.equalTo(shippingLbl.mas_bottom).offset(5);
        }];


    }
    return self;
}

- (void)configData:(Payment *)payment cart:(Cart *)cart shippingTime:(NSInteger)shippingTime {
    paymentLbl.text = payment.name;

    NSMutableDictionary *shippingNameDic = [NSMutableDictionary dictionaryWithCapacity:0];
    for(Store *store in cart.storeList){
        if(store.shipType == nil){
            [shippingNameDic setObject:@"0" forKey:@"免运费"];
        }else{
            [shippingNameDic setObject:[NSString stringWithFormat:@"%d", store.shipType.type_id] forKey:store.shipType.name];
        }
    }
    shippingLbl.text = [[[shippingNameDic keyEnumerator] allObjects] componentsJoinedByString:@" "];;
    shippingTimeLbl.text = [shippingTimeArray objectAtIndex:shippingTime];
}

@end