//
// Created by Dawei on 7/3/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>
#import "ReturnedOrderGoodsCell.h"
#import "Masonry.h"
#import "Goods.h"
#import "ESLabel.h"
#import "OrderItem.h"
#import "UIView+Common.h"
#import "ESRadioButton.h"
#import "NSString+Common.h"
#import "NumberChangedDelegate.h"

@implementation ReturnedOrderGoodsCell {
    UIView *headerLine;
    UIView *footerLine;

    UIImageView *thumbnailIV;
    ESLabel *nameLbl;
    ESLabel *priceLbl;

    ESButton *less;
    ESButton *more;
    UITextField *valueText;
    NSInteger max;
}

@synthesize value, selectBtn;
@synthesize delegate;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        headerLine = [UIView new];
        headerLine.backgroundColor = [UIColor colorWithHexString:@"#e4e5e7"];
        [self addSubview:headerLine];

        footerLine = [UIView new];
        footerLine.backgroundColor = [UIColor colorWithHexString:@"#e4e5e7"];
        [self addSubview:footerLine];

        [headerLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self);
            make.height.equalTo(@0.5f);
        }];

        [footerLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(self);
            make.height.equalTo(headerLine);
        }];

        selectBtn = [ESRadioButton new];
        [selectBtn setSelected:NO];
        [self addSubview:selectBtn];
        [selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(10);
            make.centerY.equalTo(self);
            make.width.height.equalTo(@18);
        }];

        thumbnailIV = [UIImageView new];
        [thumbnailIV borderWidth:0.5f color:[UIColor grayColor] cornerRadius:4];
        [self addSubview:thumbnailIV];
        [thumbnailIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(10);
            make.left.equalTo(selectBtn.mas_right).offset(10);
            make.width.height.equalTo(@80);
        }];

        nameLbl = [[ESLabel alloc] initWithText:@"" textColor:[UIColor darkGrayColor] fontSize:14];
        nameLbl.numberOfLines = 2;
        [self addSubview:nameLbl];
        [nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(thumbnailIV);
            make.left.equalTo(thumbnailIV.mas_right).offset(5);
            make.right.equalTo(self).offset(-10);
        }];

        priceLbl = [[ESLabel alloc] initWithText:@"" textColor:[UIColor grayColor] fontSize:12];
        [self addSubview:priceLbl];
        [priceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(nameLbl.mas_bottom).offset(5);
            make.left.equalTo(nameLbl);
            make.right.equalTo(self).offset(-10);
        }];

        less = [ESButton new];
        [less setImage:[UIImage imageNamed:@"number_less_disable"] forState:UIControlStateDisabled];
        [less setImage:[UIImage imageNamed:@"number_less_enable"] forState:UIControlStateNormal];
        [less setImage:[UIImage imageNamed:@"number_less_highLight"] forState:UIControlStateHighlighted];
        [less addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
        less.enabled = (value > 1);
        [self addSubview:less];
        [less mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(nameLbl);
            make.top.equalTo(priceLbl.mas_bottom).offset(5);
            make.width.height.equalTo(@25);
        }];

        valueText = [UITextField new];
        valueText.background = [UIImage imageNamed:@"number_middle_enable"];
        valueText.font = [UIFont systemFontOfSize:13];
        valueText.textAlignment = NSTextAlignmentCenter;
        valueText.secureTextEntry = NO;
        valueText.userInteractionEnabled = YES;
        valueText.keyboardType = UIKeyboardTypeNumberPad;
        valueText.returnKeyType = UIReturnKeyDone;
        valueText.delegate = self;
        self.value = value;
        [self addSubview:valueText];
        [valueText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(less.mas_right);
            make.top.equalTo(less);
            make.width.equalTo(@40);
            make.height.equalTo(@25);
        }];

        more = [[ESButton alloc] initWithFrame:CGRectMake(65,0,25,25)];
        [more setImage:[UIImage imageNamed:@"number_more_disable"] forState:UIControlStateDisabled];
        [more setImage:[UIImage imageNamed:@"number_more_enable"] forState:UIControlStateNormal];
        [more setImage:[UIImage imageNamed:@"number_more_highLight"] forState:UIControlStateHighlighted];
        [more addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
        more.enabled = (value < max);
        [self addSubview:more];
        [more mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(valueText.mas_right);
            make.top.equalTo(less);
            make.width.height.equalTo(@25);
        }];

    }
    return self;
}

- (void) action:(id) sender{
    NSInteger valueInText = [valueText.text intValue];
    if(sender == less) {
        if (valueInText > 0) {
            valueText.text = [NSString stringWithFormat:@"%d", (--valueInText)];
        }
    }else{
        if(valueInText < max){
            valueText.text = [NSString stringWithFormat:@"%d", (++valueInText)];
        }
    }
    [self updateButtonState];
}

/**
 * 更新按钮状态
 */
- (void) updateButtonState{
    less.enabled = [valueText.text intValue] > 1;
    more.enabled = [valueText.text intValue] < more;
    if(delegate != nil){
        [delegate numberChanged:[valueText.text intValue] tag:valueText.tag];
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    BOOL canEnd = [textField.text isInt] && ![textField.text hasPrefix:@"0"];
    if(canEnd){
        [self updateButtonState];
    }
    return canEnd;
}

- (NSInteger)value {
    return [valueText.text intValue];
}

- (void)setValue:(NSInteger)value1 {
    value = value1;
    valueText.text = [NSString stringWithFormat:@"%d", value];
    [self updateButtonState];
}

- (void)configData:(OrderItem *)orderItem index:(NSInteger)index{
    [thumbnailIV sd_setImageWithURL:[NSURL URLWithString:orderItem.thumbnail] placeholderImage:[UIImage imageNamed:@"image_empty.png"]];
    nameLbl.text = orderItem.name;
    priceLbl.text = [NSString stringWithFormat:@"价格：￥%.2f", orderItem.price];

    max = orderItem.number;
    self.value = 1;
    valueText.tag = index;

    selectBtn.tag = index;
    [selectBtn setSelected:orderItem.selected];
}

@end