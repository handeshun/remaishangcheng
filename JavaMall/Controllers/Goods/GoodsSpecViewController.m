//
// Created by Dawei on 3/24/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>
#import "GoodsSpecViewController.h"
#import "GoodsSpec.h"
#import "GoodsSpecValue.h"
#import "Goods.h"
#import "Masonry.h"
#import "UIColor+HexString.h"
#import "UIView+Common.h"
#import "NSString+Common.h"
#import "SpecButton.h"
#import "ESNumberView.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "GoodsApi.h"
#import "ToastUtils.h"

#define LEFT_SPLIT_WIDTH 50

@implementation GoodsSpecViewController {
    GoodsApi *goodsApi;

    NSMutableArray *specs;
    NSMutableDictionary *productDic;
    NSSortDescriptor *sortDescriptor;

    UIImageView *image;
    UILabel *price;
    UILabel *sn;
    UIView *line;

    TPKeyboardAvoidingScrollView *contentView;
    ESNumberView *numberView;

    NSMutableDictionary *currentSpecDic;

    UIButton *addCart;

    Goods *goods;
}

@synthesize delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    currentSpecDic = [NSMutableDictionary dictionaryWithCapacity:0];
    goodsApi = [GoodsApi new];
    sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:YES];
    [self createHeader];
    [self loadData];
    [self createOperation];

}

- (void)createHeader {
    image = [UIImageView new];
    [image borderWidth:0.5f color:[UIColor colorWithHexString:kBorderLineColor] cornerRadius:5.0f];

    price = [UILabel new];
    price.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
    price.textColor = [UIColor redColor];

    sn = [UILabel new];
    sn.font = [UIFont systemFontOfSize:14];
    sn.textColor = [UIColor darkGrayColor];

    line = [UIView new];
    line.backgroundColor = [UIColor colorWithHexString:kBorderLineColor];

    [self.view addSubview:image];
    [self.view addSubview:price];
    [self.view addSubview:sn];
    [self.view addSubview:line];

    [image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@80);
        make.height.equalTo(@80);
        make.top.equalTo(self.view).offset(30);
        make.left.equalTo(self.view).offset(10);
    }];
    [price mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(image).offset(10);
        make.left.equalTo(image.mas_right).offset(10);
    }];
    [sn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(price);
        make.top.equalTo(price.mas_bottom).offset(15);
    }];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@0.5f);
        make.left.right.equalTo(self.view);
        make.top.equalTo(image.mas_bottom).offset(10);
    }];

}

