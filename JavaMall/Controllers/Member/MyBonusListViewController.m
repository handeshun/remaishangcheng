//
// Created by Dawei on 11/7/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "MyBonusListViewController.h"
#import "MemberApi.h"
#import "MJRefresh.h"
#import "Masonry.h"
#import "ToastUtils.h"
#import "MyBonusCell.h"
#import "ESButton.h"
#import "StoreViewController.h"
#import "Bonus.h"

@implementation MyBonusListViewController {
    UITableView *myTable;

    MemberApi *memberApi;

    NSMutableArray *bonusArray;
    int page;
}

@synthesize type;

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithHexString:@"#f1f2f7"];
    memberApi = [MemberApi new];
    page = 1;

    [self setupUI];
    [self loadData];
}

- (void)setupUI {
    myTable = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    myTable.backgroundColor = [UIColor colorWithHexString:@"#f1f2f7"];
    myTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    myTable.dataSource = self;
    myTable.delegate = self;
    [myTable registerClass:[MyBonusCell class] forCellReuseIdentifier:kCellIdentifier_MyBonusCell];
    myTable.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        page++;
        [self loadData];
    }];
    [self.view addSubview:myTable];
    [myTable mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-40);
    }];
}

- (void)loadData {
    [ToastUtils showLoading];

    [memberApi bonus:page type:type success:^(NSMutableArray *_bonusArray) {
        if (bonusArray == nil) {
            bonusArray = [NSMutableArray arrayWithCapacity:_bonusArray.count];
        }
        [ToastUtils hideLoading];
        if (page == 1) {
            [bonusArray removeAllObjects];
        }
        myTable.mj_footer.hidden = _bonusArray.count < 20;   //没有更多数据时隐藏'加载更多'
        [myTable.mj_footer endRefreshing];
        [bonusArray addObjectsFromArray:_bonusArray];
        [myTable reloadData];
    }      failure:^(NSError *error) {
        [ToastUtils hideLoading];
        [ToastUtils show:[error localizedDescription]];
    }];
}

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
    return 1;
}

/**
 * 有几个区
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [bonusArray count];
}

/**
 * 行
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyBonusCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_MyBonusCell forIndexPath:indexPath];
    [cell configData:[bonusArray objectAtIndex:indexPath.section]];
    cell.useBtn.tag = indexPath.section;
    [cell.useBtn addTarget:self action:@selector(useBouns:) forControlEvents:UIControlEventTouchUpInside];
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
 * 立即使用
 * @param sender
 */
-(IBAction)useBouns:(ESButton *)sender{
    Bonus *bonus = [bonusArray objectAtIndex:sender.tag];
    StoreViewController *storeViewController = [StoreViewController new];
    storeViewController.storeid = bonus.store_id;
    [self.navigationController pushViewController:storeViewController animated:YES];
}

@end