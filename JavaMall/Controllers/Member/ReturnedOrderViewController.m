//
// Created by Dawei on 7/3/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "ReturnedOrderViewController.h"
#import "HeaderView.h"
#import "Masonry.h"
#import "ReturnedOrderGoodsCell.h"
#import "ReturnedOrderNumberCell.h"
#import "ReturnedOrderBackWayCell.h"
#import "Order.h"
#import "OrderItem.h"
#import "ReturnedOrderRemarkCell.h"
#import "OrderItem.h"
#import "TPKeyboardAvoidingTableView.h"
#import "RedButtonCell.h"
#import "ESRedButton.h"
#import "ReturnedOrder.h"
#import "ReturnedOrderItem.h"
#import "ESTextField.h"
#import "ESTextView.h"
#import "ToastUtils.h"
#import "OrderApi.h"
#import "ReturnedOrderShipCell.h"
#import "ReturnedOrderReasonCell.h"
#import "SelectValueView.h"
#import "ESRadioButton.h"


@implementation ReturnedOrderViewController {
    HeaderView *headerView;
    TPKeyboardAvoidingTableView *orderTable;

    ReturnedOrderShipCell *returnedOrderShipCell;
    ReturnedOrderBackWayCell *returnedOrderBackWayCell;
    ReturnedOrderReasonCell *returnedOrderReasonCell;
    ReturnedOrderRemarkCell *returnedOrderRemarkCell;

    SelectValueView *selectReasonView;
    NSString *reason;
    NSMutableArray *reasonArray0;
    NSMutableArray *reasonArray1;

    OrderApi *orderApi;
}

@synthesize order;

- (void)viewDidLoad {
    [super viewDidLoad];

    reasonArray0 = [[NSMutableArray alloc] initWithObjects:@"买错/不想要", @"未按照时间发货", @"快递一直没有收到", @"快递无记录", @"其它", nil];
    reasonArray1 = [[NSMutableArray alloc] initWithObjects:@"商品质量有问题", @"收到商品与描述不符", @"不喜欢/不想要", @"发票问题", @"空包裹", @"其它", nil];

    self.view.backgroundColor = [UIColor colorWithHexString:@"#f1f2f7"];
    orderApi = [OrderApi new];

    headerView = [[HeaderView alloc] initWithTitle:@"申请退货"];
    [headerView setBackAction:@selector(back)];
    [self.view addSubview:headerView];

    [self setupUI];

}

