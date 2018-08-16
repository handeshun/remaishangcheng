//
// Created by Dawei on 7/3/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "RefundOrderViewController.h"
#import "HeaderView.h"
#import "Masonry.h"
#import "ReturnedOrderNumberCell.h"
#import "ReturnedOrderRemarkCell.h"
#import "TPKeyboardAvoidingTableView.h"
#import "RedButtonCell.h"
#import "ESRedButton.h"
#import "OrderApi.h"
#import "ReturnedOrderShipCell.h"
#import "SelectValueView.h"
#import "ReturnedOrderReasonCell.h"
#import "RefundOrderBackWayCell.h"
#import "Order.h"
#import "ReturnedOrder.h"
#import "ESTextView.h"
#import "ToastUtils.h"
#import "ESTextField.h"


@implementation RefundOrderViewController {
    HeaderView *headerView;
    TPKeyboardAvoidingTableView *orderTable;

    ReturnedOrderShipCell *returnedOrderShipCell;
    RefundOrderBackWayCell *refundOrderBackWayCell;
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

    headerView = [[HeaderView alloc] initWithTitle:@"申请退款"];
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
    [orderTable registerClass:[ReturnedOrderShipCell class] forCellReuseIdentifier:kCellIdentifier_ReturnedOrderShipCell];
    [orderTable registerClass:[ReturnedOrderRemarkCell class] forCellReuseIdentifier:kCellIdentifier_ReturnedOrderRemarkCell];
    [orderTable registerClass:[ReturnedOrderReasonCell class] forCellReuseIdentifier:kCellIdentifier_ReturnedOrderReasonCell];
    [orderTable registerClass:[RefundOrderBackWayCell class] forCellReuseIdentifier:kCellIdentifier_RefundOrderBackWayCell];

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
        return 75;
    }
    if (indexPath.section == 1) {
        return 140;
    }
    if (indexPath.section == 2) {
        return 50;
    }
    if (indexPath.section == 3) {
        return 150;
    }
    if (indexPath.section == 4) {
        return 50;
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
 * 有几个区
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

/**
 * 行
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        returnedOrderShipCell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_ReturnedOrderShipCell forIndexPath:indexPath];
        returnedOrderShipCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return returnedOrderShipCell;
    }
    if (indexPath.section == 1) {
        refundOrderBackWayCell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_RefundOrderBackWayCell forIndexPath:indexPath];
        refundOrderBackWayCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [refundOrderBackWayCell setType:order.paymentName:[NSString stringWithFormat:@"%.2f",order.needPayMoney]];
        return refundOrderBackWayCell;
    }
    if (indexPath.section == 2) {
        returnedOrderReasonCell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_ReturnedOrderReasonCell forIndexPath:indexPath];
        returnedOrderReasonCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [returnedOrderReasonCell setTitle:@"退款原因"];
        [returnedOrderReasonCell setValue:@"请选择退款原因"];
        return returnedOrderReasonCell;
    }
    if (indexPath.section == 3) {
        returnedOrderRemarkCell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_ReturnedOrderRemarkCell forIndexPath:indexPath];
        returnedOrderRemarkCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return returnedOrderRemarkCell;
    }
    if (indexPath.section == 4) {
        RedButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_RedButtonCell forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.button setTitle:@"提交退款申请" forState:UIControlStateNormal];
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
    if(indexPath.section == 2){
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

/**
 * 提交退货申请
 */
- (IBAction)submit {
    ReturnedOrder *returnedOrder = [ReturnedOrder new];
    returnedOrder.orderId = order.id;
    returnedOrder.remark = returnedOrderRemarkCell.remarkTV.text;
    returnedOrder.refundWay =order.paymentName;
    double apply_alltotal = [refundOrderBackWayCell.moneyTf.text doubleValue];
    if(apply_alltotal <= 0){
        [ToastUtils show:@"请输入退款金额!"];
        return;
    }

    if (returnedOrder.remark == nil || returnedOrder.remark.length <= 0) {
        [ToastUtils show:@"请输入详细的问题描述!"];
        return;
    }
    if(reason.length == 0){
        [ToastUtils show:@"请选择退款原因!"];
        return;
    }

    returnedOrder.apply_alltotal = apply_alltotal;
    returnedOrder.ship_status = returnedOrderShipCell.value;
    returnedOrder.reason = reason;

    [ToastUtils showLoading];
    [orderApi refund:returnedOrder success:^{
        [ToastUtils hideLoading];
        [ToastUtils show:@"退款申请提交成功,请您等待客服人员的审核!"];

        [[NSNotificationCenter defaultCenter] postNotificationName:nReturnedOrder object:nil];
        [self back];

    }          failure:^(NSError *error) {
        [ToastUtils hideLoading];
        [ToastUtils show:[error localizedDescription]];
    }];


}

@end