//
// Created by Dawei on 1/28/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "Masonry.h"
#import "GoodsFilterViewController.h"
#import "REFrostedViewController.h"
#import "UIView+Common.h"
#import "GoodsFilter.h"
#import "GoodsFilterValue.h"
#import "GoodsFilterValueViewController.h"
#import "GoodsApi.h"
#import "GoodsFilterSelectDelegate.h"
#import "ToastUtils.h"

#define LEFT_SPLIT_WIDTH 50

@implementation GoodsFilterViewController {
    UIView *headerView;
    UITableView *filterTableView;

    GoodsApi *goodsApi;
    NSMutableArray *filterArray;
}

@synthesize categoryId, keyword;
@synthesize delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor colorWithHexString:@"#FAFAFA"];

    goodsApi = [GoodsApi new];

    [self createHeaderView];
    [self createFilterView];

    [self loadFilters];

}

/**
 * 载入筛选器
 */
- (void) loadFilters{
    [ToastUtils showLoading];
    [goodsApi filters:categoryId keyword:keyword success:^(NSMutableArray *filterArr) {
        if(filterArray == nil) {
            filterArray = [NSMutableArray arrayWithCapacity:filterArr.count];
        }
        if((filterArr == nil || filterArr.count == 0)){
            [ToastUtils hideLoading];
            return;
        }
        [filterArray addObjectsFromArray:filterArr];
        [filterTableView reloadData];
        [ToastUtils hideLoading];
    } failure:^(NSError *error) {
        DebugLog(@"%@", [error description]);
        [ToastUtils hideLoading];
    }];
}

/**
 * 头
 */
- (void) createHeaderView{
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width - LEFT_SPLIT_WIDTH, 60)];

    headerView.backgroundColor = [UIColor colorWithHexString:kHeaderBackgroundColor];

    //取消
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(2, 20, 44, 44)];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [cancelBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:cancelBtn];

    //标题
    UILabel *titleLbl = [UILabel new];
    titleLbl.text = @"筛选";
    titleLbl.font = [UIFont systemFontOfSize:16];
    [headerView addSubview:titleLbl];

    //确定
    UIButton *okBtn = [[UIButton alloc] initWithFrame:CGRectMake(2, 20, 44, 44)];
    [okBtn setTitle:@"确定" forState:UIControlStateNormal];
    okBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [okBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [okBtn addTarget:self action:@selector(ok) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:okBtn];

    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView).offset(10);
        make.top.equalTo(headerView).offset(30);
    }];

    [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headerView);
        make.top.equalTo(@31);
    }];

    [okBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(headerView).offset(-10);
        make.top.equalTo(headerView).offset(30);
    }];

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

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection: (NSInteger)section {
    return filterArray.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [UIView new];
    UIButton *clearBtn = [UIButton new];
    [clearBtn setTitle:@"清除选项" forState:UIControlStateNormal];
    clearBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [clearBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    clearBtn.layer.borderColor = [UIColor colorWithHexString:@"#dbdbdb"].CGColor;
    clearBtn.layer.borderWidth = 1.0;
    clearBtn.layer.masksToBounds = YES;
    clearBtn.layer.cornerRadius = 3.0;
    [clearBtn addTarget:self action:@selector(clear) forControlEvents:UIControlEventTouchUpInside];
    [filterTableView.tableFooterView addSubview:clearBtn];
    [footerView addSubview:clearBtn];

    [clearBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.and.centerY.equalTo(footerView);
        make.size.mas_equalTo(CGSizeMake(100, 25));
    }];

    return footerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];

        //添加下划线
        [cell bottomBorder:[UIColor colorWithHexString:kBorderLineColor] size:CGSizeMake(kScreen_Width, 40)];
    }

    GoodsFilter *filter = [filterArray objectAtIndex:[indexPath row]];

    [cell setBackgroundColor:[UIColor clearColor]];
    cell.textLabel.text = filter.name;
    cell.textLabel.font = [UIFont systemFontOfSize:13];

    cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
    if (filter.selectedValue == nil || [filter.selectedValue.value length] == 0) {
        cell.detailTextLabel.text = @"全部";
        cell.detailTextLabel.textColor = [UIColor darkGrayColor];
    }else{
        cell.detailTextLabel.text = filter.selectedValue.name;
        cell.detailTextLabel.textColor = [UIColor redColor];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
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

    GoodsFilterValueViewController *filterViewController = [GoodsFilterValueViewController new];
    filterViewController.filter = [filterArray objectAtIndex:[indexPath row]];
    filterViewController.delegate = self;

    [self.navigationController pushViewController:filterViewController animated:YES];

}

/**
 * 选择筛选器的值之后
 */
- (void)selectValue:(GoodsFilter *)goodsFilter {
    [filterTableView reloadData];
}

/**
 * 确定
 */
- (void) ok{
    NSMutableDictionary *dic = [goodsApi formatFilter:filterArray];
    [delegate selectFilter:dic];
    [self cancel];
}

/**
 * 取消
 */
- (void) cancel{
    [self.frostedViewController hideMenuViewController];
}

/**
 * 清除选项
 */
- (void) clear{
    if(filterArray == nil || filterArray.count == 0)
        return;
    for(GoodsFilter *filter in filterArray){
        filter.selectedValue = nil;
        for(GoodsFilterValue *value in filter.values){
            if([value.value length] == 0){
                value.selected = YES;
                continue;
            }
            value.selected = NO;
        }
    }
    [filterTableView reloadData];
}
@end