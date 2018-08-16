//
// Created by Dawei on 9/23/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "MyOrderDeliveryViewController.h"
#import "HeaderView.h"
#import "OrderApi.h"
#import "Masonry.h"
#import "ToastUtils.h"
#import "MyOrderExpressCell.h"
#import "MyOrderDeliveryCell.h"
#import "Delivery.h"
#import "Express.h"

@implementation MyOrderDeliveryViewController {
    HeaderView *headerView;
    UITableView *myTable;

    OrderApi *orderApi;

    Delivery *delivery;
    NSMutableArray *expressArray;
}

@synthesize orderId;

- (void)viewDidLoad {
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f1f2f6"];

    orderApi = [OrderApi new];
    expressArray = [[NSMutableArray alloc] initWithCapacity:0];

    headerView = [[HeaderView alloc] initWithTitle:@""];
    headerView.titleLbl.text = @"订单跟踪";
    [headerView setBackAction:@selector(back)];
    [self.view addSubview:headerView];

    [self setupUI];
    [self loadData];
}

/**
 * 创建UI并布局
 */
- (void)setupUI {
    myTable = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    myTable.backgroundColor = [UIColor colorWithHexString:@"#f1f2f6"];
    myTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    myTable.dataSource = self;
    myTable.delegate = self;
    [myTable registerClass:[MyOrderExpressCell class] forCellReuseIdentifier:kCellIdentifier_MyOrderExpressCell];
    [myTable registerClass:[MyOrderDeliveryCell class] forCellReuseIdentifier:kCellIdentifier_MyOrderDeliveryCell];
    [self.view addSubview:myTable];
    [myTable mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
}

/**
 * 载入数据
 */
- (void)loadData {
    [ToastUtils showLoading];
    [orderApi delivery:orderId success:^(Delivery *_delivery, NSMutableArray *_expressArray) {
        delivery = _delivery;
        [expressArray addObjectsFromArray:_expressArray];
        [myTable reloadData];

        [ToastUtils hideLoading];
    } failure:^(NSError *error) {
        [ToastUtils hideLoading];
        [ToastUtils show:[error localizedDescription]];
    }];
}

#pragma TableView

/**
 * 每行的高度
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0){
        return [MyOrderDeliveryCell cellHeightWithObj:delivery];
    }
    return [MyOrderExpressCell cellHeightWithObj:[expressArray objectAtIndex:indexPath.row]];
}

/**
 * 每个区有几行
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0) {
        return 1;
    }
    return expressArray.count;
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
    if(indexPath.section == 0){
        MyOrderDeliveryCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_MyOrderDeliveryCell forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell configData:delivery];
        return cell;
    }
    MyOrderExpressCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_MyOrderExpressCell forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell configData:[expressArray objectAtIndex:indexPath.row] row:indexPath.row];
    return cell;
}

/**
 * 每个区的头部高度
 */
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(section == 1) {
        return 10;
    }
    return 0.01f;
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