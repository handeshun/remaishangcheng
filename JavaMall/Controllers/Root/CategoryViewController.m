//
// Created by Dawei on 1/4/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "CategoryViewController.h"
#import "CategoryHeaderView.h"
#import "CategoryApi.h"
#import "Menu.h"
#import "RDVTabBarController.h"

#import "MultilevelMenu.h"
#import "View+MASAdditions.h"
#import "ErrorView.h"
#import "GoodsCategory.h"
#import "ControllerHelper.h"
#import "ToastUtils.h"
#import "SearchViewController.h"
#import "StoreListViewController.h"

#import "FightgroupsViewController.h"
#import "PintuanListViewController.h"
@implementation CategoryViewController {
    CategoryApi *categoryApi;

    CategoryHeaderView *headerView;
    MultilevelMenu *menuView;
    ErrorView *errorView;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    categoryApi = [CategoryApi new];

    headerView = [[CategoryHeaderView alloc] init];
    [self.view addSubview:headerView];
    [headerView setSearchAction:@selector(searchAction:)];

    [self loadCategories:nil];
}

/**
 *  点击搜索事件
 *
 *  @param gesture
 */
- (void)searchAction:(UITapGestureRecognizer *)gesture{
    SearchViewController *searchViewController = [SearchViewController new];
    searchViewController.delegate = self;
    [self presentViewController:searchViewController animated:YES completion:nil];

}

/**
 * 搜索回调事件
 */
- (void)search:(NSString *)_keyword searchType:(NSInteger)searchType{
    if(searchType == 0) {
        [[self rdv_tabBarController].navigationController pushViewController:[ControllerHelper createGoodsListViewController:0 categoryName:nil keyword:_keyword brandId:0] animated:YES];
    }else{
        StoreListViewController *storeListViewController = [StoreListViewController new];
        storeListViewController.keyword = _keyword;
        [[self rdv_tabBarController].navigationController pushViewController:storeListViewController animated:YES];
    }
}

/**
 * 显示错误信息
 */
- (void)showError:(NSString *)errorText {
    if (menuView != nil) {
        [menuView removeFromSuperview];
    }
    if (errorView == nil) {
        errorView = [[ErrorView alloc] initWithTitle:errorText];
        [errorView setGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loadCategories:)]];
    }
    [self.view addSubview:errorView];
    [errorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.view.mas_centerY);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.equalTo(self.view.mas_width);
        make.height.equalTo(@120);
    }];
}

/**
 * 载入分类
 */
- (void)loadCategories:(UITapGestureRecognizer *)gesture {
    if (errorView != nil) {
        [errorView removeFromSuperview];
    }
    [ToastUtils showLoading];
    [categoryApi loadAll:^(NSMutableArray *categories) {
        NSMutableArray *menus = [NSMutableArray arrayWithCapacity:categories.count];

        for (GoodsCategory *category in categories) {
            //一级
            Menu *menu = [[Menu alloc] init];
            menu.menuName = category.name;
            menu.id = category.id;

            //二级
            NSMutableArray *level2Menus = [NSMutableArray arrayWithCapacity:0];
            if (category.children != nil) {
                for (GoodsCategory *level2 in category.children) {
                    Menu *menu2 = [[Menu alloc] init];
                    menu2.menuName = level2.name;
                    menu2.id = level2.id;
                    [level2Menus addObject:menu2];

                    //三级
                    NSMutableArray *level3Menus = [NSMutableArray arrayWithCapacity:0];
                    if (level2.children != nil) {
                        for (GoodsCategory *level3 in level2.children) {
                            Menu *menu3 = [[Menu alloc] init];
                            menu3.menuName = level3.name;
                            menu3.urlName = level3.image;
                            menu3.id = level3.id;
                            [level3Menus addObject:menu3];
                        }
                    }
                    menu2.nextArray = level3Menus;
                }
            }
            menu.nextArray = level2Menus;
            [menus addObject:menu];

            [self initCategoryView:menus];
            [ToastUtils hideLoading];
        }

    } failure:^(NSError *error) {
        [ToastUtils hideLoading];
        [self showError:@"载入分类失败, 点击这里重试!"];
        DebugLog(error.debugDescription);
    }];
}

/**
 * 初始化三级分类视图
 */
- (void)initCategoryView:(NSMutableArray *)menus {
    //初始化分类视图
    menuView = [[MultilevelMenu alloc] initWithFrame:CGRectMake(0, 60, kScreen_Width, kScreen_Height - 49 - 60) WithData:menus withSelectIndex:^(NSInteger left, NSInteger right, Menu *info) {
        [[self rdv_tabBarController].navigationController pushViewController:[ControllerHelper createGoodsListViewController:info.id categoryName:info.menuName keyword:nil brandId:0] animated:YES];
    }];
    menuView.needToScorllerIndex = 0;
    menuView.isRecordLastScroll = YES;
    [self.view addSubview:menuView];
}
@end
