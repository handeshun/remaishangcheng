//
// Created by Dawei on 6/3/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "SelectDateView.h"
#import "ESButton.h"
#import "Masonry.h"


@implementation SelectDateView {
    UIDatePicker *pickerView;
    UIView *operationView;

    ESButton *cancelBtn;
    ESButton *okBtn;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder])
        [self setupUI];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame])
        [self setupUI];
    return self;
}

/**
 * 创建UI界面
 */
- (void)setupUI {

    self.frame = CGRectMake(0, kScreen_Height, kScreen_Width, 244);

    pickerView = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, kScreen_Height, kScreen_Width, 200)];
    pickerView.backgroundColor = [UIColor whiteColor];
    pickerView.datePickerMode = UIDatePickerModeDate;
    NSLocale *locale = [[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"];
    pickerView.locale = locale;
    [self addSubview:pickerView];

    operationView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreen_Height, kScreen_Width, 44)];
    operationView.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
    [self addSubview:operationView];

    cancelBtn = [[ESButton alloc] initWithTitle:@"取消" color:[UIColor redColor] fontSize:14];
    [cancelBtn addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    [operationView addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(operationView);
        make.left.equalTo(operationView).offset(10);
    }];

    okBtn = [[ESButton alloc] initWithTitle:@"确定" color:[UIColor redColor] fontSize:14];
    [okBtn addTarget:self action:@selector(ok:) forControlEvents:UIControlEventTouchUpInside];
    [operationView addSubview:okBtn];
    [okBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(operationView);
        make.right.equalTo(operationView).offset(-10);
    }];
}


- (void)show {
    self.frame = CGRectMake(0, 60, kScreen_Width, kScreen_Height - 60);
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3f];
        operationView.frame = CGRectMake(0, kScreen_Height - 244, kScreen_Width, 44);
        pickerView.frame = CGRectMake(0, kScreen_Height - 244, kScreen_Width, 200);
    }];
}

- (void)hide {
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0f];
        operationView.frame = CGRectMake(0, kScreen_Height, kScreen_Width, 44);
        pickerView.frame = CGRectMake(0, kScreen_Height, kScreen_Width, 200);
    }                completion:^(BOOL finished) {
        self.frame = CGRectMake(0, kScreen_Height, kScreen_Width, kScreen_Height - 60);
    }];
}

/*
 * 选择区域完成
 */
- (IBAction)ok:(id)sender {
    if(self.complete != nil){
        self.complete(pickerView.date);
    }
    [self hide];
}

@end