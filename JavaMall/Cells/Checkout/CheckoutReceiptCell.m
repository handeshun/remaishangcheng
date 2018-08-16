//
// Created by Dawei on 5/31/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "CheckoutReceiptCell.h"
#import "Masonry.h"
#import "ESLabel.h"
#import "Receipt.h"

@implementation CheckoutReceiptCell {
    UIView *headerView;
    UIView *footerView;

    UIImageView *arrowIV;

    ESLabel *titleLbl;
    ESLabel *receiptTitleLbl;
    ESLabel *receiptTypeLbl;
    ESLabel *receiptContentLbl;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];

        headerView = [UIView new];
        headerView.backgroundColor = [UIColor colorWithHexString:@"#e4e5e7"];
        [self addSubview:headerView];

        footerView = [UIView new];
        footerView.backgroundColor = [UIColor colorWithHexString:@"#e4e5e7"];
        [self addSubview:footerView];

        [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self);
            make.height.equalTo(@0.5f);
        }];

        [footerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(self);
            make.height.equalTo(headerView);
        }];

        arrowIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"right_arrow.png"]];
        [self addSubview:arrowIV];
        [arrowIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.width.equalTo(@9);
            make.height.equalTo(@15);
            make.right.equalTo(self).offset(-10);
        }];

        titleLbl = [[ESLabel alloc] initWithText:@"发票信息" textColor:[UIColor darkGrayColor] fontSize:14];
        [self addSubview:titleLbl];
        [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self).offset(10);
        }];

        receiptTitleLbl = [[ESLabel alloc] initWithText:@"" textColor:[UIColor darkGrayColor] fontSize:12];
        receiptTitleLbl.textAlignment = NSTextAlignmentRight;
        [self addSubview:receiptTitleLbl];
        [receiptTitleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(10);
            make.right.equalTo(arrowIV.mas_left).offset(-10);
            make.left.equalTo(titleLbl.mas_right).offset(10);
        }];

        receiptTypeLbl = [[ESLabel alloc] initWithText:@"" textColor:[UIColor darkGrayColor] fontSize:12];
        receiptTypeLbl.textAlignment = NSTextAlignmentRight;
        [self addSubview:receiptTypeLbl];
        [receiptTypeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.left.equalTo(receiptTitleLbl);
            make.top.equalTo(receiptTitleLbl.mas_bottom).offset(5);
        }];

        receiptContentLbl = [[ESLabel alloc] initWithText:@"" textColor:[UIColor darkGrayColor] fontSize:12];
        receiptContentLbl.textAlignment = NSTextAlignmentRight;
        [self addSubview:receiptContentLbl];
        [receiptContentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.left.equalTo(receiptTitleLbl);
            make.top.equalTo(receiptTypeLbl.mas_bottom).offset(5);
        }];

    }
    return self;
}

- (void)configData:(Receipt *)receipt {
    if(receipt == nil || receipt.type == 0){
        receiptTitleLbl.text = @"";
        receiptTypeLbl.text = @"不开发票";
        receiptContentLbl.text = @"";
        [receiptTypeLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.right.left.equalTo(receiptTitleLbl);
        }];
    }else{
        receiptTitleLbl.text = receipt.title;
        receiptTypeLbl.text = receipt.type == 1 ? @"个人" : @"公司";
        receiptContentLbl.text = receipt.content;
        [receiptTypeLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.left.equalTo(receiptTitleLbl);
            make.top.equalTo(receiptTitleLbl.mas_bottom).offset(5);
        }];
    }
}

@end