//
// Created by Dawei on 5/31/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "CheckoutViewController.h"
#import "HeaderView.h"
#import "TPKeyboardAvoidingTableView.h"
#import "CheckoutAddressCell.h"
#import "Masonry.h"
#import "CheckoutGoodsCell.h"
#import "CheckoutPaymentCell.h"
#import "CheckoutReceiptCell.h"
#import "CheckoutCouponCell.h"
#import "CheckoutMoneyCell.h"
#import "CheckoutOperationView.h"
#import "AddressApi.h"
#import "ToastUtils.h"
#import "AddressEditViewController.h"
#import "Address.h"
#import "SelectAddressViewController.h"
#import "CartApi.h"
#import "CheckoutGoodsListViewController.h"
#import "PaymentShippingViewController.h"
#import "ReceiptViewController.h"
#import "CheckoutBonusViewController.h"
#import "PaymentShippingApi.h"
#import "Payment.h"
#import "OrderApi.h"
#import "Receipt.h"
#import "OrderPrice.h"
#import "Order.h"
#import "CheckoutSuccessViewController.h"
#import "PaymentViewController.h"
#import "Cart.h"

#define API_TIMES 4

@implementation CheckoutViewController {
    HeaderView *headerView;
    TPKeyboardAvoidingTableView *checkoutTableView;
    CheckoutOperationView *checkoutOperationView;

    AddressApi *addressApi;
    CartApi *cartApi;
    PaymentShippingApi *paymentShippingApi;
    OrderApi *orderApi;

    NSInteger apiTimes;

    Address *address;
    Cart *cart;
    NSMutableArray *paymentArray;
    NSArray *shippingTimeArray;

    Payment *payment;
    NSInteger shippingTime;
    Receipt *receipt;

    OrderPrice *orderPrice;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f1f2f7"];

    addressApi = [AddressApi new];
    cartApi = [CartApi new];
    paymentShippingApi = [PaymentShippingApi new];
    orderApi = [OrderApi new];

    shippingTimeArray = [NSArray arrayWithObjects:@"任意时间", @"仅工作日", @"仅休息日", nil];
    shippingTime = 0;

    receipt = [Receipt new];
    receipt.type = 0;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectAddressCompletion:) name:nSelectAddress object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectPaymentCompletion:) name:nSelectPaymentDelivery object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectReceiptCompletion:) name:nSelectReceipt object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectBonusCompletion:) name:nSelectBonus object:nil];

    headerView = [[HeaderView alloc] initWithTitle:@"填写订单"];
    [headerView setBackAction:@selector(back)];
    [self.view addSubview:headerView];

    [self setupUI];
    [self loadData];

}

/**
 * 创建UI并布局
 */
- (void)setupUI {
    checkoutTableView = [[TPKeyboardAvoidingTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    checkoutTableView.backgroundColor = [UIColor colorWithHexString:@"#f1f0f5"];
    checkoutTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [checkoutTableView registerClass:[CheckoutAddressCell class] forCellReuseIdentifier:kCellIdentifier_CheckoutAddressCell];
    [checkoutTableView registerClass:[CheckoutGoodsCell class] forCellReuseIdentifier:kCellIdentifier_CheckoutGoodsCell];
    [checkoutTableView registerClass:[CheckoutPaymentCell class] forCellReuseIdentifier:kCellIdentifier_CheckoutPaymentCell];
    [checkoutTableView registerClass:[CheckoutReceiptCell class] forCellReuseIdentifier:kCellIdentifier_CheckoutReceiptCell];
    [checkoutTableView registerClass:[CheckoutCouponCell class] forCellReuseIdentifier:kCellIdentifier_CheckoutCouponCell];
    [checkoutTableView registerClass:[CheckoutMoneyCell class] forCellReuseIdentifier:kCellIdentifier_CheckoutMoneyCell];
    checkoutTableView.dataSource = self;
    checkoutTableView.delegate = self;
    [self.view addSubview:checkoutTableView];
    checkoutTableView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);

    checkoutOperationView = [CheckoutOperationView new];
    [checkoutOperationView setCheckoutAction:@selector(checkout)];
    [self.view addSubview:checkoutOperationView];

    [checkoutTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];

    [checkoutOperationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.equalTo(@50);
    }];
    
//    UIView *tableFootView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 60)];
//    tableFootView.backgroundColor =[UIColor colorWithHexString:@"#f1f0f5"];
//   
//    checkoutTableView.tableFooterView = tableFootView;
//    [checkoutTableView addSubview:tableFootView];
//    
//    UILabel *messagelab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 60)];
//    messagelab.text = @"下单时间为每日上午8:30-晚上20:30，\n超出下单时间送货时间会延后，敬请谅解。";
//    messagelab.textColor = LBColor(51, 51, 51);
//    messagelab.font = [UIFont systemFontOfSize:14];
//    messagelab.textAlignment = NSTextAlignmentCenter;
//    messagelab.numberOfLines = 2;
//    [tableFootView addSubview:messagelab];
}

