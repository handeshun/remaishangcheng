//
// Created by Dawei on 11/5/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "StoreAllGoodsViewController.h"
#import "GoodsListHeaderView.h"
#import "StoreApi.h"
#import "ToastUtils.h"
#import "GoodsListCell.h"
#import "GoodsGridCell.h"
#import "StoreDelegate.h"
#import "MJRefresh.h"
#import "Masonry.h"
#import "ControllerHelper.h"
#import "StoreSortView.h"
#import "Goods.h"


@implementation StoreAllGoodsViewController {
    StoreSortView *storeSortView;
    UICollectionView *goodsView;

    StoreApi *storeApi;
    NSMutableArray *goodsArray;

    int page;

    NSString *order;
    NSString *key;

    ListStyle listStyle;
    UICollectionViewFlowLayout *gridLayout;
    UICollectionViewFlowLayout *listLayout;
}

@synthesize storeid, catid, keyword;
@synthesize delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController setNavigationBarHidden:YES];

    storeApi = [StoreApi new];
    page = 1;

    key = @"1";
    order = @"desc";
    if ([keyword length] == 0) {
        keyword = @"";
    }

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

    [self createSortView];
    [self createGoodsView];

    //加载商品
    [self loadGoods];
}

/**
 * 创建排序视图
 */
- (void)createSortView {
    __weak typeof(self) weakSelf = self;
    storeSortView = [[StoreSortView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) sortBlock:^(NSInteger clickIndex) {
        //筛选
        if (clickIndex == 4) {
            if(!storeSortView.gridList.isSelected){
                listStyle = Grid;
                [storeSortView.gridList setSelected:YES];
            }else{
                listStyle = List;
                [storeSortView.gridList setSelected:NO];
            }
            if (listStyle == List) {
                [goodsView setCollectionViewLayout:listLayout animated:NO completion:^(BOOL finished) {
                    [goodsView reloadData];
                }];
            } else {
                float offset = goodsView.contentOffset.y;
                [goodsView setCollectionViewLayout:gridLayout animated:NO completion:^(BOOL finished) {
                    [goodsView reloadData];
                    if (offset == 0) {
                        [goodsView setContentOffset:CGPointMake(0, 0)];
                    }
                }];
            }
            return;
        }
        switch (clickIndex) {
            case 1:
                key = @"1";
                order = @"desc";
                break;
            case 2:
                key = @"3";
                order = @"desc";
                break;
            case 3:
                key = @"2";
                order = @"asc";
                break;
            case 31:
                key = @"2";
                order = @"desc";
                break;
        }
        page = 1;
        [goodsArray removeAllObjects];
        [weakSelf loadGoods];
    }];
    [self.view addSubview:storeSortView];
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
        make.top.equalTo(storeSortView.mas_bottom);
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
    NSMutableDictionary *parameter = [NSMutableDictionary dictionaryWithCapacity:0];
    [parameter setObject:[NSString stringWithFormat:@"%d", page] forKey:@"page"];
    [parameter setObject:key forKey:@"key"];
    [parameter setObject:order forKey:@"order"];

    if (catid > 0) {
        [parameter setObject:[NSString stringWithFormat:@"%d", catid] forKey:@"cat_id"];
    }
    if ([keyword length] > 0) {
        [parameter setObject:keyword forKey:@"keyword"];
    }

    [ToastUtils showLoading];
    [storeApi goodsList:storeid  parameters:parameter success:^(NSMutableArray *goodsArr) {
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