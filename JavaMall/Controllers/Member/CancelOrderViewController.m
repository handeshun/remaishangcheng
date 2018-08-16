//
// Created by Dawei on 7/13/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "CancelOrderViewController.h"
#import "HeaderView.h"
#import "TPKeyboardAvoidingTableView.h"
#import "Masonry.h"
#import "MyOrderSnCell.h"
#import "MyOrderGoodsCell.h"
#import "RedButtonCell.h"
#import "Order.h"
#import "InputTextViewCell.h"
#import "ESLabel.h"
#import "ESTextView.h"
#import "ESRedButton.h"
#import "ToastUtils.h"
#import "OrderApi.h"

@implementation CancelOrderViewController {
    HeaderView *headerView;
    TPKeyboardAvoidingTableView *myTable;

    InputTextViewCell *reasonCell;

    OrderApi *orderApi;
}

@synthesize order;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    orderApi = [OrderApi new];

    headerView = [[HeaderView alloc] initWithTitle:@""];
    headerView.titleLbl.text = @"取消订单";
    [headerView setBackAction:@selector(back)];
    [self.view addSubview:headerView];

    [self setupUI];
}

/**
 * 创建UI并布局
 */
- (void)setupUI {
    myTable = [TPKeyboardAvoidingTableView new];
    myTable.backgroundColor = [UIColor whiteColor];
    myTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [myTable registerClass:[MyOrderSnCell class] forCellReuseIdentifier:kCellIdentifier_MyOrderSnCell];
    [myTable registerClass:[MyOrderGoodsCell class] forCellReuseIdentifier:kCellIdentifier_MyOrderGoodsCell];
    [myTable registerClass:[InputTextViewCell class] forCellReuseIdentifier:kCellIdentifier_InputTextViewCell];
    [myTable registerClass:[RedButtonCell class] forCellReuseIdentifier:kCellIdentifier_RedButtonCell];
    myTable.dataSource = self;
    myTable.delegate = self;
    [self.view addSubview:myTable];

    [myTable mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
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
        return 80;
    }else if(indexPath.section == 2){
        return 100;
    }
    return 100;
}

/**
 * 每个区有几行
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    if (section == 1) {
        return order.orderItems.count;
    }
    return 1;
}

/**
 * 有几个区
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
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
        MyOrderGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_MyOrderGoodsCell forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell configData:[order.orderItems objectAtIndex:indexPath.row]];
        return cell;
    }
    if (indexPath.section == 2) {
        reasonCell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_InputTextViewCell forIndexPath:indexPath];
        reasonCell.selectionStyle = UITableViewCellSelectionStyleNone;
        reasonCell.titleLbl.text = @"取消原因";
        reasonCell.remarkTV.placeholder = @"请输入您取消订单的原因!";
        return reasonCell;
    }

    if (indexPath.section == 3) {
        RedButtonCell *saveCell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_RedButtonCell forIndexPath:indexPath];
        saveCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [saveCell.button addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
        [saveCell.button setTitle:@"取消订单" forState:UIControlStateNormal];
        saveCell.button.enabled = YES;
        return saveCell;
    }
    return nil;
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
    if (section == 1) {
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
}

/**
 * 保存信息
 */
- (IBAction)save {
    NSString *reason = reasonCell.remarkTV.text;
    if(reason == nil || reason.length <= 0){
        [ToastUtils show:@"请输入您取消订单的原因!"];
        return;
    }
    [ToastUtils showLoading];

    [orderApi cancel:order.id reason:reason success:^{
        [ToastUtils hideLoading];
        [ToastUtils show:@"取消订单成功!"];
        order.status = OrderStatus_CANCELLATION;
        [[NSNotificationCenter defaultCenter] postNotificationName:nOrderStatusChanged object:order];
        [self back];
    } failure:^(NSError *error) {
        [ToastUtils hideLoading];
        [ToastUtils show:[error localizedDescription]];
    }];
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