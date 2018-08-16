//
// Created by Dawei on 7/13/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "MyReturnedOrderViewController.h"
#import "HeaderView.h"
#import "ShowTextCell.h"
#import "Masonry.h"
#import "ReturnedOrder.h"
#import "MyReturnedOrderListGoodsCell.h"
#import "DateUtils.h"
#import "ToastUtils.h"
#import "OrderApi.h"

@implementation MyReturnedOrderViewController {
    HeaderView *headerView;
    UITableView *orderTable;

    ReturnedOrder *returnedOrder;

    OrderApi *orderApi;
}

@synthesize id, orderId;

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithHexString:@"#f1f2f7"];

    headerView = [[HeaderView alloc] initWithTitle:@"售后详情"];
    [headerView setBackAction:@selector(back)];
    [self.view addSubview:headerView];

    orderApi = [OrderApi new];

    [self setupUI];
    [self loadData];
}

- (void)setupUI {
    orderTable = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    orderTable.backgroundColor = [UIColor colorWithHexString:@"#f3f4f6"];
    orderTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    orderTable.dataSource = self;
    orderTable.delegate = self;
    [orderTable registerClass:[ShowTextCell class] forCellReuseIdentifier:kCellIdentifier_ShowTextCell];
    [orderTable registerClass:[MyReturnedOrderListGoodsCell class] forCellReuseIdentifier:kCellIdentifier_MyReturnedOrderListGoodsCell];
    [self.view addSubview:orderTable];
    [orderTable mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
}

/**
 * 载入数据
 */
- (void)loadData {
    [ToastUtils showLoading];
    [orderApi returnedOrder:id orderId:orderId success:^(ReturnedOrder *_returnedOrder) {
        [ToastUtils hideLoading];
        returnedOrder = _returnedOrder;
        [orderTable reloadData];
    } failure:^(NSError *error) {
        [ToastUtils hideLoading];
        [ToastUtils show:[error localizedDescription]];
    }];
}

/**
 * 每行的高度
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 100;
    }
    if (indexPath.row < 5) {
        return 44;
    }
    if (indexPath.row == 5) {
        return [ShowTextCell cellHeightWithTitle:@"申请理由" text:returnedOrder.remark];
    }
    if (indexPath.row == 6) {
        return [ShowTextCell cellHeightWithTitle:@"客服回复" text:returnedOrder.sellerRemark];
    }
    return 0;
}

/**
 * 每个区有几行
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return returnedOrder.returnedOrderItems.count;
    }
    return 7;
}

/**
 * 有几个区
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

/**
 * 行
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        MyReturnedOrderListGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_MyReturnedOrderListGoodsCell forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell configData:[returnedOrder.returnedOrderItems objectAtIndex:indexPath.row]];
        return cell;
    }
    if (indexPath.row == 0) {
        ShowTextCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_ShowTextCell forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setTitle:@"订单编号"];
        [cell setText:returnedOrder.sn];
        return cell;
    }
    if (indexPath.row == 1) {
        ShowTextCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_ShowTextCell forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setTitle:@"申请时间"];
        [cell setText:[DateUtils dateToString:returnedOrder.createTime withFormat:@"yyyy-MM-dd HH:mm:ss"]];
        return cell;
    }
    if (indexPath.row == 2) {
        ShowTextCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_ShowTextCell forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setTitle:@"处理状态"];
        [cell setText:returnedOrder.statusString];
        cell.textView.textColor = [UIColor redColor];
        return cell;
    }
    if (indexPath.row == 3) {
        ShowTextCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_ShowTextCell forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setTitle:@"退款方式"];
        [cell setText:returnedOrder.refundWay];
        return cell;
    }
    if (indexPath.row == 4) {
        ShowTextCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_ShowTextCell forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setTitle:@"退款账号"];
        [cell setText:returnedOrder.returnAccount];
        return cell;
    }
    if (indexPath.row == 5) {
        ShowTextCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_ShowTextCell forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setTitle:@"申请理由"];
        [cell setText:returnedOrder.remark];
        return cell;
    }
    if (indexPath.row == 6) {
        ShowTextCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_ShowTextCell forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setTitle:@"客服回复"];
        [cell setText:returnedOrder.sellerRemark];
        return cell;
    }
    return nil;
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
@end