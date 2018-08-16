//
// Created by Dawei on 11/10/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "GoodsBonusViewController.h"
#import "HeaderView.h"
#import "MyBonusCell.h"
#import "Masonry.h"
#import "ESButton.h"
#import "StoreApi.h"
#import "ToastUtils.h"
#import "Bonus.h"
#import "ControllerHelper.h"


@implementation GoodsBonusViewController {
    HeaderView *headerView;
    UITableView *myTable;

    StoreApi *storeApi;
}

@synthesize bonusArray, storeid;

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithHexString:@"#f1f2f7"];
    storeApi = [StoreApi new];

    headerView = [[HeaderView alloc] initWithTitle:@"领取优惠券"];
    [headerView setBackAction:@selector(back)];
    [self.view addSubview:headerView];

    [self setupUI];
}

- (void)setupUI {
    myTable = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    myTable.backgroundColor = [UIColor colorWithHexString:@"#f1f2f7"];
    myTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    myTable.dataSource = self;
    myTable.delegate = self;
    [myTable registerClass:[MyBonusCell class] forCellReuseIdentifier:kCellIdentifier_MyBonusCell];
    [self.view addSubview:myTable];
    [myTable mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-40);
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
    [cell.useBtn setTitle:@"点击领取"];
    [cell.useBtn addTarget:self action:@selector(getBonus:) forControlEvents:UIControlEventTouchUpInside];
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
 * 点击领取
 * @param sender
 */
-(IBAction)getBonus:(ESButton *)sender{
    if (![ControllerHelper isLogined]) {
        [ToastUtils show:@"请您登录后进行此项操作！"];
        [self presentViewController:[ControllerHelper createLoginViewController] animated:YES completion:nil];
        return;
    }
    Bonus *bonus = [bonusArray objectAtIndex:sender.tag];
    [ToastUtils showLoading];
    [storeApi getBonus:storeid type_id:bonus.type success:^{
        [ToastUtils hideLoading];
        [ToastUtils show:@"领取优惠券成功！"];
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