//
// Created by Dawei on 1/27/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "GoodsViewController.h"
#import "GoodsDetailViewController.h"
#import "GoodsCommentViewController.h"
#import "Goods.h"
#import "GoodsOperationView.h"
#import "Masonry.h"
#import "ToastUtils.h"
#import "FavoriteApi.h"
#import "ControllerHelper.h"
#import "CartApi.h"
#import "CartViewController.h"
#import "Constants.h"
#import "Store.h"
#import "StoreViewController.h"
#import "ESButton.h"
#import <UShareUI/UShareUI.h>
#import "LBoprationView.h"


@implementation GoodsViewController {
    NSInteger tabIndex;

    GoodsOperationView *operationView;
    
    GoodsIntroViewController *goodsIntroViewController;
    GoodsDetailViewController *goodsDetailViewController;
    GoodsCommentViewController *goodsCommentViewController;

    FavoriteApi *favoriteApi;
    CartApi *cartApi;

    Store *store;
    
    LBoprationView *lboprationView;
}

@synthesize goods;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;

    favoriteApi = [FavoriteApi new];
    cartApi = [CartApi new];

    UIView *statusView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 20)];
    statusView.backgroundColor = [UIColor colorWithHexString:@"#FAFAFA"];
    [self.view addSubview:statusView];

    self.delegate = self;
    self.dataSource = self;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadCartCount) name:nLogin object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadCartCount) name:nLogout object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadCartCount) name:nAddCart object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadCartCount) name:nCheckout object:nil];

    [self loadCartCount];
}

- (void)createOperationView {
    operationView = [[GoodsOperationView alloc] initWithFrame:CGRectMake(0, kScreen_Height - 45, kScreen_Width, 45)];
    [self.view addSubview:operationView];
    [operationView setStoreAction:@selector(gotoStore)];
    [operationView setFavoriteAction:@selector(addFavorite:)];
    [operationView setAddCartAction:@selector(addToCart)];
    [operationView setCartAction:@selector(goToCart)];

    [operationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_bottom).offset(-45);
        make.bottom.left.right.equalTo(self.view);
    }];
}

- (void)createLBOperationView:(NSString *)btnName {
    lboprationView = [[LBoprationView alloc] initWithFrame:CGRectMake(0, kScreen_Height - 45, kScreen_Width, 45)];
    [lboprationView.addCartBtn setTitle:btnName forState:UIControlStateNormal];
    [self.view addSubview:lboprationView];
    [lboprationView setStoreAction:@selector(gotoStore)];
    [lboprationView setFavoriteAction:@selector(lbaddFavorite:)];
    [lboprationView setAddCartAction:@selector(gotoSeckill)];
//    [operationView setCartAction:@selector(goToCart)];
    
    [lboprationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_bottom).offset(-45);
        make.bottom.left.right.equalTo(self.view);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    //后退按钮
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(2, 0, 44, 44)];
    [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backBtn setContentMode:UIViewContentModeCenter];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.tabsView addSubview:backBtn];

//    ESButton *shareBtn = [[ESButton alloc] initWithFrame:CGRectMake(kScreen_Width - 44, 0, 44, 44)];
//    [shareBtn setImage:[UIImage imageNamed:@"share.png"] forState:UIControlStateNormal];
//    [shareBtn setContentMode:UIViewContentModeCenter];
//    [shareBtn addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
//    [self.tabsView addSubview:shareBtn];
}


#pragma mark - ViewPagerDataSource

- (NSUInteger)numberOfTabsForViewPager:(ViewPagerController *)viewPager {
    return 3;
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
            label.text = @"详情";
            break;
        case 2:
            label.text = @"评价";
            break;
    }

    [label sizeToFit];

    return label;
}

#pragma mark - ViewPagerDataSource

