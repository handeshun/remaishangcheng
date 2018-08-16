//
// Created by Dawei on 6/29/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>
#import "MyOrderListCell.h"
#import "Masonry.h"
#import "ESLabel.h"
#import "ESButton.h"
#import "UIView+Common.h"
#import "Order.h"
#import "OrderItem.h"
#import "ActivityGift.h"
#import "Bonus.h"

@implementation MyOrderListCell {
    UIView *headerLineView;
    UIView *footerLineView;

    UIView *headerView;
    UIView *line1;
    UIView *line2;

    UIView *addressView;
    UIView *line3;
    
    UIView *footerView;
    UIView *giftView;

    UIImageView *signIV;

    ESLabel *statusLbl;
    ESLabel *snLbl;
    ESLabel *amountLbl;
    ESLabel *storeAdressLab;//店铺地址

    UIImageView *pintuanimg;
    
    UIView *containerView;
}

@synthesize paymentBtn, cancelBtn, rogBtn, returnedBtn, viewReturnedBtn, deliveryBtn;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        headerLineView = [UIView new];
        headerLineView.backgroundColor = [UIColor colorWithHexString:@"#e4e5e7"];
        [self addSubview:headerLineView];

        footerLineView = [UIView new];
        footerLineView.backgroundColor = [UIColor colorWithHexString:@"#e4e5e7"];
        [self addSubview:footerLineView];

        [headerLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self);
            make.height.equalTo(@0.5f);
        }];

        [footerLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(self);
            make.height.equalTo(headerLineView);
        }];

        signIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"order_finish_sign.png"]];
        [self addSubview:signIV];
        [signIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-80);
            make.top.equalTo(self);
        }];

       
        
        headerView = [UIView new];
        [self addSubview:headerView];
        [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@35);
            make.left.right.equalTo(self);
        }];

        line1 = [UIView new];
        line1.backgroundColor = [UIColor colorWithHexString:@"#e4e5e7"];
        [self addSubview:line1];
        [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(headerView.mas_bottom);
            make.height.equalTo(@0.5f);
        }];
        
        //地址view
        addressView = [UIView new];
        [self addSubview:addressView];
        [addressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@35);
            make.left.right.equalTo(self);
            make.top.equalTo(headerView.mas_bottom);
        }];
        
        line3 = [UIView new];
        line3.backgroundColor = [UIColor colorWithHexString:@"#e4e5e7"];
        [self addSubview:line3];
        [line3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.bottom.equalTo(addressView.mas_bottom);
            make.height.equalTo(@0.5f);
        }];

        footerView = [UIView new];
        [self addSubview:footerView];
        [footerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(self);
            make.height.equalTo(@40);
        }];
        
        pintuanimg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"pintuan.png"]];
        [self addSubview:pintuanimg];
        [pintuanimg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-20);
            make.bottom.equalTo(footerView.mas_top).offset(-5);
            make.width.equalTo(@31);
            make.height.equalTo(@13);
        }];

        line2 = [UIView new];
        line2.backgroundColor = [UIColor colorWithHexString:@"#e4e5e7"];
        [self addSubview:line2];
        [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.bottom.equalTo(footerView.mas_top);
            make.height.equalTo(@0.5f);
        }];

        snLbl = [[ESLabel alloc] initWithText:@"" textColor:[UIColor darkGrayColor] fontSize:14];
        [headerView addSubview:snLbl];
        [snLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(headerView).offset(10);
            make.centerY.equalTo(headerView);
        }];

        //店铺地址
        storeAdressLab = [[ESLabel alloc] initWithText:@"" textColor:[UIColor darkGrayColor] fontSize:13];
        [addressView addSubview:storeAdressLab];
        storeAdressLab.adjustsFontSizeToFitWidth = YES;
        [storeAdressLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(addressView).offset(10);
            make.right.equalTo(addressView.mas_right).offset(-10);
            make.centerY.equalTo(addressView);
        }];
        
        
        statusLbl = [[ESLabel alloc] initWithText:@"" textColor:[UIColor redColor] fontSize:14];
        [headerView addSubview:statusLbl];
        [statusLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(headerView).offset(-10);
            make.centerY.equalTo(headerView);
        }];

        amountLbl = [[ESLabel alloc] initWithText:@"" textColor:[UIColor darkGrayColor] fontSize:14];
        [footerView addSubview:amountLbl];
        [amountLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(footerView);
            make.left.equalTo(footerView).offset(10);
        }];

        //支付按钮
        paymentBtn = [[ESButton alloc] initWithTitle:@"去支付" color:[UIColor redColor] fontSize:14];
        [paymentBtn borderWidth:0.5f color:[UIColor redColor] cornerRadius:4];
        [self addSubview:paymentBtn];
        [paymentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-10);
            make.centerY.equalTo(footerView);
            make.width.equalTo(@70);
            make.height.equalTo(@28);
        }];

        //取消订单
        cancelBtn = [[ESButton alloc] initWithTitle:@"取消订单" color:[UIColor darkGrayColor] fontSize:14];
        [cancelBtn borderWidth:0.5f color:[UIColor colorWithHexString:@"#bab9be"] cornerRadius:4];
        [self addSubview:cancelBtn];
        [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(paymentBtn.mas_left).offset(-10);
            make.centerY.equalTo(footerView);
            make.height.width.equalTo(paymentBtn);
        }];

        //确认收货
        rogBtn = [[ESButton alloc] initWithTitle:@"确认收货" color:[UIColor darkGrayColor] fontSize:14];
        [rogBtn borderWidth:0.5f color:[UIColor colorWithHexString:@"#bab9be"] cornerRadius:4];
        [self addSubview:rogBtn];
        [rogBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-10);
            make.centerY.equalTo(footerView);
            make.height.width.equalTo(paymentBtn);
        }];
  
        //查看物流
        deliveryBtn = [[ESButton alloc] initWithTitle:@"查看物流" color:[UIColor darkGrayColor] fontSize:14];
        [deliveryBtn borderWidth:0.5f color:[UIColor colorWithHexString:@"#bab9be"] cornerRadius:4];
        [self addSubview:deliveryBtn];
        deliveryBtn.hidden = YES;
        [deliveryBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(rogBtn.mas_left).offset(-10);
            make.centerY.equalTo(footerView);
            make.height.width.equalTo(paymentBtn);
        }];
        
        //申请售后
        returnedBtn = [[ESButton alloc] initWithTitle:@"申请售后" color:[UIColor darkGrayColor] fontSize:14];
        [returnedBtn borderWidth:0.5f color:[UIColor colorWithHexString:@"#bab9be"] cornerRadius:4];
        [self addSubview:returnedBtn];
        [returnedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-10);
            make.centerY.equalTo(footerView);
            make.height.width.equalTo(paymentBtn);
        }];

        //查看售后
        viewReturnedBtn = [[ESButton alloc] initWithTitle:@"查看售后" color:[UIColor darkGrayColor] fontSize:14];
        [viewReturnedBtn borderWidth:0.5f color:[UIColor colorWithHexString:@"#bab9be"] cornerRadius:4];
        [self addSubview:viewReturnedBtn];
        [viewReturnedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-10);
            make.centerY.equalTo(footerView);
            make.height.width.equalTo(paymentBtn);
        }];

        containerView = [UIView new];
        [self addSubview:containerView];
        [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(70);
            make.height.equalTo(@80);
            make.left.right.equalTo(self);
        }];

        giftView = [UIView new];
        [self addSubview:giftView];
        [giftView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(containerView.mas_bottom);
            make.bottom.equalTo(footerView.mas_top);
        }];

    }
    return self;
}

