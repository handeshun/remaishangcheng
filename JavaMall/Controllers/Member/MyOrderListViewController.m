//
// Created by Dawei on 6/29/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "MyOrderListViewController.h"
#import "HeaderView.h"
#import "Masonry.h"
#import "MyOrderListCell.h"
#import "Order.h"
#import "ESButton.h"
#import "MJRefresh.h"
#import "OrderApi.h"
#import "ToastUtils.h"
#import "MyOrderViewController.h"
#import "ReturnedOrderListViewController.h"
#import "CancelOrderViewController.h"
#import "PaymentViewController.h"
#import "MyReturnedOrderViewController.h"
#import "MyOrderDeliveryViewController.h"

@implementation MyOrderListViewController {
    HeaderView *headerView;
    UITableView *orderTable;

    OrderApi *orderApi;

    NSMutableArray *orderArray;
    int page;
}

@synthesize status;

- (void)viewDidLoad {
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orderStatusChanged:) name:nOrderStatusChanged object:nil];

    self.view.backgroundColor = [UIColor colorWithHexString:@"#f1f2f7"];
    orderApi = [OrderApi new];
    page = 1;

    headerView = [[HeaderView alloc] initWithTitle:@"我的订单"];
    switch (status) {
        case OrderStatus_NOPAY:
            headerView.titleLbl.text = @"待付款订单";
            break;
        case OrderStatus_SHIP:
            headerView.titleLbl.text = @"待收货订单";
            break;
    }
    [headerView setBackAction:@selector(back)];
    [self.view addSubview:headerView];

    [self setupUI];
    [self loadData];
}

- (void)setupUI {
    orderTable = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    orderTable.backgroundColor = [UIColor colorWithHexString:@"#f3f4f6"];
    orderTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    orderTable.dataSource = self;
    orderTable.delegate = self;
    [orderTable registerClass:[MyOrderListCell class] forCellReuseIdentifier:kCellIdentifier_MyOrderListCell];
    orderTable.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        page++;
        [self loadData];
    }];
    [self.view addSubview:orderTable];
    [orderTable mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
}

- (void)loadData {
    [ToastUtils showLoading];
    [orderApi list:status page:page success:^(NSMutableArray *_orderArray) {
        if (orderArray == nil) {
            orderArray = [NSMutableArray arrayWithCapacity:_orderArray.count];
        }
        [ToastUtils hideLoading];
        if (page == 1) {
            [orderArray removeAllObjects];
        }
        orderTable.mj_footer.hidden = _orderArray.count < 20;   //没有更多数据时隐藏'加载更多'
        [orderTable.mj_footer endRefreshing];
        [orderArray addObjectsFromArray:_orderArray];
        [orderTable reloadData];
    }      failure:^(NSError *error) {
        [ToastUtils hideLoading];
        [ToastUtils show:[error localizedDescription]];
    }];
}

/**
 * 每行的高度
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    Order *order = [orderArray objectAtIndex:indexPath.section];
    float height = 155+35;
    if(order.gift != nil || order.bonus != nil){
        height += 25+35;
    }
    return height;
}

/**
 * 每个区有几行
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

/**
 * 有几个区
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [orderArray count];
}

/**
 * 行
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyOrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_MyOrderListCell forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell configData:[orderArray objectAtIndex:indexPath.section]];

    [cell.paymentBtn addTarget:self action:@selector(payment:) forControlEvents:UIControlEventTouchUpInside];
    cell.paymentBtn.tag = indexPath.section;

    [cell.returnedBtn addTarget:self action:@selector(returned:) forControlEvents:UIControlEventTouchUpInside];
    cell.returnedBtn.tag = indexPath.section;

    [cell.cancelBtn addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    cell.cancelBtn.tag = indexPath.section;

    [cell.rogBtn addTarget:self action:@selector(rog:) forControlEvents:UIControlEventTouchUpInside];
    cell.rogBtn.tag = indexPath.section;

    [cell.deliveryBtn addTarget:self action:@selector(lookDelivry:) forControlEvents:UIControlEventTouchUpInside];
    cell.deliveryBtn.tag = indexPath.section;
    
    [cell.viewReturnedBtn addTarget:self action:@selector(viewReturned:) forControlEvents:UIControlEventTouchUpInside];
    cell.viewReturnedBtn.tag = indexPath.section;
  

    return cell;
}


/**
 * 每个区的头部高度
 */
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
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
    Order *order = [orderArray objectAtIndex:indexPath.section];

    MyOrderViewController *myOrderViewController = [MyOrderViewController new];
    myOrderViewController.orderId = order.id;

    [self.navigationController pushViewController:myOrderViewController animated:YES];
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
 * 支付
 */
