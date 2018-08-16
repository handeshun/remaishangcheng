//
// Created by Dawei on 7/5/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "MyPointHistoryViewController.h"
#import "HeaderView.h"
#import "TPKeyboardAvoidingTableView.h"
#import "MemberApi.h"
#import "MJRefresh.h"
#import "Masonry.h"
#import "ToastUtils.h"
#import "MyPointHistoryCell.h"


@implementation MyPointHistoryViewController {
    HeaderView *headerView;
    TPKeyboardAvoidingTableView *myTable;

    MemberApi *memberApi;
    NSMutableArray *pointArray;

    int page;
}

@synthesize type;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    memberApi = [MemberApi new];
    page = 1;

    headerView = [[HeaderView alloc] initWithTitle:@""];
    if(type == 1) {
        headerView.titleLbl.text = @"等级积分";
    }else{
        headerView.titleLbl.text = @"消费积分";
    }
    [headerView setBackAction:@selector(back)];
    [self.view addSubview:headerView];

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
    [myTable registerClass:[MyPointHistoryCell class] forCellReuseIdentifier:kCellIdentifier_MyPointHistoryCell];
    myTable.dataSource = self;
    myTable.delegate = self;
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
    [memberApi pointHistory:page success:^(NSMutableArray *_pointArray) {
        if (pointArray == nil) {
            pointArray = [NSMutableArray arrayWithCapacity:_pointArray.count];
        }
        [ToastUtils hideLoading];
        if (_pointArray == nil || _pointArray.count == 0) {
            myTable.mj_footer.hidden = YES;
            if (page == 1) {
                [pointArray removeAllObjects];
                [myTable reloadData];
            }
            return;
        }
        //没有更多数据时隐藏'加载更多'
        myTable.mj_footer.hidden = _pointArray.count < 20;
        [myTable.mj_footer endRefreshing];
        [pointArray addObjectsFromArray:_pointArray];
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
    return 60;
}

/**
 * 每个区有几行
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return pointArray.count;
}

/**
 * 行
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyPointHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_MyPointHistoryCell forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell configData:[pointArray objectAtIndex:indexPath.row] andType:type];
    return cell;
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