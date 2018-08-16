//
// Created by Dawei on 11/3/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "StoreViewController.h"
#import "StoreHeaderView.h"
#import "StoreBannerView.h"
#import "View+MASAdditions.h"
#import "ESLabel.h"
#import "NSString+Common.h"
#import "StoreHomeTabView.h"
#import "StoreOtherTabView.h"
#import "StoreIndexViewController.h"
#import "StoreApi.h"
#import "StoreAllGoodsViewController.h"
#import "StoreTagGoodsViewController.h"
#import "ToastUtils.h"
#import "Store.h"
#import "ESButton.h"
#import "StoreCategoryViewController.h"
#import "StoreGoodsListViewController.h"
#import "Goods.h"
#import "ControllerHelper.h"


@implementation StoreViewController {
    StoreHeaderView *headView;
    UIScrollView *scrollView;

    StoreBannerView *bannerView;

    StoreHomeTabView *homeTabView;
    StoreOtherTabView *goodsTabView;
    StoreOtherTabView *newTabView;
    StoreOtherTabView *hotTabView;
    StoreOtherTabView *recommendTabView;

    StoreIndexViewController *indexViewController;
    StoreAllGoodsViewController *allGoodsViewController;
    StoreTagGoodsViewController *newGoodsViewController;
    StoreTagGoodsViewController *hotGoodsViewController;
    StoreTagGoodsViewController *recommendGoodsViewController;

    StoreApi *storeApi;
    Store *store;

    UIView *maskView;
}

@synthesize storeid;

- (void)viewDidLoad {
    [super viewDidLoad];

    storeApi = [StoreApi new];

    self.delegate = self;
    self.dataSource = self;

    [self setupUI];

    //遮罩层
    maskView = [UIView new];
    [maskView setHidden:YES];
    [self.view addSubview:maskView];
    [maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(headView.mas_bottom).offset(3);
    }];
    UITapGestureRecognizer *maskTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMask:)];
    [maskTapGesture setNumberOfTapsRequired:1];
    [maskView addGestureRecognizer:maskTapGesture];

    [self loadData];
}

/**
 * 生成视图
 */
- (void)setupUI {
    headView = [StoreHeaderView new];
    [headView setBackAction:@selector(back)];
    [headView setCategoryAction:@selector(category)];
    headView.maskDelegate = self;
    headView.searchDelegate = self;
    [self.view addSubview:headView];

    bannerView = [StoreBannerView new];
    [bannerView.collectBtn addTarget:self action:@selector(collect:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bannerView];
    [bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@100);
    }];

    [self.view bringSubviewToFront:headView];
}

/**
 * 载入数据
 */
- (void)loadData {
    [storeApi detail:storeid success:^(Store *_store) {
        store = _store;
        [self showData];
    }        failure:^(NSError *error) {
        [ToastUtils hideLoading];
        [ToastUtils show:[error localizedDescription]];
    }];
}

/**
 * 初始化数据
 */
- (void)showData {
    if(store == nil)
        return;
    if(bannerView != nil){
        [bannerView configData:store];
    }
    [goodsTabView setCount:[NSString stringWithFormat:@"%d", store.goods_num]];
    [newTabView setCount:[NSString stringWithFormat:@"%d", store.new_num]];
    [hotTabView setCount:[NSString stringWithFormat:@"%d", store.hot_num]];
    [recommendTabView setCount:[NSString stringWithFormat:@"%d", store.recommend_num]];
}

#pragma mark - ViewPagerDataSource

- (NSUInteger)numberOfTabsForViewPager:(ViewPagerController *)viewPager {
    return 5;
}

#pragma mark - ViewPagerDataSource

- (UIView *)viewPager:(ViewPagerController *)viewPager viewForTabAtIndex:(NSUInteger)index {
    CGRect frame = CGRectMake(0, 0, kScreen_Width / 5, 55);
    if (index == 0) {
        homeTabView = [[StoreHomeTabView alloc] initWithFrame:frame];
        return homeTabView;
    } else if (index == 1) {
        goodsTabView = [[StoreOtherTabView alloc] initWithFrame:frame andTitle:@"全部商品"];
        return goodsTabView;
    } else if (index == 2) {
        newTabView = [[StoreOtherTabView alloc] initWithFrame:frame andTitle:@"上新"];
        return newTabView;
    } else if (index == 3) {
        hotTabView = [[StoreOtherTabView alloc] initWithFrame:frame andTitle:@"热卖"];
        return hotTabView;
    } else if (index == 4) {
        recommendTabView = [[StoreOtherTabView alloc] initWithFrame:frame andTitle:@"推荐"];
        return recommendTabView;
    }
    return nil;
}

#pragma mark - ViewPagerDataSource

