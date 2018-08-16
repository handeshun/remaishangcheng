//
// Created by Dawei on 7/3/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "MyOrderViewController.h"
#import "HeaderView.h"
#import "TPKeyboardAvoidingTableView.h"
#import "OrderOperationView.h"
#import "Masonry.h"
#import "MyOrderSnCell.h"
#import "Order.h"
#import "MyOrderAddressCell.h"
#import "OrderItem.h"
#import "MyOrderGoodsCell.h"
#import "MyOrderTitleCell.h"
#import "MyOrderContentCell.h"
#import "Receipt.h"
#import "MyOrderAmountCell.h"
#import "ToastUtils.h"
#import "OrderApi.h"
#import "ESButton.h"
#import "CancelOrderViewController.h"
#import "ReturnedOrderListViewController.h"
#import "UIAlertController+SupportedInterfaceOrientations.h"
#import "PaymentViewController.h"
#import "MyReturnedOrderViewController.h"
#import "MyOrderDeliveryViewController.h"
#import "MyOrderGiftCell.h"
#import "MyOrderBonusCell.h"


@implementation MyOrderViewController {
    HeaderView *headerView;
    TPKeyboardAvoidingTableView *myTable;
    OrderOperationView *operationView;

    OrderApi *orderApi;

    Order *order;
    Receipt *receipt;
}

@synthesize orderId;

- (void)viewDidLoad {
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orderStatusChanged:) name:nOrderStatusChanged object:nil];

    self.view.backgroundColor = [UIColor colorWithHexString:@"#f1f2f7"];
    orderApi = [OrderApi new];

    headerView = [[HeaderView alloc] initWithTitle:@"订单详情"];
    [headerView setBackAction:@selector(back)];
    [self.view addSubview:headerView];

    [self setupUI];
    [self loadData];

}

/**
 * 创建UI并布局
 */
