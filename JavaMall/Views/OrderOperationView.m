//
// Created by Dawei on 5/30/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "OrderOperationView.h"
#import "ESLabel.h"
#import "ESButton.h"
#import "Masonry.h"
#import "Order.h"
#import "UIView+Common.h"


@implementation OrderOperationView {
}

@synthesize paymentBtn, cancelBtn, rogBtn, returnedBtn, viewReturnedBtn;

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
    self.backgroundColor = [[UIColor colorWithHexString:@"#eaeef1"]  colorWithAlphaComponent:1.0];

    //支付按钮
    paymentBtn = [[ESButton alloc] initWithTitle:@"去支付" color:[UIColor whiteColor] fontSize:14];
    paymentBtn.backgroundColor = [UIColor colorWithHexString:@"#f15352"];
    [paymentBtn borderWidth:0.5f color:[UIColor redColor] cornerRadius:4];
    [self addSubview:paymentBtn];
    [paymentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-10);
        make.centerY.equalTo(self);
        make.width.equalTo(@70);
        make.height.equalTo(@28);
    }];

    //取消订单
    cancelBtn = [[ESButton alloc] initWithTitle:@"取消订单" color:[UIColor darkGrayColor] fontSize:14];
    cancelBtn.backgroundColor = [UIColor whiteColor];
    [cancelBtn borderWidth:0.5f color:[UIColor colorWithHexString:@"#bab9be"] cornerRadius:4];
    [self addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(paymentBtn.mas_left).offset(-10);
        make.centerY.equalTo(self);
        make.height.width.equalTo(paymentBtn);
    }];

    //确认收货
    rogBtn = [[ESButton alloc] initWithTitle:@"确认收货" color:[UIColor darkGrayColor] fontSize:14];
    rogBtn.backgroundColor = [UIColor whiteColor];
    [rogBtn borderWidth:0.5f color:[UIColor colorWithHexString:@"#bab9be"] cornerRadius:4];
    [self addSubview:rogBtn];
    [rogBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-10);
        make.centerY.equalTo(self);
        make.height.width.equalTo(paymentBtn);
    }];

    //评价商品
//    commentBtn = [[ESButton alloc] initWithTitle:@"评价商品" color:[UIColor darkGrayColor] fontSize:14];
//    commentBtn.backgroundColor = [UIColor whiteColor];
//    [commentBtn borderWidth:0.5f color:[UIColor colorWithHexString:@"#bab9be"] cornerRadius:4];
//    [self addSubview:commentBtn];
//    [commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self).offset(-10);
//        make.centerY.equalTo(self);
//        make.height.width.equalTo(paymentBtn);
//    }];

    //申请售后
    returnedBtn = [[ESButton alloc] initWithTitle:@"申请售后" color:[UIColor darkGrayColor] fontSize:14];
    returnedBtn.backgroundColor = [UIColor whiteColor];
    [returnedBtn borderWidth:0.5f color:[UIColor colorWithHexString:@"#bab9be"] cornerRadius:4];
    [self addSubview:returnedBtn];
    [returnedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-10);
        make.centerY.equalTo(self);
        make.height.width.equalTo(paymentBtn);
    }];

    //查看售后
    viewReturnedBtn = [[ESButton alloc] initWithTitle:@"查看售后" color:[UIColor darkGrayColor] fontSize:14];
    viewReturnedBtn.backgroundColor = [UIColor whiteColor];
    [viewReturnedBtn borderWidth:0.5f color:[UIColor colorWithHexString:@"#bab9be"] cornerRadius:4];
    [self addSubview:viewReturnedBtn];
    [viewReturnedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-10);
        make.centerY.equalTo(self);
        make.height.width.equalTo(paymentBtn);
    }];
}

- (void)configData:(Order *)order {
    //在线支付
    if(!order.isCod && order.status == OrderStatus_CONFIRM && order.is_cancel == 0){
        [paymentBtn setHidden:NO];
    }else{
        [paymentBtn setHidden:YES];
    }

    //取消订单
    if((order.status == OrderStatus_NOPAY || order.status == OrderStatus_PAY || order.status == OrderStatus_CONFIRM) && order.is_cancel == 0){
        [cancelBtn setHidden:NO];
        if(paymentBtn.isHidden){
            [cancelBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self).offset(-10);
                make.centerY.equalTo(self);
                make.height.width.equalTo(paymentBtn);
            }];
        }else{
            [cancelBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(paymentBtn.mas_left).offset(-10);
                make.centerY.equalTo(self);
                make.height.width.equalTo(paymentBtn);
            }];
        }
    }else{
        [cancelBtn setHidden:YES];
    }

    //确认收货
    if(order.status == OrderStatus_SHIP){
        [rogBtn setHidden:NO];
    }else{
        [rogBtn setHidden:YES];
    }

    //申请售后
    if(order.status == OrderStatus_COMPLETE || order.status == OrderStatus_ROG){
        [returnedBtn setHidden:NO];
    }else{
        [returnedBtn setHidden:YES];
    }

    //查看售后
    if(order.status == OrderStatus_MAINTENANCE){
        [viewReturnedBtn setHidden:NO];
    }else{
        [viewReturnedBtn setHidden:YES];
    }
}


@end