- (void)createContent {
    contentView = [TPKeyboardAvoidingScrollView new];
    [self.view addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-45);
    }];

    int topOffset = 20;
    int maxLength = (kScreen_Width - LEFT_SPLIT_WIDTH - 80) / 2 - 20;
    for (GoodsSpec *spec in specs) {
        //规格名称
        UILabel *specLabel = [UILabel new];
        specLabel.text = spec.name;
        specLabel.font = [UIFont systemFontOfSize:14];
        specLabel.textColor = [UIColor darkGrayColor];
        [contentView addSubview:specLabel];
        [specLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(contentView).offset(15);
            make.top.equalTo(contentView).offset(topOffset);
        }];

        //判断是一行显示几个
        int mod = 2;
        for (GoodsSpecValue *value in spec.specValues) {
            if ([value.name getSizeWithFont:[UIFont systemFontOfSize:13]].width > maxLength) {
                mod = 1;
                break;
            }
        }

        int specValueId = 0;
        NSNumber *key = [NSNumber numberWithInt:spec.id];
        if (goods.specDic != nil && [goods.specDic objectForKey:key]) {
            specValueId = [[goods.specDic objectForKey:key] intValue];
        }

        //规格值
        for (int i = 0; i < spec.specValues.count; i++) {
            GoodsSpecValue *value = (GoodsSpecValue *) [spec.specValues objectAtIndex:i];

            SpecButton *button = [SpecButton new];
            [button setTitle:value.name forState:UIControlStateNormal];
            button.specId = spec.id;
            button.specValueId = value.valueId;
            [button addTarget:self action:@selector(selectSpec:) forControlEvents:UIControlEventTouchUpInside];
            [contentView addSubview:button];

            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@25);
                make.width.equalTo(@([value.name getSizeWithFont:[UIFont systemFontOfSize:13]].width + 20));
                if (mod > 1 && (i + 1) % mod == 0) {
                    make.left.equalTo(@180);
                } else {
                    make.left.equalTo(@80);
                }
                make.top.equalTo(contentView).offset(topOffset);

            }];
            if ((i + 1) % mod == 0 || (i + 1) == spec.specValues.count) {
                topOffset += 30;
            }
            if (value.valueId == specValueId) {
                [currentSpecDic setObject:button forKey:[NSString stringWithFormat:@"%d", spec.id]];
                [button setSelected:YES];
            }
        }

        topOffset += 10;
    }

    //数量
    UILabel *numberLabel = [UILabel new];
    numberLabel.text = @"数量";
    numberLabel.font = [UIFont systemFontOfSize:14];
    numberLabel.textColor = [UIColor darkGrayColor];
    [contentView addSubview:numberLabel];
    [numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView).offset(15);
        make.top.equalTo(contentView).offset(topOffset);
    }];

    numberView = [[ESNumberView alloc] initWithMin:1 max:999 value:1];
    [contentView addSubview:numberView];
    numberView.numberChanged = ^(NSInteger number){
        goods.buyCount = number;
        [delegate selectSpec:goods];
    };
    [numberView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView).offset(80);
        make.height.equalTo(@25);
        make.width.equalTo(@90);
        make.top.equalTo(numberLabel);
    }];

    contentView.contentSize = CGSizeMake(kScreen_Width - LEFT_SPLIT_WIDTH, topOffset + 30);
}

- (void)createOperation {
    addCart = [UIButton new];
    addCart.backgroundColor = [[UIColor colorWithHexString:@"#f15352"] colorWithAlphaComponent:1.0];
    addCart.titleLabel.font = [UIFont systemFontOfSize:16];;
    [addCart setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addCart setTitle:@"加入购物车" forState:UIControlStateNormal];
    [addCart addTarget:self action:@selector(addToCart) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addCart];
    [addCart mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.equalTo(@45);
    }];
}

/**
 * 载入规格数据
 */
- (void)loadData {
    goods = [delegate getGoods];
    [image sd_setImageWithURL:[NSURL URLWithString:goods.thumbnail]
             placeholderImage:[UIImage imageNamed:@"image_empty.png"]];
    price.text = [NSString stringWithFormat:@"￥%.2f", goods.price];
    sn.text = [NSString stringWithFormat:@"商品编号: %@", goods.sn];

    [goodsApi spec:goods.id success:^(NSMutableArray *_specs, NSMutableDictionary *_productDic) {
        specs = _specs;
        productDic = _productDic;
        [self createContent];
    }      failure:^(NSError *error) {
        [ToastUtils show:@"载入规格失败!"];
    }];
}

/**
 * 选择规格
 */
- (void)selectSpec:(SpecButton *)sender {
    if (sender == nil)
        return;
    NSString *key = [NSString stringWithFormat:@"%d", sender.specId];
    if ([currentSpecDic objectForKey:key] != nil) {
        SpecButton *currentSpecButton = (SpecButton *) [currentSpecDic objectForKey:key];
        [currentSpecButton setSelected:NO];
    }
    [sender setSelected:YES];
    [currentSpecDic setObject:sender forKey:key];

    NSMutableArray *keyArray = [NSMutableArray arrayWithCapacity:[currentSpecDic count]];
    for (SpecButton *specButton in currentSpecDic.allValues) {
        int specValue = specButton.specValueId;
        [keyArray addObject:[NSNumber numberWithInt:specValue]];
    }
    [keyArray sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    NSString *productKey = [keyArray componentsJoinedByString:@"-"];

    Goods *selectGoods = [productDic objectForKey:productKey];
    if (selectGoods != nil) {
        selectGoods.buyCount = numberView.value;
        [delegate selectSpec:selectGoods];
    }
}

/**
 * 添加到购物车
 */
-(IBAction)addToCart{
    [delegate addToCart];
}

@end