- (IBAction)payment:(ESButton *)sender {
    Order *order = [orderArray objectAtIndex:sender.tag];
    PaymentViewController *paymentViewController = [PaymentViewController new];
    paymentViewController.orderId = order.id;
    paymentViewController.type = 1;
    [self.navigationController pushViewController:paymentViewController animated:YES];
}

/**
 * 确认收货
 */
- (IBAction) rog:(ESButton *)sender {
    Order *order = [orderArray objectAtIndex:sender.tag];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请您确认收到货确再进行此操作，否则会有可能财货两空！" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }];
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"确认收货" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [ToastUtils showLoading];
        [orderApi rogConfirm:order.id success:^{
            [ToastUtils hideLoading];
            [ToastUtils show:@"确认收货成功!"];
            order.status = OrderStatus_ROG;
            [[NSNotificationCenter defaultCenter] postNotificationName:nOrderStatusChanged object:order];
        }            failure:^(NSError *error) {
            [ToastUtils hideLoading];
            [ToastUtils show:[error localizedDescription]];
        }];

    }];
    [alertController addAction:cancelAction];
    [alertController addAction:otherAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

/**
 * 退货
 */
- (IBAction)returned:(ESButton *)sender {
    Order *order = [orderArray objectAtIndex:sender.tag];
    ReturnedOrderListViewController *myReturnedOrderListViewController = [ReturnedOrderListViewController new];
    myReturnedOrderListViewController.order = order;
    [self.navigationController pushViewController:myReturnedOrderListViewController animated:YES];
}

/**
 * 查看售后
 * @param sender
 */
- (IBAction)viewReturned:(ESButton *)sender {
    Order *order = [orderArray objectAtIndex:sender.tag];
    MyReturnedOrderViewController *myReturnedOrderViewController = [MyReturnedOrderViewController new];
    myReturnedOrderViewController.orderId = order.id;
    [self.navigationController pushViewController:myReturnedOrderViewController animated:YES];
}

/**
 * 取消订单
 */
- (IBAction)cancel:(ESButton *)sender {
    Order *order = [orderArray objectAtIndex:sender.tag];
    CancelOrderViewController *cancelOrderViewController = [CancelOrderViewController new];
    cancelOrderViewController.order = order;
    [self.navigationController pushViewController:cancelOrderViewController animated:YES];
}

/**
 * 查看物流
 */
-(IBAction)lookDelivry:(ESButton*)sender
{
     Order *order = [orderArray objectAtIndex:sender.tag];
    if(order.status != OrderStatus_SHIP){
        return;
    }
    MyOrderDeliveryViewController *myOrderDeliveryViewController = [MyOrderDeliveryViewController new];
    myOrderDeliveryViewController.orderId = order.id;
    [self.navigationController pushViewController:myOrderDeliveryViewController animated:YES];
}
/**
 * 订单状态变化的通知
 */
- (void)orderStatusChanged:(NSNotification *)notification {
    Order *order = notification.object;
    if (order == nil) {
        return;
    }
    for (Order *o in orderArray) {
        if (o.id == order.id) {
            o.status = order.status;
        }
    }
    [orderTable reloadData];
}

@end
