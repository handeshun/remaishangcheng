//
// Created by Dawei on 6/26/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "CheckoutSuccessViewController.h"
#import "HeaderView.h"
#import "Payment.h"
#import "Masonry.h"
#import "ESLabel.h"
#import "ESButton.h"
#import "UIView+Common.h"
#import "Order.h"
#import "PaymentViewController.h"
#import "MyOrderViewController.h"


@implementation CheckoutSuccessViewController {
    HeaderView *headerView;

    ESLabel *paymentTitleLbl;
    ESLabel *paymentLbl;

    ESLabel *amountTitleLbl;
    ESLabel *amountLbl;

    ESButton *orderBtn;
    ESButton *indexBtn;

    ESButton *finishBtn;
}

@synthesize type;
@synthesize order, payment;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    headerView = [[HeaderView alloc] initWithTitle:@"订单提交成功"];
    if (type == 1) {
        headerView.titleLbl.text = @"订单支付成功";
    }
    [self.view addSubview:headerView];

    [self setupUI];
    [self loadData];
}

- (void)setupUI {
    finishBtn = [[ESButton alloc] initWithTitle:@"完成" color:[UIColor darkGrayColor] fontSize:14];
    [finishBtn addTarget:self action:@selector(finish) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:finishBtn];
    [finishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(headerView).offset(-10);
        make.bottom.equalTo(headerView).offset(-5);
    }];

    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checkout_success_icon.png"]];
    [self.view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView.mas_bottom).offset(30);
        make.left.equalTo(self.view).offset(30);
    }];

    paymentTitleLbl = [[ESLabel alloc] initWithText:@"支付方式:" textColor:[UIColor darkGrayColor] fontSize:14];
    [self.view addSubview:paymentTitleLbl];
    [paymentTitleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageView.mas_right).offset(5);
        make.top.equalTo(imageView).offset(10);
    }];

    paymentLbl = [[ESLabel alloc] initWithText:@"在线支付" textColor:[UIColor redColor] fontSize:14];
    [self.view addSubview:paymentLbl];
    [paymentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(paymentTitleLbl.mas_right).offset(10);
        make.top.equalTo(paymentTitleLbl);
    }];

    amountTitleLbl = [[ESLabel alloc] initWithText:@"订单金额:" textColor:[UIColor darkGrayColor] fontSize:14];
    [self.view addSubview:amountTitleLbl];
    [amountTitleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(paymentTitleLbl);
        make.top.equalTo(paymentTitleLbl.mas_bottom).offset(10);
    }];

    amountLbl = [[ESLabel alloc] initWithText:@"" textColor:[UIColor redColor] fontSize:14];
    [self.view addSubview:amountLbl];
    [amountLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(paymentLbl);
        make.top.equalTo(amountTitleLbl);
    }];

    orderBtn = [[ESButton alloc] initWithTitle:@"查看订单" color:[UIColor darkGrayColor] fontSize:14];
    [orderBtn borderWidth:0.5f color:[UIColor darkGrayColor] cornerRadius:4];
    [orderBtn addTarget:self action:@selector(viewOrder) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:orderBtn];
    [orderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageView.mas_bottom).offset(50);
        make.left.equalTo(self.view).offset((kScreen_Width - 240) / 2);
        make.height.equalTo(@40);
        make.width.equalTo(@100);
    }];

    indexBtn = [[ESButton alloc] initWithTitle:@"回首页" color:[UIColor darkGrayColor] fontSize:14];
    [indexBtn borderWidth:0.5f color:[UIColor darkGrayColor] cornerRadius:4];
    [indexBtn addTarget:self action:@selector(toIndex) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:indexBtn];
    [indexBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(orderBtn.mas_right).offset(40);
        make.width.height.top.equalTo(orderBtn);
    }];

}

- (void)loadData {
    amountLbl.text = [NSString stringWithFormat:@"￥%.2f", order.orderAmount];
    if(payment != nil){
        paymentLbl.text = payment.name;
    }
}

/**
 * 完成
 */
- (IBAction)finish {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

/**
 * 查看订单
 */
-(IBAction)viewOrder{
    MyOrderViewController *myOrderViewController = [MyOrderViewController new];
    myOrderViewController.orderId = order.id;
    [self.navigationController pushViewController:myOrderViewController animated:YES];
}

/**
 * 回首页
 */
-(IBAction)toIndex{
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:0], @"index", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:nToRoot object:nil userInfo:userInfo];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end