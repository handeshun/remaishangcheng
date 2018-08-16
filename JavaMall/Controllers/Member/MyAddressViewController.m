//
// Created by Dawei on 6/19/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "MyAddressViewController.h"
#import "Masonry.h"
#import "AddressApi.h"
#import "HeaderView.h"
#import "ESRedButton.h"
#import "ToastUtils.h"
#import "AddressEditViewController.h"
#import "ESButton.h"
#import "Address.h"
#import "MyAddressCell.h"
#import "ESRadioButton.h"


@implementation MyAddressViewController {
    HeaderView *headerView;
    UITableView *addressTable;
    ESRedButton *createBtn;

    AddressApi *addressApi;
    NSMutableArray *addressArray;
}

- (void)viewDidLoad {
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f1f2f6"];

    addressApi = [AddressApi new];
    addressArray = [[NSMutableArray alloc] initWithCapacity:0];

    headerView = [[HeaderView alloc] initWithTitle:@""];
    headerView.titleLbl.text = @"收货地址管理";
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

    addressTable = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    addressTable.backgroundColor = [UIColor colorWithHexString:@"#f1f2f6"];
    addressTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    addressTable.dataSource = self;
    addressTable.delegate = self;
    [addressTable registerClass:[MyAddressCell class] forCellReuseIdentifier:kCellIdentifier_MyAddressCell];
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
    return 110;
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
    return addressArray.count;
}

/**
 * 行
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_MyAddressCell forIndexPath:indexPath];
    [cell configData:[addressArray objectAtIndex:indexPath.section]];

    [cell.editBtn addTarget:self action:@selector(edit:) forControlEvents:UIControlEventTouchUpInside];
    cell.editBtn.tag = indexPath.section;

    [cell.deleteBtn addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
    cell.deleteBtn.tag = indexPath.section;

    [cell.defaultBtn addTarget:self action:@selector(setDefault:) forControlEvents:UIControlEventTouchUpInside];
    cell.defaultBtn.tag = indexPath.section;

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
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 10)];
    view.backgroundColor = [UIColor colorWithHexString:@"#f1f2f6"];
    return view;
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
-(IBAction)edit:(ESButton *)btn{
    AddressEditViewController *addressEditViewController = [AddressEditViewController new];
    addressEditViewController.address = [addressArray objectAtIndex:btn.tag];
    [self.navigationController pushViewController:addressEditViewController animated:YES];
}

/**
 * 删除地址
 */
-(IBAction)delete:(ESButton *)sender{
    Address *address = [addressArray objectAtIndex:sender.tag];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"您确认要删除此收货地址?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {}];
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        [ToastUtils showLoading];
        [addressApi delete:address.id success:^{
            [self loadData];
            [ToastUtils hideLoading];
        } failure:^(NSError *error) {
            [ToastUtils hideLoading];
            [ToastUtils show:[error localizedDescription]];
        }];

    }];
    [alertController addAction:cancelAction];
    [alertController addAction:otherAction];
    [self presentViewController:alertController animated:YES completion:nil];


}

/**
 * 设置为默认地址
 */
-(IBAction)setDefault:(ESRadioButton *)sender{
    Address *address = [addressArray objectAtIndex:sender.tag];
    if(address.isDefault)
        return;
    [ToastUtils showLoading];
    [addressApi setDefault:address.id success:^{
        [self loadData];
        [ToastUtils hideLoading];
    } failure:^(NSError *error) {
        [ToastUtils hideLoading];
        [ToastUtils show:[error localizedDescription]];
    }];
}

/**
 * 响应新建或编辑地址完毕的通知
 */
-(void)editAddressCompletion:(NSNotification*)notification {
    [self loadData];
}
@end