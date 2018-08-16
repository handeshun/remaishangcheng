//
// Created by Dawei on 6/26/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <AlipaySDK/AlipaySDK.h>
#import "PaymentViewController.h"
#import "Payment.h"
#import "Order.h"
#import "HeaderView.h"
#import "Masonry.h"
#import "PaymentTitleCell.h"
#import "PaymentCell.h"
#import "UIView+Common.h"
#import "ToastUtils.h"
#import "CheckoutSuccessViewController.h"
#import "AlipayPaymentHelper.h"
#import "WechatPayment.h"
#import "PaymentShippingApi.h"
#import "UPPaymentControl.h"
#import "OrderApi.h"
#import "PaymentManager.h"
#import "NSDictionary+Common.h"

#define kMode_Development             @"00"

@implementation PaymentViewController {
    HeaderView *headerView;
    UITableView *paymentTable;

    Order *order;
    NSMutableArray *paymentList;

    OrderApi *orderApi;
    PaymentShippingApi *paymentShippingApi;

    //当前使用的支付方式
    Payment *currentPayment;
}

@synthesize orderId, type;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    orderApi = [OrderApi new];
    paymentShippingApi = [PaymentShippingApi new];

    paymentList = [[NSMutableArray alloc] initWithCapacity:0];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(becomeActive)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(paymentResult:)
                                                 name:nPaymentResult
                                               object:nil];

    headerView = [[HeaderView alloc] initWithTitle:@"收银台"];
    [headerView setBackAction:@selector(back)];
    [self.view addSubview:headerView];

    [self setupUI];
    [self loadData];
}

- (void)setupUI {
    paymentTable = [UITableView new];
    paymentTable.backgroundColor = [UIColor colorWithHexString:@"#f3f4f6"];
    paymentTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    paymentTable.dataSource = self;
    paymentTable.delegate = self;
    [paymentTable registerClass:[PaymentTitleCell class] forCellReuseIdentifier:kCellIdentifier_PaymentTitleCell];
    [paymentTable registerClass:[PaymentCell class] forCellReuseIdentifier:kCellIdentifier_PaymentCell];
    [self.view addSubview:paymentTable];
    [paymentTable mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
}

- (void)loadData {
    [ToastUtils showLoading];
    [orderApi detail:orderId success:^(Order *_order, Receipt *receipt) {
        order = _order;

        if(order.needPayMoney <= 0){
            [ToastUtils hideLoading];
            CheckoutSuccessViewController *checkoutSuccessViewController = [CheckoutSuccessViewController new];
            checkoutSuccessViewController.type = 1;
            checkoutSuccessViewController.order = order;
            checkoutSuccessViewController.payment = currentPayment;
            [self.navigationController pushViewController:checkoutSuccessViewController animated:YES];
            return;
        }

        [self loadPayment];
    }        failure:^(NSError *error) {

    }];
}

/**
 * 载入支付方式列表
 */
- (void)loadPayment {
    [paymentShippingApi list:^(NSMutableArray *paymentArray, NSMutableArray *shippingArray) {
        [ToastUtils hideLoading];
        for (Payment *payment in paymentArray) {
            if (payment.type == Payment_Alipay || payment.type == Payment_Wechat || payment.type == Payment_UnionPay) {
                [paymentList addObject:payment];
            }
        }
        [paymentTable reloadData];
    }                failure:^(NSError *error) {
        [ToastUtils hideLoading];
    }];
}

/**
 * 每行的高度
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

/**
 * 每个区有几行
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0)
        return 1;
    return paymentList.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

/**
 * 行
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        PaymentTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_PaymentTitleCell forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell configData:order.needPayMoney];
        return cell;
    } else if (indexPath.section == 1) {
        PaymentCell *paymentCell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_PaymentCell forIndexPath:indexPath];
        paymentCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [paymentCell configData:[paymentList objectAtIndex:indexPath.row]];
        return paymentCell;
    }
    return [UITableViewCell new];
}


/**
 * 每个区的头部高度
 */
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01f;
}

/**
 * 每个区的尾部高度
 */
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

/**
 * 每个区的尾部视图
 */
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 10)];
    footerView.backgroundColor = [UIColor colorWithHexString:@"#f3f4f6"];
    if (section == 0) {
        [footerView bottomBorder:[UIColor colorWithHexString:@"#e4e5e7"]];
    }
    return footerView;
}

