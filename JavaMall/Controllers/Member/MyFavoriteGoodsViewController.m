//
// Created by Dawei on 7/5/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "MyFavoriteGoodsViewController.h"
#import "TPKeyboardAvoidingTableView.h"
#import "HeaderView.h"
#import "FavoriteApi.h"
#import "Masonry.h"
#import "MyFavoriteCell.h"
#import "ToastUtils.h"
#import "MJRefresh.h"
#import "Favorite.h"
#import "Goods.h"
#import "ControllerHelper.h"

@implementation MyFavoriteGoodsViewController {
    TPKeyboardAvoidingTableView *myTable;

    FavoriteApi *favoriteApi;
    NSMutableArray *favoriteArray;

    int page;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    favoriteApi = [FavoriteApi new];
    page = 1;

    [self setupUI];
    [self loadData];
}

/**
 * 创建UI并布局
 */
- (void)setupUI {
    myTable = [TPKeyboardAvoidingTableView new];
    myTable.backgroundColor = [UIColor whiteColor];
    myTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [myTable registerClass:[MyFavoriteCell class] forCellReuseIdentifier:kCellIdentifier_MyFavoriteCell];
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
    [favoriteApi list:page success:^(NSMutableArray *_favoriteArray) {
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
    return 100;
}

/**
 * 每个区有几行
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return favoriteArray.count;
}

/**
 * 行
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyFavoriteCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_MyFavoriteCell forIndexPath:indexPath];
    [cell configData:[favoriteArray objectAtIndex:indexPath.row]];
    return cell;
}

/**
 *  选中行
 *
 *  @param tableView
 *  @param indexPath
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    Favorite *favorite = [favoriteArray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:[ControllerHelper createGoodsViewController:favorite.goods] animated:YES];
}

/**
 *  左滑cell时出现什么按钮
 */
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"移除收藏" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        [ToastUtils showLoading];
        Favorite *favorite = [favoriteArray objectAtIndex:indexPath.row];
        [favoriteApi unfavorite:favorite.goods.id success:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:nFavriteChanged object:nil];
            [ToastUtils hideLoading];
            [favoriteArray removeObject:favorite];
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