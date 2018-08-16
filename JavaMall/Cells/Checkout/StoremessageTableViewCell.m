//
//  StoremessageTableViewCell.m
//  JavaMall
//
//  Created by Cheerue on 2018/4/13.
//  Copyright © 2018年 Enation. All rights reserved.
//

#import "StoremessageTableViewCell.h"
#import "ESLabel.h"
#import "Masonry.h"
#import "NSString+Common.h"
#import "ESCheckButton.h"
@implementation StoremessageTableViewCell{
    UIView *headerView;
    UIView *footerView;
}
@synthesize buttons, titleLbl, storeAdressLab;
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
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
        [self addSubview:titleLbl];
        [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(10);
            make.top.equalTo(self).offset(10);
        }];
        
        storeAdressLab = [[UILabel alloc]init];
        storeAdressLab.textAlignment = NSTextAlignmentLeft;
        storeAdressLab.textColor = [UIColor darkGrayColor];
        storeAdressLab.font = [UIFont systemFontOfSize:13];
        storeAdressLab.numberOfLines = 4;
        [self addSubview:storeAdressLab];
       
        [storeAdressLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(10);
            make.right.equalTo(self).offset(-10);
            make.top.equalTo(titleLbl.mas_bottom).offset(10);
           
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

- (void)setTitle:(NSString *)title {
    titleLbl.text = title;
   
}
-(void)setAddress:(NSString *)address
{
    storeAdressLab.text = address;
}

- (void)configData:(NSMutableArray *)nameArray typeArr:(NSMutableArray *)typeArray {
    int topOffset = 10;
    int leftOffset = 20;
    int i = 0;
    [buttons removeAllObjects];
    for (NSString *name in nameArray) {
        
        ESCheckButton *button = [ESCheckButton new];
        [button setTitle:name];
        button.tag = i;
        button.typeids = [typeArray[i] integerValue]; 
        NSLog(@"==============================================================%@",name);
        [self addSubview:button];
        [buttons addObject:button];
        
        float buttonWidth = [name getSizeWithFont:[UIFont systemFontOfSize:13]].width + 30;
        if (i > 0 && leftOffset + buttonWidth + 10 > kScreen_Width - 30) {
            leftOffset = 20;
            topOffset += 35;
        }
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(leftOffset);
            make.top.equalTo(storeAdressLab.mas_bottom).offset(topOffset);
            make.height.equalTo(@25);
            make.width.equalTo(@(buttonWidth));
        }];
        leftOffset += buttonWidth + 10;
        i++;
    }
}

- (void)showLine:(BOOL)header footer:(BOOL)footer {
    [headerView setHidden:!header];
    [footerView setHidden:!footer];
}


+ (CGFloat)cellHeightWithObj:(NSMutableArray *)nameArray address:(NSString *)addresss {
    
    
    //1.1最大允许绘制的文本范围
    CGSize size = CGSizeMake(kScreen_Width-20, 200);
    //1.2配置计算时的行截取方法,和contentLabel对应
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:10];
    //1.3配置计算时的字体的大小
    //1.4配置属性字典
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:13], NSParagraphStyleAttributeName:style};
    //2.计算
    //如果想保留多个枚举值,则枚举值中间加按位或|即可,并不是所有的枚举类型都可以按位或,只有枚举值的赋值中有左移运算符时才可以
    CGFloat heights = [addresss boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil].size.height;
    
    
    
    int topOffset = 0;
    int leftOffset = 20;
    int i = 0;
    for (NSString *name in nameArray) {
        float buttonWidth = [name getSizeWithFont:[UIFont systemFontOfSize:13]].width + 30;
        if (i > 0 && leftOffset + buttonWidth + 10 > kScreen_Width - 30) {
            leftOffset = 20;
            topOffset += 35;
        }
        leftOffset += buttonWidth + 10;
        i++;
    }
    topOffset += 35+heights;
    return topOffset + 40;
}


- (CGFloat)getHeightLineWithString:(NSString *)string withWidth:(CGFloat)width withFont:(UIFont *)font {
    //1.1最大允许绘制的文本范围
    CGSize size = CGSizeMake(width, 200);
    //1.2配置计算时的行截取方法,和contentLabel对应
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:10];
    //1.3配置计算时的字体的大小
    //1.4配置属性字典
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:style};
    //2.计算
    //如果想保留多个枚举值,则枚举值中间加按位或|即可,并不是所有的枚举类型都可以按位或,只有枚举值的赋值中有左移运算符时才可以
    CGFloat height = [string boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil].size.height;
    
    return height;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