- (void)configData:(Order *)order {
    for(UIView *subView in containerView.subviews){
        [subView removeFromSuperview];
    }
    for(UIView *subView in giftView.subviews){
        [subView removeFromSuperview];
    }
    if(order.order_type ==2)
    {
        pintuanimg.hidden = NO;
    }
    else
    {
        pintuanimg.hidden = YES;
    }
    int left = 10;
    //赠品
    if(order.gift != nil){
        ESLabel *giftTitleLbl = [[ESLabel alloc] initWithText:@"赠品" textColor:[UIColor whiteColor] fontSize:12];
        giftTitleLbl.textAlignment = NSTextAlignmentCenter;
        [giftTitleLbl borderWidth:1 color:[UIColor colorWithHexString:@"#e1321f"] cornerRadius:4];
        giftTitleLbl.backgroundColor = [UIColor colorWithHexString:@"#e1321f"];
        [giftView addSubview:giftTitleLbl];
        [giftTitleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(giftView).offset(left);
            make.top.equalTo(giftView).offset(0);
            make.width.equalTo(@30);
            make.height.equalTo(@18);
        }];

        ESLabel *contentLbl = [[ESLabel alloc] initWithText:order.gift.name textColor:[UIColor darkGrayColor] fontSize:12];
        [giftView addSubview:contentLbl];
        [contentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(giftTitleLbl.mas_right).offset(5);
            make.top.equalTo(giftTitleLbl).offset(2);
            make.width.equalTo(@((kScreen_Width-30) / 2));
        }];

        left += (kScreen_Width / 2) + 10;
    }
    //优惠券
    if(order.gift != nil){
        ESLabel *bonusTitleLbl = [[ESLabel alloc] initWithText:@"赠券" textColor:[UIColor whiteColor] fontSize:12];
        bonusTitleLbl.textAlignment = NSTextAlignmentCenter;
        [bonusTitleLbl borderWidth:1 color:[UIColor colorWithHexString:@"#e1321f"] cornerRadius:4];
        bonusTitleLbl.backgroundColor = [UIColor colorWithHexString:@"#e1321f"];
        [giftView addSubview:bonusTitleLbl];
        [bonusTitleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(giftView).offset(left);
            make.top.equalTo(giftView).offset(0);
            make.width.equalTo(@30);
            make.height.equalTo(@18);
        }];

        ESLabel *contentLbl = [[ESLabel alloc] initWithText:order.bonus.name textColor:[UIColor darkGrayColor] fontSize:12];
        [giftView addSubview:contentLbl];
        [contentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bonusTitleLbl.mas_right).offset(5);
            make.top.equalTo(bonusTitleLbl).offset(2);
            make.width.equalTo(@((kScreen_Width-30) / 2));
        }];
    }

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
                make.centerY.equalTo(footerView);
                make.height.width.equalTo(paymentBtn);
            }];
        }else{
            [cancelBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(paymentBtn.mas_left).offset(-10);
                make.centerY.equalTo(footerView);
                make.height.width.equalTo(paymentBtn);
            }];
        }
    }else{
        [cancelBtn setHidden:YES];
    }

    //确认收货
    if(order.status == OrderStatus_SHIP){
        [rogBtn setHidden:NO];
        [deliveryBtn setHidden:NO];
        if([order.shippingName isEqualToString:@"门店自提"])
        {
            [deliveryBtn setHidden:YES];
        }
    }else{
        [rogBtn setHidden:YES];
        [deliveryBtn setHidden:YES];
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

    amountLbl.text = [NSString stringWithFormat:@"订单金额:￥%.2f", order.orderAmount];
    snLbl.text = [NSString stringWithFormat:@"订单号:%@", order.sn];
    statusLbl.text = order.statusString;
    storeAdressLab.text = order.storeAddr;
    [signIV setHidden:!(order.status == OrderStatus_COMPLETE)];

    if(order.orderItems.count > 1) {
        int count = kScreen_Width / 70;
        if(order.orderItems.count < count){
            count = order.orderItems.count;
        }
        int leftOffset = 10;
        for (int i = 0; i < count; i++) {
            OrderItem *orderItem = [order.orderItems objectAtIndex:i];

            UIImageView *goodsThumbnailIV = [UIImageView new];
            [goodsThumbnailIV borderWidth:0.5f color:[UIColor colorWithHexString:@"#e3e3e3"] cornerRadius:4];
            [containerView addSubview:goodsThumbnailIV];
            [goodsThumbnailIV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(containerView);
                make.width.height.equalTo(@60);
                make.left.equalTo(@(leftOffset));
            }];
            [goodsThumbnailIV sd_setImageWithURL:[NSURL URLWithString:orderItem.thumbnail] placeholderImage:[UIImage imageNamed:@"image_empty.png"]];
            leftOffset += 70;
        }
        return;
    }

    OrderItem *orderItem = [order.orderItems objectAtIndex:0];
    UIImageView *goodsThumbnailIV = [UIImageView new];
    [goodsThumbnailIV borderWidth:0.5f color:[UIColor colorWithHexString:@"#e3e3e3"] cornerRadius:4];
    [goodsThumbnailIV sd_setImageWithURL:[NSURL URLWithString:orderItem.thumbnail] placeholderImage:[UIImage imageNamed:@"image_empty.png"]];
    [containerView addSubview:goodsThumbnailIV];
    [goodsThumbnailIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(containerView);
        make.width.height.equalTo(@60);
        make.left.equalTo(@10);
    }];

    ESLabel *nameLbl = [[ESLabel alloc] initWithText:orderItem.name textColor:[UIColor darkGrayColor] fontSize:14];
    nameLbl.numberOfLines = 2;
    [containerView addSubview:nameLbl];
    [nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(goodsThumbnailIV.mas_right).offset(10);
        make.right.equalTo(self).offset(-10);
        make.centerY.equalTo(containerView);
    }];
}


@end