- (void)setupUI {
    myTable = [[TPKeyboardAvoidingTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    myTable.backgroundColor = [UIColor colorWithHexString:@"#f1f0f5"];
    myTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [myTable registerClass:[MyOrderSnCell class] forCellReuseIdentifier:kCellIdentifier_MyOrderSnCell];
    [myTable registerClass:[MyOrderAddressCell class] forCellReuseIdentifier:kCellIdentifier_MyOrderAddressCell];
    [myTable registerClass:[MyOrderGoodsCell class] forCellReuseIdentifier:kCellIdentifier_MyOrderGoodsCell];
    [myTable registerClass:[MyOrderGiftCell class] forCellReuseIdentifier:kCellIdentifier_MyOrderGiftCell];
    [myTable registerClass:[MyOrderBonusCell class] forCellReuseIdentifier:kCellIdentifier_MyOrderBonusCell];
    [myTable registerClass:[MyOrderTitleCell class] forCellReuseIdentifier:kCellIdentifier_MyOrderTitleCell];
    [myTable registerClass:[MyOrderContentCell class] forCellReuseIdentifier:kCellIdentifier_MyOrderContentCell];
    [myTable registerClass:[MyOrderAmountCell class] forCellReuseIdentifier:kCellIdentifier_MyOrderAmountCell];
    myTable.dataSource = self;
    myTable.delegate = self;
    [self.view addSubview:myTable];
    myTable.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);

    operationView = [OrderOperationView new];
    [operationView.paymentBtn addTarget:self action:@selector(payment:) forControlEvents:UIControlEventTouchUpInside];
    [operationView.rogBtn addTarget:self action:@selector(rog:) forControlEvents:UIControlEventTouchUpInside];
    [operationView.returnedBtn addTarget:self action:@selector(returned:) forControlEvents:UIControlEventTouchUpInside];
    [operationView.cancelBtn addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    [operationView.viewReturnedBtn addTarget:self action:@selector(viewReturned:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:operationView];

    [myTable mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];

    [operationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.equalTo(@50);
    }];
}

/**
 * 载入数据
 */
- (void)loadData {
    [ToastUtils showLoading];
    [orderApi detail:orderId success:^(Order *_order, Receipt *_receipt) {
        order = _order;
        receipt = _receipt;
        [myTable reloadData];
        [operationView configData:order];

        if (operationView.paymentBtn.isHidden &&
                operationView.cancelBtn.isHidden &&
                operationView.rogBtn.isHidden &&
                operationView.returnedBtn.isHidden &&
                operationView.viewReturnedBtn.isHidden) {
            [operationView setHidden:YES];
            myTable.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        }

        [ToastUtils hideLoading];
    }        failure:^(NSError *error) {
        [ToastUtils hideLoading];
        [ToastUtils show:[error localizedDescription]];
    }];
}

#pragma TableView

/**
 * 每行的高度
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 40;
    } else if (indexPath.section == 1) {
        return 90;
    } else if (indexPath.section == 2) {
        return 80;
    } else if (indexPath.section == 3) {
        if (indexPath.row == 0) {
            return 44;
        }
        if (indexPath.row ==3) {
            if(receipt.type==1){
                return 60;
            }
            if (receipt==nil) {
                return 35;
            }
            return 80;
        }
        if (indexPath.row==4) {
            return  0;
        }
        return 35;
    } else if (indexPath.section == 4) {
        return 190;
    }
    return 0;
}

/**
 * 每个区有几行
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    if (section == 1) {
        return 1;
    }
    if (section == 2) {
        int number = order.orderItems.count;
        if(order.gift != nil){
            number++;
        }
        if(order.bonus != nil){
            number++;
        }
        return number;
    }
    if (section == 3) {
        if (receipt == nil) {
            return 4;
        }
        return 5;
    }
    return 1;
}

/**
 * 几个区
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

/**
 * 行
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        MyOrderSnCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_MyOrderSnCell forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell configData:order];
        return cell;
    }
    if (indexPath.section == 1) {
        MyOrderAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_MyOrderAddressCell forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell configData:order];
        return cell;
    }
    if (indexPath.section == 2) {
        if(indexPath.row < order.orderItems.count) {
            MyOrderGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_MyOrderGoodsCell forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell configData:[order.orderItems objectAtIndex:indexPath.row]];
            return cell;
        }
        //赠品或优惠券
        if(indexPath.row == order.orderItems.count){
            if(order.gift != nil){
                MyOrderGiftCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_MyOrderGiftCell forIndexPath:indexPath];
                [cell configData:order.gift];
                return cell;
            }else {
                MyOrderBonusCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_MyOrderBonusCell forIndexPath:indexPath];
                [cell configData:order.bonus];
                return cell;
            }
        }
        //优惠券
        if(indexPath.row > order.orderItems.count){
            MyOrderBonusCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_MyOrderBonusCell forIndexPath:indexPath];
            [cell configData:order.bonus];
            return cell;
        }
    }
    if (indexPath.section == 3) {
        if (indexPath.row == 0) {
            MyOrderTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_MyOrderTitleCell forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell configData:@"支付方式" value:order.paymentName headerLine:YES footerLine:YES];
            return cell;
        }
        if (indexPath.row == 1) {
            MyOrderTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_MyOrderTitleCell forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell configData:@"配送方式" value:order.shippingName headerLine:NO footerLine:NO];
            if(order.status == OrderStatus_SHIP) {
                [cell showArrow];
            }
            return cell;
        }
        if (indexPath.row == 2) {
            MyOrderTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_MyOrderTitleCell forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if(order.shippingTime == nil || ![order.shippingTime isKindOfClass:[NSString class]] || order.shippingTime.length <= 0){
                [cell configData:@"配送时间" value:@"任意时间" headerLine:NO footerLine:YES];
            }else {
                [cell configData:@"配送时间" value:order.shippingTime headerLine:NO footerLine:YES];
            }
            return cell;
        }
        if (indexPath.row == 3) {
            MyOrderTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_MyOrderTitleCell forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if(receipt == nil) {
                [cell configData:@"发票信息" value:@"不开发票" headerLine:YES footerLine:YES];
            } else{
                if (receipt.type==2) {
                 [cell configData:@"发票信息" value:receipt.title content:receipt.content duby:receipt.duby  headerLine:YES footerLine:YES];
                }else{
                [cell configData:@"发票信息" value:@"个人" content:receipt.content  headerLine:YES footerLine:YES];
                }
            }
            return cell;
        }
//        if (indexPath.row == 4) {
//            MyOrderTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_MyOrderTitleCell forIndexPath:indexPath];
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            [cell configData:@"" value:receipt.content headerLine:NO footerLine:NO];
//            return cell;
//        }
    }
    if (indexPath.section == 4) {
        MyOrderAmountCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_MyOrderAmountCell forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell configData:order];
        return cell;
    }
    return [UITableViewCell new];
}

/**
 * 每个区的头部高度
 */
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0)
        return 0.01f;
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
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 10)];
    view.backgroundColor = [UIColor colorWithHexString:@"#f1f2f6"];
    if (section == 2) {
        UIView *line = [UIView new];
        line.backgroundColor = [UIColor colorWithHexString:@"#e4e5e7"];
        [view addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(view);
            make.height.equalTo(@0.5f);
        }];
    }
    return view;
}

