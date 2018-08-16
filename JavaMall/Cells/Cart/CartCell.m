//
// Created by Dawei on 5/25/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "CartCell.h"
#import "Goods.h"
#import "ESButton.h"
#import "ESNumberView.h"
#import "ESLabel.h"
#import "UIView+Common.h"
#import "UIImageView+WebCache.h"
#import "CartGoods.h"
#import "View+MASAdditions.h"
#import "CartGoods.h"
#import "ESTextField.h"


@implementation CartCell {
    UIView *headerView;
    UIView *footerView;

    UIImageView *thumbnailImageView;
    ESLabel *nameLbl;
    ESLabel *priceLbl;
    ESLabel *specLbl;
    ESLabel *totalLbl;
    ESLabel *discountLbl;
}

@synthesize isEditing;
@synthesize selectBtn;
@synthesize numberLessBtn, numberTf, numberAddBtn;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        headerView = [UIView new];
        headerView.backgroundColor = [UIColor colorWithHexString:@"#dedede"];
        [self addSubview:headerView];

        selectBtn = [ESButton new];
        [selectBtn setBackgroundImage:[UIImage imageNamed:@"cart_round_check1.png"] forState:UIControlStateNormal];
        [selectBtn setBackgroundImage:[UIImage imageNamed:@"cart_round_check2.png"] forState:UIControlStateSelected];
        [self addSubview:selectBtn];

        thumbnailImageView = [UIImageView new];
        [thumbnailImageView borderWidth:1.0 color:[UIColor colorWithHexString:@"#d7d7d7"] cornerRadius:8];
        [self addSubview:thumbnailImageView];

        //调整数量
        numberLessBtn = [ESButton new];
        [numberLessBtn setImage:[UIImage imageNamed:@"number_less_enable"] forState:UIControlStateNormal];
        [numberLessBtn setImage:[UIImage imageNamed:@"number_less_highLight"] forState:UIControlStateHighlighted];
        [self addSubview:numberLessBtn];

        numberTf = [ESTextField new];
        numberTf.background = [UIImage imageNamed:@"number_middle_enable"];
        numberTf.font = [UIFont systemFontOfSize:13];
        numberTf.textAlignment = NSTextAlignmentCenter;
        numberTf.secureTextEntry = NO;
        numberTf.userInteractionEnabled = YES;
        numberTf.keyboardType = UIKeyboardTypeNumberPad;
        numberTf.returnKeyType = UIReturnKeyDone;
        [self addSubview:numberTf];

        numberAddBtn = [ESButton new];
        [numberAddBtn setImage:[UIImage imageNamed:@"number_more_disable"] forState:UIControlStateDisabled];
        [numberAddBtn setImage:[UIImage imageNamed:@"number_more_enable"] forState:UIControlStateNormal];
        [numberAddBtn setImage:[UIImage imageNamed:@"number_more_highLight"] forState:UIControlStateHighlighted];
        [self addSubview:numberAddBtn];

        nameLbl = [[ESLabel alloc] initWithText:@"" textColor:[UIColor darkGrayColor] fontSize:14];
        nameLbl.numberOfLines = 2;
        [self addSubview:nameLbl];

        priceLbl = [[ESLabel alloc] initWithText:@"" textColor:[UIColor redColor] fontSize:14];
        [self addSubview:priceLbl];

        specLbl = [[ESLabel alloc] initWithText:@"" textColor:[UIColor grayColor] fontSize:12];
        [self addSubview:specLbl];

        totalLbl = [[ESLabel alloc] initWithText:@"" textColor:[UIColor redColor] fontSize:14];
        [self addSubview:totalLbl];

        discountLbl = [[ESLabel alloc] initWithText:@"" textColor:[UIColor grayColor] fontSize:12];
        [self addSubview:discountLbl];

        footerView = [UIView new];
        footerView.backgroundColor = [UIColor colorWithHexString:@"#dedede"];
        [self addSubview:footerView];

        //开始布局

        [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self);
            make.height.equalTo(@0.5f);
        }];

        [thumbnailImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(15);
            make.left.equalTo(selectBtn.mas_right).offset(10);
            make.width.height.equalTo(@90);
        }];

        [selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(thumbnailImageView);
            make.left.equalTo(self).offset(10);
            make.width.height.equalTo(@18);
        }];

        [numberLessBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(thumbnailImageView.mas_bottom).offset(10);
            make.left.equalTo(thumbnailImageView);
            make.width.height.equalTo(@25);
        }];
        [numberTf mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(numberLessBtn);
            make.left.equalTo(numberLessBtn.mas_right);
            make.height.equalTo(numberLessBtn);
            make.width.equalTo(@40);
        }];
        [numberAddBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(numberLessBtn);
            make.left.equalTo(numberTf.mas_right);
            make.width.height.equalTo(numberLessBtn);
        }];

        [nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(thumbnailImageView.mas_right).offset(10);
            make.right.equalTo(self).offset(-10);
            make.top.equalTo(thumbnailImageView).offset(5);
        }];

        [specLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(nameLbl);
            make.top.equalTo(nameLbl.mas_bottom).offset(10);
        }];

        [priceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(nameLbl);
            make.bottom.equalTo(thumbnailImageView).offset(-5);
        }];

        [totalLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(priceLbl);
            make.centerY.equalTo(numberLessBtn);
        }];

        [discountLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(totalLbl.mas_right).offset(30);
            make.top.equalTo(totalLbl);
        }];

        [footerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self).offset(0.5f);
            make.height.equalTo(@0.5f);
            make.left.right.equalTo(self);
        }];
    }
    return self;
}

- (void)configData:(CartGoods *)goods {
    numberTf.text = [NSString stringWithFormat:@"%d", goods.buyCount];
    nameLbl.text = goods.name;
    totalLbl.text = [NSString stringWithFormat:@"小计:￥%.2f", goods.subTotal];
//    discountLbl.text = [NSString stringWithFormat:@"立减:￥%.2f", (goods.marketPrice * goods.buyCount) - goods.subTotal];
    priceLbl.text = [NSString stringWithFormat:@"￥%.2f", goods.price];
    [thumbnailImageView sd_setImageWithURL:[NSURL URLWithString:goods.thumbnail]
                          placeholderImage:[UIImage imageNamed:@"image_empty"]];
    if(goods.specs.length > 0){
        [specLbl setHidden:NO];
        specLbl.text = goods.specs;
    }else{
        [specLbl setHidden:YES];
    }

    numberAddBtn.tag = goods.productId;
    numberTf.tag = goods.productId;
    numberLessBtn.tag = goods.productId;

    if(isEditing) {
        [selectBtn setSelected:goods.selected];
    }else{
        [selectBtn setSelected:goods.checked];
    }
    NSLog(@"%zd",goods.is_seckill);
    if (goods.is_seckill == 0) {
        numberTf.hidden = NO;
        numberLessBtn.hidden = NO;
        numberAddBtn.hidden = NO;
    }else {
        numberTf.hidden = YES;
        numberLessBtn.hidden = YES;
        numberAddBtn.hidden = YES;
    }
}

+ (CGFloat)cellHeightWithObj:(id)obj {
    return 155;
}

- (void)setIsEditing:(BOOL)isEditing1 {
    isEditing = isEditing1;
    if(isEditing){
        return;
    }
}


@end