- (UIViewController *)viewPager:(ViewPagerController *)viewPager contentViewControllerForTabAtIndex:(NSUInteger)index {

    switch (index) {
        case 0:
            if (goodsIntroViewController == nil) {
                goodsIntroViewController = [[GoodsIntroViewController alloc] initWithGoods:goods delegate:self];
                
                __weak typeof (self)weakSelf = self;
                [goodsIntroViewController setBackOprationView:^(NSInteger is_seckill,NSString *btnName) {
                    if (is_seckill == 1) {
                        [weakSelf createLBOperationView:btnName];
                    }else {
                        [weakSelf createOperationView];
                    }
                }];
            }
            return goodsIntroViewController;
        case 1:
            if (goodsDetailViewController == nil) {
                goodsDetailViewController = [GoodsDetailViewController new];
                goodsDetailViewController.goodsId = goods.id;
            }
            return goodsDetailViewController;
        case 2:
            if (goodsCommentViewController == nil) {
                goodsCommentViewController = [GoodsCommentViewController new];
                goodsCommentViewController.goodsId = goods.id;
            }
            return goodsCommentViewController;
    }
    return nil;
}

#pragma mark - ViewPagerDelegate

- (void)viewPager:(ViewPagerController *)viewPager didChangeTabToIndex:(NSUInteger)index {
    tabIndex = index;
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

#pragma GoodsIntroDelegate

/**
 * 显示商品详情
 */
- (void)showDetail {
    [self selectTabAtIndex:1];
}

/**
 * 显示评论列表
 */
- (void)showComment {
    [self selectTabAtIndex:2];
}

- (void)setGoods:(Goods *)_goods {
    goods = _goods;
    [operationView setFavorited:goods.favorited];
}

- (void)setStore:(Store *)store1 {
    store = store1;
}

#pragma GoodsSpecDelegate

- (Goods *)getGoods {
    return goods;
}

/**
 * 选择规格
 */
- (void)selectSpec:(Goods *)_goods {
    goods = _goods;
    [goodsIntroViewController setGoods:_goods];
}

/**
 * 载入购物车数量
 */
- (void)loadCartCount {
    [cartApi count:^(NSInteger cartItemCount) {
        [operationView setCartCount:cartItemCount];
    }      failure:^(NSError *error) {

    }];
}

#pragma 事件

/**
 * 点击左上方的后退按钮
 */
- (IBAction)back {
    if (tabIndex > 0) {
        [self selectTabAtIndex:0];
    } else {
        if (self.navigationController) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

/**
 * 分享
 */
- (IBAction)share {
    //显示分享面板
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        NSString *urlString = goods.thumbnail;
        NSData *data = [NSData dataWithContentsOfURL:[NSURL  URLWithString:urlString]];
        UIImage *image = [UIImage imageWithData:data];
        //创建分享消息对象
        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
        
        //创建网页内容对象
        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:goods.name descr:goods.name thumImage:image];
        NSLog(goods.thumbnail);
        //设置网页地址
        shareObject.webpageUrl = [kBaseUrl stringByAppendingFormat:@"/goods-%d.html", goods.id];

        //分享消息对象设置分享内容对象
        messageObject.shareObject = shareObject;
        
        //调用分享接口
        [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
            if (error) {
                UMSocialLogInfo(@"************Share fail with error %@*********",error);
                [ToastUtils show:@"取消分享！"];
            }else{
                [ToastUtils show:@"分享成功！"];
            }
        }];

    }];
}

/**
 * 点击最下面的添加到购物车
 */
- (IBAction)addToCart {
    [ToastUtils showLoading:@"正在加入购物车..."];
    [cartApi add:goods.productId count:goods.buyCount success:^(NSInteger cartItemCount) {
        [ToastUtils hideLoading];
        [operationView setCartCount:cartItemCount];
        [ToastUtils show:@"添加到购物车成功!"];
        [[NSNotificationCenter defaultCenter] postNotificationName:nAddCart object:nil];
    }    failure:^(NSError *error) {
        [ToastUtils hideLoading];
        [ToastUtils show:[error localizedDescription]];
    }];
}

