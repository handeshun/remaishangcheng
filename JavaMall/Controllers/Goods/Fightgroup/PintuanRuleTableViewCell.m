//
//  PintuanRuleTableViewCell.m
//  JavaMall
//
//  Created by Cheerue on 2017/11/26.
//  Copyright © 2017年 Enation. All rights reserved.
//

#import "PintuanRuleTableViewCell.h"
#import "ESLabel.h"
#import "Masonry.h"
#import "ESButton.h"
#import "Bonus.h"
#import "UIView+Common.h"
@implementation PintuanRuleTableViewCell
{
    UILabel *titleLabel;
    UILabel *infoLab;
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        titleLabel = [UILabel new];
        titleLabel.font = [UIFont systemFontOfSize:19];
        titleLabel.textColor = [UIColor darkGrayColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = @"规则简介";
        
        
        UIView *line = [UIView new];
        line.backgroundColor = [UIColor colorWithHexString:kBorderLineColor];
        
        infoLab  =[UILabel new];
        infoLab.font = [UIFont systemFontOfSize:14];
        infoLab.textColor = [UIColor lightGrayColor];
        infoLab.textAlignment = NSTextAlignmentLeft;
        infoLab.numberOfLines = 0;
        infoLab.text = @"1.用户A购买时可选择普通购买还是拼团模式购买，如果普通购买直接支付100 元，完成订单。\n2.如果选择拼团模式，则支付押金50元（暂定使用最低拼团金额）。\n3.  如果B，C......购买时，如果选择拼团模式，流程同 2，3；有效期戴上（如3天），根据拼团人数确定产品价格，如：到了100人就是80元，到了200人就是70元...根据确定的价格，用户补交差额货款，平台发货，完成订单；3天到了，不够100人，每人按100元的差价补金额。";
        [self changeLineSpaceForLabel:infoLab WithSpace:5];
        
        [self addSubview:titleLabel];
        [self addSubview:line];
        [self addSubview:infoLab];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(self).offset(15);
            
        }];
        
        
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0.5f);
            make.left.right.equalTo(self);
            make.top.equalTo(titleLabel.mas_bottom).offset(12);
        }];
        
        [infoLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(25);
            make.right.equalTo(self.mas_right).offset(-25);
            make.top.equalTo(line.mas_bottom).offset(20);
        }];
        
        
    }
    return self;
}

-(UILabel *)changeLineSpaceForLabel:(UILabel *)label WithSpace:(float)space {
    
    NSString *labelText = label.text;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:space];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    label.attributedText = attributedString;
    [label sizeToFit];
    return label;
}


+ (CGFloat)cellHeightWithObj:(id)obj{
    return 400;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
