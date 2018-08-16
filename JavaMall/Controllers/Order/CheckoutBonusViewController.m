//
// Created by Dawei on 6/22/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "CheckoutBonusViewController.h"
#import "Masonry.h"
#import "HeaderView.h"
#import "BonusCell.h"
#import "Bonus.h"
#import "Cart.h"
#import "Store.h"
#import "ESCheckButton.h"
#import "ESRadioButton.h"
#import "ESRedButton.h"
#import "ESLabel.h"
#import "ToastUtils.h"
#import "OrderApi.h"


@implementation CheckoutBonusViewController {
    HeaderView *headerView;
    UITableView *myTable;
    ESRedButton *okBtn;

    OrderApi *orderApi;
}

@synthesize cart;
@synthesize regionId;

- (void)viewDidLoad {

    orderApi = [OrderApi new];

    self.view.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    headerView = [[HeaderView alloc] initWithTitle:@""];
    headerView.titleLbl.text = @"优惠券";
    [headerView setBackAction:@selector(back)];
    [self.view addSubview:headerView];

    [self setupUI];
}

/**
 * 创建UI并布局
 */
- (void)setupUI {
    okBtn = [[ESRedButton alloc] initWithTitle:@"确定"];
    [okBtn addTarget:self action:@selector(ok) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:okBtn];
    [okBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.centerX.equalTo(self.view);
        make.height.equalTo(@40);
        make.bottom.equalTo(self.view).offset(-10);
    }];

    myTable = [UITableView new];
    myTable.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    myTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    myTable.dataSource = self;
    myTable.delegate = self;
    [myTable registerClass:[BonusCell class] forCellReuseIdentifier:kCellIdentifier_BonusCell];
    [self.view addSubview:myTable];
    [myTable mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(okBtn.mas_top).offset(-10);
    }];
}

#pragma TableView

/**
 * 每行的高度
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [BonusCell cellHeightWithObj:nil];
}

/**
 * 每个区有几行
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    Store *store = [cart.storeList objectAtIndex:section];
    return store.bonusList == nil ? 0 : store.bonusList.count;
}

/**
 * 有几个区
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return cart.storeList.count;
}

/**
 * 行
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Store *store = [cart.storeList objectAtIndex:indexPath.section];

    BonusCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_BonusCell forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.radioBtn.value = indexPath;
    [cell.radioBtn addTarget:self action:@selector(selectBonus:) forControlEvents:UIControlEventTouchUpInside];
    [cell configData:[store.bonusList objectAtIndex:indexPath.row]];
    return cell;
}

/**
 * 每个区的头部高度
 */
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    Store *store = [cart.storeList objectAtIndex:section];
    if(store.bonusList != nil && store.bonusList.count > 0) {
        return 40;
    }
    return 0.01f;
}

/**
 * 每个区的头部视图
 */
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    Store *store = [cart.storeList objectAtIndex:section];
    if(store.bonusList == nil || store.bonusList.count <= 0) {
        return [UIView new];
    }

    //配送方式
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];

    UIImageView *iconIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"store.png"]];
    [view addSubview:iconIv];
    [iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view);
        make.left.equalTo(view).offset(10);
    }];

    ESLabel *titleLbl = [[ESLabel alloc] initWithText:store.name textColor:[UIColor darkGrayColor] fontSize:14];
    [view addSubview:titleLbl];
    [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconIv.mas_right).offset(10);
        make.centerY.equalTo(view);
    }];

    UIView *footerLine = [UIView new];
    footerLine.backgroundColor = [UIColor colorWithHexString:kBorderLineColor];
    [view addSubview:footerLine];
    [footerLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(view);
        make.height.equalTo(@0.5f);
    }];

    UIView *headerLine = [UIView new];
    headerLine.backgroundColor = [UIColor colorWithHexString:kBorderLineColor];
    [view addSubview:headerLine];
    [headerLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(view);
        make.height.equalTo(footerLine);
    }];

    return view;
}

/**
 * 选择优惠券
 * @param sender
 */
- (IBAction)selectBonus:(ESCheckButton *)sender {
    NSIndexPath *indexPath = (NSIndexPath *)sender.value;
    Store *store = [cart.storeList objectAtIndex:indexPath.section];
    Bonus *bonus = [store.bonusList objectAtIndex:indexPath.row];
    for (Bonus *b in store.bonusList) {
        b.selected = NO;
    }
    if(!sender.isSelected) {
        bonus.selected = YES;
        store.bonus = bonus;
    }else{
        bonus.selected = NO;
        store.bonus = nil;
    }
    [myTable reloadData];
}

/**
 * 确定使用优惠券
 */
- (IBAction)ok {
    [ToastUtils showLoading];
    [orderApi changeShipBonus:regionId Cart:cart success:^(OrderPrice *orderPrice) {
        [ToastUtils hideLoading];
        NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:orderPrice, @"orderPrice", nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:nSelectBonus object:nil userInfo:userInfo];
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