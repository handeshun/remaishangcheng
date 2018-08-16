//
// Created by Dawei on 11/6/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "StoreCategoryViewController.h"
#import "HeaderView.h"
#import "TPKeyboardAvoidingTableView.h"
#import "Masonry.h"
#import "SelectTextCell.h"
#import "StoreApi.h"
#import "ToastUtils.h"
#import "StoreCategory.h"
#import "UIView+Layout.h"
#import "StoreSubCategoryCell.h"
#import "StoreGoodsListViewController.h"


@implementation StoreCategoryViewController {
    HeaderView *headerView;
    TPKeyboardAvoidingTableView *myTable;

    NSMutableArray *categories;
    StoreApi *storeApi;
}

@synthesize storeid;

- (void)viewDidLoad {
    [super viewDidLoad];

    categories = [NSMutableArray arrayWithCapacity:0];
    storeApi = [StoreApi new];

    headerView = [[HeaderView alloc] initWithTitle:@""];
    headerView.titleLbl.text = @"商品分类";
    [headerView setBackAction:@selector(back)];
    [self.view addSubview:headerView];

    [self setupUI];
    [self loadData];
}

/**
 * 创建UI并布局
 */
- (void)setupUI {
    myTable = [[TPKeyboardAvoidingTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    myTable.backgroundColor = [UIColor colorWithHexString:@"#f3f2f7"];
    myTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [myTable registerClass:[SelectTextCell class] forCellReuseIdentifier:kCellIdentifier_SelectTextCell];
    [myTable registerClass:[StoreSubCategoryCell class] forCellReuseIdentifier:kCellIdentifier_StoreSubCategoryCell];

    myTable.dataSource = self;
    myTable.delegate = self;
    [self.view addSubview:myTable];

    [myTable mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
}

/**
 * 载入数据
 */
- (void)loadData {
    [ToastUtils showLoading];
    [storeApi category:storeid success:^(NSMutableArray *_catgories) {
        [ToastUtils hideLoading];
        [categories removeAllObjects];
        [categories addObjectsFromArray:_catgories];
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
    if(indexPath.section == 0) {
        return 40;
    }
    StoreCategory *category = [categories objectAtIndex:indexPath.row];
    if(category.parent_id == 0){
        return 40;
    }else{
        return 35;
    }
}

/**
 * 每个区有几行
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0)
        return 1;
    return categories.count;
}

/**
 * 有几个区
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

/**
 * 行
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0){
        SelectTextCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_SelectTextCell forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setTitle:@"全部分类"];
        return cell;
    }

    StoreCategory *category = [categories objectAtIndex:indexPath.row];
    if(category.parent_id == 0) {
        SelectTextCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_SelectTextCell forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setTitle:category.name];
        return cell;
    }else{
        StoreSubCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_StoreSubCategoryCell forIndexPath:indexPath];
        [cell setTitle:category.name];
        return cell;
    }
}


/**
 * 每个区的头部高度
 */
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 5;
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
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor colorWithHexString:@"#f3f2f7"];

    UIView *line = [UIView new];
    line.backgroundColor = [UIColor colorWithHexString:@"#e4e5e7"];
    [view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(view);
        make.height.equalTo(@0.5f);
    }];

    return view;
}

/**
 *  选中行
 *
 *  @param tableView
 *  @param indexPath
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger categoryId = 0;
    if(indexPath.section == 1){
        StoreCategory *category = [categories objectAtIndex:indexPath.row];
        categoryId = category.cat_id;
    }
    StoreGoodsListViewController *storeGoodsListViewController = [StoreGoodsListViewController new];
    storeGoodsListViewController.storeid = storeid;
    storeGoodsListViewController.categoryId = categoryId;
    [self.navigationController pushViewController:storeGoodsListViewController animated:YES];
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