/**
 * 载入数据
 */
- (void)loadData {
    apiTimes = 0;
    [ToastUtils showLoading];

    //载入默认收货地址
    [addressApi getDefault:^(Address *_address) {
        address = _address;
        [self loadDataCompletion];
    }              failure:^(NSError *error) {
        address = nil;
        [self loadDataCompletion];
    }];

    //载入购物车数据
    [cartApi listSelected:^(Cart *_cart) {
        cart = _cart;
        [self loadDataCompletion];
    }     failure:^(NSError *error) {
        [self loadDataCompletion];
    }];

    //载入支付配送方式
    [paymentShippingApi list:^(NSMutableArray *_paymentArray, NSMutableArray *_shippingArray) {
        //格式化支付方式为货到付款、在线支付
        BOOL cod = NO;
        BOOL onlinePay = NO;
        paymentArray = [[NSMutableArray alloc] initWithCapacity:0];
        for(Payment *pay in _paymentArray) {
            if(pay.type == Payment_Cod && !cod){
                [paymentArray addObject:pay];
                cod = YES;
                continue;
            }
            if((pay.type == Payment_Alipay || pay.type == Payment_Wechat || pay.type == Payment_UnionPay) &&
                    !onlinePay){
                pay.name = @"在线支付";
                [paymentArray addObject:pay];
                onlinePay = YES;
                continue;
            }
        }

        if (paymentArray.count > 0) {
            payment = [paymentArray objectAtIndex:0];
        }
        [self loadDataCompletion];
    }                failure:^(NSError *error) {
        [self loadDataCompletion];
    }];

    //清除之前使用优惠券信息
    [orderApi useBonus:0 success:^{
        [self loadDataCompletion];
    }          failure:^(NSError *error) {
        [self loadDataCompletion];
    }];
}

/**
 * 载入数据完成
 */
