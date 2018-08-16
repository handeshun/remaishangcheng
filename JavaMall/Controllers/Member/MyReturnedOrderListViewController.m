//
// Created by Dawei on 7/12/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "MyReturnedOrderListViewController.h"
#import "OrderApi.h"
#import "HeaderView.h"
#import "Masonry.h"
#import "MyReturnedOrderListTitleCell.h"
#import "MyReturnedOrderListStatusCell.h"
#import "MyReturnedOrderListGoodsCell.h"
#import "ReturnedOrder.h"
#import "MJRefresh.h"
#import "ToastUtils.h"
#import "ESButton.h"
#import "MyReturnedOrderViewController.h"

@implementation MyReturnedOrderListViewController {
    HeaderView *headerView;
    UITableView *orderTable;

    OrderApi *orderApi;
    int page;

    NSMutableArray *orderArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithHexString:@"#f1f2f7"];
    orderApi = [OrderApi new];
    page = 1;

    headerView = [[HeaderView alloc] initWithTitle:@"退换货进度"];
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
    [orderTable registerClass:[MyReturnedOrderListTitleCell class] forCellReuseIdentifier:kCellIdentifier_MyReturnedOrderListTitleCell];
    [orderTable registerClass:[MyReturnedOrderListStatusCell class] forCellReuseIdentifier:kCellIdentifier_MyReturnedOrderListStatusCell];
    [orderTable registerClass:[MyReturnedOrderListGoodsCell class] forCellReuseIdentifier:kCellIdentifier_MyReturnedOrderListGoodsCell];
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

/**
 * 载入数据
 */
- (void)loadData {
    [ToastUtils showLoading];
    [orderApi returnedOrderList:page success:^(NSMutableArray *_orderArray) {
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
    }                   failure:^(NSError *error) {
        [ToastUtils hideLoading];
        [ToastUtils show:[error localizedDescription]];
    }];
}

/**
 * 每行的高度
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ReturnedOrder *order = [orderArray objectAtIndex:indexPath.section];
    if (indexPath.row > 0 && indexPath.row <= order.returnedOrderItems.count) {
        return 100;
    }
    return 40;
}

/**
 * 每个区有几行
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    ReturnedOrder *order = [orderArray objectAtIndex:section];
    return 2 + order.returnedOrderItems.count;
}

/**
 * 有几个区
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return orderArray.count;
}

/**
 * 行
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ReturnedOrder *order = [orderArray objectAtIndex:indexPath.section];
    if (indexPath.row == 0) {
        MyReturnedOrderListTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_MyReturnedOrderListTitleCell forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.detailBtn.tag = indexPath.section;
        [cell.detailBtn addTarget:self action:@selector(detail:) forControlEvents:UIControlEventTouchUpInside];
        [cell configData:order];
        return cell;
    }
    if (indexPath.row > 0 && indexPath.row <= order.returnedOrderItems.count) {
        MyReturnedOrderListGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_MyReturnedOrderListGoodsCell forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell configData:[order.returnedOrderItems objectAtIndex:indexPath.row - 1]];
        return cell;
    }

    MyReturnedOrderListStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_MyReturnedOrderListStatusCell forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell configData:order];
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

/**
 * 查看详情
 */
- (IBAction)detail:(ESButton *)sender {
    ReturnedOrder *returnedOrder = [orderArray objectAtIndex:sender.tag];

    MyReturnedOrderViewController *myReturnedOrderViewController = [MyReturnedOrderViewController new];
    myReturnedOrderViewController.id = returnedOrder.id;
    [self.navigationController pushViewController:myReturnedOrderViewController animated:YES];
}

@end