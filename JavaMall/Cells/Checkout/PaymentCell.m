//
// Created by Dawei on 6/26/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "PaymentCell.h"
#import "ESLabel.h"
#import "Masonry.h"
#import "Payment.h"

@implementation PaymentCell {
    UIImageView *paymentIV;
    ESLabel *nameLbl;

    UIImageView *arrowIV;

    UIView *footerView;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        footerView = [UIView new];
        footerView.backgroundColor = [UIColor colorWithHexString:@"#e4e5e7"];
        [self addSubview:footerView];

        [footerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(self);
            make.height.equalTo(@0.5f);
        }];

        paymentIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"alipay.png"]];
        [self addSubview:paymentIV];
        [paymentIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(10);
            make.centerY.equalTo(self);
        }];

        nameLbl = [[ESLabel alloc] initWithText:@"支付宝" textColor:[UIColor darkGrayColor] fontSize:14];
        [self addSubview:nameLbl];
        [nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(paymentIV.mas_right).offset(10);
            make.centerY.equalTo(self);
        }];

        arrowIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"right_arrow.png"]];
        [self addSubview:arrowIV];
        [arrowIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.width.equalTo(@9);
            make.height.equalTo(@15);
            make.right.equalTo(self).offset(-10);
        }];

    }
    return self;
}

- (void)configData:(Payment *)payment {
    if(payment.type == Payment_Alipay){
        [paymentIV setImage:[UIImage imageNamed:@"alipay.png"]];
    }else if(payment.type == Payment_Wechat){
        [paymentIV setImage:[UIImage imageNamed:@"wechat.png"]];
    }else if(payment.type == Payment_UnionPay){
        [paymentIV setImage:[UIImage imageNamed:@"unionpay.png"]];
    }
    nameLbl.text = payment.name;
}

@end