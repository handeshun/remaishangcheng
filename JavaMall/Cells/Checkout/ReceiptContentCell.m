//
// Created by Dawei on 6/22/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "ReceiptContentCell.h"
#import "Masonry.h"
#import "ESLabel.h"
#import "ESRadioButton.h"
#import "NSString+Common.h"
#import "Receipt.h"

@implementation ReceiptContentCell {
    ESLabel *titleLbl;

    UIView *headerView;
    UIView *footerView;
}
@synthesize buttons;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        buttons = [NSMutableArray arrayWithCapacity:0];

        headerView = [UIView new];
        headerView.backgroundColor = [UIColor colorWithHexString:@"#e2e2e2"];
        [self addSubview:headerView];
        [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self);
            make.height.equalTo(@0.5f);
        }];

        titleLbl = [[ESLabel alloc] initWithText:@"" textColor:[UIColor darkGrayColor] fontSize:14];
        titleLbl.text = @"发票内容";
        [self addSubview:titleLbl];
        [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(10);
            make.top.equalTo(self).offset(10);
        }];

        footerView = [UIView new];
        footerView.backgroundColor = [UIColor colorWithHexString:@"#e2e2e2"];
        [self addSubview:footerView];
        [footerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.bottom.equalTo(self);
            make.height.equalTo(@0.5f);
        }];
    }
    return self;
}

- (void)configData:(NSMutableArray *)nameArray receipt:(Receipt *)receipt selectType:(NSInteger)selectType{
    int topOffset = 10;
    int leftOffset = 20;
    int i = 0;
    for (ESRadioButton *but in buttons) {
        [but removeFromSuperview];
    }
    [buttons removeAllObjects];
    for (NSString *name in nameArray) {
        ESRadioButton *button = [ESRadioButton new];
        [button setTitle:name];
        button.tag = i;
        [self addSubview:button];
        [buttons addObject:button];
        
            if([receipt.content length] == 0){
                if(i == 0){
                    [button setSelected:YES];
                }
            }else{
                if([receipt.content isEqualToString:name]){
                    [button setSelected:YES];
                }
            }
        
//        if (![nameArray containsObject:@"明细"]&&[receipt.content isEqualToString:@"明细"]) {
//            if ([nameArray indexOfObject:name]==0) {
//                 [button setSelected:YES];
//            }
//        }
        float buttonWidth = [name getSizeWithFont:[UIFont systemFontOfSize:13]].width + 30;
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(leftOffset);
            make.top.equalTo(titleLbl.mas_bottom).offset(topOffset);
            make.height.equalTo(@25);
            make.width.equalTo(@(buttonWidth));
        }];
        topOffset += 30;
        i++;
    }
}

+ (CGFloat)cellHeightWithObj:(NSMutableArray *)nameArray {
    return nameArray.count * 30 + 40;
}

@end