//
// Created by Dawei on 6/30/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "MyCommentOrderListViewController.h"
#import "HeaderView.h"
#import "OrderApi.h"
#import "MJRefresh.h"
#import "MyCommentOrderCell.h"
#import "Masonry.h"
#import "ESButton.h"
#import "PostCommentViewController.h"
#import "CommentApi.h"
#import "ToastUtils.h"


@implementation MyCommentOrderListViewController {
    HeaderView *headerView;
    UITableView *myTable;

    CommentApi *commentApi;
    int page;

    NSMutableArray *goodsArray;
}

@synthesize orderId;

- (void)viewDidLoad {
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(postCommentNotification:) name:nPostComment object:nil];

    self.view.backgroundColor = [UIColor colorWithHexString:@"#f1f2f7"];
    commentApi = [CommentApi new];
    page = 1;
    goodsArray = [NSMutableArray arrayWithCapacity:0];

    headerView = [[HeaderView alloc] initWithTitle:@"评价中心"];
    [headerView setBackAction:@selector(back)];
    [self.view addSubview:headerView];

    [self setupUI];
    [self loadData];
}

- (void)setupUI {
    myTable = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    myTable.backgroundColor = [UIColor colorWithHexString:@"#f3f4f6"];
    myTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    myTable.dataSource = self;
    myTable.delegate = self;
    [myTable registerClass:[MyCommentOrderCell class] forCellReuseIdentifier:kCellIdentifier_MyCommentOrderCell];
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
    [commentApi waitList:page orderId:orderId success:^(NSMutableArray *_goodsArray) {
        [ToastUtils hideLoading];
        if (page == 1) {
            [goodsArray removeAllObjects];
        }
        [myTable.mj_footer endRefreshing];
        [goodsArray addObjectsFromArray:_goodsArray];
        myTable.mj_footer.hidden = _goodsArray.count < 20; //没有更多数据时隐藏'加载更多'
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
    return goodsArray.count;
}

/**
 * 行
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyCommentOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_MyCommentOrderCell forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.commentBtn addTarget:self action:@selector(comment:) forControlEvents:UIControlEventTouchUpInside];
    cell.commentBtn.tag = indexPath.section;
    [cell configData:[goodsArray objectAtIndex:indexPath.section]];
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
    headerView.backgroundColor = [UIColor colorWithHexString:@"#f1f2f6"];
    return headerView;
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
 * 发表评论
 */
- (IBAction) comment:(ESButton *)sender {
    PostCommentViewController *postCommentViewController = [PostCommentViewController new];
    postCommentViewController.goods = [goodsArray objectAtIndex:sender.tag];
    [self.navigationController pushViewController:postCommentViewController animated:YES];
}

/**
 * 发表评论成功的通知
 */
- (void)postCommentNotification:(NSNotification *)notification {
    page = 1;
    [self loadData];
}

@end