//
// Created by Dawei on 6/30/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "ReturnedOrderListViewController.h"
#import "HeaderView.h"
#import "OrderApi.h"
#import "MJRefresh.h"
#import "Masonry.h"
#import "ESButton.h"
#import "ReturnedOrderCell.h"
#import "Order.h"
#import "OrderItem.h"
#import "ESLabel.h"
#import "ReturnedOrderViewController.h"
#import "DateUtils.h"
#import "UIView+Common.h"
#import "RefundOrderViewController.h"


@implementation ReturnedOrderListViewController {
    HeaderView *headerView;
    UITableView *orderTable;

    OrderApi *orderApi;
}

@synthesize order;

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithHexString:@"#f1f2f7"];
    orderApi = [OrderApi new];

    headerView = [[HeaderView alloc] initWithTitle:@"申请售后"];
    [headerView setBackAction:@selector(back)];
    [self.view addSubview:headerView];

    [self setupUI];
    [self loadData];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(returnedOrderCompletion:) name:nReturnedOrder object:nil];
}

- (void)setupUI {
    orderTable = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    orderTable.backgroundColor = [UIColor colorWithHexString:@"#f3f4f6"];
    orderTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    orderTable.dataSource = self;
    orderTable.delegate = self;
    [orderTable registerClass:[ReturnedOrderCell class] forCellReuseIdentifier:kCellIdentifier_ReturnedOrderCell];
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
    [orderApi detail:order.id success:^(Order *_order, Receipt *receipt) {
        order = _order;
        [orderTable reloadData];
        [[NSNotificationCenter defaultCenter] postNotificationName:nOrderStatusChanged object:order];

    }        failure:^(NSError *error) {

    }];
}

/**
 * 每行的高度
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

/**
 * 每个区有几行
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return order.orderItems.count;
}

/**
 * 有几个区
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

/**
 * 行
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ReturnedOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_ReturnedOrderCell forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell configData:[order.orderItems objectAtIndex:indexPath.row] order:order];
    return cell;
}

/**
 * 每个区的头部高度
 */
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 60;
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
    view.backgroundColor = [UIColor whiteColor];

    UIView *topView = [UIView new];
    topView.backgroundColor = [UIColor colorWithHexString:@"#f1f2f6"];
    [view addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(view);
        make.height.equalTo(@10);
    }];

    UIView *headerLine = [UIView new];
    headerLine.backgroundColor = [UIColor colorWithHexString:@"#e4e5e7"];
    [view addSubview:headerLine];
    [headerLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(view);
        make.top.equalTo(topView.mas_bottom);
        make.height.equalTo(@0.5f);
    }];

    UIView *footerLine = [UIView new];
    footerLine.backgroundColor = [UIColor colorWithHexString:@"#e4e5e7"];
    [view addSubview:footerLine];
    [footerLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(view);
        make.height.equalTo(headerLine);
    }];

    ESLabel *snLbl = [[ESLabel alloc] initWithText:[NSString stringWithFormat:@"订单编号:%@", order.sn] textColor:[UIColor darkGrayColor] fontSize:12];
    [view addSubview:snLbl];
    [snLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).offset(10);
        make.top.equalTo(view).offset(20);
        make.right.equalTo(view).offset(-50);
    }];

    ESLabel *timeLbl = [[ESLabel alloc] initWithText:[NSString stringWithFormat:@"下单时间:%@", [DateUtils dateToString:order.createTime withFormat:@"yyyy-MM-dd HH:mm:ss"]] textColor:[UIColor darkGrayColor] fontSize:12];
    [view addSubview:timeLbl];
    [timeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(snLbl.mas_bottom).offset(5);
        make.left.right.equalTo(snLbl);
    }];

    if (order.status == OrderStatus_ROG || order.status == OrderStatus_COMPLETE) {
        ESButton *refundBtn = [[ESButton alloc] initWithTitle:@"退款" color:[UIColor colorWithHexString:@"#d04353"] fontSize:12];
        [refundBtn borderWidth:0.5f color:[UIColor colorWithHexString:@"#d04353"] cornerRadius:4];
        [refundBtn addTarget:self action:@selector(refund) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:refundBtn];
        [refundBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(snLbl);
            make.right.equalTo(view).offset(-10);
            make.width.equalTo(@40);
        }];

        ESButton *returnBtn = [[ESButton alloc] initWithTitle:@"退货" color:[UIColor colorWithHexString:@"#d04353"] fontSize:12];
        [returnBtn borderWidth:0.5f color:[UIColor colorWithHexString:@"#d04353"] cornerRadius:4];
        [returnBtn addTarget:self action:@selector(returned:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:returnBtn];
        [returnBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(refundBtn);
            make.right.equalTo(refundBtn.mas_left).offset(-10);
            make.width.equalTo(refundBtn);
        }];
    } else {
        ESLabel *statusLbl = [[ESLabel alloc] initWithText:order.statusString textColor:[UIColor colorWithHexString:@"#d04353"] fontSize:12];
        statusLbl.textAlignment = NSTextAlignmentRight;
        [view addSubview:statusLbl];
        [statusLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(snLbl);
            make.right.equalTo(view).offset(-10);
            make.width.equalTo(@100);
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
 * 申请退货
 */
- (IBAction) returned:(ESButton *)sender {
    ReturnedOrderViewController *returnedOrderViewController = [ReturnedOrderViewController new];
    returnedOrderViewController.order = order;
    [self.navigationController pushViewController:returnedOrderViewController animated:YES];
}

/**
 * 申请退款
 */
- (IBAction) refund {
    RefundOrderViewController *refundOrderViewController = [RefundOrderViewController new];
    refundOrderViewController.order = order;
    [self.navigationController pushViewController:refundOrderViewController animated:YES];
}

/**
 * 退货申请成功的通知
 */
- (void)returnedOrderCompletion:(NSNotification *)notification {
    [self loadData];
}

@end