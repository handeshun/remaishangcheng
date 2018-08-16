//
// Created by Dawei on 11/8/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "MyFavoriteViewController.h"
#import "MyFavoriteGoodsViewController.h"
#import "MyFavoriteStoreViewController.h"


@implementation MyFavoriteViewController {
    MyFavoriteGoodsViewController *myFavoriteGoodsViewController;
    MyFavoriteStoreViewController *myFavoriteStoreViewController;
}

@synthesize tabIndex;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;

    UIView *statusView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 20)];
    statusView.backgroundColor = [UIColor colorWithHexString:@"#FAFAFA"];
    [self.view addSubview:statusView];

    self.delegate = self;
    self.dataSource = self;
    self.pageViewController.dataSource = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    //后退按钮
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(2, 0, 44, 44)];
    [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backBtn setContentMode:UIViewContentModeCenter];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.tabsView addSubview:backBtn];

    if(tabIndex == 1){
        [self selectTabAtIndex:1];
    }
}

/**
 * 点击左上方的后退按钮
 */
- (IBAction)back {
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - ViewPagerDataSource

- (NSUInteger)numberOfTabsForViewPager:(ViewPagerController *)viewPager {
    return 2;
}

#pragma mark - ViewPagerDataSource

- (UIView *)viewPager:(ViewPagerController *)viewPager viewForTabAtIndex:(NSUInteger)index {

    UILabel *label = [UILabel new];
    label.font = [UIFont systemFontOfSize:14];
    switch (index) {
        case 0:
            label.text = @"商品";
            break;
        case 1:
            label.text = @"店铺";
            break;
    }

    [label sizeToFit];

    return label;
}

#pragma mark - ViewPagerDataSource

- (UIViewController *)viewPager:(ViewPagerController *)viewPager contentViewControllerForTabAtIndex:(NSUInteger)index {

    switch (index) {
        case 0:
            if (myFavoriteGoodsViewController == nil) {
                myFavoriteGoodsViewController = [MyFavoriteGoodsViewController new];
            }
            return myFavoriteGoodsViewController;
        case 1:
            if (myFavoriteStoreViewController == nil) {
                myFavoriteStoreViewController = [MyFavoriteStoreViewController new];
            }
            return myFavoriteStoreViewController;
    }
    return nil;
}

#pragma mark - ViewPagerDelegate

- (void)viewPager:(ViewPagerController *)viewPager didChangeTabToIndex:(NSUInteger)index {
}

#pragma mark - ViewPagerDelegate

- (CGFloat)viewPager:(ViewPagerController *)viewPager valueForOption:(ViewPagerOption)option withDefault:(CGFloat)value {

    switch (option) {
        case ViewPagerOptionStartFromSecondTab:
            return 0.0;
        case ViewPagerOptionCenterCurrentTab:
            return 0.0;
        case ViewPagerOptionTabLocation:
            return 1.0;
        case ViewPagerOptionTabWidth:
            return 60.0;
        default:
            return value;
    }
}

#pragma mark - ViewPagerDelegate

- (UIColor *)viewPager:(ViewPagerController *)viewPager colorForComponent:(ViewPagerComponent)component withDefault:(UIColor *)color {

    switch (component) {
        case ViewPagerIndicator:
            return [UIColor blackColor];
        case ViewPagerTabsView:
            return [UIColor colorWithHexString:@"#FAFAFA"];
        default:
            return color;
    }
}

@end