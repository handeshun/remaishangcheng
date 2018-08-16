//
// Created by Dawei on 6/19/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "SelectAddressViewController.h"
#import "Masonry.h"
#import "AddressApi.h"
#import "HeaderView.h"
#import "ESRedButton.h"
#import "SelectAddressCell.h"
#import "ToastUtils.h"
#import "AddressEditViewController.h"
#import "ESButton.h"
#import "Address.h"


@implementation SelectAddressViewController {
    HeaderView *headerView;
    UITableView *addressTable;
    ESRedButton *createBtn;

    AddressApi *addressApi;
    NSMutableArray *addressArray;
}

- (void)viewDidLoad {
    self.view.backgroundColor = [UIColor whiteColor];

    addressApi = [AddressApi new];
    addressArray = [[NSMutableArray alloc] initWithCapacity:0];

    headerView = [[HeaderView alloc] initWithTitle:@""];
    headerView.titleLbl.text = @"选择收货地址";
    [headerView setBackAction:@selector(back)];
    [self.view addSubview:headerView];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(editAddressCompletion:) name:nAddAddress object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(editAddressCompletion:) name:nEditAddress object:nil];

    [self setupUI];
    [self loadData];
}

/**
 * 创建UI并布局
 */
- (void)setupUI {
    createBtn = [[ESRedButton alloc] initWithTitle:@"+ 新建地址"];
    [createBtn addTarget:self action:@selector(createAddress) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:createBtn];
    [createBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.centerX.equalTo(self.view);
        make.height.equalTo(@40);
        make.bottom.equalTo(self.view).offset(-10);
    }];

    addressTable = [UITableView new];
    addressTable.backgroundColor = [UIColor whiteColor];
    addressTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    addressTable.dataSource = self;
    addressTable.delegate = self;
    [addressTable registerClass:[SelectAddressCell class] forCellReuseIdentifier:kCellIdentifier_SelectAddressCell];
    [self.view addSubview:addressTable];
    [addressTable mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-60);
    }];
}

/**
 * 载入数据
 */
- (void)loadData {
    [addressApi list:^(NSMutableArray *addArray) {
        [addressArray removeAllObjects];
        [addressArray addObjectsFromArray:addArray];
        [addressTable reloadData];
    }        failure:^(NSError *error) {
        [ToastUtils show:[error localizedDescription]];
    }];
}

#pragma TableView

/**
 * 每行的高度
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

/**
 * 每个区有几行
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return addressArray.count;
}

/**
 * 行
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SelectAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_SelectAddressCell forIndexPath:indexPath];
    [cell configData:[addressArray objectAtIndex:indexPath.row] index:indexPath.row];
    [cell.editBtn addTarget:self action:@selector(editAddress:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

/**
 *  选中行
 *
 *  @param tableView
 *  @param indexPath
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Address *address = [addressArray objectAtIndex:indexPath.row];
    [[NSNotificationCenter defaultCenter] postNotificationName:nSelectAddress object:nil userInfo:address];
    [self back];
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
 * 新建地址
 */
- (IBAction)createAddress {
    AddressEditViewController *addressEditViewController = [AddressEditViewController new];
    [self.navigationController pushViewController:addressEditViewController animated:YES];
}

/**
 * 编辑地址
 */
-(IBAction)editAddress:(ESButton *)btn{
    AddressEditViewController *addressEditViewController = [AddressEditViewController new];
    addressEditViewController.address = [addressArray objectAtIndex:btn.tag];
    [self.navigationController pushViewController:addressEditViewController animated:YES];
}

/**
 * 响应新建或编辑地址完毕的通知
 */
-(void)editAddressCompletion:(NSNotification*)notification {
    [self loadData];
}
@end