//
// Created by Dawei on 5/30/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "CartCheckoutView.h"
#import "ESLabel.h"
#import "ESButton.h"
#import "Masonry.h"


@implementation CartCheckoutView {
    ESButton *checkBtn;

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
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];

    checkBtn = [ESButton new];
    [checkBtn setImage:[UIImage imageNamed:@"cart_round_check1.png"] forState:UIControlStateNormal];
    [checkBtn setImage:[UIImage imageNamed:@"cart_round_check2.png"] forState:UIControlStateSelected];
    [checkBtn setTitle:@"全选" forState:UIControlStateNormal];
    [checkBtn setFontSize:14];
    [checkBtn setImageEdgeInsets:UIEdgeInsetsMake(0.0, -10, 0.0, 0.0)];
    [self addSubview:checkBtn];

    totalPrice = [[ESLabel alloc] initWithText:@"合计:￥0.00" textColor:[UIColor whiteColor] fontSize:14];
    [self addSubview:totalPrice];

    checkoutBtn = [[ESButton alloc] initWithTitle:@"去结算" color:[UIColor whiteColor] fontSize:16];
    checkoutBtn.backgroundColor = [UIColor colorWithHexString:@"#ee5253"];
    [self addSubview:checkoutBtn];

    //开始布局
    [checkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20);
        make.centerY.equalTo(self);
    }];

    [totalPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(checkBtn.mas_right).offset(10);
        make.centerY.equalTo(self);
    }];

    [checkoutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.equalTo(self);
        make.width.equalTo(@120);
    }];
}

- (void)setTotalPrice:(double)totalPrice1 {
    totalPrice.text = [NSString stringWithFormat:@"合计:￥%.2f", totalPrice1];
}

- (void)setCheckoutAction:(SEL)action {
    [checkoutBtn addTarget:[self viewController] action:action forControlEvents:UIControlEventTouchUpInside];
}

- (void)setChecked:(BOOL)checked {
    [checkBtn setSelected:checked];
}

- (BOOL)isChecked {
    return [checkBtn isSelected];
}

- (void)setCheckAction:(SEL)action {
    [checkBtn addTarget:[self viewController] action:action forControlEvents:UIControlEventTouchUpInside];
}


@end