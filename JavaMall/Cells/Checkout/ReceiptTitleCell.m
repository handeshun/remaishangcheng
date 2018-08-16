//
// Created by Dawei on 6/22/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "ReceiptTitleCell.h"
#import "ESLabel.h"
#import "Masonry.h"
#import "ESRadioButton.h"
#import "NSString+Common.h"
#import "UIView+Common.h"
#import "Receipt.h"

@implementation ReceiptTitleCell {
    ESLabel *titleLbl;

    ESRadioButton *noReceiptBtn;
    ESRadioButton *personBtn;
    ESRadioButton *companyBtn;

    UIView *headerView;
    UIView *footerView;
}

@synthesize companyNameTf,numberTf, buttons;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        headerView = [UIView new];
        headerView.backgroundColor = [UIColor colorWithHexString:@"#e2e2e2"];
        [self addSubview:headerView];
        [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self);
            make.height.equalTo(@0.5f);
        }];

        titleLbl = [[ESLabel alloc] initWithText:@"" textColor:[UIColor darkGrayColor] fontSize:14];
        titleLbl.text = @"发票抬头";
        [self addSubview:titleLbl];
        [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(10);
            make.top.equalTo(self).offset(10);
        }];

        noReceiptBtn = [ESRadioButton new];
        [noReceiptBtn setTitle:@"不开发票"];
        noReceiptBtn.tag = 0;
        [self addSubview:noReceiptBtn];
        [noReceiptBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleLbl.mas_bottom).offset(10);
            make.left.equalTo(self).offset(20);
            make.width.equalTo(@([@"不开发票" getSizeWithFont:[UIFont systemFontOfSize:13]].width + 30));
        }];

        float buttonWidth = [@"个人" getSizeWithFont:[UIFont systemFontOfSize:13]].width + 30;
        personBtn = [ESRadioButton new];
        [personBtn setTitle:@"个人"];
        personBtn.tag = 1;
        [self addSubview:personBtn];
        [personBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(noReceiptBtn.mas_bottom).offset(10);
            make.left.equalTo(self).offset(20);
            make.width.equalTo(@(buttonWidth));
        }];

        companyBtn = [ESRadioButton new];
        [companyBtn setTitle:@"公司"];
        companyBtn.tag = 2;
        [self addSubview:companyBtn];
        [companyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(personBtn.mas_bottom).offset(10);
            make.left.width.equalTo(personBtn);
        }];

        companyNameTf = [UITextField new];
        [companyNameTf borderWidth:0.5f color:[UIColor colorWithHexString:kBorderLineColor] cornerRadius:4];
        companyNameTf.font = [UIFont systemFontOfSize:13];
        companyNameTf.clearButtonMode = UITextFieldViewModeUnlessEditing;
        companyNameTf.attributedPlaceholder =
                [[NSAttributedString alloc] initWithString:@"请输入您的公司名称"
                                                attributes:@{
                                                        NSForegroundColorAttributeName : [UIColor grayColor],
                                                        NSFontAttributeName : [UIFont systemFontOfSize:13]
                                                }
                ];
        companyNameTf.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
        [companyNameTf setHidden:YES];
        [self addSubview:companyNameTf];
        [companyNameTf mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(companyBtn.mas_right).offset(10);
            make.top.equalTo(companyBtn).offset(-5);
            make.right.equalTo(self).offset(-10);
            make.height.equalTo(@25);
        }];

        
        numberTf = [UITextField new];
        [numberTf borderWidth:0.5f color:[UIColor colorWithHexString:kBorderLineColor] cornerRadius:4];
        numberTf.font = [UIFont systemFontOfSize:13];
        numberTf.clearButtonMode = UITextFieldViewModeUnlessEditing;
        numberTf.attributedPlaceholder =
        [[NSAttributedString alloc] initWithString:@"请输入纳税人识别号"
                                        attributes:@{
                                                     NSForegroundColorAttributeName : [UIColor grayColor],
                                                     NSFontAttributeName : [UIFont systemFontOfSize:13]
                                                     }
         ];
        numberTf.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
        [numberTf setHidden:YES];
        [self addSubview:numberTf];
        [numberTf mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(companyBtn.mas_right).offset(10);
            make.top.equalTo(companyNameTf.mas_bottom).offset(10);
            make.right.equalTo(self).offset(-10);
            make.height.equalTo(@25);
        }];

        
        
        footerView = [UIView new];
        footerView.backgroundColor = [UIColor colorWithHexString:@"#e2e2e2"];
        [self addSubview:footerView];
        [footerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.bottom.equalTo(self);
            make.height.equalTo(@0.5f);
        }];

        buttons = [NSMutableArray arrayWithObjects:noReceiptBtn, personBtn, companyBtn, nil];
    }
    return self;
}

- (void)configData:(Receipt *)receipt :(NSInteger)selectType {
    switch (selectType){
        case 0:
            [noReceiptBtn setSelected:YES];
            [companyNameTf setHidden:YES];
            [numberTf setHidden:YES];
            break;
        case 1:
            [personBtn setSelected:YES];
            [companyNameTf setHidden:YES];
            [numberTf setHidden:YES];
            break;
        case 2:
            [companyBtn setSelected:YES];
            [companyNameTf setHidden:NO];
            [numberTf setHidden:NO];
            companyNameTf.text = receipt.title;
            numberTf.text = receipt.duby;
            break;
    }
}

@end