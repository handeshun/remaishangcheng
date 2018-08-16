//
// Created by Dawei on 1/29/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "Masonry.h"
#import "UIView+Common.h"
#import "GoodsFilterValueViewController.h"
#import "HeaderView.h"
#import "GoodsFilter.h"
#import "GoodsFilterValue.h"
#import "GoodsFilterValueSelectDelegate.h"

#define LEFT_SPLIT_WIDTH 50

@implementation GoodsFilterValueViewController {
    UIView *headerView;
    UITableView *filterTableView;

    int selectedIndex;
}

@synthesize filter;
@synthesize delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor colorWithHexString:kHeaderBackgroundColor];

    [self createHeaderView];
    [self createFilterView];
}

- (void) createHeaderView{
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width - LEFT_SPLIT_WIDTH, 60)];
    headerView.backgroundColor = [UIColor colorWithHexString:kHeaderBackgroundColor];

    //标题
    UILabel *titleLbl = [UILabel new];
    titleLbl.text = filter.name;
    titleLbl.font = [UIFont systemFontOfSize:16];
    [headerView addSubview:titleLbl];
    [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headerView);
        make.top.equalTo(@29);
    }];

    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(2, 18, 44, 44)];
    [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backBtn setContentMode:UIViewContentModeCenter];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:backBtn];

    //添加下划线
    [headerView bottomBorder:[UIColor colorWithHexString:kBorderLineColor]];


    [self.view addSubview:headerView];
}

/**
 * 创建筛选视图
 */
- (void) createFilterView{
    filterTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 61, kScreen_Width-LEFT_SPLIT_WIDTH, kScreen_Height - 61)];
    filterTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    filterTableView.delegate = self;
    filterTableView.dataSource = self;
    [self.view addSubview:filterTableView];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection: (NSInteger)section {
    return filter.values.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
        //添加下划线
        [cell bottomBorder:[UIColor colorWithHexString:kBorderLineColor] size:CGSizeMake(kScreen_Width, 40)];
    }

    GoodsFilterValue *filterValue = [filter.values objectAtIndex:[indexPath row]];

    [cell setBackgroundColor:[UIColor clearColor]];
    cell.textLabel.text = filterValue.name;
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    if(filterValue.selected){
        selectedIndex = indexPath.row;
        cell.textLabel.textColor = [UIColor redColor];
    }else{
        cell.textLabel.textColor = [UIColor blackColor];
    }
    return cell;
}

/**
 *  选中行
 *
 *  @param tableView
 *  @param indexPath
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [filterTableView deselectRowAtIndexPath:indexPath animated:NO];

    GoodsFilterValue *selectedValue = [filter.values objectAtIndex:selectedIndex];
    selectedValue.selected = NO;

    GoodsFilterValue *filterValue = [filter.values objectAtIndex:[indexPath row]];
    filterValue.selected = YES;
    filter.selectedValue = filterValue;
    [delegate selectValue:filter];

    [self back];
}

/**
 * 确定
 */
- (void) back{
    [self.navigationController popViewControllerAnimated:YES];
}

@end