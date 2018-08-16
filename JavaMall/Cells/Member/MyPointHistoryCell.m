//
// Created by Dawei on 7/5/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "MyPointHistoryCell.h"
#import "Masonry.h"
#import "ESLabel.h"
#import "PointHistory.h"
#import "DateUtils.h"

@implementation MyPointHistoryCell {
    UIView *headerLine;
    UIView *footerLine;

    ESLabel *reasonLbl;
    ESLabel *timeLbl;
    ESLabel *pointLbl;
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
            make.bottom.right.equalTo(self);
            make.left.equalTo(self).offset(10);
            make.height.equalTo(headerLine);
        }];

        pointLbl = [[ESLabel alloc] initWithText:@"" textColor:[UIColor colorWithHexString:@"#f0566e"] fontSize:16];
        [self addSubview:pointLbl];
        [pointLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-10);
            make.centerY.equalTo(self);
            make.width.equalTo(@60);
        }];

        reasonLbl = [[ESLabel alloc] initWithText:@"" textColor:[UIColor darkGrayColor] fontSize:14];
        [self addSubview:reasonLbl];
        [reasonLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(self).offset(10);
            make.right.equalTo(pointLbl.mas_left).offset(-10);
        }];

        timeLbl = [[ESLabel alloc] initWithText:@"" textColor:[UIColor grayColor] fontSize:12];
        [self addSubview:timeLbl];
        [timeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(reasonLbl.mas_bottom).offset(10);
            make.left.equalTo(reasonLbl);
        }];
    }
    return self;
}

- (void)configData:(PointHistory *)pointHistory andType:(NSInteger)type {
    reasonLbl.text = pointHistory.reason;
    timeLbl.text = [DateUtils dateToString:pointHistory.time withFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSInteger p = 0;
    if(type == 1){
        p = pointHistory.point;
    }else{
        p = pointHistory.mp;
    }
    if(p > 0){
        pointLbl.text = [NSString stringWithFormat:@"+%d", p];
    }else{
        pointLbl.text = [NSString stringWithFormat:@"%d", p];
    }
}

@end