//
// Created by Dawei on 11/8/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "StoreListViewController.h"
#import "StoreApi.h"
#import "SearchViewController.h"
#import "StoreListHeaderView.h"
#import "MJRefresh.h"
#import "Masonry.h"
#import "StoreCell.h"
#import "ToastUtils.h"
#import "Store.h"
#import "ESButton.h"
#import "StoreViewController.h"
#import "ControllerHelper.h"


@implementation StoreListViewController {
    StoreListHeaderView *headerView;
    UITableView *myTable;
    StoreApi *storeApi;

    NSMutableArray *storeArray;

    NSInteger page;
}

@synthesize keyword;

- (void)viewDidLoad {
    [super viewDidLoad];

    page = 1;
    storeArray = [NSMutableArray arrayWithCapacity:0];
    storeApi = [StoreApi new];

    if(keyword == nil || ![keyword isKindOfClass:[NSString class]] || keyword.length == 0){
        keyword = @"";
    }

    headerView = [[StoreListHeaderView alloc] init];
    if(keyword.length > 0) {
        headerView.titleLbl.text = keyword;
    }
    [self.view addSubview:headerView];
    [headerView setSearchAction:@selector(searchAction:)];
    [headerView setBackAction:@selector(backAction)];

    [self setupUI];
    [self loadData];
}

- (void)setupUI {
    myTable = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    myTable.backgroundColor = [UIColor colorWithHexString:@"#f1f2f7"];
    myTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    myTable.dataSource = self;
    myTable.delegate = self;
    [myTable registerClass:[StoreCell class] forCellReuseIdentifier:kCellIdentifier_StoreCell];
    myTable.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        page++;
        [self loadData];
    }];
    [self.view addSubview:myTable];
    [myTable mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
}

- (void)loadData {
    [ToastUtils showLoading];
    [storeApi search:keyword page:page success:^(NSMutableArray *_storeList) {
        [ToastUtils hideLoading];
        if(page == 1){
            [storeArray removeAllObjects];
        }
        if (_storeList == nil || _storeList.count == 0) {
            myTable.mj_footer.hidden = YES;
            return;
        }
        //没有更多数据时隐藏'加载更多'
        myTable.mj_footer.hidden = _storeList.count < 20;
        [myTable.mj_footer endRefreshing];
        [storeArray addObjectsFromArray:_storeList];
        [myTable reloadData];
    } failure:^(NSError *error) {
        [ToastUtils hideLoading];
        [ToastUtils show:[error localizedDescription]];
    }];
}
/**
 * 每行的高度
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    float height = 55;
    Store *store = [storeArray objectAtIndex:indexPath.section];
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
    return storeArray.count;
}

/**
 * 行
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    StoreCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_StoreCell forIndexPath:indexPath];
    Store *store = [storeArray objectAtIndex:indexPath.section];
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
    Store *store = [storeArray objectAtIndex:indexPath.row];
    StoreViewController *storeViewController = [StoreViewController new];
    storeViewController.storeid = store.id;
    [self.navigationController pushViewController:storeViewController animated:YES];
}

-(IBAction)toStore:(ESButton *)sender{
    Store *store = [storeArray objectAtIndex:sender.tag];
    StoreViewController *storeViewController = [StoreViewController new];
    storeViewController.storeid = store.id;
    [self.navigationController pushViewController:storeViewController animated:YES];
}

/**
 *  点击搜索事件
 *
 *  @param gesture
 */
- (void)searchAction:(UITapGestureRecognizer *)gesture {
    SearchViewController *searchViewController = [SearchViewController new];
    searchViewController.delegate = self;
    [self presentViewController:searchViewController animated:YES completion:nil];
}

/**
 * 后退事件
 */
- (IBAction)backAction {
    if (self.navigationController != nil) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 * 搜索回调事件
 */
- (void)search:(NSString *)_keyword searchType:(NSInteger)searchType {
    if(searchType == 0) {
        [self.navigationController pushViewController:[ControllerHelper createGoodsListViewController:0 categoryName:nil keyword:_keyword brandId:0] animated:YES];
    }else {
        keyword = _keyword;
        if (keyword.length > 0) {
            headerView.titleLbl.text = keyword;
        }
        page = 1;
        [self loadData];
    }
}

@end