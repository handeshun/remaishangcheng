//
// Created by Dawei on 11/5/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "StoreTagGoodsViewController.h"
#import "StoreDelegate.h"
#import "StoreApi.h"
#import "GoodsListHeaderView.h"
#import "GoodsListCell.h"
#import "GoodsGridCell.h"
#import "MJRefresh.h"
#import "Masonry.h"
#import "ControllerHelper.h"
#import "Goods.h"
#import "ToastUtils.h"


@implementation StoreTagGoodsViewController {
    UICollectionView *goodsView;

    StoreApi *storeApi;
    NSMutableArray *goodsArray;

    int page;

    ListStyle listStyle;
    UICollectionViewFlowLayout *gridLayout;
    UICollectionViewFlowLayout *listLayout;
}

@synthesize tag, storeid, delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController setNavigationBarHidden:YES];

    storeApi = [StoreApi new];
    page = 1;

    //商品列表样式
    gridLayout = [[UICollectionViewFlowLayout alloc] init];
    gridLayout.minimumLineSpacing = 5;
    gridLayout.minimumInteritemSpacing = 5;
    gridLayout.itemSize = CGSizeMake((kScreen_Width - 15) / 2, (kScreen_Width - 30) / 2 + 58); //宽=(屏幕长度-间距)/2 高=宽+标题高度+价格高度
    gridLayout.sectionInset = (UIEdgeInsets) {0, 5, 0, 5};

    listLayout = [[UICollectionViewFlowLayout alloc] init];
    listLayout.minimumLineSpacing = 0;
    listLayout.minimumInteritemSpacing = 0;
    listLayout.itemSize = CGSizeMake(kScreen_Width, 100);

    [self createGoodsView];

    //加载商品
    [self loadGoods];
}


/**
 * 创建商品列表视图
 */
- (void)createGoodsView {
    goodsView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 85, kScreen_Width, kScreen_Height - 85) collectionViewLayout:listLayout];
    goodsView.backgroundColor = [UIColor colorWithHexString:kHeaderBackgroundColor];
    goodsView.delegate = self;
    goodsView.dataSource = self;

    [goodsView registerClass:[GoodsListCell class] forCellWithReuseIdentifier:@"List"];
    [goodsView registerClass:[GoodsGridCell class] forCellWithReuseIdentifier:@"Grid"];

    goodsView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        page++;
        [self loadGoods];
    }];
    [self.view addSubview:goodsView];
    [goodsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-40);
    }];
}

/**
 * 返回商品数量
 */
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return goodsArray.count;
}

/**
 *  设置cell样式
 *
 *  @param tableView
 *  @param indexPath
 *
 *  @return
 */
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (listStyle == List) {
        GoodsListCell *cell = [goodsView dequeueReusableCellWithReuseIdentifier:@"List" forIndexPath:indexPath];
        [cell config:[goodsArray objectAtIndex:[indexPath row]]];
        return cell;
    } else {
        GoodsGridCell *cell = [goodsView dequeueReusableCellWithReuseIdentifier:@"Grid" forIndexPath:indexPath];
        [cell config:[goodsArray objectAtIndex:[indexPath row]]];
        return cell;
    }
}

/**
 * 点击商品
 */
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    Goods *goods = [goodsArray objectAtIndex:[indexPath row]];
    if(delegate != nil){
        [delegate showGoods:goods];
    }
}


/**
 * 载入商品
 */
- (void)loadGoods {
    [ToastUtils showLoading];
    [storeApi tagGoods:storeid tag:tag page:page success:^(NSMutableArray *goodsArr) {
        if (goodsArray == nil) {
            goodsArray = [NSMutableArray arrayWithCapacity:goodsArr.count];
        }
        [ToastUtils hideLoading];
        if (goodsArr == nil || goodsArr.count == 0) {
            goodsView.mj_footer.hidden = YES;
            if (page == 1) {
                [goodsArray removeAllObjects];
                [goodsView reloadData];
            }
            return;
        }
        //没有更多数据时隐藏'加载更多'
        goodsView.mj_footer.hidden = goodsArr.count < 20;
        [goodsView.mj_footer endRefreshing];
        [goodsArray addObjectsFromArray:goodsArr];
        [goodsView reloadData];
    }      failure:^(NSError *error) {
        DebugLog(@"%@", [error description]);
        [ToastUtils hideLoading];
        [ToastUtils show:[error localizedDescription]];

    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (delegate != nil) {
        [delegate scroll:scrollView.contentOffset];
    }
}

@end