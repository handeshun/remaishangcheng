//
//  GroupNameTableViewCell.m
//  JavaMall
//
//  Created by Cheerue on 2017/11/25.
//  Copyright © 2017年 Enation. All rights reserved.
//

#import "GroupNameTableViewCell.h"
#import "Masonry.h"
#import "Goods.h"
#import "ImagePlayerView.h"
#import "UIView+Common.h"
#import "NSString+Common.h"
@implementation GroupNameTableViewCell{
    UILabel *name;
    UILabel *price;
    UILabel *origalPrice;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIImageView *Pintuanimg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pintuan"]];
        
        name = [UILabel new];
        name.font = [UIFont systemFontOfSize:15];
        name.textColor = [UIColor blackColor];
        name.numberOfLines = 2;
        
        
        origalPrice = [UILabel new];
        origalPrice.font = [UIFont systemFontOfSize:17];
        origalPrice.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
       
        
        price = [UILabel new];
        price.font = [UIFont fontWithName:@"Helvetica-Bold" size:25];
        price.textColor = [UIColor redColor];
        price.textAlignment = NSTextAlignmentRight;
        
        UIView *line = [UIView new];
        line.backgroundColor = [UIColor colorWithHexString:kBorderLineColor];
        
        [self addSubview:name];
        [self addSubview:origalPrice];
        [self addSubview:price];
        [self addSubview:Pintuanimg];
        [self addSubview:line];
        
        [Pintuanimg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(10);
            make.left.equalTo(self).offset(10);
            make.width.equalTo(@62);
            make.height.equalTo(@26);
        }];
        
        [name mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(Pintuanimg.mas_right).offset(10);
            make.right.equalTo(self).offset(-20);
            make.top.equalTo(self).offset(10);
        }];
        
        
        [origalPrice mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(10);
            make.top.equalTo(Pintuanimg.mas_bottom).offset(25);
            
        }];
        
        [price mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-20);
            make.top.equalTo(Pintuanimg.mas_bottom).offset(18);
             
             }];
        
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0.5f);
            make.left.right.bottom.equalTo(self);
        }];
    }
    return self;
}

/**
 * 设置商品数据
 */
- (void) configData:(Goods *)goods{
    name.text = goods.name;
    origalPrice.text =[NSString stringWithFormat:@"￥%.2f", goods.price];
    price.text = [NSString stringWithFormat:@"￥%.2f", goods.deposit];
    
    //文字中横线
    NSMutableAttributedString *newPrice = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",origalPrice.text]];
    [newPrice addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, newPrice.length)];
    origalPrice.attributedText = newPrice;
   
}

+ (CGFloat)cellHeightWithObj:(id)obj{
//    CGFloat cellHeight = 0;
//    if ([obj isKindOfClass:[Goods class]]) {
//        Goods *goods = (Goods *)obj;
//        cellHeight = [goods.name getSizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(kScreen_Width - 40, 100)].height;
//        cellHeight += 55;
//    }
    return 105;
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
