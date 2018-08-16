//
// Created by Dawei on 7/5/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "MyFavoriteStoreViewController.h"
#import "TPKeyboardAvoidingTableView.h"
#import "FavoriteApi.h"
#import "Masonry.h"
#import "ToastUtils.h"
#import "MJRefresh.h"
#import "Favorite.h"
#import "Goods.h"
#import "ControllerHelper.h"
#import "StoreCell.h"
#import "ESButton.h"
#import "Store.h"
#import "StoreViewController.h"
#import "StoreApi.h"

@implementation MyFavoriteStoreViewController {
    TPKeyboardAvoidingTableView *myTable;

    FavoriteApi *favoriteApi;
    StoreApi *storeApi;
    NSMutableArray *favoriteArray;

    int page;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    favoriteApi = [FavoriteApi new];
    storeApi = [StoreApi new];
    page = 1;

    [self setupUI];
    [self loadData];
}

/**
 * 创建UI并布局
 */
- (void)setupUI {
    myTable = [TPKeyboardAvoidingTableView new];
    myTable.backgroundColor = [UIColor colorWithHexString:@"#f1f2f7"];
    myTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [myTable registerClass:[StoreCell class] forCellReuseIdentifier:kCellIdentifier_StoreCell];
    myTable.dataSource = self;
    myTable.delegate = self;
    myTable.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        page++;
        [self loadData];
    }];
    [self.view addSubview:myTable];

    [myTable mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
}

- (void)loadData {
    [ToastUtils showLoading];
    [favoriteApi storeList:page success:^(NSMutableArray *_favoriteArray) {
        if (favoriteArray == nil) {
            favoriteArray = [NSMutableArray arrayWithCapacity:_favoriteArray.count];
        }
        [ToastUtils hideLoading];
        if (_favoriteArray == nil || _favoriteArray.count == 0) {
            myTable.mj_footer.hidden = YES;
            if (page == 1) {
                [favoriteArray removeAllObjects];
                [myTable reloadData];
            }
            return;
        }
        //没有更多数据时隐藏'加载更多'
        myTable.mj_footer.hidden = _favoriteArray.count < 20;
        [myTable.mj_footer endRefreshing];
        [favoriteArray addObjectsFromArray:_favoriteArray];
        [myTable reloadData];
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
    float height = 55;
    Store *store = [favoriteArray objectAtIndex:indexPath.section];
    if(store.goodsList != nil && store.goodsList.count > 0){
        height += (kScreen_Width-30)/3+28;
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
    return favoriteArray.count;
}

/**
 * 行
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    StoreCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_StoreCell forIndexPath:indexPath];
    Store *store = [favoriteArray objectAtIndex:indexPath.section];
    cell.toStoreBtn.tag = indexPath.section;
    [cell.toStoreBtn addTarget:self action:@selector(toStore:) forControlEvents:UIControlEventTouchUpInside];
    [cell configData:store];
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
    headerView.backgroundColor = [UIColor colorWithHexString:@"#f1f2f7"];
    return headerView;
}

/**
 *  选中行
 *
 *  @param tableView
 *  @param indexPath
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    Store *store = [favoriteArray objectAtIndex:indexPath.section];
    StoreViewController *storeViewController = [StoreViewController new];
    storeViewController.storeid = store.id;
    [self.navigationController pushViewController:storeViewController animated:YES];
}

/**
 *  左滑cell时出现什么按钮
 */
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"移除收藏" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        [ToastUtils showLoading];
        Store *store = [favoriteArray objectAtIndex:indexPath.section];
        [storeApi uncollect:store.id success:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:nFavriteChanged object:nil];
            [ToastUtils hideLoading];
            [favoriteArray removeObject:store];
            [myTable reloadData];
        } failure:^(NSError *error) {
            [ToastUtils hideLoading];
            [ToastUtils show:error.localizedDescription];
        }];
        tableView.editing = NO;
    }];

    return @[deleteAction];
}

@end