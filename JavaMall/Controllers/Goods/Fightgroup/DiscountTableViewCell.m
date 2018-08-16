//
//  DiscountTableViewCell.m
//  JavaMall
//
//  Created by Cheerue on 2017/11/26.
//  Copyright © 2017年 Enation. All rights reserved.
//

#import "DiscountTableViewCell.h"
#import "Masonry.h"
#import "UIView+Common.h"
#import "NSString+Common.h"
#import "Goods.h"
#import "TXScrollLabelView.h"
@implementation DiscountTableViewCell {
    TXScrollLabelView *storeLabel;
   
   
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
       
        self.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
        storeLabel = [TXScrollLabelView scrollWithTitle:@"" type:0 velocity:3 options:UIViewAnimationOptionCurveEaseInOut];
         [self addSubview:storeLabel];
        storeLabel.font = [UIFont systemFontOfSize:14];
        storeLabel.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
        storeLabel.scrollTitleColor = [UIColor redColor];
       
        storeLabel.scrollVelocity =3;
        [storeLabel beginScrolling];
       

        UIView *line = [UIView new];
        line.backgroundColor = [UIColor colorWithHexString:kBorderLineColor];
        [self addSubview:line];
        
     
//        [storeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(self);
//            make.left.equalTo(self).offset(20);
//            make.right.equalTo(self).offset(-20);
//        }];
        
        storeLabel.frame = CGRectMake(10, 15, kScreen_Width-20, 30);
        
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0.5f);
            make.left.right.bottom.equalTo(self);
        }];
        
    }
    return self;
}

- (void) configData:(Goods *) goods{
    
    NSString *rulestr=@"";
    for(int i=0;i<goods.modelList.count;i++)
    {
        NSDictionary *dict = goods.modelList[i];
        rulestr = [NSString stringWithFormat:@"%@参团%@人%0.2f元    ",rulestr,dict[@"people_num"],[dict[@"percent"]floatValue]* goods.price/100];
    }

    storeLabel.scrollTitle=rulestr;
   
}

+ (CGFloat)cellHeightWithObj:(id)obj{
    return 60;
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
