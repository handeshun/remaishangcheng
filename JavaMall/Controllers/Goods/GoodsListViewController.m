#import <Masonry.h>
#import "MJRefresh.h"
#import "REFrostedViewController.h"
#import "NSString+Common.h"
#import "UIView+Common.h"
#import "GoodsListViewController.h"
#import "HeaderView.h"
#import "ErrorView.h"
#import "GoodsApi.h"
#import "GoodsListCell.h"
#import "Goods.h"
#import "GoodsGridCell.h"
#import "SortView.h"
#import "GoodsListHeaderView.h"
#import "ControllerHelper.h"
#import "ToastUtils.h"
#import "SearchViewController.h"
#import "StoreListViewController.h"

@implementation GoodsListViewController {
    GoodsListHeaderView *headerView;
    SortView *sortView;
    UICollectionView *goodsView;
    ErrorView *errorView;
    UIView *noDataView;

    GoodsApi *goodsApi;
    NSMutableArray *goodsArray;

    int page;
    NSString *sort;
    NSMutableDictionary *filterParameters;

    ListStyle listStyle;
    UICollectionViewFlowLayout *gridLayout;
    UICollectionViewFlowLayout *listLayout;
}

@synthesize categoryId, categoryName, keyword, brandId;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController setNavigationBarHidden:YES];

    goodsApi = [GoodsApi new];
    page = 1;
    sort = @"def_desc";
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

    [self createHeaderView];
    [self createSortView];
    [self createGoodsView];

    //加载商品
    [self loadGoods];
}

/**
 * 显示错误信息
 */
- (void)showError:(NSString *)errorText {
    if (errorView == nil) {
        errorView = [[ErrorView alloc] initWithTitle:errorText];
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
 * 创建搜索框视图
 */
- (void)createHeaderView {
    headerView = [[GoodsListHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 55)];
    [self.view addSubview:headerView];
    [headerView setBackAction:@selector(back)];
    [headerView setSearchAction:@selector(search)];
    [headerView setStyleBlock:^(ListStyle style) {
        listStyle = style;
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
    }];
}

/**
 * 搜索
 */
- (IBAction)search {
    SearchViewController *searchViewController = [SearchViewController new];
    searchViewController.delegate = self;
    [self presentViewController:searchViewController animated:YES completion:nil];
}

/**
 * 搜索回调事件
 */
- (void)search:(NSString *)_keyword searchType:(NSInteger)searchType{
    if(searchType == 0) {
        categoryId = 0;
        categoryName = nil;
        keyword = _keyword;
        page = 1;
        [goodsArray removeAllObjects];
        [self loadGoods];
    }else{
        StoreListViewController *storeListViewController = [StoreListViewController new];
        storeListViewController.keyword = _keyword;
        [self.navigationController pushViewController:storeListViewController animated:YES];
    }
}

/**
 * 后退
 */
- (IBAction)back {
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 * 创建排序视图
 */
- (void)createSortView {
    __weak typeof(self) weakSelf = self;
    sortView = [[SortView alloc] initWithFrame:CGRectMake(0, headerView.frame.size.height, 0, 0) sortBlock:^(NSInteger clickIndex) {
        //筛选
        if (clickIndex == 4) {
            [self.frostedViewController presentMenuViewController];
            return;
        }
        switch (clickIndex) {
            case 1:
                sort = @"def_desc";
                break;
            case 2:
                sort = @"buynum_desc";
                break;
            case 3:
                sort = @"price_asc";
                break;
            case 31:
                sort = @"price_desc";
                break;
        }
        page = 1;
        [goodsArray removeAllObjects];
        [weakSelf loadGoods];
    }];
    [self.view addSubview:sortView];
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
        make.top.equalTo(sortView.mas_bottom);
        make.left.and.right.and.bottom.equalTo(self.view);
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
    UIViewController *goodsViewController = [ControllerHelper createGoodsViewController:goods];
    [self.navigationController pushViewController:goodsViewController animated:YES];
}


/**
 * 载入商品
 */
- (void)loadGoods {
    if (errorView != nil) {
        [errorView removeFromSuperview];
    }
    if (noDataView != nil) {
        [noDataView removeFromSuperview];
    }

    NSMutableDictionary *parameter = [NSMutableDictionary dictionaryWithCapacity:0];
    [parameter setObject:[NSString stringWithFormat:@"%d", page] forKey:@"page"];
    [parameter setObject:sort forKey:@"sort"];
    if (categoryId > 0) {
        [parameter setObject:[NSString stringWithFormat:@"%d", categoryId] forKey:@"cat"];
    }
    if ([keyword length] > 0) {
        [parameter setObject:keyword forKey:@"keyword"];
    }
    if (brandId > 0) {
        [parameter setObject:[NSString stringWithFormat:@"%d", brandId] forKey:@"brand"];
    }
    if (filterParameters != nil) {
        [parameter addEntriesFromDictionary:filterParameters];
    }

    [ToastUtils showLoading];
    [goodsApi list:parameter success:^(NSMutableArray *goodsArr) {
        if (goodsArray == nil) {
            goodsArray = [NSMutableArray arrayWithCapacity:goodsArr.count];
        }
        [ToastUtils hideLoading];
        if (goodsArr == nil || goodsArr.count == 0) {
            goodsView.mj_footer.hidden = YES;
            if (page == 1) {
                [goodsArray removeAllObjects];
                [goodsView reloadData];
                [self showNoData];
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

        if (errorView == nil) {
            errorView = [[ErrorView alloc] initWithTitle:@"载入商品失败, 点击这里重试!"];
            [errorView setGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reloadGoods:)]];
        }
        [self.view addSubview:errorView];
        [errorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.view.mas_centerY);
            make.centerX.equalTo(self.view.mas_centerX);
            make.width.equalTo(self.view.mas_width);
            make.height.equalTo(@120);
        }];

    }];
}

/**
 * 显示没有数据
 */
- (void)showNoData {
    if (noDataView == nil) {
        noDataView = [UIView new];
        UILabel *nodataLabel = [UILabel new];
        [nodataLabel setText:@"抱歉，没有符合条件的商品"];
        [nodataLabel setTextColor:[UIColor darkGrayColor]];
        [nodataLabel setFont:[UIFont systemFontOfSize:14]];
        [noDataView addSubview:nodataLabel];
        [nodataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(noDataView);
        }];
    }
    [self.view addSubview:noDataView];
    [noDataView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.view.mas_centerY);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.equalTo(self.view.mas_width);
        make.height.equalTo(@25);
    }];
}

/**
 * 网络请求出错时,重新载入商品
 */
- (void)reloadGoods:(UITapGestureRecognizer *)gesture {
    [self loadGoods];
}

/**
 * 筛选回调
 */
- (void)selectFilter:(NSMutableDictionary *)parameters {
    filterParameters = parameters;
    page = 1;
    [goodsArray removeAllObjects];
    [self loadGoods];
}

@end