- (void)setupUI {
    orderTable = [[TPKeyboardAvoidingTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    orderTable.backgroundColor = [UIColor colorWithHexString:@"#f3f4f6"];
    orderTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    orderTable.dataSource = self;
    orderTable.delegate = self;
    [orderTable registerClass:[ReturnedOrderGoodsCell class] forCellReuseIdentifier:kCellIdentifier_ReturnedOrderGoodsCell];
    [orderTable registerClass:[ReturnedOrderShipCell class] forCellReuseIdentifier:kCellIdentifier_ReturnedOrderShipCell];
    [orderTable registerClass:[ReturnedOrderBackWayCell class] forCellReuseIdentifier:kCellIdentifier_ReturnedOrderBackWayCell];
    [orderTable registerClass:[ReturnedOrderReasonCell class] forCellReuseIdentifier:kCellIdentifier_ReturnedOrderReasonCell];
    [orderTable registerClass:[ReturnedOrderRemarkCell class] forCellReuseIdentifier:kCellIdentifier_ReturnedOrderRemarkCell];
    [orderTable registerClass:[RedButtonCell class] forCellReuseIdentifier:kCellIdentifier_RedButtonCell];
    [self.view addSubview:orderTable];
    [orderTable mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
}

/**
 * 每行的高度
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 100;
    }
    if (indexPath.section == 1) {
        return 75;
    }
    if (indexPath.section == 2) {
        return 160;
    }
    if(indexPath.section == 3){
        return 50;
    }
    if (indexPath.section == 4) {
        return 150;
    }
    if (indexPath.section == 5) {
        return 50;
    }
    return 0;
}

/**
 * 每个区有几行
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0){
        return order.orderItems.count;
    }
    return 1;
}

/**
 * 有几个区
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 6;
}

/**
 * 行
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        ReturnedOrderGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_ReturnedOrderGoodsCell forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.selectBtn addTarget:self action:@selector(selectGoods:) forControlEvents:UIControlEventTouchUpInside];
        [cell configData:[order.orderItems objectAtIndex:indexPath.row] index:indexPath.row];
        return cell;
    }
    if (indexPath.section == 1) {
        returnedOrderShipCell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_ReturnedOrderShipCell forIndexPath:indexPath];
        returnedOrderShipCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return returnedOrderShipCell;
    }
    if (indexPath.section == 2) {
        returnedOrderBackWayCell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_ReturnedOrderBackWayCell forIndexPath:indexPath];
        returnedOrderBackWayCell.selectionStyle = UITableViewCellSelectionStyleNone;
        returnedOrderBackWayCell.moneyTf.text = [NSString stringWithFormat:@"%.2f", order.needPayMoney];
        [returnedOrderBackWayCell selectType:order.paymentName];
        return returnedOrderBackWayCell;
    }
    if (indexPath.section == 3) {
        returnedOrderReasonCell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_ReturnedOrderReasonCell forIndexPath:indexPath];
        returnedOrderReasonCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [returnedOrderReasonCell setTitle:@"退货原因"];
        [returnedOrderReasonCell setValue:@"请选择退货原因"];
        return returnedOrderReasonCell;
    }
    if (indexPath.section == 4) {
        returnedOrderRemarkCell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_ReturnedOrderRemarkCell forIndexPath:indexPath];
        returnedOrderRemarkCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return returnedOrderRemarkCell;
    }
    if (indexPath.section == 5) {
        RedButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_RedButtonCell forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.button setTitle:@"提交退货申请" forState:UIControlStateNormal];
        cell.button.enabled = YES;
        cell.backgroundColor = [UIColor colorWithHexString:@"#f1f2f6"];
        [cell.button addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    return [UITableViewCell new];
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
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 10)];
    view.backgroundColor = [UIColor colorWithHexString:@"#f1f2f6"];
    return view;
}

/**
 *  选中行
 *
 *  @param tableView
 *  @param indexPath
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 3){
        selectReasonView = [SelectValueView new];
        selectReasonView.complete = ^(NSInteger index, NSString *value){
            reason = value;
            [returnedOrderReasonCell setValue:reason];
        };
        if(returnedOrderShipCell.value == 0) {
            selectReasonView.valueArray = reasonArray0;
        }else{
            selectReasonView.valueArray = reasonArray1;
        }
        [self.view addSubview:selectReasonView];
        [selectReasonView show];
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


-(IBAction)selectGoods:(ESRadioButton *)sender{
    OrderItem *orderItem = [order.orderItems objectAtIndex:sender.tag];
    orderItem.selected = !orderItem.selected;
    [orderTable reloadData];
}

- (void)numberChanged:(NSInteger)number tag:(NSInteger)tag {
    OrderItem *orderItem = [order.orderItems objectAtIndex:tag];
    orderItem.selectedNumber = number;
    [orderTable reloadData];
}


/**
 * 提交退货申请
 */
- (IBAction)submit {
    ReturnedOrder *returnedOrder = [ReturnedOrder new];
    returnedOrder.orderId = order.id;
    returnedOrder.refundWay = returnedOrderBackWayCell.refundWay;
    //returnedOrder.returnAccount = returnedOrderBackWayCell.accountTf.text;
    returnedOrder.remark = returnedOrderRemarkCell.remarkTV.text;
    returnedOrder.apply_alltotal = [returnedOrderBackWayCell.moneyTf.text doubleValue];

    returnedOrder.returnedOrderItems = [NSMutableArray arrayWithCapacity:0];

    for(OrderItem *orderItem in order.orderItems){
        if(orderItem.selected){
            ReturnedOrderItem *returnedOrderItem = [ReturnedOrderItem new];
            returnedOrderItem.returnNumber = orderItem.selectedNumber > 0 ? orderItem.selectedNumber : 1;
            returnedOrderItem.itemId = orderItem.itemId;

            [returnedOrder.returnedOrderItems addObject:returnedOrderItem];
        }
    }


    if(returnedOrder.returnedOrderItems.count == 0){
        [ToastUtils show:@"请选择您要退货的商品！"];
        return;
    }

//    if (returnedOrder.returnAccount == nil || returnedOrder.returnAccount.length <= 0) {
//        [ToastUtils show:@"请输入您的收款账号!"];
//        return;
//    }

    double apply_alltotal = [returnedOrderBackWayCell.moneyTf.text doubleValue];
    if(apply_alltotal <= 0){
        [ToastUtils show:@"请输入退款金额!"];
        return;
    }

    if (returnedOrder.remark == nil || returnedOrder.remark.length <= 0) {
        [ToastUtils show:@"请输入详细的问题描述!"];
        return;
    }
    if(reason.length == 0){
        [ToastUtils show:@"请选择退货原因!"];
        return;
    }

    returnedOrder.apply_alltotal = apply_alltotal;
    returnedOrder.ship_status = returnedOrderShipCell.value;
    returnedOrder.reason = reason;

    [ToastUtils showLoading];
    [orderApi returned:returnedOrder success:^{
        [ToastUtils hideLoading];
        [ToastUtils show:@"退货申请提交成功,请您等待客服人员的审核!"];

        [[NSNotificationCenter defaultCenter] postNotificationName:nReturnedOrder object:nil];
        [self back];

    }          failure:^(NSError *error) {
        [ToastUtils hideLoading];
        [ToastUtils show:[error localizedDescription]];
    }];


}

@end