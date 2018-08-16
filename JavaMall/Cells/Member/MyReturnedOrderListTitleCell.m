//
// Created by Dawei on 6/29/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>
#import "MyReturnedOrderListTitleCell.h"
#import "Masonry.h"
#import "ESLabel.h"
#import "ESButton.h"
#import "UIView+Common.h"
#import "Order.h"
#import "OrderItem.h"
#import "ReturnedOrder.h"
#import "DateUtils.h"

@implementation MyReturnedOrderListTitleCell {
    UIView *headerLine;
    ESLabel *snLbl;
}

@synthesize detailBtn;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        headerLine = [UIView new];
        headerLine.backgroundColor = [UIColor colorWithHexString:@"#e4e5e7"];
        [self addSubview:headerLine];

        [headerLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self);
            make.height.equalTo(@0.5f);
        }];


        snLbl = [[ESLabel alloc] initWithText:@"订单编号:" textColor:[UIColor grayColor] fontSize:12];
        [self addSubview:snLbl];
        [snLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(10);
            make.centerY.equalTo(self);
        }];

        detailBtn = [[ESButton alloc] initWithTitle:@"进度查询" color:[UIColor redColor] fontSize:14];
        [detailBtn borderWidth:0.5f color:[UIColor redColor] cornerRadius:4];
        [self addSubview:detailBtn];
        [detailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.right.equalTo(self).offset(-10);
            make.width.equalTo(@70);
            make.height.equalTo(@28);
        }];

    }
    return self;
}

- (void)configData:(ReturnedOrder *)returnedOrder {
    snLbl.text = [NSString stringWithFormat:@"订单编号:%@", returnedOrder.sn];
}


@end