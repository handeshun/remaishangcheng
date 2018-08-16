//
// Created by Dawei on 7/3/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "ReturnedOrderShipCell.h"
#import "Masonry.h"
#import "ESLabel.h"
#import "ESButton.h"
#import "ESRadioButton.h"

@implementation ReturnedOrderShipCell {
    UIView *headerLine;
    UIView *footerLine;
    
    ESLabel *titleLbl;
    
    ESRadioButton *shipBtn0;
    ESRadioButton *shipBtn1;
}

@synthesize value;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    value = 1;
    
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
        
        titleLbl = [[ESLabel alloc] initWithText:@"是否已收到货" textColor:[UIColor darkGrayColor] fontSize:14];
        [self addSubview:titleLbl];
        [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(self).offset(10);
        }];
        
        shipBtn0 = [ESRadioButton new];
        [shipBtn0 setTitle:@"已收到货"];
        [shipBtn0 setSelected:YES];
        shipBtn0.tag = 0;
        [shipBtn0 addTarget:self action:@selector(selectType:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:shipBtn0];
        [shipBtn0 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(titleLbl);
            make.top.equalTo(titleLbl.mas_bottom).offset(10);
            make.width.equalTo(@100);
        }];
        
        shipBtn1 = [ESRadioButton new];
        [shipBtn1 setTitle:@"已收到货"];
        shipBtn1.tag = 1;
        [shipBtn1 addTarget:self action:@selector(selectType:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:shipBtn1];
        [shipBtn1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(shipBtn0.mas_right).offset(10);
            make.top.equalTo(shipBtn0);
            make.width.equalTo(@80);
        }];
        [shipBtn1 setHidden:YES];
    }
    return self;
}

- (IBAction)selectType:(ESRadioButton *)sender {
    [shipBtn0 setSelected:NO];
    [shipBtn1 setSelected:NO];
    [sender setSelected:YES];
    //value = sender.tag;
    value = 1;
}


@end