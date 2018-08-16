//
// Created by Dawei on 9/23/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <Masonry/View+MASAdditions.h>
#import "MyOrderDeliveryCell.h"
#import "Delivery.h"
#import "ESLabel.h"


@implementation MyOrderDeliveryCell {
    ESLabel *logicNumberTitleLbl;
    ESLabel *logicNumberLbl;

    ESLabel *logicNameTitleLbl;
    ESLabel *logicNameLbl;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        logicNumberTitleLbl = [[ESLabel alloc] initWithText:@"订单编号：" textColor:[UIColor darkGrayColor] fontSize:14];
        [self addSubview:logicNumberTitleLbl];
        [logicNumberTitleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(self).offset(10);
            make.width.equalTo(@80);
        }];

        logicNumberLbl = [[ESLabel alloc] initWithText:@"" textColor:[UIColor blackColor] fontSize:14];
        [self addSubview:logicNumberLbl];
        [logicNumberLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(logicNumberTitleLbl);
            make.left.equalTo(logicNumberTitleLbl.mas_right).offset(5);
            make.right.equalTo(self).offset(-10);
        }];

        logicNameTitleLbl = [[ESLabel alloc] initWithText:@"物流公司：" textColor:[UIColor darkGrayColor] fontSize:14];
        [self addSubview:logicNameTitleLbl];
        [logicNameTitleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(logicNumberTitleLbl.mas_bottom).offset(10);
            make.left.width.equalTo(logicNumberTitleLbl);
        }];

        logicNameLbl = [[ESLabel alloc] initWithText:@"" textColor:[UIColor blackColor] fontSize:14];
        [self addSubview:logicNameLbl];
        [logicNameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(logicNameTitleLbl);
            make.left.equalTo(logicNumberLbl);
            make.right.equalTo(logicNumberLbl);
        }];

    }
    return self;
}

+ (CGFloat)cellHeightWithObj:(Delivery *)delivery {
    return 60;
}

- (void)configData:(Delivery *)delivery {
    logicNumberLbl.text = delivery.logicNumber;
    logicNameLbl.text = delivery.logicName;
}

@end