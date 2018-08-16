//
// Created by Dawei on 5/30/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "CheckoutOperationView.h"
#import "ESLabel.h"
#import "ESButton.h"
#import "Masonry.h"


@implementation CheckoutOperationView {
    ESLabel *totalPrice;

    ESButton *checkoutBtn;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder])
        [self setupUI];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame])
        [self setupUI];
    return self;
}

/**
 * 创建UI界面
 */
- (void)setupUI {
    self.backgroundColor = [[UIColor blackColor]  colorWithAlphaComponent:0.8];

    totalPrice = [[ESLabel alloc] initWithText:@"实付款:￥0.00" textColor:[UIColor whiteColor] fontSize:14];
    [self addSubview:totalPrice];

    checkoutBtn = [[ESButton alloc] initWithTitle:@"提交订单" color:[UIColor whiteColor] fontSize:16];
    checkoutBtn.backgroundColor = [UIColor colorWithHexString:@"#ee5253"];
    [self addSubview:checkoutBtn];

    [totalPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.centerY.equalTo(self);
    }];

    [checkoutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.equalTo(self);
        make.width.equalTo(@120);
    }];
}

- (void)setTotalPrice:(double)totalPrice1 {
    totalPrice.text = [NSString stringWithFormat:@"实付款:￥%.2f", totalPrice1];
}

- (void)setCheckoutAction:(SEL)action {
    [checkoutBtn addTarget:[self viewController] action:action forControlEvents:UIControlEventTouchUpInside];
}


@end