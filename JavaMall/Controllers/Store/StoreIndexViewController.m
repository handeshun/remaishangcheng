//
// Created by Dawei on 11/3/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "StoreIndexViewController.h"
#import "GoodsListCell.h"
#import "GoodsGridCell.h"
#import "StoreDelegate.h"
#import "View+MASAdditions.h"
#import "StoreBonusCell.h"
#import "StoreApi.h"
#import "ToastUtils.h"
#import "StoreGoodsCellHeader.h"
#import "StoreGoodsCellFooter.h"
#import "StoreBonusCellHeader.h"
#import "StoreBonusCellFooter.h"
#import "ESLabel.h"
#import "Bonus.h"
#import "Goods.h"
#import "ControllerHelper.h"


@implementation StoreIndexViewController {
    UICollectionView *collectionView;
    UICollectionViewFlowLayout *gridLayout;

    StoreApi *storeApi;

    NSMutableArray *bonuses;

    NSMutableDictionary *goodsDic;
}

@synthesize delegate;
@synthesize storeid;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f3f2f7"];

    storeApi = [StoreApi new];
    bonuses = [NSMutableArray arrayWithCapacity:0];
    goodsDic = [NSMutableDictionary dictionaryWithCapacity:0];

    gridLayout = [[UICollectionViewFlowLayout alloc] init];
    gridLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    gridLayout.minimumInteritemSpacing = 0;
    gridLayout.minimumLineSpacing = 5;

    collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height - 115) collectionViewLayout:gridLayout];
    collectionView.backgroundColor = [UIColor colorWithHexString:kHeaderBackgroundColor];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [collectionView registerClass:[GoodsGridCell class] forCellWithReuseIdentifier:@"Grid"];
    [collectionView registerClass:[StoreBonusCell class] forCellWithReuseIdentifier:kCellIdentifier_StoreBonusCell];
    [collectionView registerClass:[StoreGoodsCellHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kCellIdentifier_StoreGoodsCellHeader];
    [collectionView registerClass:[StoreGoodsCellFooter class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kCellIdentifier_StoreGoodsCellFooter];
    [collectionView registerClass:[StoreBonusCellHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kCellIdentifier_StoreBonusCellHeader];
    [collectionView registerClass:[StoreBonusCellFooter class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kCellIdentifier_StoreBonusCellFooter];

    [self.view addSubview:collectionView];

    [self loadData];
}

/**
 * 载入数据
 */
- (void)loadData {
    [ToastUtils showLoading];
    [storeApi bonusList:storeid success:^(NSMutableArray *_bonuses) {
        [ToastUtils hideLoading];
        [bonuses removeAllObjects];
        [bonuses addObjectsFromArray:_bonuses];
        [collectionView reloadData];
    }           failure:^(NSError *error) {
        [ToastUtils hideLoading];
        [ToastUtils show:[error localizedDescription]];
    }];

    //载入商品
    [storeApi indexGoods:storeid success:^(NSMutableDictionary *_goodsDic) {
        goodsDic = _goodsDic;
        [collectionView reloadData];
    } failure:^(NSError *error) {
        [ToastUtils hideLoading];
        [ToastUtils show:[error localizedDescription]];
    }];
}

-(NSMutableArray *)getGoodsListBySection:(NSInteger)section{
    if(section == 1){
        return [goodsDic objectForKey:@"new"];
    }else if(section == 2){
        return [goodsDic objectForKey:@"hot"];
    }else if(section == 3){
        return [goodsDic objectForKey:@"recommend"];
    }
    return nil;
}

#pragma mark collectionView代理方法

/**
 * section个数
 * @param collectionView
 * @return
 */
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 4;
}

/**
 * 每个section的item个数
 * @param collectionView
 * @param section
 * @return
 */
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return bonuses.count;
    }
    return [self getGoodsListBySection:section].count;
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
    if (indexPath.section == 0) {
        StoreBonusCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier_StoreBonusCell forIndexPath:indexPath];
        [cell configData:[bonuses objectAtIndex:indexPath.row]];
        return cell;
    }

    Goods *goods = [[self getGoodsListBySection:indexPath.section] objectAtIndex:indexPath.row];
    GoodsGridCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Grid" forIndexPath:indexPath];
    [cell config:goods];
    return cell;
}

