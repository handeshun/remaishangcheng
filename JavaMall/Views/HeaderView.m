//
// Created by Dawei on 12/28/15.
// Copyright (c) 2015 Enation. All rights reserved.
//

#import "HeaderView.h"
#import "Masonry.h"
#import "ESButton.h"


@implementation HeaderView {
    NSString *title;
}

- (instancetype)initWithTitle:(NSString *)_title {
    self = [super init];
    if (self) {
        title = _title;
        [self setFrame:CGRectMake(0, 0, kScreen_Width, kTopHeight)];
        [self createUI];
    }
    return self;
}

/**
 * 创建界面
 */
- (void)createUI {
    self.backgroundColor = [UIColor colorWithHexString:@"#FAFAFA"];

    //标题
    self.titleLbl = [UILabel new];
    self.titleLbl.text = title;
    self.titleLbl.font = [UIFont systemFontOfSize:16];
    [self addSubview:self.titleLbl];
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(@(kStatusBarHeight+9));
    }];
    //添加下划线
    float lineHeight = 0.5f;
    self.lineLayer = [CALayer layer];
    self.lineLayer.frame = CGRectMake(0, self.frame.size.height - lineHeight, self.frame.size.width, lineHeight);
    self.lineLayer.backgroundColor = [UIColor colorWithHexString:@"#cdcdcd"].CGColor;
    [self.layer addSublayer:self.lineLayer];
}

/**
 * 添加后退按钮
 */
- (void)setBackAction:(SEL)action {
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(2, kStatusBarHeight-2, 44, 44)];
    [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backBtn setContentMode:UIViewContentModeCenter];
    [backBtn addTarget:[self viewController] action:action forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:backBtn];
}

/**
 * 添加取消按钮
 */
- (void)setCancelAction:(SEL)action {
    ESButton *cancelBtn = [[ESButton alloc] initWithTitle:@"取消" color:[UIColor grayColor] fontSize:14];
    [self addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.bottom.equalTo(self).offset(-5);
    }];
    [cancelBtn addTarget:[self viewController] action:action forControlEvents:UIControlEventTouchUpInside];
}

@end
