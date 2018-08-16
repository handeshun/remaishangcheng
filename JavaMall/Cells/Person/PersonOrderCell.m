//
// Created by Dawei on 6/28/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Masonry/View+MASAdditions.h>
#import "PersonOrderCell.h"
#import "ESButton.h"
#import "NSString+Common.h"
#import "ESLabel.h"
#import "UIView+Common.h"
#import "ESImageButton.h"
#import "Member.h"


@implementation PersonOrderCell {
    UIView *paymentView;
    ESLabel *paymentBadgeLbl;

    UIView *shippingView;
    ESLabel *shippingBadgeLbl;

    UIView *commentView;
    ESLabel *commentBadgeLbl;

    UIView *returnedView;
    ESLabel *returnedBadgeLbl;

}

@synthesize paymentBtn, shippingBtn, commentBtn, returnedBtn;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        //待付款
        paymentView = [UIView new];
        [self addSubview:paymentView];
        [paymentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.height.equalTo(self);
            make.width.equalTo(@(kScreen_Width / 4));
        }];


        paymentBtn = [[ESImageButton alloc] initWithTitle:@"待付款" image:[UIImage imageNamed:@"myorder_payment_icon.png"] fontSize:12];
        [paymentBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [paymentView addSubview:paymentBtn];
        [paymentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.centerX.equalTo(paymentView);
        }];

        paymentBadgeLbl = [[ESLabel alloc] initWithText:@" 0 " textColor:[UIColor whiteColor] fontSize:10];
        [paymentBadgeLbl setBackgroundColor:[UIColor redColor]];
        [paymentBadgeLbl borderWidth:0.5f color:[UIColor whiteColor] cornerRadius:4];
        [paymentBadgeLbl setHidden:YES];
        [paymentView addSubview:paymentBadgeLbl];
        [paymentBadgeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(paymentBtn.mas_right).offset(-22);
            make.top.equalTo(paymentBtn).offset(-10);
            make.height.equalTo(@(15));
        }];

        //待收货
        shippingView = [UIView new];
        [self addSubview:shippingView];
        [shippingView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(paymentView.mas_right);
            make.width.height.equalTo(paymentView);
        }];

        shippingBtn = [[ESImageButton alloc] initWithTitle:@"待收货" image:[UIImage imageNamed:@"myorder_shipping_icon.png"] fontSize:12];
        [shippingBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [shippingView addSubview:shippingBtn];
        [shippingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.centerX.equalTo(shippingView);
        }];

        shippingBadgeLbl = [[ESLabel alloc] initWithText:@" 0 " textColor:[UIColor whiteColor] fontSize:10];
        [shippingBadgeLbl setBackgroundColor:[UIColor redColor]];
        [shippingBadgeLbl borderWidth:0.5f color:[UIColor whiteColor] cornerRadius:4];
        [shippingBadgeLbl setHidden:YES];
        [shippingView addSubview:shippingBadgeLbl];
        [shippingBadgeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(shippingBtn.mas_right).offset(-22);
            make.top.equalTo(shippingBtn).offset(-10);
            make.height.equalTo(@(15));
        }];

        //待评价
        commentView = [UIView new];
        [self addSubview:commentView];
        [commentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(shippingView.mas_right);
            make.height.width.equalTo(paymentView);
        }];

        commentBtn = [[ESImageButton alloc] initWithTitle:@"待评价" image:[UIImage imageNamed:@"myorder_comment_icon.png"] fontSize:12];
        [commentBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [commentView addSubview:commentBtn];
        [commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.centerX.equalTo(commentView);
        }];

        commentBadgeLbl = [[ESLabel alloc] initWithText:@" 0 " textColor:[UIColor whiteColor] fontSize:10];
        [commentBadgeLbl setBackgroundColor:[UIColor redColor]];
        [commentBadgeLbl borderWidth:0.5f color:[UIColor whiteColor] cornerRadius:4];
        [commentBadgeLbl setHidden:YES];
        [commentView addSubview:commentBadgeLbl];
        [commentBadgeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(commentBtn.mas_right).offset(-22);
            make.top.equalTo(commentBtn).offset(-10);
            make.height.equalTo(@(15));
        }];

        //退换货
        returnedView = [UIView new];
        [self addSubview:returnedView];
        [returnedView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(commentView.mas_right);
            make.width.height.equalTo(paymentView);
        }];

        returnedBtn = [[ESImageButton alloc] initWithTitle:@"退换货" image:[UIImage imageNamed:@"myorder_returned_icon.png"] fontSize:12];
        [returnedBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [returnedView addSubview:returnedBtn];
        [returnedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.centerX.equalTo(returnedView);
        }];

        returnedBadgeLbl = [[ESLabel alloc] initWithText:@" 0 " textColor:[UIColor whiteColor] fontSize:10];
        [returnedBadgeLbl setBackgroundColor:[UIColor redColor]];
        [returnedBadgeLbl borderWidth:0.5f color:[UIColor whiteColor] cornerRadius:4];
        [returnedBadgeLbl setHidden:YES];
        [returnedView addSubview:returnedBadgeLbl];
        [returnedBadgeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(returnedBtn.mas_right).offset(-22);
            make.top.equalTo(returnedBtn).offset(-10);
            make.height.equalTo(@(15));
        }];


    }
    return self;
}

- (void)configData:(Member *)member {
    if(member == nil){
        [paymentBadgeLbl setHidden:YES];
        [shippingBadgeLbl setHidden:YES];
        [commentBadgeLbl setHidden:YES];
        [returnedBadgeLbl setHidden:YES];
        return;
    }
    if(member.paymentOrderCount > 0) {
        [paymentBadgeLbl setHidden:NO];
        paymentBadgeLbl.text = [NSString stringWithFormat:@" %d ", member.paymentOrderCount];
    }else{
        [paymentBadgeLbl setHidden:YES];
    }
    if(member.shippingOrderCount > 0){
        [shippingBadgeLbl setHidden:NO];
        shippingBadgeLbl.text = [NSString stringWithFormat:@" %d ",member.shippingOrderCount];
    }else{
        [shippingBadgeLbl setHidden:YES];
    }
    if(member.commentOrderCount > 0){
        [commentBadgeLbl setHidden:NO];
        commentBadgeLbl.text = [NSString stringWithFormat:@" %d ", member.commentOrderCount];
    }else{
        [commentBadgeLbl setHidden:YES];
    }
    if(member.returnedOrderCount > 0){
        [returnedBadgeLbl setHidden:NO];
        returnedBadgeLbl.text = [NSString stringWithFormat:@" %d ", member.returnedOrderCount];
    }else{
        [returnedBadgeLbl setHidden:YES];
    }
}


@end