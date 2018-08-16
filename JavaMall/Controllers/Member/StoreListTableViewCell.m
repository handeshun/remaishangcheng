//
//  StoreListTableViewCell.m
//  JavaMall
//
//  Created by Cheerue on 2018/4/13.
//  Copyright © 2018年 Enation. All rights reserved.
//

#import "StoreListTableViewCell.h"
#import "Masonry.h"
#import "Address.h"
#import "UIImageView+EMWebCache.h"

@implementation StoreListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.backgroundColor = [UIColor whiteColor];
        _titleImg = [[UIImageView alloc]initWithFrame:CGRectMake(15, 20, 61, 61)];
        _titleImg.layer.masksToBounds = YES;
        _titleImg.layer.cornerRadius = _titleImg.frame.size.width/2;
        [self.contentView addSubview:_titleImg];
        
        _titleName = [[UILabel alloc]init];
        _titleName.textAlignment = NSTextAlignmentLeft;
        _titleName.font = [UIFont systemFontOfSize:18];
        _titleName.textColor = LBColor(51, 51, 51);
        [self.contentView addSubview:_titleName];
        
        [_titleName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_titleImg.mas_right).offset(13);
            make.top.equalTo(@20);
            make.height.equalTo(@20);
            make.right.equalTo(self.contentView);
        }];
        
        _adreessLab = [[UILabel alloc]init];
        _adreessLab.textAlignment = NSTextAlignmentLeft;
        _adreessLab.font = [UIFont systemFontOfSize:14];
        _adreessLab.textColor = LBColor(153, 153, 153);
        _adreessLab.numberOfLines =3;
        [self.contentView addSubview:_adreessLab];
        
        [_adreessLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_titleImg.mas_right).offset(13);
            make.top.equalTo(_titleName.mas_bottom).offset(8);
            make.right.equalTo(self.contentView.mas_right).offset(-45);
        }];
        
        UIImageView *rightImg = [UIImageView new];
        rightImg.image = [UIImage imageNamed:@"right_arrow"];
        [self.contentView addSubview:rightImg];
        [rightImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.right.equalTo(self).offset(-15);
            make.width.equalTo(@8);
            make.height.equalTo(@15);
        }];
        
        _juliLab = [[UILabel alloc]init];
        _juliLab.textAlignment =NSTextAlignmentCenter;
        _juliLab.textColor = LBColor(255, 113, 112);
        _juliLab.font = [UIFont systemFontOfSize:14];
        _juliLab.layer.borderWidth = 0.5;
        _juliLab.layer.cornerRadius =4;
        _juliLab.layer.borderColor = LBColor(255, 113, 112).CGColor;
        [self.contentView addSubview:_juliLab];
        
        [_juliLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_adreessLab.mas_left);
            make.top.equalTo(_adreessLab.mas_bottom).offset(8);
            make.height.equalTo (@20);
        }];
        
    }
    return self;
}

- (void)configData:(Address *)address{
    [_titleImg sd_setImageWithURL:[NSURL URLWithString:address.store_logo]];
    _titleName.text = address.store_name;
    _adreessLab.text = address.attr;
    _juliLab.text = [NSString stringWithFormat:@"  距离%@米  ", address.distance];
    [_juliLab sizeToFit];
}

@end