- (void)loadDataCompletion {
    apiTimes++;
    if (apiTimes == API_TIMES) {
        //获取订单金额信息
        [self loadOrderPrice:^{
            [checkoutTableView reloadData];
        }];
        [ToastUtils hideLoading];

        //判断数据是否完整
        if(cart.storeList == nil || cart.storeList.count <= 0){
            [ToastUtils show:@"请将商品加入购物车后再提交订单!"];
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
        if(paymentArray == nil || paymentArray.count <= 0){
            [ToastUtils show:@"没有配置支付方式, 不能提交订单!"];
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
    }
}

/**
 * 载入订单金额信息
 */
- (void)loadOrderPrice:(void (^)())callback {
    [orderApi orderPrice:address.regionId shippingId:0 success:^(OrderPrice *_orderPrice) {
        orderPrice = _orderPrice;
        [checkoutOperationView setTotalPrice:orderPrice.paymentMoney];
        callback();
    }            failure:^(NSError *error) {
    }];
}


#pragma TableView

/**
 * 每行的高度
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 96;
    } else if (indexPath.section == 1) {
        return 90;
    } else if (indexPath.section == 2) {
        return 70;
    } else if (indexPath.section == 3) {
        return 70;
    } else if (indexPath.section == 4) {
        return 50;
    } else if (indexPath.section == 5) {
        return 120;
    }
    return 0;
}

/**
 * 每个区有几行
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

/**
 * 几个区
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 6;
}

/**
 * 行
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        CheckoutAddressCell *checkoutAddressCell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_CheckoutAddressCell forIndexPath:indexPath];
        checkoutAddressCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [checkoutAddressCell configData:address];
        return checkoutAddressCell;
    } else if (indexPath.section == 1) {
        CheckoutGoodsCell *checkoutGoodsCell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_CheckoutGoodsCell forIndexPath:indexPath];
        checkoutGoodsCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [checkoutGoodsCell configData:cart];
        return checkoutGoodsCell;
    } else if (indexPath.section == 2) {
        CheckoutPaymentCell *checkoutPaymentCell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_CheckoutPaymentCell forIndexPath:indexPath];
        checkoutPaymentCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [checkoutPaymentCell configData:payment cart:cart shippingTime:shippingTime];
        return checkoutPaymentCell;
    } else if (indexPath.section == 3) {
        CheckoutReceiptCell *checkoutReceiptCell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_CheckoutReceiptCell forIndexPath:indexPath];
        checkoutReceiptCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [checkoutReceiptCell configData:receipt];
        return checkoutReceiptCell;
    } else if (indexPath.section == 4) {
        CheckoutCouponCell *checkoutCouponCell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_CheckoutCouponCell forIndexPath:indexPath];
        checkoutCouponCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [checkoutCouponCell configData:cart];
        return checkoutCouponCell;
    } else if (indexPath.section == 5) {
        CheckoutMoneyCell *checkoutMoneyCell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_CheckoutMoneyCell forIndexPath:indexPath];
        checkoutMoneyCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [checkoutMoneyCell configData:orderPrice];
        return checkoutMoneyCell;
    }
    return nil;
}

/**
 * 每个区的头部高度
 */
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(section ==1)
    {
        return 50;
    }
    return 10;
}

/**
 * 每个区的尾部高度
 */
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

/**
 * 每个区的头部视图
 */
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if(section ==1)
    {
            UIView *tableFootView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 50)];
            tableFootView.backgroundColor =[UIColor colorWithHexString:@"#f1f0f5"];
        
            UILabel *messagelab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 50)];
        messagelab.text = @"温馨提示：下单时间为每日上午8:30-晚上20:30，\n超出下单时间送货时间会延后，敬请谅解。";
            messagelab.textColor = [UIColor redColor];
            messagelab.font = [UIFont systemFontOfSize:13];
            messagelab.textAlignment = NSTextAlignmentCenter;
            messagelab.numberOfLines = 2;
            [tableFootView addSubview:messagelab];
            return tableFootView;
    }
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 10)];
    headerView.backgroundColor = [UIColor colorWithHexString:@"#f1f2f6"];
    return headerView;
}

