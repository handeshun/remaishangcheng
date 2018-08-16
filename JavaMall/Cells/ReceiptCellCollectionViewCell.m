//
//  ReceiptCellCollectionViewCell.m
//  JavaMall
//
//  Created by LDD on 17/7/7.
//  Copyright © 2017年 Enation. All rights reserved.
//

#import "ReceiptCellCollectionViewCell.h"
#import "Masonry.h"
@implementation ReceiptCellCollectionViewCell
@synthesize nameLabel;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        nameLabel = [[ESLabel alloc] initWithText:@"" textColor:[UIColor grayColor] fontSize:13];
        nameLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(5);
        }];
        UIView *line = [UIView new];
        line.backgroundColor = [UIColor grayColor];
        [self.contentView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(self.contentView);
            make.right.width.equalTo(self.contentView);
            make.height.equalTo(@0.1);
            make.top.equalTo(nameLabel.mas_bottom);
        }];
    }
    return self;
}

-(void) initData:(NSString *)addressTitle{
    self.nameLabel.text = addressTitle;
}

@end
