//
// Created by Dawei on 5/26/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "CartMoreGoodsCell.h"
#import "ESLabel.h"
#import "Masonry.h"
#import "GoodsGridCell.h"
#import "Goods.h"
#import "UIView+Common.h"
#import "HotGoodsDelegate.h"


@implementation CartMoreGoodsCell {
    ESLabel *hotLbl;
    UIView *leftView;
    UIView *rightView;

    ESLabel *nodataLbl;

    UICollectionView *goodsView;
    UICollectionViewFlowLayout *gridLayout;

    NSMutableArray *goodsArray;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];

        //商品列表样式
        gridLayout = [[UICollectionViewFlowLayout alloc] init];
        gridLayout.minimumLineSpacing = 5;
        gridLayout.minimumInteritemSpacing = 5;
        gridLayout.itemSize = CGSizeMake((kScreen_Width - 15) / 2, (kScreen_Width - 30) / 2 + 58); //宽=(屏幕长度-间距)/2 高=宽+标题高度+价格高度
        gridLayout.sectionInset = (UIEdgeInsets) {0, 5, 0, 5};

        UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0,0, kScreen_Width, 10)];
        topView.backgroundColor = [UIColor colorWithHexString:@"#f1f2f7"];
        [topView bottomBorder:[UIColor colorWithHexString:@"#e0e0e2"]];
        [self addSubview:topView];

        hotLbl = [[ESLabel alloc] initWithText:@"看看热卖" textColor:[UIColor colorWithHexString:@"#878789"] fontSize:14];
        [self addSubview:hotLbl];

        leftView = [UIView new];
        leftView.backgroundColor = [UIColor colorWithHexString:@"#f0f0f0"];
        rightView = [UIView new];
        rightView.backgroundColor = [UIColor colorWithHexString:@"#f0f0f0"];
        [self addSubview:leftView];
        [self addSubview:rightView];

        [hotLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(topView.mas_bottom).offset(10);
            make.centerX.equalTo(self);
        }];
        [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(hotLbl.mas_left).offset(-10);
            make.left.equalTo(self).offset(10);
            make.height.equalTo(@1);
            make.centerY.equalTo(hotLbl);
        }];
        [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(hotLbl.mas_right).offset(10);
            make.right.equalTo(self).offset(-10);
            make.height.equalTo(@1);
            make.centerY.equalTo(leftView);
        }];

        //商品列表
        goodsView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:gridLayout];
        goodsView.backgroundColor = [UIColor whiteColor];
        goodsView.scrollEnabled = NO;
        goodsView.delegate = self;
        goodsView.dataSource = self;
        [goodsView registerClass:[GoodsGridCell class] forCellWithReuseIdentifier:@"Grid"];
        [self addSubview:goodsView];
        [goodsView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(hotLbl.mas_bottom).offset(10);
            make.left.and.right.and.bottom.equalTo(self);
        }];
    }
    return self;
}

- (void)configData:(NSMutableArray *)_goodsArray {
    goodsArray = _goodsArray;
    [goodsView reloadData];
}

+ (CGFloat)cellHeightWithObj:(NSMutableArray *)_goodsArray {
    if(_goodsArray == nil || _goodsArray.count == 0){
        return 50;
    }
    float height = 30;
    int index = _goodsArray.count / 2;
    if(_goodsArray.count % 2 != 0){
        index++;
    }
    //(图片高度+商品名称高度+间距) * 行数
    height += ((kScreen_Width - 30) / 2 + 58 + 10) * index;
    return height;
}

#pragma UICollectionView
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
    GoodsGridCell *cell = [goodsView dequeueReusableCellWithReuseIdentifier:@"Grid" forIndexPath:indexPath];
    [cell config:[goodsArray objectAtIndex:[indexPath row]]];
    return cell;
}

/**
 * 点击商品
 */
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    Goods *goods = [goodsArray objectAtIndex:[indexPath row]];
    if (self.delegate != nil) {
        [self.delegate selectHotGoods:goods];
    }
}

/**
 * 暂无数据
 */
- (void)showNoData {
    [goodsView setHidden:YES];
    if(nodataLbl == nil){
        nodataLbl = [[ESLabel alloc] initWithText:@"暂时没有热卖商品!" textColor:[UIColor darkGrayColor] fontSize:14];
        [self addSubview:nodataLbl];
        [nodataLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(hotLbl.mas_bottom).offset(10);
            make.bottom.equalTo(self).offset(-10);
        }];
    }
    [nodataLbl setHidden:NO];
}


@end