/**
 *  选中行
 *
 *  @param tableView
 *  @param indexPath
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0)
        return;
    if(order.needPayMoney <= 0){
        [ToastUtils show:@"订单支付金额为0元，不能在线支付，请联系客服修改订单状态！"];
        return;
    }
    currentPayment = [paymentList objectAtIndex:indexPath.row];
    [self pay];
}

/**
 * 后退
 */
- (IBAction)back {
    if(type > 0){
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 * 发起支付
 */
- (void)pay {
    [ToastUtils showLoading:@"支付中..."];
    [paymentShippingApi payment:order.id paymentId:currentPayment.id success:^(NSString *payhtml) {

        if (currentPayment.type == Payment_Alipay) {
            [self alipay:payhtml];
        } else if (currentPayment.type == Payment_Wechat) {
            [self wechat:payhtml];
        } else if (currentPayment.type == Payment_UnionPay) {
            [self unionpay:payhtml];
        }

    }                   failure:^(NSError *error) {
        [ToastUtils hideLoading];
        [ToastUtils show:[error localizedDescription]];
    }];
}

/**
 *  支付宝支付
 *
 *  @param sender
 */
- (void)alipay:(NSString *)payhtml {
    NSString *orderString = [AlipayPaymentHelper generateOrderString:order withPayment:currentPayment];
    [[AlipaySDK defaultService] payOrder:orderString fromScheme:@"javamallsss" callback:^(NSDictionary *resultDic) {
        int resultStatus = [[resultDic objectForKey:@"resultStatus"] intValue];
        [PaymentManager alipayResult:resultStatus];
    }];
}

/**
 *  微信支付
 *
 *  @param sender
 */
- (void)wechat:(NSString *)payhtml {
    //创建支付签名对象
    WechatPayment *wechatPayment = [[WechatPayment alloc] init];
    [wechatPayment init:order withPayment:currentPayment];

    //获取到实际调起微信支付的参数后，在app端调起支付
    NSMutableDictionary *dict = [wechatPayment pay];
    if (dict == nil) {
        [self paymentCallback:0 message:@"订单支付失败！"];
    } else {
        NSMutableString *stamp = [dict objectForKey:@"timestamp"];

        //调起微信支付
        PayReq *req = [[PayReq alloc] init];
        req.openID = [dict objectForKey:@"appid"];
        req.partnerId = [dict objectForKey:@"partnerid"];
        req.prepayId = [dict objectForKey:@"prepayid"];
        req.nonceStr = [dict objectForKey:@"noncestr"];
        req.timeStamp = stamp.intValue;
        req.package = [dict objectForKey:@"package"];
        req.sign = [dict objectForKey:@"sign"];
        [WXApi sendReq:req];
    }
}

/**
 *  银联支付
 *
 *  @param sender
 */
- (void)unionpay:(NSString *)payhtml {
    [[UPPaymentControl defaultControl]
            startPay:payhtml
          fromScheme:@"javashop"
                mode:kMode_Development
      viewController:self];
}

/**
* 处理支付结果
*/
- (void)paymentCallback:(int)result message:(NSString *)msg {
    [ToastUtils hideLoading];
    if (result == 0) {
        [ToastUtils show:msg];
        return;
    } else if (result == 1) {
        CheckoutSuccessViewController *checkoutSuccessViewController = [CheckoutSuccessViewController new];
        checkoutSuccessViewController.type = 1;
        checkoutSuccessViewController.order = order;
        checkoutSuccessViewController.payment = currentPayment;
        [self.navigationController pushViewController:checkoutSuccessViewController animated:YES];
        return;
    } else if (result == 2) {
        [ToastUtils show:@"订单正在处理中，请您稍后查询订单状态！"];
        NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:0], @"index", nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:nToRoot object:nil userInfo:userInfo];
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        return;
    }
}

/**
 * 应用被重新激活
 */
- (void)becomeActive {
    [ToastUtils hideLoading];
}

/**
 * 响应支付完成的通知
 */
- (void)paymentResult:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    if (userInfo == nil || ![userInfo has:@"result"]) {
        [ToastUtils hideLoading];
        return;
    }
    int result = [[userInfo objectForKey:@"result"] intValue];
    NSString *message = [userInfo objectForKey:@"message"];
    [self paymentCallback:result message:message];
}

@end
