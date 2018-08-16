//
// Created by Dawei on 11/8/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "StoreCell.h"
#import "ESLabel.h"
#import "Masonry.h"
#import "UIView+Common.h"
#import "StoreGoodsCell.h"
#import "Store.h"
#import "UIImageView+EMWebCache.h"
#import "ESButton.h"


@implementation StoreCell {
    /**
     * 店铺logo
     */
    UIImageView *logoIv;

    /**
     * 店铺名称
     */
    ESLabel *nameLbl;

    ESLabel *creditTitleLbl;

    /**
     * 店铺信用
     */
    ESLabel *creditLbl;

    /**
     * 关注人数
     */
    ESLabel *collectNumberLbl;

    UIView *headerLine;
    UIView *footerLine;

    UICollectionView *collectionView;
    UICollectionViewFlowLayout *gridLayout;

    NSMutableArray *goodsArray;
}

@synthesize toStoreBtn;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        goodsArray = [NSMutableArray arrayWithCapacity:0];

        logoIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"store_logo_placeholder.png"]];
        logoIv.contentMode =  UIViewContentModeScaleAspectFill;
        [logoIv borderWidth:0.5f color:[UIColor colorWithHexString:@"#d1d1d1"] cornerRadius:0];
        [self addSubview:logoIv];
        [logoIv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(10);
            make.top.equalTo(self).offset(15);
            make.width.equalTo(@95);
            make.height.equalTo(@30);
        }];

        nameLbl = [[ESLabel alloc] initWithText:@"店铺名称店铺名称" textColor:[UIColor darkGrayColor] fontSize:14];
        [self addSubview:nameLbl];
        [nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(logoIv.mas_right).offset(5);
            make.top.equalTo(logoIv).offset(-5);
        }];

        collectNumberLbl = [[ESLabel alloc] initWithText:@"1989人关注" textColor:[UIColor grayColor] fontSize:12];
        [self addSubview:collectNumberLbl];
        [collectNumberLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(nameLbl);
            make.top.equalTo(nameLbl.mas_bottom).offset(5);
        }];

        creditTitleLbl = [[ESLabel alloc] initWithText:@"信用" textColor:[UIColor grayColor] fontSize:12];
        [self addSubview:creditTitleLbl];
        [creditTitleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(collectNumberLbl);
            make.left.equalTo(collectNumberLbl.mas_right).offset(10);
        }];

        creditLbl = [[ESLabel alloc] initWithText:@"5分" textColor:[UIColor colorWithHexString:@"#f22e2f"] fontSize:12];
        [self addSubview:creditLbl];
        [creditLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(collectNumberLbl);
            make.left.equalTo(creditTitleLbl.mas_right).offset(2);
        }];

        gridLayout = [[UICollectionViewFlowLayout alloc] init];
        gridLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        gridLayout.minimumInteritemSpacing = 0;
        gridLayout.minimumLineSpacing = 5;

        collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:gridLayout];
        collectionView.backgroundColor = [UIColor colorWithHexString:kHeaderBackgroundColor];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.userInteractionEnabled = NO;
        [collectionView registerClass:[StoreGoodsCell class] forCellWithReuseIdentifier:kCellIdentifier_StoreGoodsCell];
        [self addSubview:collectionView];
        [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.top.equalTo(logoIv.mas_bottom).offset(5);
        }];

        toStoreBtn = [[ESButton alloc] initWithTitle:@"进店" color:[UIColor colorWithHexString:@"#f22e2f"] fontSize:12];
        [toStoreBtn borderWidth:1 color:[UIColor colorWithHexString:@"#f22e2f"] cornerRadius:4];
        [self addSubview:toStoreBtn];
        [toStoreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(20);
            make.right.equalTo(self).offset(-15);
            make.width.equalTo(@40);
            make.height.equalTo(@25);
        }];

        headerLine = [UIView new];
        headerLine.backgroundColor = [UIColor colorWithHexString:kBorderLineColor];
        [self addSubview:headerLine];
        [headerLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self);
            make.height.equalTo(@0.5f);
        }];

        footerLine = [UIView new];
        footerLine.backgroundColor = [UIColor colorWithHexString:kBorderLineColor];
        [self addSubview:footerLine];
        [footerLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.height.equalTo(headerLine);
        }];

    }
    return self;
}

#pragma mark collectionView代理方法

/**
 * section个数
 * @param collectionView
 * @return
 */
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

/**
 * 每个section的item个数
 * @param collectionView
 * @param section
 * @return
 */
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if(goodsArray.count > 3){
        return 3;
    }
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
    Goods *goods = [goodsArray objectAtIndex:indexPath.row];
    StoreGoodsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier_StoreGoodsCell forIndexPath:indexPath];
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
    int width = (kScreen_Width - 30) / 3;
    return CGSizeMake(width, width + 28);
}

/**
 * 设置每个item的UIEdgeInsets
 * @param collectionView
 * @param collectionViewLayout
 * @param section
 * @return
 */
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
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
    return 5;
}

- (void)configData:(Store *)store {
    nameLbl.text = store.name;
    if(store.store_logo != nil && [store.store_logo isKindOfClass:[NSString class]] && store.store_logo.length > 0){
        [logoIv sd_setImageWithURL:store.store_logo placeholderImage:[UIImage imageNamed:@"store_logo_placeholder.png"]];
    }
    creditLbl.text = [NSString stringWithFormat:@"%d分", store.store_credit];
    collectNumberLbl.text = [NSString stringWithFormat:@"%d人关注", store.store_collect];

    [goodsArray removeAllObjects];
    if(store.goodsList != nil && store.goodsList.count > 0){
        [goodsArray addObjectsFromArray:store.goodsList];
    }
    [collectionView reloadData];
}


@end