#pragma UICollectionViewDelegateFlowLayout

/**
 * 设置每个item的尺寸
 * @param collectionView
 * @param collectionViewLayout
 * @param indexPath
 * @return
 */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return CGSizeMake(100, 45);
    }
    return CGSizeMake((kScreen_Width - 15) / 2, (kScreen_Width - 30) / 2 + 58);
}

/**
 * 设置每个item的UIEdgeInsets
 * @param collectionView
 * @param collectionViewLayout
 * @param section
 * @return
 */
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (section == 0) {
        if(bonuses.count > 0) {
            return (UIEdgeInsets) {10, 5, 10, 5};
        }
        return (UIEdgeInsets) {0, 0, 0, 0};
    }
    return (UIEdgeInsets) {0, 5, 0, 5};
}

/**
 * 设置每个item水平间距
 * @param collectionView
 * @param collectionViewLayout
 * @param section
 * @return
 */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    if (section == 0) {
        return 5;
    }
    return 0.01f;
}

/**
 * 设置每个item垂直间距
 * @param collectionView
 * @param collectionViewLayout
 * @param section
 * @return
 */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

/**
 * 显示header和footer
 * @param collectionView
 * @param kind
 * @param indexPath
 * @return
 */
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (kind == UICollectionElementKindSectionHeader) {
        if(indexPath.section == 0){
            StoreBonusCellHeader *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kCellIdentifier_StoreBonusCellHeader forIndexPath:indexPath];
            return view;
        }
        StoreGoodsCellHeader *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kCellIdentifier_StoreGoodsCellHeader forIndexPath:indexPath];
        switch (indexPath.section){
            case 1:
                view.titleLbl.text = @"最新上架";
                break;
            case 2:
                view.titleLbl.text = @"热卖排行";
                break;
            case 3:
                view.titleLbl.text = @"推荐商品";
                break;
        }
        return view;
    }
    if (kind == UICollectionElementKindSectionFooter) {
        if(indexPath.section == 0){
            StoreBonusCellFooter *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kCellIdentifier_StoreBonusCellFooter forIndexPath:indexPath];
            return view;
        }
        StoreGoodsCellFooter *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kCellIdentifier_StoreGoodsCellFooter forIndexPath:indexPath];
        return view;
    }
    return nil;
}

/**
 * 返回头headerView的大小
 * @param collectionView
 * @param collectionViewLayout
 * @param section
 * @return
 */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return CGSizeMake(kScreen_Width, 1);
    }
    return CGSizeMake(kScreen_Width, 45);
}

/**
 * 返回footerView的大小
 * @param collectionView
 * @param collectionViewLayout
 * @param section
 * @return
 */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return CGSizeMake(kScreen_Width, 1);
    }
    return CGSizeMake(kScreen_Width, 10);
}

/**
 * 点击事件
 * @param collectionView
 * @param indexPath
 */
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0){
        Bonus *bonus = [bonuses objectAtIndex:indexPath.row];
        [self getBonus:bonus];
        return;
    }
    Goods *goods = [[self getGoodsListBySection:indexPath.section] objectAtIndex:indexPath.row];
    if(delegate != nil){
        [delegate showGoods:goods];
    }
}

/**
 * 领取优惠券
 * @param bonus
 */
-(void)getBonus:(Bonus *)bonus{
    [ToastUtils showLoading];
    [storeApi getBonus:storeid type_id:bonus.type success:^{
        [ToastUtils hideLoading];
        [ToastUtils show:@"领取优惠券成功！"];
    } failure:^(NSError *error) {
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