/**
 * 点击最下方的关注
 */
- (IBAction)addFavorite:(UIButton *)favoriteBtn {
    if (![ControllerHelper isLogined]) {
        [self presentViewController:[ControllerHelper createLoginViewController] animated:YES completion:nil];
        return;
    }
    if (favoriteBtn.isSelected) {
        [favoriteApi unfavorite:goods.id success:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:nFavriteChanged object:nil];
            [operationView setFavorited:NO];
        }               failure:^(NSError *error) {
            if (error.userInfo != nil && [error.userInfo objectForKey:@"message"]) {
                [ToastUtils show:[error.userInfo objectForKey:@"message"]];
            } else {
                [ToastUtils show:@"取消收藏失败,请您重试!"];
            }
        }];
    } else {
        [favoriteApi favorite:goods.id success:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:nFavriteChanged object:nil];
            [operationView setFavorited:YES];
        }             failure:^(NSError *error) {
            if (error.userInfo != nil && [error.userInfo objectForKey:@"message"]) {
                [ToastUtils show:[error.userInfo objectForKey:@"message"]];
            } else {
                [ToastUtils show:@"收藏失败,请您重试!"];
            }
        }];
    }
}

/**
 * 秒杀点击最下方的关注
 */
- (IBAction)lbaddFavorite:(UIButton *)favoriteBtn {
    if (![ControllerHelper isLogined]) {
        [self presentViewController:[ControllerHelper createLoginViewController] animated:YES completion:nil];
        return;
    }
    if (favoriteBtn.isSelected) {
        [favoriteApi unfavorite:goods.id success:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:nFavriteChanged object:nil];
            [lboprationView setFavorited:NO]; 
        }               failure:^(NSError *error) {
            if (error.userInfo != nil && [error.userInfo objectForKey:@"message"]) {
                [ToastUtils show:[error.userInfo objectForKey:@"message"]];
            } else {
                [ToastUtils show:@"取消收藏失败,请您重试!"];
            }
        }];
    } else {
        [favoriteApi favorite:goods.id success:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:nFavriteChanged object:nil];
            [lboprationView setFavorited:YES];
        }             failure:^(NSError *error) {
            if (error.userInfo != nil && [error.userInfo objectForKey:@"message"]) {
                [ToastUtils show:[error.userInfo objectForKey:@"message"]];
            } else {
                [ToastUtils show:@"收藏失败,请您重试!"];
            }
        }];
    }
}

/**
 * 点击最下方的到购物车
 */
- (IBAction)goToCart {
    [[self navigationController] pushViewController:[[CartViewController alloc] init] animated:YES];
}

/**
 * 点击最下方的联系客服
 */
- (IBAction)connectService {
    if (![Constants isLogin]) {
        [ToastUtils show:@"请您登录后进行此项操作！"];
        [self presentViewController:[ControllerHelper createLoginViewController] animated:YES completion:nil];
        return;
    }

    ChatViewController *chatViewController = [ControllerHelper createChatViewController];
    if (chatViewController == nil)
        return;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:chatViewController];
    [self presentViewController:navigationController animated:YES completion:nil];
}

/**
 * 进入店铺
 */
- (IBAction)gotoStore {
    StoreViewController *storeViewController = [StoreViewController new];
    storeViewController.storeid = store.id;
    [[self navigationController] pushViewController:storeViewController animated:YES];
}

/**
 * 立即秒杀
 */
- (IBAction)gotoSeckill {
    [cartApi addSeckill:goods.productId count:1 activity_id:goods.activity_id success:^(NSInteger cartItemCount) {
        [[NSNotificationCenter defaultCenter] postNotificationName:nAddCart object:nil];
    }    failure:^(NSError *error) {
        [ToastUtils show:[error localizedDescription]];
    }];
    [[self navigationController] pushViewController:[[CartViewController alloc] init] animated:YES];
}


@end
