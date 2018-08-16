//
//  GoodintroduceTableViewCell.m
//  JavaMall
//
//  Created by Cheerue on 2017/11/26.
//  Copyright © 2017年 Enation. All rights reserved.
//

#import "GoodintroduceTableViewCell.h"
#import "ESLabel.h"
#import "Masonry.h"
#import "ESButton.h"
#import "Bonus.h"
#import "UIView+Common.h"
@implementation GoodintroduceTableViewCell{
    UILabel *titleLabel;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        titleLabel = [UILabel new];
        titleLabel.font = [UIFont systemFontOfSize:15];
        titleLabel.textColor = [UIColor darkGrayColor];
        titleLabel.text = @"商品介绍";
        
        
        UIImageView *arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"right_arrow"]];
        
        UIView *line = [UIView new];
        line.backgroundColor = [UIColor colorWithHexString:kBorderLineColor];
        
        [self addSubview:titleLabel];
      
        [self addSubview:arrow];
        [self addSubview:line];
        
       
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(10);
            make.centerY.equalTo(self);
          
        }];
        
      
        
        [arrow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.right.equalTo(self).offset(-10);
        }];
        
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0.5f);
            make.left.right.bottom.equalTo(self);
        }];
    }
    return self;
}



+ (CGFloat)cellHeightWithObj:(id)obj{
    return 50;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
