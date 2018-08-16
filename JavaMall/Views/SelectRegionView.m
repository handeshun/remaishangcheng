//
// Created by Dawei on 6/3/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import "SelectRegionView.h"
#import "UIView+Common.h"
#import "ESButton.h"
#import "View+MASAdditions.h"
#import "UIView+Layout.h"
#import "Region.h"
#import "AddressApi.h"


@implementation SelectRegionView {
    UIPickerView *pickerView;
    UIView *operationView;

    AddressApi *addressApi;

    ESButton *cancelBtn;
    ESButton *okBtn;

    NSMutableArray *provinces;
    NSMutableArray *citys;
    NSMutableArray *regions;
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
    addressApi = [AddressApi new];
    provinces = [NSMutableArray arrayWithCapacity:0];
    citys = [NSMutableArray arrayWithCapacity:0];
    regions = [NSMutableArray arrayWithCapacity:0];

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

    [self loadData:0 type:0];
}

-(void)loadData:(NSInteger)parentid type:(NSInteger)type{
    if(type < 3){
        [regions removeAllObjects];
    }
    if(type < 2){
        [citys removeAllObjects];
    }
    if(type < 1){
        [provinces removeAllObjects];
    }
    [addressApi getRegions:parentid success:^(NSMutableArray *regs) {
        switch (type){
            case 0:
                [provinces addObjectsFromArray:regs];
                break;
            case 1:
                [citys addObjectsFromArray:regs];
                break;
            case 2:
                [regions addObjectsFromArray:regs];
                break;
        }
        [pickerView reloadComponent:type];
        if(type == 0 && provinces.count > 0){
            Region *reg = [provinces objectAtIndex:0];
            [self loadData:reg.id type:1];
        }
        if(type == 1 && citys.count > 0){
            Region *reg = [citys objectAtIndex:0];
            [self loadData:reg.id type:2];
        }

    } failure:^(NSError *error) {

    }];
}


#pragma mark - UIPicker Delegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return provinces.count;
    } else if (component == 1) {
        return citys.count;
    } else {
        return regions.count;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        Region *region = [provinces objectAtIndex:row];
        return region.name;
    } else if (component == 1) {
        Region *region = [citys objectAtIndex:row];
        return region.name;
    } else {
        Region *region = [regions objectAtIndex:row];
        return region.name;
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return kScreen_Width / 3;
}

- (void)pickerView:(UIPickerView *)_pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        Region *province = [provinces objectAtIndex:row];
        [self loadData:province.id type:1];
        [_pickerView selectedRowInComponent:1];
        [_pickerView selectedRowInComponent:2];
        return;
    }
    if (component == 1) {
        Region *city = [citys objectAtIndex:row];
        [self loadData:city.id type:2];
        return;
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *myView = nil;
    myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 100, 30)];
    myView.textAlignment = NSTextAlignmentCenter;
    myView.font = [UIFont systemFontOfSize:14];
    myView.backgroundColor = [UIColor clearColor];
    if (component == 0) {
        Region *region = [provinces objectAtIndex:row];
        myView.text = region.name;
    } else if (component == 1) {
        Region *region = [citys objectAtIndex:row];
        myView.text = region.name;
    } else {
        Region *region = [regions objectAtIndex:row];
        myView.text = region.name;
    }
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
    Region *province = [provinces objectAtIndex:[pickerView selectedRowInComponent:0]];
    Region *city = [citys objectAtIndex:[pickerView selectedRowInComponent:1]];
    Region *region = [regions objectAtIndex:[pickerView selectedRowInComponent:2]];
    if(self.complete != nil){
        self.complete(province, city, region);
    }
    [self hide];
}

@end