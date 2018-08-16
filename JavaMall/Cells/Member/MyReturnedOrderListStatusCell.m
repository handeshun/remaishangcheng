//
// Created by Dawei on 6/29/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>
#import "MyReturnedOrderListStatusCell.h"
#import "Masonry.h"
#import "ESLabel.h"
#import "ESButton.h"
#import "UIView+Common.h"
#import "Order.h"
#import "OrderItem.h"
#import "ReturnedOrder.h"
#import "DateUtils.h"

@implementation MyReturnedOrderListStatusCell {
    UIView *headerLine;
    UIView *footerLine;

    ESLabel *timeLbl;
    ESLabel *statusLbl;
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


        timeLbl = [[ESLabel alloc] initWithText:@"申请时间:" textColor:[UIColor grayColor] fontSize:12];
        [self addSubview:timeLbl];
        [timeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self).offset(10);
        }];

        statusLbl = [[ESLabel alloc] initWithText:@"" textColor:[UIColor redColor] fontSize:14];
        statusLbl.textAlignment = NSTextAlignmentRight;
        [self addSubview:statusLbl];
        [statusLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.right.equalTo(self).offset(-10);
            make.width.equalTo(@80);
        }];
    }
    return self;
}

- (void)configData:(ReturnedOrder *)returnedOrder {
    timeLbl.text = [NSString stringWithFormat:@"申请时间:%@", [DateUtils dateToString:returnedOrder.createTime withFormat:@"yyyy-MM-dd HH:mm:ss"]];
    statusLbl.text = returnedOrder.statusString;
}


@end