//
// Created by Dawei on 6/3/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "SelectValueView.h"
#import "ESButton.h"
#import "View+MASAdditions.h"


@implementation SelectValueView {
    UIPickerView *pickerView;
    UIView *operationView;

    ESButton *cancelBtn;
    ESButton *okBtn;
}

@synthesize valueArray;

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
    valueArray = [NSMutableArray arrayWithCapacity:0];

    self.frame = CGRectMake(0, kScreen_Height, kScreen_Width, 244);

    pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, kScreen_Height, kScreen_Width, 200)];
    pickerView.backgroundColor = [UIColor whiteColor];
    pickerView.delegate = self;
    pickerView.dataSource = self;
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

- (NSMutableArray *)valueArray {
    return valueArray;
}

- (void)setValueArray:(NSMutableArray *)valueArray1 {
    valueArray = valueArray1;
    [pickerView reloadComponent:0];
}


#pragma mark - UIPicker Delegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return valueArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [valueArray objectAtIndex:row];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return kScreen_Width / 3;
}

- (void)pickerView:(UIPickerView *)_pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {

}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *myView = nil;
    myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, kScreen_Width, 30)];
    myView.textAlignment = NSTextAlignmentCenter;
    myView.font = [UIFont systemFontOfSize:14];
    myView.backgroundColor = [UIColor clearColor];
    myView.text = [valueArray objectAtIndex:row];
    return myView;
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
    NSInteger index = [pickerView selectedRowInComponent:0];
    NSString *value = [valueArray objectAtIndex:index];
    if(self.complete != nil){
        self.complete(index, value);
    }
    [self hide];
}

@end