/**
 *  选中行
 *
 *  @param tableView
 *  @param indexPath
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //选择收货地址
    if (indexPath.section == 0) {
        if (address) {
            [self.navigationController pushViewController:[SelectAddressViewController new] animated:YES];
            return;
        }
        [self createAddress];
    } else if (indexPath.section == 1) {   //查看购物车商品清单
        CheckoutGoodsListViewController *checkoutGoodsListViewController = [CheckoutGoodsListViewController new];
        checkoutGoodsListViewController.cart = cart;
        [self.navigationController pushViewController:checkoutGoodsListViewController animated:YES];
    } else if (indexPath.section == 2) {
        PaymentShippingViewController *paymentShippingViewController = [PaymentShippingViewController new];
        paymentShippingViewController.paymentArray = paymentArray;
        paymentShippingViewController.cart = cart;
        paymentShippingViewController.shippingTimeArray = shippingTimeArray;
        paymentShippingViewController.payment = payment;
        paymentShippingViewController.shippingTime = shippingTime;
        if(address != nil){
            paymentShippingViewController.regionId = address.regionId;
        }else{
            paymentShippingViewController.regionId = 0;
        }
        [self.navigationController pushViewController:paymentShippingViewController animated:YES];
    } else if (indexPath.section == 3) {
        ReceiptViewController *receiptViewController = [ReceiptViewController new];
        receiptViewController.receipt = receipt;
        [self.navigationController pushViewController:receiptViewController animated:YES];
    } else if (indexPath.section == 4) {
        CheckoutBonusViewController *checkoutBonusViewController = [CheckoutBonusViewController new];
        checkoutBonusViewController.cart = cart;
        if(address != nil){
            checkoutBonusViewController.regionId = address.regionId;
        }else{
            checkoutBonusViewController.regionId = 0;
        }
        [self.navigationController pushViewController:checkoutBonusViewController animated:YES];
    }

}

/**
 * 后退
 */
- (IBAction)back {
    [self.navigationController popToRootViewControllerAnimated:YES];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

/**
 * 新建收货地址
 */
- (IBAction)createAddress {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectAddressCompletion:) name:nAddAddress object:nil];
    [self presentViewController:[AddressEditViewController new] animated:YES completion:nil];
}

/**
 * 去结算
 */
- (IBAction)checkout {
    if(cart.storeList.count>1)
    {
        [ToastUtils show:@"抱歉，本商城暂不支持跨店结算"];
        return;
    }
    [ToastUtils showLoading];
    Order *order = [Order new];
    order.addressId = address.id;
    order.paymentId = payment.id;
    order.shippingTime = [shippingTimeArray objectAtIndex:shippingTime];
    order.remark = @"";
    [orderApi create:order receipt:receipt success:^(Order *_order) {
        [ToastUtils hideLoading];

        //发送购物车商品项改变的通知
        [[NSNotificationCenter defaultCenter] postNotificationName:nCheckout object:nil];

        if(payment.type == Payment_Cod || _order.needPayMoney <= 0){
            CheckoutSuccessViewController *checkoutSuccessViewController = [CheckoutSuccessViewController new];
            checkoutSuccessViewController.payment = payment;
            checkoutSuccessViewController.order = _order;
            [self.navigationController pushViewController:checkoutSuccessViewController animated:YES];
            return;
        }

        PaymentViewController *paymentViewController = [PaymentViewController new];
        paymentViewController.orderId = _order.id;
        [self.navigationController pushViewController:paymentViewController animated:YES];

    } failure:^(NSError *error) {
        [ToastUtils hideLoading];
        [ToastUtils show:[error localizedDescription]];
    }];
}

/**
 * 选择地址完毕的回调
 */
- (void)selectAddressCompletion:(NSNotification *)notification {
    address = (Address *) [notification userInfo];
    [self loadOrderPrice:^{
        [checkoutTableView reloadData];
    }];
}

/**
 * 选择支付配送方式完毕的回调
 */
- (void)selectPaymentCompletion:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    payment = [userInfo objectForKey:@"payment"];
    shippingTime = [[userInfo objectForKey:@"shippingTime"] intValue];
    [self loadOrderPrice:^{
        [checkoutTableView reloadData];
    }];
}

/**
 * 选择发票信息完毕的回调
 */
- (void)selectReceiptCompletion:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    receipt = [userInfo objectForKey:@"receipt"];
    [checkoutTableView reloadData];
}

/**
 * 选择优惠券完毕的回调
 */
- (void)selectBonusCompletion:(NSNotification *)notification {
    [self loadOrderPrice:^{
        [checkoutTableView reloadData];
    }];
}

@end
