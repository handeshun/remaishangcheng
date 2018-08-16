//
//  GroupNumTableViewCell.m
//  JavaMall
//
//  Created by Cheerue on 2017/11/25.
//  Copyright © 2017年 Enation. All rights reserved.
//

#import "GroupNumTableViewCell.h"
#import "Masonry.h"
#import "NSString+Common.h"
#import "Goods.h"
#import "UIView+Common.h"
@implementation GroupNumTableViewCell
{
    UILabel *titleLabel;
   
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        titleLabel = [UILabel new];
        titleLabel.font = [UIFont systemFontOfSize:15];
        titleLabel.textColor = [UIColor darkGrayColor];
        titleLabel.text = @"规格";
        
       
       
        
//        UIView *line = [UIView new];
//        line.backgroundColor = [UIColor colorWithHexString:kBorderLineColor];
        
        [self addSubview:titleLabel];
     
  //      [self addSubview:line];
        
        CGFloat titleHeight = [@"" getSizeWithFont:[UIFont systemFontOfSize:13]].height;
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(10);
            make.centerY.equalTo(self);
            
        }];
        
//        [line mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.height.equalTo(@0.5f);
//            make.left.right.bottom.equalTo(self);
//        }];
    }
    return self;
}

- (void)configData:(Goods *)goods{
    
        titleLabel.text = [NSString stringWithFormat:@"已有%zd 人参与拼团", goods.pintuan_peoplecount];
    
}

+ (CGFloat)cellHeightWithObj:(id)obj{
    return 63;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
