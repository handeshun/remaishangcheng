//
// Created by Dawei on 7/3/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "RefundOrderBackWayCell.h"
#import "Masonry.h"
#import "ESLabel.h"
#import "ESRadioButton.h"
#import "ESTextField.h"
#import "UIView+Common.h"

@implementation RefundOrderBackWayCell {
    UIView *headerLine;
    UIView *footerLine;
    
    //退款方式
    ESLabel *typeTitleLbl;
    ESLabel *typeLbl;
    
    //退款金额
    ESLabel *moneyTitleLbl;
}

@synthesize moneyTf;

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
        
        typeTitleLbl = [[ESLabel alloc] initWithText:@"退款方式" textColor:[UIColor darkGrayColor] fontSize:14];
        [self addSubview:typeTitleLbl];
        [typeTitleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(self).offset(10);
        }];
        
        typeLbl = [[ESLabel alloc] initWithText:@"货到付款" textColor:[UIColor lightGrayColor] fontSize:12];
        [self addSubview:typeLbl];
        [typeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(typeTitleLbl);
            make.top.equalTo(typeTitleLbl.mas_bottom).offset(10);
            make.right.equalTo(self).offset(-10);
        }];
        
        moneyTitleLbl = [[ESLabel alloc] initWithText:@"退款金额" textColor:[UIColor darkGrayColor] fontSize:14];
        [self addSubview:moneyTitleLbl];
        [moneyTitleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(10);
            make.top.equalTo(typeLbl.mas_bottom).offset(10);
        }];
        
        moneyTf = [ESTextField new];
        moneyTf.font = [UIFont systemFontOfSize:14];
        moneyTf.clearButtonMode = UITextFieldViewModeUnlessEditing;
        moneyTf.attributedPlaceholder =
        [[NSAttributedString alloc] initWithString:@""
                                        attributes:@{
                                                     NSForegroundColorAttributeName : [UIColor grayColor],
                                                     NSFontAttributeName : [UIFont systemFontOfSize:12]
                                                     }
         ];
        [moneyTf borderWidth:0.5f color:[UIColor grayColor] cornerRadius:4];
        moneyTf.keyboardType = UIKeyboardTypeNumberPad;
        [self addSubview:moneyTf];
        [moneyTf mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(moneyTitleLbl.mas_bottom).offset(10);
            make.left.equalTo(moneyTitleLbl);
            make.right.equalTo(self).offset(-10);
            make.height.equalTo(@30);
        }];
        
    }
    return self;
}

- (void)setType:(NSString *)type :(NSString *)money {
    typeLbl.text = type;
    moneyTf.text = money;
}


@end