/**
 *  选中行
 *
 *  @param tableView
 *  @param indexPath
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //查询物流信息
    if(indexPath.section == 3 && indexPath.row == 1){
        if(order.status != OrderStatus_SHIP){
            return;
        }
        MyOrderDeliveryViewController *myOrderDeliveryViewController = [MyOrderDeliveryViewController new];
        myOrderDeliveryViewController.orderId = order.id;
        [self.navigationController pushViewController:myOrderDeliveryViewController animated:YES];
    }
}

/**
 * 后退
 */
- (IBAction)back {
    if (self.navigationController != nil) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 * 去支付
 */
- (IBAction)payment:(ESButton *)sender {
    PaymentViewController *paymentViewController = [PaymentViewController new];
    paymentViewController.orderId = order.id;
    paymentViewController.type = 1;
    [self.navigationController pushViewController:paymentViewController animated:YES];
}

/**
 * 确认收货
 */
- (IBAction) rog:(ESButton *)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请您确认收到货确再进行此操作，否则会有可能财货两空！" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {}];
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"确认收货" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [ToastUtils showLoading];
        [orderApi rogConfirm:order.id success:^{
            [ToastUtils hideLoading];
            [ToastUtils show:@"确认收货成功!"];
            order.status = OrderStatus_ROG;
            [[NSNotificationCenter defaultCenter] postNotificationName:nOrderStatusChanged object:order];
        } failure:^(NSError *error) {
            [ToastUtils hideLoading];
            [ToastUtils show:[error localizedDescription]];
        }];

    }];
    [alertController addAction:cancelAction];
    [alertController addAction:otherAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

/**
 * 申请售后
 */
- (IBAction) returned:(ESButton *)sender {
    ReturnedOrderListViewController *myReturnedOrderListViewController = [ReturnedOrderListViewController new];
    myReturnedOrderListViewController.order = order;
    [self.navigationController pushViewController:myReturnedOrderListViewController animated:YES];
}

/**
 * 查看售后
 */
- (IBAction) viewReturned:(ESButton *)sender {
    MyReturnedOrderViewController *myReturnedOrderViewController = [MyReturnedOrderViewController new];
    myReturnedOrderViewController.orderId = order.id;
    [self.navigationController pushViewController:myReturnedOrderViewController animated:YES];
}

/**
 * 取消订单
 */
- (IBAction) cancel:(ESButton *)sender {
    CancelOrderViewController *cancelOrderViewController = [CancelOrderViewController new];
    cancelOrderViewController.order = order;
    [self.navigationController pushViewController:cancelOrderViewController animated:YES];
}

/**
 * 订单状态变化的通知
 */
- (void)orderStatusChanged:(NSNotification *)notification {
    Order *_order = notification.object;
    if(_order == nil){
        return;
    }
    order.status = _order.status;
    [operationView configData:order];
}

@end
