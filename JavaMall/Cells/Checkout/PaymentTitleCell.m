//
// Created by Dawei on 6/26/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "PaymentTitleCell.h"
#import "ESLabel.h"
#import "Masonry.h"


@implementation PaymentTitleCell {
    UIView *headerView;
    UIView *footerView;

    ESLabel *titleLbl;
    ESLabel *amountLbl;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
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

        titleLbl = [[ESLabel alloc] initWithText:@"请支付" textColor:[UIColor darkGrayColor] fontSize:14];
        [self addSubview:titleLbl];
        [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(10);
            make.centerY.equalTo(self);
        }];

        amountLbl = [[ESLabel alloc] initWithText:@"1212.22元" textColor:[UIColor redColor] fontSize:14];
        [self addSubview:amountLbl];
        [amountLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-10);
            make.centerY.equalTo(self);
        }];
    }
    return self;
}

- (void)configData:(double)amount {
    amountLbl.text = [NSString stringWithFormat:@"%.2f元", amount];
}

@end