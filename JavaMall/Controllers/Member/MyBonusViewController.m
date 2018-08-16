//
// Created by Dawei on 11/7/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "MyBonusViewController.h"
#import "HeaderView.h"
#import "MemberApi.h"
#import "ESLabel.h"
#import "ToastUtils.h"
#import "MyBonusListViewController.h"


@implementation MyBonusViewController {
    HeaderView *headerView;

    MemberApi *memberApi;

    ESLabel *unusedLbl;
    ESLabel *usedLbl;
    ESLabel *expiredLbl;

    MyBonusListViewController *unusedViewController;
    MyBonusListViewController *usedViewController;
    MyBonusListViewController *expiredViewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithHexString:@"#f1f2f7"];
    memberApi = [MemberApi new];

    self.delegate = self;
    self.dataSource = self;

    headerView = [[HeaderView alloc] initWithTitle:@"优惠券"];
    [headerView setBackAction:@selector(back)];
    [self.view addSubview:headerView];

    [self loadData];
}


- (void)loadData {
    [ToastUtils showLoading];
    [memberApi bonusCount:^(NSInteger unusedCount, NSInteger usedCount, NSInteger expriedCount) {
        [ToastUtils hideLoading];
        unusedLbl.text = [NSString stringWithFormat:@"未使用(%d)", unusedCount];
        usedLbl.text = [NSString stringWithFormat:@"已使用(%d)", usedCount];
        expiredLbl.text = [NSString stringWithFormat:@"已过期(%d)", expriedCount];
    } failure:^(NSError *error) {
        [ToastUtils hideLoading];
        [ToastUtils show:[error localizedDescription]];
    }];
}

#pragma mark - ViewPagerDataSource

- (NSUInteger)numberOfTabsForViewPager:(ViewPagerController *)viewPager {
    return 3;
}

#pragma mark - ViewPagerDataSource

- (UIView *)viewPager:(ViewPagerController *)viewPager viewForTabAtIndex:(NSUInteger)index {
    if (index == 0) {
        unusedLbl = [[ESLabel alloc] initWithText:@"未使用(0)" textColor:[UIColor colorWithHexString:@"#f22e2f"] fontSize:14];
        [unusedLbl sizeToFit];
        return unusedLbl;
    } else if (index == 1) {
        usedLbl = [[ESLabel alloc] initWithText:@"已使用(0)" textColor:[UIColor darkGrayColor] fontSize:14];
        [usedLbl sizeToFit];
        return usedLbl;
    } else if (index == 2) {
        expiredLbl = [[ESLabel alloc] initWithText:@"已过期(0)" textColor:[UIColor darkGrayColor] fontSize:14];
        [expiredLbl sizeToFit];
        return expiredLbl;
    }
    return nil;
}

#pragma mark - ViewPagerDataSource

- (UIViewController *)viewPager:(ViewPagerController *)viewPager contentViewControllerForTabAtIndex:(NSUInteger)index {
    if(index == 0){
        if(unusedViewController == nil){
            unusedViewController = [MyBonusListViewController new];
            unusedViewController.type = 1;
        }
        return unusedViewController;
    }else if(index == 1){
        if(usedViewController == nil){
            usedViewController = [MyBonusListViewController new];
            usedViewController.type = 2;
        }
        return usedViewController;
    }else if(index == 2){
        if(expiredViewController == nil){
            expiredViewController = [MyBonusListViewController new];
            expiredViewController.type = 3;
        }
        return expiredViewController;
    }
    return nil;
}

#pragma mark - ViewPagerDelegate

- (void)viewPager:(ViewPagerController *)viewPager didChangeTabToIndex:(NSUInteger)index {
    unusedLbl.textColor = [UIColor darkGrayColor];
    usedLbl.textColor = [UIColor darkGrayColor];
    expiredLbl.textColor = [UIColor darkGrayColor];
    switch (index){
        case 0:
            unusedLbl.textColor = [UIColor colorWithHexString:@"#f22e2f"];
            break;
        case 1:
            usedLbl.textColor = [UIColor colorWithHexString:@"#f22e2f"];
            break;
        case 2:
            expiredLbl.textColor = [UIColor colorWithHexString:@"#f22e2f"];
            break;
    }
}

#pragma mark - ViewPagerDelegate

- (CGFloat)viewPager:(ViewPagerController *)viewPager valueForOption:(ViewPagerOption)option withDefault:(CGFloat)value {

    switch (option) {
        case ViewPagerOptionStartFromSecondTab:
            return 0.0;
        case ViewPagerOptionCenterCurrentTab:
            return 0.0;
        case ViewPagerOptionTabLocation:
            return 2.0;
        case ViewPagerOptionTabLocationFrameY:
            return 60.0;
        case ViewPagerOptionTabOffset:
            return 50.0;
        case ViewPagerOptionTabWidth:
            return (kScreen_Width / 3);
        case ViewPagerOptionTabHeight:
            return 40.0;
        default:
            return value;
    }
}

#pragma mark - ViewPagerDelegate

- (UIColor *)viewPager:(ViewPagerController *)viewPager colorForComponent:(ViewPagerComponent)component withDefault:(UIColor *)color {

    switch (component) {
        case ViewPagerIndicator:
            return [UIColor colorWithHexString:@"#f22e2f"];
        case ViewPagerTabsView:
            return [UIColor colorWithHexString:@"#FAFAFA"];
        default:
            return color;
    }
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