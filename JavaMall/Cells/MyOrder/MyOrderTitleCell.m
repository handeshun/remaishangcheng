//
// Created by Dawei on 7/3/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "MyOrderTitleCell.h"
#import "Masonry.h"
#import "ESLabel.h"
#import "Order.h"


@implementation MyOrderTitleCell {
    UIView *headerLine;
    UIView *footerLine;

    ESLabel *titleLbl;
    ESLabel *valueLbl;

    UIImageView *arrowIV;
}

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

        titleLbl = [[ESLabel alloc] initWithText:@"" textColor:[UIColor darkGrayColor] fontSize:14];
        [self addSubview:titleLbl];
        [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(10);
            make.centerY.equalTo(self);
            make.width.equalTo(@100);
        }];

        //箭头
        arrowIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"right_arrow.png"]];
        [arrowIV setHidden:YES];
        [self addSubview:arrowIV];
        [arrowIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.width.equalTo(@9);
            make.height.equalTo(@15);
            make.right.equalTo(self).offset(-10);
        }];

        valueLbl = [[ESLabel alloc] initWithText:@"" textColor:[UIColor darkGrayColor] fontSize:14];
        valueLbl.textAlignment = NSTextAlignmentRight;
        [self addSubview:valueLbl];
        [valueLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-10);
            make.top.equalTo(self).offset(10);
            make.left.equalTo(titleLbl.mas_right).offset(10);
        }];
    }
    return self;
}

-(void) configData:(NSString *)title value:(NSString *)value content:(NSString *)content duby:(NSString *)duby headerLine:(BOOL)showHeaderLine footerLine:(BOOL)showFooterLine{
    titleLbl.text = title;
    valueLbl.text = [NSString stringWithFormat:@"发票抬头：%@" ,value];
    ESLabel *valueLbl2 = [[ESLabel alloc] initWithText:@"" textColor:[UIColor darkGrayColor] fontSize:14];
    valueLbl2.textAlignment = NSTextAlignmentRight;
    [self addSubview:valueLbl2];
    [valueLbl2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-10);
        make.left.equalTo(titleLbl.mas_right).offset(10);
        make.top.equalTo(valueLbl.mas_bottom).offset(5);
    }];
    ESLabel *valueLbl3 = [[ESLabel alloc] initWithText:@"" textColor:[UIColor darkGrayColor] fontSize:14];
    valueLbl3.textAlignment = NSTextAlignmentRight;
    [self addSubview:valueLbl3];
    [valueLbl3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-10);
        make.top.equalTo(valueLbl2.mas_bottom).offset(5);
        make.left.equalTo(titleLbl.mas_right).offset(10);
    }];
    valueLbl2.text=[NSString stringWithFormat:@"发票税号：%@" ,duby];;
    valueLbl3.text=[NSString stringWithFormat:@"发票内容：%@" ,content];

    [footerLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self);
        make.height.equalTo(headerLine);
    }];
    [headerLine setHidden:!showHeaderLine];
    [footerLine setHidden:!showFooterLine];
}

-(void) configData:(NSString *)title value:(NSString *)value content:(NSString *)content headerLine:(BOOL)showHeaderLine footerLine:(BOOL)showFooterLine{
    titleLbl.text = title;
    valueLbl.text = [NSString stringWithFormat:@"发票抬头：%@" ,value];
    ESLabel *valueLbl3 = [[ESLabel alloc] initWithText:@"" textColor:[UIColor darkGrayColor] fontSize:14];
    valueLbl3.textAlignment = NSTextAlignmentRight;
    [self addSubview:valueLbl3];
    [valueLbl3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-10);
        make.top.equalTo(valueLbl.mas_bottom).offset(5);
        make.left.equalTo(titleLbl.mas_right).offset(10);
    }];
    valueLbl3.text=[NSString stringWithFormat:@"发票内容：%@" ,content];
    [footerLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self).offset(10);
        make.height.equalTo(headerLine);
    }];
    [headerLine setHidden:!showHeaderLine];
    [footerLine setHidden:!showFooterLine];
}

- (void)configData:(NSString *)title value:(NSString *)value headerLine:(BOOL)showHeaderLine footerLine:(BOOL)showFooterLine {
    titleLbl.text = title;
    valueLbl.text = value;
    [headerLine setHidden:!showHeaderLine];
    [footerLine setHidden:!showFooterLine];
}

- (void)showArrow {
    [arrowIV setHidden:NO];
    [valueLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(arrowIV.mas_left).offset(-5);
        make.centerY.equalTo(self);
        make.left.equalTo(titleLbl.mas_right).offset(10);
    }];
}


@end