- (UIViewController *)viewPager:(ViewPagerController *)viewPager contentViewControllerForTabAtIndex:(NSUInteger)index {
    if (index == 0) {
        if (indexViewController == nil) {
            indexViewController = [StoreIndexViewController new];
            indexViewController.delegate = self;
            indexViewController.storeid = storeid;
        }
        return indexViewController;
    } else if (index == 1) {
        if (allGoodsViewController == nil) {
            allGoodsViewController = [StoreAllGoodsViewController new];
            allGoodsViewController.delegate = self;
            allGoodsViewController.storeid = storeid;
        }
        return allGoodsViewController;
    } else if (index == 2) {
        if (newGoodsViewController == nil) {
            newGoodsViewController = [StoreTagGoodsViewController new];
            newGoodsViewController.storeid = storeid;
            newGoodsViewController.delegate = self;
            newGoodsViewController.tag = @"new";
        }
        return newGoodsViewController;
    } else if (index == 3) {
        if (hotGoodsViewController == nil) {
            hotGoodsViewController = [StoreTagGoodsViewController new];
            hotGoodsViewController.storeid = storeid;
            hotGoodsViewController.delegate = self;
            hotGoodsViewController.tag = @"hot";
        }
        return hotGoodsViewController;
    } else if (index == 4) {
        if (recommendGoodsViewController == nil) {
            recommendGoodsViewController = [StoreTagGoodsViewController new];
            recommendGoodsViewController.storeid = storeid;
            recommendGoodsViewController.delegate = self;
            recommendGoodsViewController.tag = @"recommend";
        }
        return recommendGoodsViewController;
    }
    return nil;
}

#pragma mark - ViewPagerDelegate

- (void)viewPager:(ViewPagerController *)viewPager didChangeTabToIndex:(NSUInteger)index {
    [homeTabView setSelected:NO];
    [goodsTabView setSelected:NO];
    [newTabView setSelected:NO];
    [hotTabView setSelected:NO];
    [recommendTabView setSelected:NO];
    switch (index) {
        case 0:
            [homeTabView setSelected:YES];
            break;
        case 1:
            [goodsTabView setSelected:YES];
            break;
        case 2:
            [newTabView setSelected:YES];
            break;
        case 3:
            [hotTabView setSelected:YES];
            break;
        case 4:
            [recommendTabView setSelected:YES];
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
            return 160.0;
        case ViewPagerOptionTabOffset:
            return 100.0;
        case ViewPagerOptionTabWidth:
            return (kScreen_Width / 5);
        case ViewPagerOptionTabHeight:
            return 55.0;
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

#pragma mark - StoreDelegate

- (void)scroll:(CGPoint)offset {
    if (offset.y >= 0) {

        float y = offset.y > 100 ? 100 : offset.y;

        CGRect bannerFrame = bannerView.frame;
        if (bannerFrame.origin.y > 60 || bannerFrame.origin.y < -40)
            return;

        bannerFrame.origin.y = 60 - y;
        bannerView.frame = bannerFrame;

        CGRect tabFrame = self.tabsView.frame;
        tabFrame.origin.y = 160 - y;
        self.tabsView.frame = tabFrame;

        CGRect contentFrame = self.contentView.frame;
        contentFrame.origin.y = 160 + tabFrame.size.height - y;
        self.contentView.frame = contentFrame;
    }
}

- (void)showGoods:(Goods *)goods {
    [self.navigationController pushViewController:[ControllerHelper createGoodsViewController:goods] animated:YES];
}


/**
 * 关注或取消关注
 * @param sender
 */
-(IBAction)collect:(ESButton *)sender{
    [ToastUtils showLoading];
    if(sender.selected){
        [storeApi uncollect:storeid success:^{
            [ToastUtils hideLoading];
            [ToastUtils show:@"取消关注店铺成功！"];
            [[NSNotificationCenter defaultCenter] postNotificationName:nFavriteChanged object:nil];
            [self loadData];
        } failure:^(NSError *error) {
            [ToastUtils hideLoading];
            [ToastUtils show:[error localizedDescription]];
        }];
        return;
    }
    [storeApi collect:storeid success:^{
        [ToastUtils hideLoading];
        [ToastUtils show:@"关注店铺成功！"];
        [[NSNotificationCenter defaultCenter] postNotificationName:nFavriteChanged object:nil];
        [self loadData];
    } failure:^(NSError *error) {
        [ToastUtils hideLoading];
        [ToastUtils show:[error localizedDescription]];
    }];
    return;
}

/**
 * 后退
 */
- (IBAction)back {
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 * 选择分类
 */
-(IBAction)category{
    StoreCategoryViewController *storeCategoryViewController = [StoreCategoryViewController new];
    storeCategoryViewController.storeid = storeid;
    [self.navigationController pushViewController:storeCategoryViewController animated:YES];
}

#pragma MaskDelegate

- (void)showMask {
    [maskView setHidden:NO];
    [UIView animateWithDuration:0.3 animations:^{
        maskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3f];
    }];
}

- (void)hideMask {
    [UIView animateWithDuration:0.3 animations:^{
        maskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0f];
    }                completion:^(BOOL finished) {
        [maskView setHidden:YES];
    }];
}

- (void)tapMask:(UITapGestureRecognizer *)gesture{
    [headView cancel];
}

#pragma SearchDelegate
- (void) search:(NSString *)_keyword searchType:(NSInteger)searchType{
    StoreGoodsListViewController *storeGoodsListViewController = [StoreGoodsListViewController new];
    storeGoodsListViewController.storeid = storeid;
    storeGoodsListViewController.keyword = _keyword;
    [self.navigationController pushViewController:storeGoodsListViewController animated:YES];
}

@end