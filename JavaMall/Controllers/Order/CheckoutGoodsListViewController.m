//
// Created by Dawei on 6/20/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "CheckoutGoodsListViewController.h"
#import "HeaderView.h"
#import "CartApi.h"
#import "CheckoutGoodsListCell.h"
#import "Masonry.h"
#import "ToastUtils.h"
#import "Cart.h"
#import "CartGoods.h"
#import "ESLabel.h"
#import "Store.h"
#import "CartStoreHeader.h"
#import "ESButton.h"
#import "CartStoreFooter.h"
#import "StoreViewController.h"
#import "GoodsActivityViewController.h"


@implementation CheckoutGoodsListViewController {
    HeaderView *headerView;
    UITableView *goodsTable;
    ESLabel *totalLbl;
}

@synthesize cart;

- (void)viewDidLoad {
    self.view.backgroundColor = [UIColor whiteColor];

    headerView = [[HeaderView alloc] initWithTitle:@""];
    headerView.titleLbl.text = @"商品清单";
    [headerView setBackAction:@selector(back)];
    [self.view addSubview:headerView];

    [self setupUI];
    [self loadData];
}

/**
 * 创建UI并布局
 */
- (void)setupUI {
    totalLbl = [[ESLabel alloc] initWithText:@"" textColor:[UIColor grayColor] fontSize:14];
    [headerView addSubview:totalLbl];
    [totalLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(headerView).offset(-10);
        make.bottom.equalTo(headerView).offset(-10);
    }];

    goodsTable = [UITableView new];
    goodsTable.backgroundColor = [UIColor colorWithHexString:@"#f1f2f6"];
    goodsTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    goodsTable.dataSource = self;
    goodsTable.delegate = self;
    [goodsTable registerClass:[CheckoutGoodsListCell class] forCellReuseIdentifier:kCellIdentifier_CheckoutGoodsListCell];
    [self.view addSubview:goodsTable];
    [goodsTable mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
}

/**
 * 载入数据
 */
- (void)loadData {
    NSInteger count = 0;
    for(Store *store in cart.storeList){
        for(CartGoods *cartGoods in store.goodsList){
            count++;
        }
    }
    totalLbl.text = [NSString stringWithFormat:@"共%d件", count];
    [goodsTable reloadData];
}

#pragma TableView

/**
 * 每行的高度
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

/**
 * 几个区
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return cart.storeList.count;
}

/**
 * 每个区有几行
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    Store *store = [cart.storeList objectAtIndex:section];
    return store.goodsList.count;
}

/**
 * 行
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Store *store = [cart.storeList objectAtIndex:indexPath.section];
    CheckoutGoodsListCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_CheckoutGoodsListCell forIndexPath:indexPath];
    [cell configData:[store.goodsList objectAtIndex:indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

/**
 *  选中行
 *
 *  @param tableView
 *  @param indexPath
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Store *store = [cart.storeList objectAtIndex:indexPath.section];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    CartGoods *goods = [store.goodsList objectAtIndex:indexPath.row];
    NSLog(@"%@", goods.name);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    Store *store = [cart.storeList objectAtIndex:section];
    return [CartStoreFooter heightWithObject:store];
}

/**
 * 头
 * @param tableView
 * @param section
 * @return
 */
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    Store *store = [cart.storeList objectAtIndex:section];
    CartStoreHeader *headerView = [CartStoreHeader new];
    headerView.tag = section;
    [headerView.selectBtn setHidden:YES];
    [headerView.selectBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@0.01f);
    }];
    [headerView configData:store section:section];
    [headerView.activityBtn addTarget:self action:@selector(showActivity:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addTarget:self action:@selector(toStore:) forControlEvents:UIControlEventTouchUpInside];
    return headerView;
}

/**
 * 尾
 * @param tableView
 * @param section
 * @return
 */
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    Store *store = [cart.storeList objectAtIndex:section];
    CartStoreFooter *footerView = [CartStoreFooter new];
    footerView.tag = section;
    [footerView configData:store];
    return footerView;
}

/**
 * 进入店铺
 * @param view
 */
-(IBAction)toStore:(UIView *)view{
    Store *store = [cart.storeList objectAtIndex:view.tag];
    StoreViewController *storeViewController = [StoreViewController new];
    storeViewController.storeid = store.id;
    [[self navigationController] pushViewController:storeViewController animated:YES];
}

/**
 * 显示促销活动
 * @param view
 */
-(IBAction)showActivity:(UIView *)view{
    Store *store = [cart.storeList objectAtIndex:view.tag];
    GoodsActivityViewController *goodsActivityViewController = [GoodsActivityViewController new];
    goodsActivityViewController.activity_id = store.activity_id;
    [[self navigationController] pushViewController:goodsActivityViewController animated:YES];
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