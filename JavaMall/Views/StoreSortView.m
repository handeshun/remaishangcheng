//
// Created by Dawei on 3/18/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#define kGoodsListSortView_Height 40.0

#import "StoreSortView.h"
#import "UIView+Common.h"
#import "NSString+Common.h"
#import "ESButton.h"
#import "UIButton+Common.h"
#import "Masonry.h"

@interface StoreSortView () {
}

@property(nonatomic, copy) SortViewBlock clickBlock;

@end


@implementation StoreSortView {
    ESButton *sortNew;
    ESButton *sortSales;
    UIButton *sortPrice;

    UIView *spaceComplex2Sales;
    UIView *spaceSales2Price;
    UIView *spacePrice2Filter;

    NSInteger clickIndex;
}

@synthesize gridList;

- (instancetype)initWithFrame:(CGRect)frame sortBlock:(SortViewBlock)sortHandle {
    self = [super initWithFrame:frame];
    if (self) {
        self.clickBlock = sortHandle;
        [self setFrame:CGRectMake(frame.origin.x, frame.origin.y, kScreen_Width, kGoodsListSortView_Height)];
        [self createUI];
    }
    return self;
}

/**
 * 创建排序视图
 */
- (void)createUI {
    self.backgroundColor = [UIColor colorWithHexString:kHeaderBackgroundColor];

    //新品
    sortNew = [[ESButton alloc] initWithTitle:@"新品" color:[UIColor redColor] fontSize:13];
    sortNew.titleLabel.font = [UIFont systemFontOfSize:13];
    [sortNew addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:sortNew];

    //销量
    sortSales = [[ESButton alloc] initWithTitle:@"销量" color:[UIColor darkGrayColor] fontSize:13];
    sortSales.titleLabel.font = [UIFont systemFontOfSize:13];
    [sortSales addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:sortSales];

    //价格
    sortPrice = [[UIButton alloc] initWithFrame:CGRectMake((kScreen_Width - 84) / 3 * 2 + 10, 0, 34, kGoodsListSortView_Height)];
    UIImage *sortPriceImage = [UIImage imageNamed:@"sort_price"];
    NSString *sortPriceTitle = @"价格";
    CGSize sortPriceTitleSize = [sortPriceTitle getSizeWithFont:[UIFont systemFontOfSize:13]];
    [sortPrice setTitle:sortPriceTitle forState:UIControlStateNormal];
    [sortPrice setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [sortPrice setImage:sortPriceImage forState:UIControlStateNormal];
    [sortPrice setTitleEdgeInsets:UIEdgeInsetsMake(0, -sortPriceImage.size.width - 3, 0, sortPriceImage.size.width + 3)];
    [sortPrice setImageEdgeInsets:UIEdgeInsetsMake(0, sortPriceTitleSize.width + 3, 0, -sortPriceTitleSize.width - 3)];
    sortPrice.titleLabel.font = [UIFont systemFontOfSize:13];
    [sortPrice addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:sortPrice];

    //切换
    gridList = [[UIButton alloc] initWithFrame:CGRectMake(kScreen_Width - 50, 0, 40, kGoodsListSortView_Height)];
    [gridList setImage:[UIImage imageNamed:@"goods_grid.png"] forState:UIControlStateNormal];
    [gridList setImage:[UIImage imageNamed:@"goods_list.png"] forState:UIControlStateSelected];
    [gridList addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:gridList];

    //间距视图
    spaceComplex2Sales = [UIView new];
    spaceSales2Price = [UIView new];
    spacePrice2Filter = [UIView new];
    [self addSubview:spaceComplex2Sales];
    [self addSubview:spaceSales2Price];
    [self addSubview:spacePrice2Filter];

    [sortNew mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.centerY.equalTo(self);
        make.right.equalTo(spaceComplex2Sales.mas_left);
    }];

    [sortSales mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sortNew);
        make.left.equalTo(spaceComplex2Sales.mas_right);
        make.right.equalTo(spaceSales2Price.mas_left);
    }];

    [sortPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@13);
        make.left.equalTo(spaceSales2Price.mas_right);
        make.right.equalTo(spacePrice2Filter.mas_left);
    }];

    [gridList mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-10);
        make.top.equalTo(sortPrice);
        make.left.equalTo(spacePrice2Filter.mas_right);
    }];

    //布局间距视图
    [spaceComplex2Sales mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(spacePrice2Filter.mas_width);
    }];
    [spaceSales2Price mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(spacePrice2Filter.mas_width);
    }];
    [spacePrice2Filter mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
    }];

    //添加下划线
    [self bottomBorder:[UIColor colorWithHexString:kBorderLineColor]];
}

- (void)click:(ESButton *)sender {
    if(sender != gridList) {
        [sortNew setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [sortSales setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [sortPrice setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [sortPrice setImage:[UIImage imageNamed:@"sort_price"] forState:UIControlStateNormal];
        [sender setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }

    if(sender == sortNew){
        clickIndex = 1;
    }else if(sender == sortSales){
        clickIndex = 2;
    }else if(sender == sortPrice){
        if(clickIndex == 3){
            clickIndex = 31;
            [sortPrice setImage:[UIImage imageNamed:@"sort_price_down"] forState:UIControlStateNormal];
        }else{
            clickIndex = 3;
            [sortPrice setImage:[UIImage imageNamed:@"sort_price_up"] forState:UIControlStateNormal];
        }
    }else if(sender == gridList){
        clickIndex = 4;
    }

    self.clickBlock(clickIndex);
}

@end